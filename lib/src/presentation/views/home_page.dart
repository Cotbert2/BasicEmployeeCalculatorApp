import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../viewmodels/employee_viewmodel.dart';
import './../routes/app_routes.dart';


//molecula
class InputsSection extends StatelessWidget {
  final TextEditingController salaryController;
  final TextEditingController yearsController;
  final TextEditingController nameController;

  const InputsSection({
    super.key,
    required this.salaryController,
    required this.yearsController,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Salario Actual',
            border: OutlineInputBorder(),
            prefixText: '\$ ',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: yearsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Años de Experiencia',
            border: OutlineInputBorder(),
            helperText: 'Ingrese un valor entre 0 y 80 años',
          ),
        ),
      ],
    );
  }
}


//// organism (filend and button)
class HomeCard extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController salaryController;
  final TextEditingController yearsController;

  const HomeCard({
    super.key,
    required this.nameController,
    required this.salaryController,
    required this.yearsController,
  });

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeViewModel>(
      builder: (context, employeeViewModel, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de empleado
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Calculadora de Aumento Salarial',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                InputsSection(
                  nameController: widget.nameController,
                  salaryController: widget.salaryController,
                  yearsController: widget.yearsController,
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: employeeViewModel.isLoading
                      ? null
                      : () async {
                          final isValid = employeeViewModel.validateAndCompute(
                            widget.nameController.text,
                            widget.salaryController.text,
                            widget.yearsController.text,
                            (errorMessage) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            },
                          );
                          
                          if (isValid && employeeViewModel.resultEmployee != null && context.mounted) {
                            Navigator.pushNamed(
                              context, 
                              AppRoutes.result,
                              arguments: employeeViewModel.resultEmployee,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: employeeViewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Calcular Aumento'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


//page
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController salaryController = TextEditingController();
    final TextEditingController yearsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Aumento Salarial'),
        centerTitle: true,
        actions: [
          Consumer<EmployeeViewModel>(
            builder: (context, viewModel, child) {
              return PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'history') {
                    Navigator.pushNamed(context, AppRoutes.history);
                  } else if (value == 'clear') {
                    _showClearHistoryDialog(context, viewModel);
                  } else if (value == 'share') {
                    viewModel.generateAndSharePdfReport((errorMessage) {
                      if (context.mounted) {
                        _showErrorSnackBar(context, errorMessage);
                      }
                    });
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'history',
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('Ver Historial'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
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
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Eliminar Historial', style: TextStyle(color: Colors.red)),
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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: HomeCard(
                    nameController: nameController,
                    salaryController: salaryController,
                    yearsController: yearsController,
                  ),
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Procesando...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, EmployeeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Eliminación',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar todo el historial de cálculos? Esta acción no se puede deshacer.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                viewModel.clearHistory((errorMessage) {
                  if (context.mounted) {
                    _showErrorSnackBar(context, errorMessage);
                  }
                });
                if (context.mounted) {
                  _showSuccessSnackBar(context, 'Historial eliminado exitosamente');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
