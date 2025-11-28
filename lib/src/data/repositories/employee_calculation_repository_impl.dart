import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/employee_calculation.dart';
import '../../domain/repositories/employee_calculation_repository.dart';
import '../datasources/memory_data_source.dart';

class EmployeeCalculationRepositoryImpl implements EmployeeCalculationRepository {
  final MemoryDataSource memoryDataSource;

  EmployeeCalculationRepositoryImpl(this.memoryDataSource);

  @override
  Future<List<EmployeeCalculation>> getAllCalculations() async {
    return memoryDataSource.getCalculations();
  }

  @override
  Future<void> saveCalculation(EmployeeCalculation calculation) async {
    memoryDataSource.saveCalculation(calculation);
  }

  @override
  Future<void> clearHistory() async {
    memoryDataSource.clearCalculations();
  }

  @override
  Future<String> generatePdfReport(List<EmployeeCalculation> calculations) async {
    final pdf = pw.Document();

    // Calcular totales
    final totalSalaries = calculations.fold(0.0, (sum, calc) => sum + calc.salary);
    final totalBonuses = calculations.fold(0.0, (sum, calc) => sum + calc.bonus);
    final totalFinalSalaries = calculations.fold(0.0, (sum, calc) => sum + calc.finalSalary);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Título
          pw.Header(
            level: 0,
            child: pw.Text(
              'Reporte de Cálculos Salariales',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),

          // Información general
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Resumen General',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Total de empleados calculados: ${calculations.length}'),
                pw.Text('Total salarios base: \$${totalSalaries.toStringAsFixed(2)}'),
                pw.Text('Total bonificaciones: \$${totalBonuses.toStringAsFixed(2)}'),
                pw.Text('Total salarios finales: \$${totalFinalSalaries.toStringAsFixed(2)}'),
                pw.Text('Fecha de generación: ${DateTime.now().toString().substring(0, 16)}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Tabla de empleados
          pw.Text(
            'Detalle por Empleado',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black, width: 1),
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Encabezado
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  _buildTableCell('Nombre', isHeader: true),
                  _buildTableCell('Salario Base', isHeader: true),
                  _buildTableCell('Años', isHeader: true),
                  _buildTableCell('Bonificación', isHeader: true),
                  _buildTableCell('Salario Final', isHeader: true),
                  _buildTableCell('Fecha', isHeader: true),
                ],
              ),
              // Datos
              ...calculations.map((calc) => pw.TableRow(
                children: [
                  _buildTableCell(calc.name),
                  _buildTableCell('\$${calc.salary.toStringAsFixed(2)}'),
                  _buildTableCell('${calc.yearsOfExperience.toInt()}'),
                  _buildTableCell('\$${calc.bonus.toStringAsFixed(2)}'),
                  _buildTableCell('\$${calc.finalSalary.toStringAsFixed(2)}'),
                  _buildTableCell(calc.calculationDate.toString().substring(0, 10)),
                ],
              )),
            ],
          ),
        ],
      ),
    );

    // Guardar archivo
    final directory = Directory.systemTemp;
    final fileName = 'reporte_salarios_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  @override
  Future<void> shareFile(String filePath) async {
    final xFile = XFile(filePath);
    await Share.shareXFiles([xFile], text: 'Reporte de Cálculos Salariales');
  }
}