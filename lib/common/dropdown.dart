import 'dart:developer';

import 'package:flutter/material.dart';

class CommonDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  const CommonDropdown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hint = 'Select',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('$items');
    return Container(
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: DropdownButton<String>(
          underline: SizedBox(),
          hint: Text(hint),
          value: selectedValue,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
