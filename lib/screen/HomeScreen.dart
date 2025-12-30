import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:servicio_tecnico/classes/Budget.dart';
import 'package:servicio_tecnico/components/Card.dart';
import 'package:servicio_tecnico/providers/budget_provider.dart';
import 'package:servicio_tecnico/screen/BudgetFormScreen.dart';
import 'package:servicio_tecnico/screen/ViewBudget.dart';
import 'package:servicio_tecnico/utils/budgetMockupData.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<HomeScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool demoMode = false;
  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() {
    setState(() {
      budgets = demoMode ? mockBudgets : ref.read(budgetsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Servicio técnico'),
          backgroundColor: const Color(0xFF2A3D53),
          foregroundColor: Colors.white),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3D53),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(15)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BudgetFormScreen()),
                  ).then((value) => {budgets = ref.watch(budgetsProvider)});
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text(
                      "Agregar nuevo",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ultimos 5 presupuestos",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Column(
                    children: budgets.isEmpty
                        ? [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  "No hay presupuestos",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          ]
                        : budgets.map((budget) {
                            return CardItem(
                              budget: budget,
                              onDelete: () {
                                ref
                                    .read(budgetsProvider.notifier)
                                    .removeBudget(budget.id);
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewBudget(
                                            screenshotController:
                                                screenshotController,
                                            data: budget.toJson(),
                                          )),
                                );
                              },
                            );
                          }).toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
