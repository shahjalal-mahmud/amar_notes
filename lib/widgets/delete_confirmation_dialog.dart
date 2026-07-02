// Delete-confirmation dialog — extracted from NotesListScreen so it can
// be reused by future screens (e.g. a detail screen).
//
// Usage:
//   final confirmed = await showDeleteNoteDialog(context, note: note);
//   if (confirmed) { ... }
//
// The dialog is themed via the app's M3 dialogTheme — colors come from
// Theme.of(context).colorScheme.

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_spacing.dart';

/// Shows a Material 3 confirmation dialog asking whether to delete [note].
///
/// Returns `true` if the user confirmed, `false` (or `null`) otherwise.
Future<bool?> showDeleteNoteDialog({
  required BuildContext context,
  required Note note,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        icon: Icon(
          Icons.delete_outline,
          color: colorScheme.error,
          size: 32,
        ),
        title: const Text('Delete note?'),
        content: Text(
          'Are you sure you want to delete "${note.title}"? '
          'This cannot be undone.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}