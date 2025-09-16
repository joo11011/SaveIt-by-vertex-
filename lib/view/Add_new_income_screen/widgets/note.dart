import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class Note extends StatelessWidget {
  final void Function(String?) onsaved;
  const Note({super.key, required this.onsaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Note'.tr,
        hintText: 'Optional',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      maxLines: 2,
      onSaved: onsaved,
    );
  }
}
