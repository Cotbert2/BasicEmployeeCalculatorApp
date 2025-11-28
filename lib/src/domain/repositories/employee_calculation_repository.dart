import '../entities/employee_calculation.dart';

abstract class EmployeeCalculationRepository {
  Future<List<EmployeeCalculation>> getAllCalculations();
  Future<void> saveCalculation(EmployeeCalculation calculation);
  Future<void> clearHistory();
  Future<String> generatePdfReport(List<EmployeeCalculation> calculations);
  Future<void> shareFile(String filePath);
}