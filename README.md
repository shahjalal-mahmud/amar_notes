# Amar Notes

A small but polished Flutter notes-management app backed by **Cloud Firestore**.
Built as a student project to demonstrate clean architecture, Material 3
design, and reactive Firestore CRUD — without leaning on heavyweight
state-management libraries.

---

## Features

- **Create, read, update, delete** notes (title + description).
- **Real-time list** — the home screen updates automatically the moment a
  note is added, edited, or deleted (even from another device), via a
  Firestore `Stream` and Flutter's `StreamBuilder`.
- **Light, dark, and system theme modes** — fully custom Material 3 themes,
  switchable from the AppBar.
- **Responsive layout** — content stays readable on phones, tablets, and
  wider screens.
- **Form validation** with friendly inline error messages.
- **Confirmation dialog** before destructive actions.
- **Zero hardcoded colors** in widgets — every color, text style, and
  corner radius comes from the central `lib/theme/` design-token system.

---

## Tech Stack

| Layer     | Choice                          |
|-----------|---------------------------------|
| Framework | Flutter (Material 3)            |
| Backend   | Firebase Cloud Firestore        |
| Auth      | _Not used — see Security below_ |
| State     | `setState` + `StreamBuilder`    |
| Theming   | Hand-built `ColorScheme` + M3   |

---

## Project Structure

```
lib/
├── main.dart                          # App entry; Firebase init + theme state
├── firebase_options.dart              # Platform config (generated)
│
├── models/
│   └── note.dart                      # Note data class + Firestore (de)serialization
│
├── services/
│   └── firestore_service.dart         # All Firestore CRUD (add / read / update / delete / stream)
│
├── screens/
│   ├── notes_list_screen.dart         # Home: real-time list + FAB + theme toggle
│   └── note_edit_screen.dart          # Add / Edit form (single screen, dual mode)
│
├── widgets/
│   ├── note_card.dart                 # Reusable card for one note
│   ├── empty_state.dart               # Reusable empty-state widget
│   ├── delete_confirmation_dialog.dart # showDeleteNoteDialog()
│   └── responsive.dart                # horizontalScreenPadding() helper
│
└── theme/                             # Design-token system (no widgets)
    ├── app_theme.dart                 # Barrel: lightTheme, darkTheme, tokens
    ├── app_colors.dart                # Brand + hand-tuned lightScheme & darkScheme
    ├── app_spacing.dart               # 4-pt scale + responsive helper
    ├── app_radius.dart                # sm / md / lg / xl / pill
    ├── app_text_theme.dart            # Material 3 TextTheme for both modes
    ├── light_theme.dart               # ThemeData(light) — built from scratch
    └── dark_theme.dart                # ThemeData(dark)  — built from scratch
```

### Architecture Notes

- **Layered by purpose** (model → service → screen → widget), not by
  feature. Appropriate for a small CRUD app of this size.
- **`FirestoreService` is a static facade** — no DI container, no
  repository pattern. A `FirestoreService` instance is shared, and screens
  call it directly. Simple, debuggable, and easy to extend.
- **No Bloc, Riverpod, or GetX.** `StreamBuilder` plus `setState` carries
  all UI state. Right-sized for the problem.
- **One screen for add and edit** (`NoteEditScreen`) — the optional `note`
  argument decides mode, eliminating duplication.

---

## Firestore Data Model

Each note is a document in the top-level `notes` collection:

```jsonc
{
  "title":       "Buy groceries",
  "description": "Milk, eggs, bread",
  "createdAt":   <Firestore Timestamp>,
  "updatedAt":   <Firestore Timestamp>
}
```

The document ID is the Firestore-generated UID; it is **not** stored as a
field. Timestamps use `FieldValue.serverTimestamp()` to avoid client-clock
skew when sorting by `updatedAt`.

---

## Setup

### 1. Prerequisites

- Flutter SDK (the project targets `^3.11.5`).
- A Firebase project (free Spark tier is enough).
- Firebase CLI and FlutterFire CLI.

### 2. Install the Firebase tooling (one-time)

```bash
# Firebase CLI (Node.js required)
npm install -g firebase-tools

# FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 3. Sign in to Firebase

```bash
firebase login
```

### 4. Configure the project

From the project root:

```bash
flutterfire configure
```

This will:

1. Ask you to **select or create** a Firebase project.
2. Ask which **platforms** to enable (Android is the focus; iOS / web are
   optional).
3. Auto-register the Android app and **download `google-services.json`**
   into `android/app/`.
4. **Patch the Android Gradle files** to apply the Google Services plugin.
5. **Generate `lib/firebase_options.dart`** with your real keys.

> ℹ️ `lib/firebase_options.dart` and `android/app/google-services.json`
> are **gitignored** because they contain API keys. They are regenerated
> locally by `flutterfire configure` — never commit them.

### 5. Run

```bash
flutter pub get
flutter run
```

> 💡 If you skip step 4, the app will fail at startup with an invalid API
> key error — that's expected. The placeholder `firebase_options.dart`
> cannot talk to a real Firestore project.

---

## Verification

```bash
flutter analyze        # static analysis
flutter test           # theme smoke tests
```

---

## License

This is a student project provided as-is for educational use.
