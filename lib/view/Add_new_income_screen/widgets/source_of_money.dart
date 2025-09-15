import 'package:flutter/material.dart';

class Sourceofmoney extends StatelessWidget {
  final void Function(String?) onsaved;
  const Sourceofmoney({super.key,required this.onsaved});


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Source of money',
        hintText: 'e.g. Salary',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onSaved: onsaved,
    );
  }
}
