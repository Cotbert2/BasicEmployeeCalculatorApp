import '../entities/employee_calculation.dart';
import '../repositories/employee_calculation_repository.dart';

class GetCalculationHistoryUseCase {
  final EmployeeCalculationRepository repository;

  GetCalculationHistoryUseCase(this.repository);

  Future<List<EmployeeCalculation>> call() async {
    return await repository.getAllCalculations();
  }
}