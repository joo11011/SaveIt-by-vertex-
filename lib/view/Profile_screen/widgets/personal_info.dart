// Refactored lib/view/Profile_screen/widgets/personal_info.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoPage extends StatefulWidget {
  final UserModel user;

  const PersonalInfoPage({super.key, required this.user});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late String? name;
  late String? location;
  late String? bio;

  @override
  void initState() {
    super.initState();
    name = widget.user.username;
    location = null; // Assuming location is not in UserModel
    bio = null; // Assuming bio is not in UserModel
  }

  Future<void> _editField(String field, String? currentValue) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    TextEditingController controller = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field".tr),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("cancel".tr)),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({field.toLowerCase(): controller.text.trim()});

                if (mounted) {
                  setState(() {
                    switch (field) {
                      case "Name":
                        name = controller.text.trim();
                        break;
                      case "Location":
                        location = controller.text.trim();
                        break;
                      case "Bio":
                        bio = controller.text.trim();
                        break;
                    }
                  });
                }
                Get.back();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating: $e')));
                }
              }
            },
            child: Text("save".tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text("${'Name'.tr}: ${name ?? ""}"),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField("Name", name),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text("${'City'.tr}: ${location ?? ""}"),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField("Location", location),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: Text("${'bio'.tr}: ${bio ?? ""}"),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editField("Bio", bio),
          ),
        ),
      ],
    );
  }
}