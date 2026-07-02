// NotesListScreen — the home screen of the app.
//
// Responsibilities:
//   1. Subscribe to FirestoreService.streamNotes() via a StreamBuilder so
//      the list updates in real time whenever a note is added, edited,
//      or deleted.
//   2. Render each note as a NoteCard.
//   3. Provide a Floating Action Button (FAB) for creating new notes.
//   4. Handle Edit and Delete button presses from each NoteCard.
//
// All visuals come from the theme — see lib/theme/.

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/firestore_service.dart';
import '../theme/app_spacing.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/responsive.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  /// Current theme mode (passed down from `MyApp`).
  final ThemeMode themeMode;

  /// Called when the user taps the theme-toggle icon in the AppBar.
  /// The parent (`MyApp`) decides what the next mode should be.
  final VoidCallback onToggleTheme;

  const NotesListScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  /// FAB tap — navigate to NoteEditScreen in CREATE mode.
  void _onAddNotePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NoteEditScreen(),
      ),
    );
  }

  /// Edit tap on a card — navigate to NoteEditScreen in EDIT mode.
  void _onEditNote(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(note: note),
      ),
    );
  }

  /// Delete tap on a card — show confirmation dialog, then delete.
  Future<void> _onDeleteNote(Note note) async {
    final confirmed = await showDeleteNoteDialog(context: context, note: note);
    if (confirmed != true) return;

    try {
      await FirestoreService.deleteNote(note.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  /// Returns the appropriate icon and tooltip for the current theme mode.
  ///
  ///   - system → "brightness_auto"  (follows device)
  ///   - light  → "light_mode"       (sun)
  ///   - dark   → "dark_mode"        (moon)
  ({IconData icon, String tooltip}) _themeToggleContent() {
    return switch (widget.themeMode) {
      ThemeMode.system => (
          icon: Icons.brightness_auto,
          tooltip: 'Theme: system — tap for light',
        ),
      ThemeMode.light => (
          icon: Icons.light_mode,
          tooltip: 'Theme: light — tap for dark',
        ),
      ThemeMode.dark => (
          icon: Icons.dark_mode,
          tooltip: 'Theme: dark — tap for system',
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeToggle = _themeToggleContent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amar Notes'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(themeToggle.icon),
            tooltip: themeToggle.tooltip,
          ),
        ],
      ),

      // Extended FAB shows icon + label for better discoverability.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddNotePressed,
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),

      body: StreamBuilder<List<Note>>(
        stream: FirestoreService.streamNotes(),
        builder: (context, snapshot) {
          // 1) Waiting for first event.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2) Error from Firestore.
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Couldn\'t load notes',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${snapshot.error}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // 3) Empty state.
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const EmptyState(
              icon: Icons.note_alt_outlined,
              title: 'No notes yet',
              message: 'Tap "New note" to capture your first thought.',
            );
          }

          // 4) Happy path: render the list.
          // Cap the content width on tablets/desktop so cards don't stretch
          // absurdly wide.
          return AppSpacing.constrained(
            ListView.builder(
              padding: horizontalScreenPadding(context),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  onEdit: () => _onEditNote(note),
                  onDelete: () => _onDeleteNote(note),
                );
              },
            ),
          );
        },
      ),
    );
  }
}