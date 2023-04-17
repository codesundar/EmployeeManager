class Employee {
  int? id;
  String fullName;
  String role;
  String startDate;
  String endDate;
  bool isCurrentEmployee;

  Employee({
    this.id,
    required this.fullName,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.isCurrentEmployee,
  });

  Employee.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        fullName = json['fullName'] ?? '',
        role = json['role'] ?? '',
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        isCurrentEmployee = EmployeeHelper().isCurrentEmployee(json['endDate']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'fullName': fullName,
      'role': role,
      'startDate': startDate,
      'endDate': endDate
    };
    return data;
  }
}

class EmployeeHelper {
  bool isCurrentEmployee(endDate) {
    DateTime today = DateTime.now();
    return DateTime.parse(endDate).isAfter(today);
  }
}
