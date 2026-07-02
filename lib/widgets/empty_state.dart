// EmptyState — a centered icon + heading + subtitle shown when a list
// has no items. Used by [NotesListScreen] for the "no notes yet" case.
//
// All colors and typography come from the theme — no literals here.

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon in a soft tinted circle ─────────────────────────
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}