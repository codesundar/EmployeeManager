import 'package:employeeadmin/common/app_colors.dart';
import 'package:employeeadmin/common/app_images.dart';
import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/common/app_themes.dart';
import 'package:employeeadmin/utils/datetime_helper.dart';
import 'package:employeeadmin/features/employee/models/employee_model.dart';
import 'package:employeeadmin/features/employee/providers/employee_provider.dart';
import 'package:employeeadmin/features/employee/views/calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ManageEmployee extends StatefulWidget {
  const ManageEmployee({super.key});
  // final dynamic args;

  @override
  State<ManageEmployee> createState() => _ManageEmployeeState();
}

class _ManageEmployeeState extends State<ManageEmployee> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _roleCtrl = TextEditingController();
  final TextEditingController _startsAtCtrl = TextEditingController();
  final TextEditingController _endsAtCtrl = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool hasExistingValue = false;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    _startsAtCtrl.text = DateTimeHelper.formatDate(startDate!);
  }

  @override
  Widget build(BuildContext context) {
    EmployeeProvider employeeProvider = Provider.of<EmployeeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          employeeProvider.employee == null
              ? AppStrings.addEmployeeDetails
              : AppStrings.editEmployeeDetails,
        ),
        actions: [
          employeeProvider.employee != null
              ? IconButton(
                  onPressed: () {
                    Provider.of<EmployeeProvider>(context, listen: false)
                        .deleteEmployee(employeeProvider.employee!);
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(AppImages.trash),
                )
              : const SizedBox()
        ],
      ),
      body: Consumer<EmployeeProvider>(builder: (context, state, _) {
        if (state.employee != null && !hasExistingValue) {
          _nameCtrl.text = state.employee!.fullName;
          _roleCtrl.text = state.employee!.role;
          startDate = DateTime.parse(state.employee!.startDate);
          endDate = DateTime.parse(state.employee!.endDate);
          _startsAtCtrl.text = DateTimeHelper.formatDate(startDate!);
          _endsAtCtrl.text = DateTimeHelper.formatDate(endDate!);
          hasExistingValue = true;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: AppThemes.inputDecoration(
                  AppImages.person,
                  AppStrings.employeeName,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: showRolePicker,
                child: TextFormField(
                  enabled: false,
                  controller: _roleCtrl,
                  decoration: AppThemes.inputDecoration(
                    AppImages.role,
                    AppStrings.selectRole,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => openCustomDatePicker('startDate'),
                      child: TextFormField(
                        controller: _startsAtCtrl,
                        enabled: false,
                        decoration: AppThemes.inputDecoration(
                          AppImages.calender,
                          DateTimeHelper.isToday(startDate!)
                              ? AppStrings.today
                              : AppStrings.nodate,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(AppImages.arrowRight),
                  const SizedBox(width: 8),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => openCustomDatePicker('endDate'),
                      child: TextFormField(
                        enabled: false,
                        controller: _endsAtCtrl,
                        decoration: AppThemes.inputDecoration(
                          AppImages.calender,
                          AppStrings.nodate,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.backgroundColor,
                      width: 1,
                    ),
                  ),
                ),
                width: double.maxFinite,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: AppThemes.secondaryButton,
                    child: Text(AppStrings.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: AppThemes.primaryButton,
                    onPressed: () {
                      Employee employee = Employee(
                        fullName: _nameCtrl.text,
                        role: _roleCtrl.text,
                        startDate: startDate.toString(),
                        endDate: endDate.toString(),
                        isCurrentEmployee: EmployeeHelper().isCurrentEmployee(
                          endDate.toString(),
                        ),
                      );
                      if (employeeProvider.employee == null) {
                        Provider.of<EmployeeProvider>(context, listen: false)
                            .insertEmployee(employee);
                      } else {
                        employee.id = employeeProvider.employee!.id;
                        Provider.of<EmployeeProvider>(context, listen: false)
                            .updateEmployee(employee);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(AppStrings.save),
                  )
                ]),
              )
            ],
          ),
        );
      }),
    );
  }

  openCustomDatePicker(mode) {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: ((context) {
        return CalenderView(
          firstDate: mode == 'startDate' ? null : startDate!,
          selectedDate: mode == 'startDate' ? startDate : endDate,
          onConfirm: (DateTime? selectedDate) {
            if (selectedDate != null) {
              if (mode == 'startDate') {
                _startsAtCtrl.text = DateTimeHelper.formatDate(selectedDate);
                startDate = selectedDate;
              } else if (mode == 'endDate') {
                selectedDate = selectedDate
                    .add(const Duration(hours: 23, minutes: 59, seconds: 59));
                _endsAtCtrl.text = DateTimeHelper.formatDate(selectedDate);
                endDate = selectedDate;
              }
            }
          },
        );
      }),
    );
  }

  showRolePicker() {
    FocusScope.of(context).requestFocus(FocusNode());
    List<String> roles = [
      'Product Designer',
      'Flutter Developer',
      'QA Tester',
      'Product Owner'
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: ((context) {
        return Wrap(
          children: roles.map((role) {
            return ListTile(
              shape: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
              title: Text(role),
              onTap: () {
                setState(() => _roleCtrl.text = role);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      }),
    );
  }
}
