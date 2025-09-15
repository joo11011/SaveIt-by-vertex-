import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Sourceofmoney extends StatelessWidget {
  final void Function(String?) onsaved;
  const Sourceofmoney({super.key, required this.onsaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Source_of_income'.tr,
        hintText: 'e.g. Salary',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onSaved: onsaved,
    );
  }
}
