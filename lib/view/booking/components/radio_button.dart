import 'package:flutter/material.dart';
import 'package:qixer/view/utils/constant_colors.dart';

class RadioButton extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final TextStyle? textStyle;
  final bool? isVertical;
  final int? selectedValue;
  final bool? isReadOnly;
  const RadioButton(
      {super.key,
      required this.options,
      this.isVertical,
      this.selectedValue,
      this.textStyle,
      this.isReadOnly});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  int? _selectedValue;
  bool isVertical = true;
  bool isReadOnly = false;
  @override
  void initState() {
    super.initState();
    isVertical = widget.isVertical ?? true;
    _selectedValue = widget.selectedValue;
    isReadOnly = widget.isReadOnly ?? false;
  }

  Widget _getRadioOptionButtons() {
    if (isVertical) {
      return Column(
        children: widget.options.map((option) {
          return ListTile(
            visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
            horizontalTitleGap: 2,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            title: Text(option['name'],
                style: widget.textStyle ??
                    TextStyle(
                      color: cc.greyParagraph,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
            leading: Radio<int>(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              value: option['id'],
              groupValue: _selectedValue,
              onChanged: (int? value) {
                setState(() {
                  if (!isReadOnly) {
                    _selectedValue = value;
                  }
                });
              },
            ),
            onTap: () {
              setState(() {
                if (!isReadOnly) {
                  _selectedValue = option['id'];
                }
              });
            },
          );
        }).toList(),
      );
    } else {
      return Row(
        children: widget.options.map((option) {
          return Expanded(
            child: ListTile(
              visualDensity: VisualDensity(horizontal: -2, vertical: -5),
              horizontalTitleGap: 2,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              title: Text(option['name'],
                  style: widget.textStyle ??
                      TextStyle(
                        color: cc.greyParagraph,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
              leading: Radio<int>(
                visualDensity: VisualDensity(horizontal: -5, vertical: -5),
                value: option['id'],
                activeColor: Colors.black,
                groupValue: _selectedValue,
                onChanged: (int? value) {
                  setState(() {
                    if (!isReadOnly) {
                      _selectedValue = value;
                    }
                  });
                },
              ),
              onTap: () {
                setState(() {
                  if (!isReadOnly) {
                    _selectedValue = option['id'];
                  }
                });
              },
            ),
          );
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: const Offset(-8, 0.0), // Adjust this offset as needed
        child: _getRadioOptionButtons());
  }
}
