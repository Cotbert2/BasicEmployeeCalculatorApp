import '../entities/employee_calculation.dart';
import '../repositories/employee_calculation_repository.dart';

class GeneratePdfReportUseCase {
  final EmployeeCalculationRepository repository;

  GeneratePdfReportUseCase(this.repository);

  Future<String> call(List<EmployeeCalculation> calculations) async {
    return await repository.generatePdfReport(calculations);
  }
}