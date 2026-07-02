// NotesListScreen — the home screen of the app.
//
// Responsibilities:
//   1. Subscribe to FirestoreService.streamNotes() via a StreamBuilder so
//      the list updates in real time whenever a note is added, edited,
//      or deleted (anywhere — even from another device).
//   2. Render each note as a NoteCard.
//   3. Provide a Floating Action Button (FAB) for creating new notes.
//   4. Handle Edit and Delete button presses from each NoteCard.
//
// The Edit button currently shows a SnackBar — the dedicated NoteEditScreen
// will be wired up in the next step. Delete shows a confirmation dialog.

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/firestore_service.dart';
import '../widgets/note_card.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  /// Tap handler for the "+" FAB.
  ///
  /// For now we just show a SnackBar — in the next step this will navigate
  /// to the dedicated NoteEditScreen in "create" mode.
  void _onAddNotePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add note — coming next step')),
    );
  }

  /// Tap handler for the "Edit" button on a NoteCard.
  ///
  /// Will later navigate to NoteEditScreen with the note passed in.
  void _onEditNote(Note note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit "${note.title}" — coming next step')),
    );
  }

  /// Tap handler for the "Delete" button on a NoteCard.
  ///
  /// Shows a confirmation AlertDialog. If the user confirms, we call
  /// FirestoreService.deleteNote() — the StreamBuilder automatically
  /// removes the card from the list when Firestore emits the change.
  Future<void> _onDeleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete note?'),
          content: Text(
            'Are you sure you want to delete "${note.title}"? '
            'This cannot be undone.',
          ),
          actions: [
            // Cancel — just closes the dialog with `false`.
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            // Delete — closes the dialog with `true`, then the caller
            // actually performs the Firestore delete.
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // If the user confirmed, perform the actual delete.
    if (confirmed == true) {
      try {
        await FirestoreService.deleteNote(note.id);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amar Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      // ── FAB: add a new note ──────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddNotePressed,
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),

      // ── Body: real-time list of notes ────────────────────────────
      body: StreamBuilder<List<Note>>(
        // Subscribe to the live stream of notes from Firestore.
        stream: FirestoreService.streamNotes(),
        builder: (context, snapshot) {
          // 1) Waiting for the first event from Firestore.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) Firestore returned an error (e.g. permissions, offline).
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading notes:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // 3) No error but the user has no notes yet — empty state.
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No notes yet.\nTap + to create your first note.',
                textAlign: TextAlign.center,
              ),
            );
          }

          // 4) Happy path: render the list of cards.
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onEdit: () => _onEditNote(note),
                onDelete: () => _onDeleteNote(note),
              );
            },
          );
        },
      ),
    );
  }
}