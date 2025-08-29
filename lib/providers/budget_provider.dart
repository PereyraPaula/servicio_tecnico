import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:servicio_tecnico/classes/Budget.dart';
import 'package:servicio_tecnico/classes/BudgetItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferencesProvider no fue sobreescrito');
});

final budgetsProvider =
    StateNotifierProvider<BudgetsNotifier, List<Budget>>((ref) {
  return BudgetsNotifier();
});

class BudgetsNotifier extends StateNotifier<List<Budget>> {
  BudgetsNotifier() : super([]) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('budgets_data');
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        final List<Budget> loadedBudgets =
            jsonList.map((json) => Budget.fromJson(json)).toList();

        loadedBudgets.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        state = loadedBudgets.take(5).toList();
      }
    } catch (e) {
      print('Error loading budgets: $e');
      state = [];
    }
  }

  // Guardar datos en SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.map((budget) => budget.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString('budgets_data', jsonString);
    } catch (e) {
      print('Error saving budgets: $e');
    }
  }

  void _limitToFiveRecent() {
    if (state.length > 5) {
      final sorted = List<Budget>.from(state)
        ..sort((a, b) => b.creationDate.compareTo(a.creationDate));
      state = sorted.take(5).toList();
    }
  }

  void addBudget(Budget budget) {
    state = [...state, budget]
      ..sort((a, b) => b.creationDate.compareTo(a.creationDate));
    _limitToFiveRecent();
    _saveToStorage();
  }

  void removeBudget(String budgetId) {
    state = state.where((budget) => budget.id != budgetId).toList();
    _saveToStorage();
  }

  void updateBudget(Budget updatedBudget) {
    state = state
        .map((budget) => budget.id == updatedBudget.id ? updatedBudget : budget)
        .toList();
  }

  void addItemToBudget(String budgetId, BudgetItem item) {
    state = state.map((budget) {
      if (budget.id == budgetId) {
        return budget.addItem(item);
      }
      return budget;
    }).toList();
    _saveToStorage();
  }

  void removeItemFromBudget(String budgetId, String itemId) {
    state = state.map((budget) {
      if (budget.id == budgetId) {
        return budget.removeItem(itemId);
      }
      return budget;
    }).toList();
    _saveToStorage();
  }
}
