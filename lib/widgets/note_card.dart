// NoteCard — a Material `Card` widget that displays a single Note.
//
// Layout:
//   ┌──────────────────────────────────────────────┐
//   │ Title                                        │
//   │ Description preview (max 2 lines)            │
//   │                              [Edit] [Delete] │
//   └──────────────────────────────────────────────┘
//
// Both buttons call a callback supplied by the parent screen so this
// widget stays "dumb" — it only renders and forwards events.

import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Slight elevation to match Material 3 defaults.
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ───────────────────────────────────────────────
            Text(
              note.title.isEmpty ? '(Untitled)' : note.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // ── Description preview ─────────────────────────────────
            // maxLines: 2 keeps the list compact while still showing
            // enough of the note to be recognisable.
            Text(
              note.description.isEmpty ? '(No description)' : note.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // ── Action row ──────────────────────────────────────────
            // Row at the bottom-right with Edit and Delete buttons.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}