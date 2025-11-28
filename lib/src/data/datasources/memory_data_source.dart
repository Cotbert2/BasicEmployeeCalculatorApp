import '../../domain/entities/employee_calculation.dart';

abstract class MemoryDataSource {
  List<EmployeeCalculation> getCalculations();
  void saveCalculation(EmployeeCalculation calculation);
  void clearCalculations();
}

class MemoryDataSourceImpl implements MemoryDataSource {
  static final List<EmployeeCalculation> _calculations = [];

  @override
  List<EmployeeCalculation> getCalculations() {
    return List.from(_calculations); // Retorna una copia para evitar modificaciones externas
  }

  @override
  void saveCalculation(EmployeeCalculation calculation) {
    _calculations.add(calculation);
  }

  @override
  void clearCalculations() {
    _calculations.clear();
  }
}