import 'package:employeeadmin/common/app_colors.dart';
import 'package:employeeadmin/common/app_images.dart';
import 'package:employeeadmin/common/app_routes.dart';
import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/common/app_themes.dart';
import 'package:employeeadmin/features/employee/models/employee_model.dart';
import 'package:employeeadmin/utils/datetime_helper.dart';
import 'package:employeeadmin/features/employee/providers/employee_provider.dart';
import 'package:employeeadmin/features/employee/widgets/no_employee_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<EmployeeProvider>(context, listen: false).retriveEmployees();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.employeeList),
      ),
      body: Consumer<EmployeeProvider>(builder: (context, state, index) {
        if (state.employees.isEmpty) {
          return const NoEmployeeRecordFound();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupedListView(
                shrinkWrap: true,
                elements: state.employees,
                order: GroupedListOrder.DESC,
                groupBy: (element) {
                  return element.isCurrentEmployee.toString();
                },
                separator: Container(
                  color: Colors.white,
                  child: const Divider(),
                ),
                groupSeparatorBuilder: _buildSeparator,
                itemBuilder: _buildUserCard,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppStrings.swipeLeftToDelete,
                  style: AppThemes.listTileText,
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        enableFeedback: false,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        onPressed: () {
          Provider.of<EmployeeProvider>(context, listen: false).employee = null;
          Navigator.pushNamed(context, AppRoutes.MANAGE_EMPLOYEE);
        },
        child: SvgPicture.asset(AppImages.add),
      ),
    );
  }

  Widget _buildSeparator(groupByValue) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        groupByValue == 'true'
            ? AppStrings.currentEmployees
            : AppStrings.previousEmployees,
        style: AppThemes.listSepartorTitle,
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Employee employee) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(employee.id.toString()),
      background: Container(color: AppColors.deleteBgColor),
      secondaryBackground: Container(
        color: AppColors.deleteBgColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(AppImages.trash),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          Provider.of<EmployeeProvider>(context, listen: false)
              .deleteEmployee(employee);
        }
        return false;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        tileColor: Colors.white,
        onTap: () {
          Provider.of<EmployeeProvider>(context, listen: false).employee =
              employee;
          Navigator.pushNamed(context, AppRoutes.MANAGE_EMPLOYEE);
        },
        title: Text(
          employee.fullName,
          style: AppThemes.listTileTitle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              employee.role,
              style: AppThemes.listTileText,
            ),
            const SizedBox(height: 4),
            employee.isCurrentEmployee
                ? Text(
                    'From ${DateTimeHelper.formatDate(DateTime.parse(employee.startDate))}',
                    style: AppThemes.listTileText,
                  )
                : Text(
                    '${DateTimeHelper.formatDate(DateTime.parse(employee.startDate))} - ${DateTimeHelper.formatDate(DateTime.parse(employee.endDate))}',
                    style: AppThemes.listTileText,
                  )
          ],
        ),
      ),
    );
  }
}
