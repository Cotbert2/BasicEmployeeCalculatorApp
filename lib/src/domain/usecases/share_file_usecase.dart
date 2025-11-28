import '../repositories/employee_calculation_repository.dart';

class ShareFileUseCase {
  final EmployeeCalculationRepository repository;

  ShareFileUseCase(this.repository);

  Future<void> call(String filePath) async {
    await repository.shareFile(filePath);
  }
}