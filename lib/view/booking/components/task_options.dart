import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer/model/service_extra_model.dart';
import 'package:qixer/service/app_string_service.dart';
import 'package:qixer/service/booking_services/personalization_service.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/view/booking/components/radio_button.dart';
import 'package:qixer/view/utils/common_helper.dart';
import 'package:qixer/view/utils/constant_colors.dart';

class TaskOptions extends StatelessWidget {
  const TaskOptions({
    super.key,
    required this.cc,
    required this.taskOptions,
    required this.asProvider,
  });

  final ConstantColors cc;
  final List<TaskOption> taskOptions;
  final AppStringService asProvider;

  Widget _getTaskOptionItem(TaskOption option) {
    List<Map<String, dynamic>> subOptions = List<Map<String, dynamic>>.from(
        option.options == null ? [] : option.options!.map((x) => x.toJson()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          asProvider.getString(option.name ?? ''),
          style: TextStyle(
            color: cc.greyParagraph,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        RadioButton(
          options: subOptions,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RtlService>(
      builder: (context, rtlP, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper()
              .titleCommon('${asProvider.getString('Task Options')}:'),
          const SizedBox(height: 20),
          for (var option in taskOptions) _getTaskOptionItem(option)
        ],
      ),
    );
  }
}
