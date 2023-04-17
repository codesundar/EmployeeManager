import 'package:employeeadmin/common/app_themes.dart';
import 'package:employeeadmin/features/employee/providers/employee_provider.dart';
import 'package:employeeadmin/route_generator.dart';
import 'package:employeeadmin/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => EmployeeProvider()))
      ],
      child: MaterialApp(
        title: 'Employee Portal',
        theme: AppThemes.primaryTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        scaffoldMessengerKey: snackbarKey,
      ),
    );
  }
}
