import 'package:employeeadmin/common/app_colors.dart';
import 'package:employeeadmin/common/app_images.dart';
import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/common/app_themes.dart';
import 'package:employeeadmin/utils/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CalenderView extends StatefulWidget {
  const CalenderView({
    super.key,
    required this.onConfirm,
    this.firstDate,
    this.selectedDate,
  });

  final Function(DateTime? value) onConfirm;
  final DateTime? firstDate;
  final DateTime? selectedDate;

  @override
  State<CalenderView> createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  DateTime? _selectedDate;
  late DateTime _today;
  late DateTime _weekPlusOneDay;
  late DateTime _weekPlusTwoDay;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _weekPlusOneDay = _today.add(const Duration(days: 7));
    _weekPlusTwoDay = _today.add(const Duration(days: 8));
    _selectedDate = widget.selectedDate ?? _today;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDateSuggestUI(),
            CalendarDatePicker(
                currentDate: _selectedDate,
                initialDate: _selectedDate!,
                firstDate: widget.firstDate ?? DateTime(1990),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() => _selectedDate = date);
                }),
            _buildBottomUI()
          ],
        ),
      ),
    );
  }

  Widget _buildDateSuggestUI() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.backgroundColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedDate = _weekPlusOneDay);
                  },
                  style: AppThemes.secondaryButton,
                  child: Text(
                      'Next ${DateTimeHelper.formatToDay(_weekPlusOneDay)}'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedDate = _weekPlusTwoDay);
                  },
                  style: AppThemes.secondaryButton,
                  child: Text(
                      'Next ${DateTimeHelper.formatToDay(_weekPlusTwoDay)}'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedDate = DateTime.now());
                  },
                  style: AppThemes.secondaryButton,
                  child: Text(AppStrings.today),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedDate = null);
                  },
                  style: AppThemes.secondaryButton,
                  child: Text(AppStrings.nodate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomUI() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.backgroundColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppImages.calender),
              const SizedBox(width: 4),
              Text(_selectedDate != null
                  ? DateTimeHelper.formatDate(_selectedDate!)
                  : AppStrings.nodate),
            ],
          )),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: AppThemes.secondaryButton,
            child: Text(AppStrings.cancel),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: () {
              if (_selectedDate != null) {
                // resetting datetime to 00:00:00
                _selectedDate = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                );
                widget.onConfirm(_selectedDate);
              }
              Navigator.pop(context);
            },
            style: AppThemes.primaryButton,
            child: Text(AppStrings.save),
          )
        ],
      ),
    );
  }
}
