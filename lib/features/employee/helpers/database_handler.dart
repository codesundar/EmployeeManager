import 'package:employeeadmin/features/employee/models/employee_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  final String _dbName = 'employee.db';
  final int _version = 1;
  final String _employeeTableName = 'employee';

  Future<Database> _initalizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, _dbName),
      version: _version,
      onCreate: (db, version) async {
        String query = '''
              CREATE TABLE $_employeeTableName (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                fullName TEXT NOT NULL,
                role TEXT NOT NULL,
                startDate TEXT NOT NULL,
                endDate TEXT NOT NULL)
            ''';
        await db.execute(query);
      },
    );
  }

  Future<List<Employee>> retriveEmployees() async {
    final Database db = await _initalizeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.query(_employeeTableName);
    return queryResult.map((e) => Employee.fromJson(e)).toList();
  }

  Future<int> insertEmployee(Employee employee) async {
    final Database db = await _initalizeDB();
    int result = await db.insert(
      _employeeTableName,
      employee.toJson(),
    );
    return result;
  }

  Future<int> updateEmployee(Employee employee) async {
    final Database db = await _initalizeDB();
    int result = await db.update(
      _employeeTableName,
      employee.toJson(),
      where: 'id  = ?',
      whereArgs: [employee.id],
    );
    return result;
  }

  Future<int> deleteEmployee(Employee employee) async {
    final Database db = await _initalizeDB();
    int result = await db.delete(
      _employeeTableName,
      where: 'id  = ?',
      whereArgs: [employee.id],
    );
    return result;
  }
}
