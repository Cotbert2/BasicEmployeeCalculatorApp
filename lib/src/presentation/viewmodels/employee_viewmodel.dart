import 'package:flutter/material.dart';
import './../../domain/entities/employee.dart';
import './../../domain/entities/result_employee.dart';
import './../../domain/entities/employee_calculation.dart';
import './../../domain/validators/employee_validator.dart';

import './../../domain/usecases/compute_bonus_usecase.dart';
import './../../domain/usecases/save_calculation_usecase.dart';
import './../../domain/usecases/get_calculation_history_usecase.dart';
import './../../domain/usecases/clear_history_usecase.dart';
import './../../domain/usecases/generate_pdf_report_usecase.dart';
import './../../domain/usecases/share_file_usecase.dart';

class EmployeeViewModel extends ChangeNotifier {
  final ComputeBonusUseCase computeBonusUseCase;
  final SaveCalculationUseCase saveCalculationUseCase;
  final GetCalculationHistoryUseCase getCalculationHistoryUseCase;
  final ClearHistoryUseCase clearHistoryUseCase;
  final GeneratePdfReportUseCase generatePdfReportUseCase;
  final ShareFileUseCase shareFileUseCase;

  EmployeeViewModel({
    required this.computeBonusUseCase,
    required this.saveCalculationUseCase,
    required this.getCalculationHistoryUseCase,
    required this.clearHistoryUseCase,
    required this.generatePdfReportUseCase,
    required this.shareFileUseCase,
  });

  ResultEmployee? _resultEmployee;
  List<EmployeeCalculation> _calculationHistory = [];
  bool _isLoading = false;
  
  ResultEmployee? get resultEmployee => _resultEmployee;
  List<EmployeeCalculation> get calculationHistory => _calculationHistory;
  bool get isLoading => _isLoading;

  bool validateAndCompute(String name, String salaryText, String yearsText, Function(String) onError) {
    final nameError = EmployeeValidator.validateName(name);
    final salaryError = EmployeeValidator.validateSalary(salaryText);
    final yearsError = EmployeeValidator.validateYearsOfExperience(yearsText);
    
    if (nameError != null || salaryError != null || yearsError != null) {
      // Construir mensaje de error más específico
      List<String> errors = [];
      if (nameError != null) errors.add('• $nameError');
      if (salaryError != null) errors.add('• $salaryError');
      if (yearsError != null) errors.add('• $yearsError');
      
      onError('Campos inválidos:\n${errors.join('\n')}');
      return false;
    }
    
    computeBonus(name, salaryText, yearsText);
    return true;
  }

  Future<void> computeBonus(String name, String salaryText, String yearsText) async {
    try {
      _isLoading = true;
      notifyListeners();

      final salary = double.parse(salaryText);
      final years = double.parse(yearsText);
      
      final employee = Employee(name: name, salary: salary, yearsOfExperience: years);
      _resultEmployee = computeBonusUseCase.call(employee);
      
      // Guardar el cálculo en el historial
      final calculation = EmployeeCalculation.fromResultEmployee(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        salary: salary,
        yearsOfExperience: years,
        bonus: _resultEmployee!.bonus,
        finalSalary: _resultEmployee!.finalSalary,
      );
      
      await saveCalculationUseCase.call(calculation);
      await loadCalculationHistory();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _resultEmployee = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCalculationHistory() async {
    try {
      _calculationHistory = await getCalculationHistoryUseCase.call();
      notifyListeners();
    } catch (e) {
      // Error silencioso, mantener lista vacía
      notifyListeners();
    }
  }

  Future<void> clearHistory([Function(String)? onError]) async {
    try {
      _isLoading = true;
      notifyListeners();

      await clearHistoryUseCase.call();
      _calculationHistory = [];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      onError?.call('Error al limpiar el historial');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateAndSharePdfReport([Function(String)? onError]) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_calculationHistory.isEmpty) {
        onError?.call('No hay cálculos para generar el reporte');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final filePath = await generatePdfReportUseCase.call(_calculationHistory);
      await shareFileUseCase.call(filePath);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      onError?.call('Error al generar o compartir el reporte PDF');
      _isLoading = false;
      notifyListeners();
    }
  }

  ResultEmployee compute(String name, double salary, double yearsOfExperience) {
    final employee =
        Employee(name: name, salary: salary, yearsOfExperience: yearsOfExperience);
    _resultEmployee = computeBonusUseCase.call(employee);
    notifyListeners();
    return _resultEmployee!;
  }
}
