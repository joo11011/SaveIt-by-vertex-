import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Addincomebutton extends StatelessWidget {
  final VoidCallback onpressed;
  const Addincomebutton({super.key, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Add the income'.tr,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
