import 'package:employeeadmin/common/app_images.dart';
import 'package:employeeadmin/common/app_strings.dart';
import 'package:employeeadmin/common/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoEmployeeRecordFound extends StatelessWidget {
  const NoEmployeeRecordFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.employeeNotFound),
          const SizedBox(height: 8),
          Text(
            AppStrings.noEmployeeRecordFound,
            style: AppThemes.listTileTitle,
          )
        ],
      ),
    );
  }
}
