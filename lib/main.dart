import 'package:clean_arc/src/presentation/themes/general_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/domain/usecases/compute_bonus_usecase.dart';
import 'src/domain/usecases/save_calculation_usecase.dart';
import 'src/domain/usecases/get_calculation_history_usecase.dart';
import 'src/domain/usecases/clear_history_usecase.dart';
import 'src/domain/usecases/generate_pdf_report_usecase.dart';
import 'src/domain/usecases/share_file_usecase.dart';

import 'src/data/datasources/memory_data_source.dart';
import 'src/data/repositories/employee_calculation_repository_impl.dart';

import 'src/presentation/viewmodels/employee_viewmodel.dart';
import 'src/presentation/routes/app_routes.dart';

void main() {
  // Configuración de dependencias
  final memoryDataSource = MemoryDataSourceImpl();
  final repository = EmployeeCalculationRepositoryImpl(memoryDataSource);
  
  final computeBonusUseCase = ComputeBonusUseCase();
  final saveCalculationUseCase = SaveCalculationUseCase(repository);
  final getCalculationHistoryUseCase = GetCalculationHistoryUseCase(repository);
  final clearHistoryUseCase = ClearHistoryUseCase(repository);
  final generatePdfReportUseCase = GeneratePdfReportUseCase(repository);
  final shareFileUseCase = ShareFileUseCase(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => EmployeeViewModel(
        computeBonusUseCase: computeBonusUseCase,
        saveCalculationUseCase: saveCalculationUseCase,
        getCalculationHistoryUseCase: getCalculationHistoryUseCase,
        clearHistoryUseCase: clearHistoryUseCase,
        generatePdfReportUseCase: generatePdfReportUseCase,
        shareFileUseCase: shareFileUseCase,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aumento Operario',
      debugShowCheckedModeBanner: false,

      theme: GeneralTheme.generalThemeLight,

      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
