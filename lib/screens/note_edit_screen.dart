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

import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/firestore_service.dart';

class NoteEditScreen extends StatefulWidget {
  /// The note to edit. Pass `null` to create a new note.
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  // ── Form key — lets us call _formKey.currentState!.validate() ──────
  final _formKey = GlobalKey<FormState>();

  // ── TextEditingControllers ─────────────────────────────────────────
  // Pre-fill with the existing note's values in EDIT mode, empty in CREATE.
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  // ── Saving flag — disables the Save button while Firestore write runs.
  bool _isSaving = false;

  // Convenience getters to make the code below read more naturally.
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
    // Always dispose controllers to avoid memory leaks.
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Tap handler for the Save button.
  ///
  /// 1. Validates the form. If invalid, validation messages appear and we
  ///    stop here.
  /// 2. Disables the button (setState) to prevent double-submits.
  /// 3. Calls the appropriate Firestore method (add or update).
  /// 4. Shows a SnackBar with success/error feedback.
  /// 5. Pops back to the previous screen (NotesListScreen), which updates
  ///    automatically because of StreamBuilder.
  Future<void> _onSavePressed() async {
    // 1) Validate. If any field is invalid, Form.validate() returns false
    //    and shows the error messages we defined in the validators.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (_isEditMode) {
        // EDIT: update the existing note. We keep the original `id` and
        // `createdAt`; FirestoreService.updateNote() bumps `updatedAt`.
        final updatedNote = widget.note!.copyWith(
          title: title,
          description: description,
        );
        await FirestoreService.updateNote(updatedNote);
      } else {
        // CREATE: write a brand-new document. Firestore assigns the ID.
        await FirestoreService.addNote(
          title: title,
          description: description,
        );
      }

      if (!mounted) return;

      // Pop back to the list screen. StreamBuilder picks up the change.
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      // Re-enable the button so the user can retry.
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title reflects the current mode — small UX touch.
        title: Text(_isEditMode ? 'Edit Note' : 'Add Note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Save action lives in the AppBar so it's always visible.
          TextButton(
            onPressed: _isSaving ? null : _onSavePressed,
            child: Text(
              _isSaving ? 'Saving…' : 'Save',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title field ────────────────────────────────────────
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter a title',
                  border: OutlineInputBorder(),
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

              const SizedBox(height: 16),

              // ── Description field ─────────────────────────────────
              // Expanded so it fills the remaining screen height.
              Expanded(
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Write your note here…',
                    border: OutlineInputBorder(),
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

              const SizedBox(height: 16),

              // ── Save button (also visible at the bottom) ───────────
              // AppBar already has a Save action; this gives the user
              // a more obvious primary CTA at the bottom of the form.
              FilledButton.icon(
                onPressed: _isSaving ? null : _onSavePressed,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving…' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}