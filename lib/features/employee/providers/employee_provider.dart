import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/features/employee/helpers/database_handler.dart';
import 'package:employeeadmin/features/employee/models/employee_model.dart';
import 'package:employeeadmin/utils/globals.dart';
import 'package:flutter/material.dart';

class EmployeeProvider extends ChangeNotifier {
  final handler = DatabaseHandler();
  late Employee? _employee;
  late Employee? _lastDeletedEmployee;
  List<Employee> _employees = [];

  List<Employee> get employees => [..._employees];

  Employee? get employee => _employee;

  set employee(e) => _employee = e;

  void updateCurrentEmployee(e) {
    _employee = e;
    notifyListeners();
  }

  void retriveEmployees() async {
    _employees = await handler.retriveEmployees();
    notifyListeners();
  }

  void insertEmployee(Employee employee) async {
    int id = await handler.insertEmployee(employee);
    if (id != 0) {
      employee.id = id;
      _employees.add(employee);
      notifyListeners();
    }
  }

  void updateEmployee(Employee employee) async {
    if (await handler.updateEmployee(employee) != 0) {
      int index = _employees.indexWhere((element) => element.id == employee.id);
      _employees[index] = employee;
      notifyListeners();
    }
  }

  void deleteEmployee(Employee employee) async {
    _lastDeletedEmployee = employee;
    if (await handler.deleteEmployee(employee) != 0) {
      _employees.removeWhere((element) => element.id == employee.id);
      showUndoDelete();
      notifyListeners();
    }
  }

  void showUndoDelete() {
    final SnackBar snackBar = SnackBar(
      content: Text(AppStrings.employeeDeleteMessage),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppStrings.undo,
        onPressed: () {
          insertEmployee(_lastDeletedEmployee!);
        },
      ),
    );
    snackbarKey.currentState?.showSnackBar(snackBar);
  }
}
