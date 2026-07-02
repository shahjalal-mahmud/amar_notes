// NoteCard — Material 3 card representing a single note in the list.
//
// Layout:
//   ┌──────────────────────────────────────────────────┐
//   │ Title (semibold)                       ✏   🗑    │
//   │ Description preview (max 2 lines)               │
//   └──────────────────────────────────────────────────┘
//
// The edit/delete actions are icon-only IconButtons (48×48 hit targets).
// All colors/typography/radii come from the theme — no literals here.

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_spacing.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title + actions row ───────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? '(Untitled)' : note.title,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit',
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xs),

              // ── Description preview ───────────────────────────────
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.sm,
                  bottom: AppSpacing.xs,
                ),
                child: Text(
                  note.description.isEmpty
                      ? '(No description)'
                      : note.description,
                  style: textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}