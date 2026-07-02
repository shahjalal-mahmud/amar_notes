// NoteEditScreen — a single screen used for BOTH creating a new note and
// editing an existing one.
//
// Mode is determined by whether the optional `note` argument is null:
//   - note == null  → CREATE mode  (form starts empty, Save calls addNote)
//   - note != null  → EDIT mode    (form pre-filled, Save calls updateNote)
//
// Uses Flutter's `Form` + `TextFormField` with validators for inline
// validation feedback. The Save button is disabled while the async save
// is in flight to prevent double-submits.
//
// All visuals come from the theme — no hardcoded colors, text styles,
// or radii.

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/firestore_service.dart';
import '../theme/app_spacing.dart';
import '../widgets/responsive.dart';

class NoteEditScreen extends StatefulWidget {
  /// The note to edit. Pass `null` to create a new note.
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  /// Disables Save while a Firestore write is in flight.
  bool _isSaving = false;

  bool get _isEditMode => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditMode) {
        final updatedNote = widget.note!.copyWith(
          title: title,
          description: description,
        );
        await FirestoreService.updateNote(updatedNote);
      } else {
        await FirestoreService.addNote(
          title: title,
          description: description,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keyboard inset handling: the bottom button stays above the keyboard.
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Note' : 'Add Note'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: TextButton(
              onPressed: _isSaving ? null : _onSavePressed,
              child: Text(
                _isSaving ? 'Saving…' : 'Save',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AppSpacing.constrained(
            Padding(
              padding: horizontalScreenPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // ── Title field ─────────────────────────────────────
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter a title',
                      prefixIcon: Icon(Icons.title),
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 100,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      if (value.trim().length > 100) {
                        return 'Title must be 100 characters or fewer';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Description field ───────────────────────────────
                  Expanded(
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Write your note here…',
                        alignLabelWithHint: true,
                      ),
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // ── Save button ─────────────────────────────────────
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _onSavePressed,
                    icon: _isSaving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSaving ? 'Saving…' : 'Save note'),
                  ),

                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}