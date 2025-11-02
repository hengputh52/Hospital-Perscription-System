import '../repository/medical_log_repository.dart';
import '../domain/medical_log.dart';

class PatientUI {
  final MedicalLogRepository logRepo;

  PatientUI(this.logRepo);

  void markMedication(String prescriptionId, String patientId, String medicationId, bool taken) {
    final log = MedicalLog(
      prescription_id: prescriptionId,
      patient_id: patientId,
      dateTime: DateTime.now(),
      medicationStatus: {medicationId: taken},
    );
    logRepo.add(log);
    print(taken ? "Medication marked as taken." : "Medication marked as missed.");
  }
}
