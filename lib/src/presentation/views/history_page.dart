import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/employee_calculation.dart';
import '../viewmodels/employee_viewmodel.dart';
import '../widgets/confirmation_dialog.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeViewModel>().loadCalculationHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Cálculos'),
        centerTitle: true,
        actions: [
          Consumer<EmployeeViewModel>(
            builder: (context, viewModel, child) {
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'clear') {
                    _showClearHistoryDialog(context, viewModel);
                  } else if (value == 'share') {
                    await viewModel.generateAndSharePdfReport();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Compartir PDF'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'clear',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Limpiar Historial'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<EmployeeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Procesando...'),
                ],
              ),
            );
          }

          if (viewModel.calculationHistory.isEmpty && !viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.grey,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay cálculos en el historial',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (viewModel.calculationHistory.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.grey,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay cálculos en el historial',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Los cálculos aparecerán aquí automáticamente',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSummaryCard(viewModel.calculationHistory),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.calculationHistory.length,
                  itemBuilder: (context, index) {
                    final calculation = viewModel.calculationHistory[index];
                    return _buildCalculationCard(calculation);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(List<EmployeeCalculation> calculations) {
    final totalSalaries = calculations.fold(0.0, (sum, calc) => sum + calc.salary);
    final totalBonuses = calculations.fold(0.0, (sum, calc) => sum + calc.bonus);
    final totalFinalSalaries = calculations.fold(0.0, (sum, calc) => sum + calc.finalSalary);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total Empleados', '${calculations.length}', Icons.people),
                _buildSummaryItem('Total Bonos', '\$${totalBonuses.toStringAsFixed(2)}', Icons.card_giftcard),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Salarios Base', '\$${totalSalaries.toStringAsFixed(2)}', Icons.attach_money),
                _buildSummaryItem('Salarios Finales', '\$${totalFinalSalaries.toStringAsFixed(2)}', Icons.account_balance_wallet),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCalculationCard(EmployeeCalculation calculation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  calculation.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  calculation.calculationDate.toString().substring(0, 16),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Salario Base', '\$${calculation.salary.toStringAsFixed(2)}', Colors.black),
                ),
                Expanded(
                  child: _buildDetailItem('Años Exp.', '${calculation.yearsOfExperience.toInt()}', Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Bonificación', '\$${calculation.bonus.toStringAsFixed(2)}', Colors.black),
                ),
                Expanded(
                  child: _buildDetailItem('Salario Final', '\$${calculation.finalSalary.toStringAsFixed(2)}', Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  void _showClearHistoryDialog(BuildContext context, EmployeeViewModel viewModel) {
    ConfirmationDialog.show(
      context: context,
      title: 'Confirmar Eliminación',
      content: '¿Estás seguro de que deseas eliminar todo el historial de cálculos? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      confirmColor: Colors.red,
      onConfirm: () async {
        await viewModel.clearHistory();
      },
    );
  }
}