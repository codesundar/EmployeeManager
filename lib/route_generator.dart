import 'package:employeeadmin/common/app_routes.dart';
import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/features/employee/views/employee_list.dart';
import 'package:employeeadmin/features/employee/views/manage_employee.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.HOME:
        return MaterialPageRoute(builder: (context) => const EmployeeList());

      case AppRoutes.MANAGE_EMPLOYEE:
        return MaterialPageRoute(builder: (context) => const ManageEmployee());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(AppStrings.pageNotFound),
        ),
      );
    });
  }
}
