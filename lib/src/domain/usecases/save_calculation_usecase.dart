import '../entities/employee_calculation.dart';
import '../repositories/employee_calculation_repository.dart';

class SaveCalculationUseCase {
  final EmployeeCalculationRepository repository;

  SaveCalculationUseCase(this.repository);

  Future<void> call(EmployeeCalculation calculation) async {
    await repository.saveCalculation(calculation);
  }
}