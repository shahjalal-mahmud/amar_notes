// FirestoreService — all Firestore CRUD operations for Note live here.
//
// Design notes:
//   - We expose a single class with static-style methods that internally
//     share a single `FirebaseFirestore` instance (Firestore manages its
//     own connection pool, so this is safe and avoids re-init overhead).
//   - The collection name is centralised in `_notesCollection` to make
//     future refactors easy.
//   - Timestamps use `FieldValue.serverTimestamp()` so the Firestore server
//     (not the device clock) writes the time. This avoids clock-skew bugs
//     when sorting by `updatedAt`.
//
// All four CRUD methods are implemented:
//   - addNote    : create a new note
//   - getNotes   : fetch all notes (one-shot Future)
//   - streamNotes: real-time updates via a Stream (used by the UI later)
//   - updateNote : edit an existing note
//   - deleteNote : remove a note

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class FirestoreService {
  // Single shared Firestore instance (lazy-initialised on first access).
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Name of the collection that stores all notes.
  // Centralised here so it's easy to rename later.
  static const String _notesCollection = 'notes';

  // ─────────────────────────────────────────────────────────────────────
  // CREATE
  // ─────────────────────────────────────────────────────────────────────

  /// Create a new note in Firestore.
  ///
  /// We do NOT pass an `id` — Firestore auto-generates one with `.add()`.
  /// Both `createdAt` and `updatedAt` are set to the server time at write.
  ///
  /// Returns the generated document ID so the caller can reference it later.
  static Future<String> addNote({
    required String title,
    required String description,
  }) async {
    final docRef = await _db.collection(_notesCollection).add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // ─────────────────────────────────────────────────────────────────────
  // READ — one-shot (Future)
  // ─────────────────────────────────────────────────────────────────────

  /// Fetch ALL notes once, ordered by `updatedAt` descending
  /// (most-recently-edited note appears first).
  ///
  /// This is a one-shot read. For real-time updates in the UI, prefer
  /// `streamNotes()` below.
  static Future<List<Note>> getNotes() async {
    final querySnapshot = await _db
        .collection(_notesCollection)
        .orderBy('updatedAt', descending: true)
        .get();

    // Map each Firestore document to our Dart `Note` model.
    return querySnapshot.docs.map((doc) {
      return Note.fromMap(doc.id, doc.data());
    }).toList();
  }

  // ─────────────────────────────────────────────────────────────────────
  // READ — real-time (Stream)
  // ─────────────────────────────────────────────────────────────────────

  /// Stream of all notes, ordered by `updatedAt` descending.
  ///
  /// Firestore emits a new event every time the collection changes
  /// (add, edit, delete). Perfect for `StreamBuilder` in the UI.
  ///
  /// The Stream stays open until the caller cancels it (e.g. when a
  /// widget is disposed).
  static Stream<List<Note>> streamNotes() {
    return _db
        .collection(_notesCollection)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // ─────────────────────────────────────────────────────────────────────
  // UPDATE
  // ─────────────────────────────────────────────────────────────────────

  /// Update an existing note's title and description.
  ///
  /// We only overwrite fields the user actually edits. The `updatedAt`
  /// field is bumped to the server time so the note moves to the top
  /// of the list. `createdAt` is left untouched.
  static Future<void> updateNote(Note note) async {
    await _db.collection(_notesCollection).doc(note.id).update({
      'title': note.title,
      'description': note.description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─────────────────────────────────────────────────────────────────────
  // DELETE
  // ─────────────────────────────────────────────────────────────────────

  /// Delete the note with the given Firestore document ID.
  static Future<void> deleteNote(String id) async {
    await _db.collection(_notesCollection).doc(id).delete();
  }
}