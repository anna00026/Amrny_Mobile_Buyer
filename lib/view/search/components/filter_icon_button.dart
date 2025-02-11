import 'package:flutter/material.dart';
import 'package:amrny/helper/extension/int_extension.dart';
import 'package:amrny/helper/extension/string_extension.dart';
import 'package:amrny/view/utils/constant_colors.dart';

class FilterIconButton extends StatelessWidget {
  final String icon;
  final String subtitle;
  final onPressed;
  const FilterIconButton(
      {super.key,
      required this.icon,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: IconButton(
          onPressed: onPressed,
          icon: Column(
            children: [
              icon.toSVGSized(
                20,
                color: cc.black3,
              ),
              6.toHeight,
              Text(subtitle),
            ],
          )),
    );
  }
}
