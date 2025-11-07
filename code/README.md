# Hospital Prescription System

Small file-backed Hospital Prescription & Medication Tracking console app in Dart. Data is stored as JSON files under `lib/data/`.

This README is updated to reflect recent domain, repository and UI changes: Gender enums, contact fields, repository update/delete methods, JsonStorageHelper helpers, and integration tests.

## Project layout

```
code/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── data/
│   │   ├── doctors.json
│   │   ├── patients.json
│   │   ├── medications.json
│   │   ├── prescriptions.json
│   │   └── medical_logs.json
│   ├── domain/
│   │   ├── doctor.dart          # Doctor model (gender, contactInfo)
│   │   ├── patient.dart         # Patient model (gender)
│   │   ├── medication.dart
│   │   ├── prescription.dart
│   │   ├── prescription_item.dart
│   │   └── medical_log.dart
│   ├── repository/
│   │   ├── doctor_repository.dart
│   │   ├── patient_repository.dart
│   │   ├── medication_repository.dart
│   │   ├── prescription_repository.dart
│   │   ├── medical_log_repository.dart
│   │   └── json_storage_helper.dart
│   └── ui/
│       ├── doctor_ui.dart
│       ├── patient_ui.dart
│       └── pharmacist.dart
└── test/
    └── test.dart
```

## Key updates (summary)

- Domain
  - Doctor now contains:
    - gender: Gender enum (male, female).
    - contactInfo: String (phone/email).
  - Patient now contains:
    - gender: Gender enum (male, female) (optional handling in UI).
- Repository layer
  - Each repository implements standard CRUD: getAll(), findById(), add()/addOrUpdate(), update(entity), deleteById(id).
  - PrescriptionRepository.getByPatientId(...) and MedicalLogRepository.deleteByPrescriptionId(...) available.
  - JsonStorageHelper includes read/write helpers and update helpers (update by id / predicate).
  - Repositories are defensive when reading malformed JSON (skip invalid entries).
- UI layer
  - DoctorUI, PatientUI and Pharmacist UIs updated to collect/display gender and contact info.
  - Simple gender input: accept "m"/"f" (default or fallback configurable in UI).
  - DoctorUI supports create, update, delete prescriptions and Doctor sign-up (with gender/contact).
  - PatientUI supports sign-up, track prescription, view logs, delete patient.
  - Pharmacist UI supports add and delete medication.
- Tests
  - `code/test/test.dart` performs repository integration tests and restores original JSON files after running.

## Data formats & examples

All files are JSON arrays. Domain factories read these shapes.

- doctors.json entry:
```json
{
  "id": "uuid",
  "firstName": "John",
  "lastName": "Doe",
  "gender": "male",
  "specialization": "General",
  "contactInfo": "john@example.com"
}
```

- patients.json entry:
```json
{
  "id": "uuid",
  "firstName": "Jane",
  "lastName": "Doe",
  "age": 30,
  "contact": "0123456789",
  "gender": "female"
}
```

- prescriptions.json entry:
```json
{
  "id": "uuid",
  "doctor_id": "uuid",
  "patient_id": "uuid",
  "diagnosis": "cold",
  "prescription_date": "2025-11-06T...",
  "items": [
     {"id":"uuid","medication_id":"m-001","quantity":2,"frequency":"twice a day","duration":5}
  ],
  "note": "Take with food"
}
```

- medical_logs.json entry:
```json
{
  "log_id": "uuid",
  "patient_id": "uuid",
  "prescription_id": "uuid",
  "dateTime": "2025-11-06T...",
  "medicationStatus": {"m-001": true, "m-002": false}
}
```

If a file is empty, initialize it with `[]`.

## How to run

From the `code/` folder:

- Run app: `dart run lib/main.dart`
- Run tests: `dart test` (or `dart test test/test.dart`)

The app shows a role-selection menu (Doctor / Patient / Pharmacist / Exit). UI prompts accept simple gender inputs ("m"/"f") and optional contact info.

## Developer notes

- Keep domain ↔ repository separation: all CRUD logic lives in repositories; domain models are plain data + (de)serialization.
- If you encounter "Gender" name conflicts (multiple Gender declarations), import with hiding/aliasing:
  - Example: `import 'package:.../patient.dart' hide Gender;` or `import '.../patient.dart' as patient;`
- To debug which JSON file a repository uses, print `Repository().filePath` in `main.dart`.
- Repositories try candidate paths: `code/lib/data/...`, `lib/data/...`, `data/...`. Ensure your JSON files are under one of these.

## Next steps / suggestions

- Add explicit "unknown" value to Gender enum if needed.
- Add input validation and sanitize UI inputs.
- Add unit tests for UI flows (mock stdin/stdout).
- Consider migrating from JSON files to Hive or SQLite for concurrency.
