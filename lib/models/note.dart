// Note data model.
//
// Represents a single note stored in Cloud Firestore.
// Each note has:
//   - id          : Firestore document ID (auto-generated, unique per note)
//   - title       : Note title (user-provided, required)
//   - description : Note body (user-provided, required)
//   - createdAt   : Timestamp when the note was first created
//   - updatedAt   : Timestamp of the last edit; used for sorting newest-first
//
// Firestore stores documents as Maps. The `fromMap`/`toMap` methods translate
// between the Dart `Note` object and the Firestore document representation.

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  // The Firestore document ID. Empty string means "not yet saved".
  final String id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Build a Note from a Firestore document.
  ///
  /// `id` comes from the document itself, not from a field inside it.
  /// Timestamp fields come back as Firestore `Timestamp` objects and are
  /// converted to Dart `DateTime` here so the rest of the app can use them
  /// directly.
  factory Note.fromMap(String id, Map<String, dynamic> map) {
    return Note(
      id: id,
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      // Timestamps may be null if the doc was written before serverTimestamp
      // resolved (rare race condition) or if it's a local-only draft.
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert this Note into a Map ready to be written to Firestore.
  ///
  /// Note: we deliberately do NOT include `id` in the map because Firestore
  /// stores the ID as the document key, not as a field in the document.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Returns a copy of this Note with the given fields replaced.
  ///
  /// Useful when updating a note — we keep the same `id` and `createdAt`
  /// but replace `title`, `description`, and `updatedAt`.
  Note copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, description: $description, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}