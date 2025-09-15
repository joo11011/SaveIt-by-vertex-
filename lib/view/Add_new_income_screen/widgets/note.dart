import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final void Function(String?) onsaved;
  const Note({super.key,required this.onsaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Note',
        hintText: 'Optional',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      maxLines: 2,
      onSaved: onsaved,
    );
  }
}
