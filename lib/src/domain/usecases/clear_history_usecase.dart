import '../repositories/employee_calculation_repository.dart';

class ClearHistoryUseCase {
  final EmployeeCalculationRepository repository;

  ClearHistoryUseCase(this.repository);

  Future<void> call() async {
    await repository.clearHistory();
  }
}