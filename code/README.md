# Hospital Prescription System

This repository is a small, file-backed Hospital Prescription & Medication Tracking System written in Dart using simple OOP principles. It is designed to be run as a console app and uses JSON files in `lib/data/` as a lightweight local "database".

This README summarizes the project layout, key domain classes and repositories, how data is stored, and how to run and seed the data.

## Project structure

```
code/
├── pubspec.yaml
├── lib/
│   ├── main.dart                 # Console entry point
│   ├── data/                     # JSON data files
│   │   ├── doctors.json
│   │   ├── patients.json
│   │   ├── medications.json
│   │   ├── prescriptions.json
│   │   └── medical_logs.json
│   ├── domain/                   # Domain models
│   │   ├── doctor.dart
│   │   ├── patient.dart
│   │   ├── medication.dart
│   │   ├── prescription.dart
│   │   ├── prescription_item.dart
│   │   └── medical_log.dart
│   ├── repository/               # File-backed repositories & helpers
│   │   ├── doctor_repository.dart
│   │   ├── patient_repository.dart
│   │   ├── medication_repository.dart
│   │   ├── prescription_repository.dart
│   │   ├── medical_log_repository.dart
│   │   └── json_storage_helper.dart
│   └── ui/                       # Console UI wrappers
│       ├── doctor_ui.dart
│       ├── patient_ui.dart
│       └── pharmacist.dart
└── test/                         # Unit tests (if present)
```

## Core concepts

- Domain classes (under `lib/domain`) are simple models with `toJson()` / `fromJson()` helpers. Important classes:
  - `Doctor` — id, firstName, lastName, specialization.
  - `Patient` — id, name, age, contact, prescription ids.
  - `Medication` — id, name, description, dosageForm, instruction.
  - `Prescription` — id, doctor_id, patient_id, diagnosis, date, items, note.
  - `PrescriptionItem` — id, medication_id, quantity, frequency, duration.
  - `MedicalLog` — records for when a patient marked medications as taken/missed.

- Repositories (under `lib/repository`) are thin file-backed stores that read and write the corresponding JSON files. They provide convenience methods such as `getAll()`, `getById()`, `add()`, `update()` and domain-specific helpers.

- UI (under `lib/ui`) is a simple console menu layer that prompts the user to sign up, create prescriptions, and track medication intake.

## Data files

Data files live in `lib/data/` and are JSON arrays of objects. Example files:
- `medications.json` — seed or maintain a central list of available medications (doctors select medication by id when creating a prescription).
- `doctors.json`, `patients.json` — user records for sign-up/lookup.
- `prescriptions.json` — saved prescriptions with embedded prescription items.
- `medical_logs.json` — patient medication intake history.

If you move or rename these files, update repository `filePath` resolvers inside `lib/repository/*_repository.dart`.

## How the flow works

1. Start the app with `dart run lib/main.dart` (or `flutter run` if this is a Flutter project adapted to console). The app loads repositories, then presents a role menu (Doctor/Patient/Pharmacist/Exit).
2. Doctor can sign up (saved to `doctors.json`), create prescriptions for patients (select medication ids from `medications.json` and input quantity/frequency/duration). Prescriptions are saved to `prescriptions.json` and the patient record receives the prescription id.
3. Patient can sign up and then track prescriptions by entering a prescription id; they will be prompted to mark each medication as taken/missed. Those actions are saved in `medical_logs.json`.
4. Pharmacist UI allows adding or seeding medications (updating `medications.json`).

## Seeding medications (one-time)

If you want to populate the medication repository quickly, either:

- Replace `lib/data/medications.json` with the sample list (20 medications) provided in this project, or
- Use the app's pharmacist UI to add medications via the console.

Example: a medication JSON entry:

```json
{
  "id": "m-001",
  "name": "Paracetamol",
  "description": "Analgesic and antipyretic",
  "dosageForm": "tablet",
  "instruction": "Take 1 tablet every 4-6 hours as needed."
}
```

## Tests

- Tests can be added under `test/` and run with `dart test` (or `flutter test`). The project includes example unit tests for repository loading and prescription flows.

## Common tasks & debugging

- If the program creates a new `data/` folder instead of using the existing files, ensure the repository `filePath` resolver checks the correct candidate locations. The code uses a list of candidates such as `code/lib/data/...`, `lib/data/...` and `data/...`.

- If sign-up fails with `Null` errors while reading JSON, verify your JSON objects use the expected keys (e.g., `firstName`, `lastName`). The `fromJson` factories defensively coalesce alternate key names.

- To see which file path a repository will use, temporarily print `Repository().filePath` in `main.dart` during startup.
