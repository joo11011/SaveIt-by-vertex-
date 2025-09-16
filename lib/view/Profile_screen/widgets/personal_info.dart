// lib/view/Profile_screen/widgets/personal_info.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String? name;
  String? location;
  String? bio;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();
    if (data != null) {
      setState(() {
        name = data['name'] ?? "";
        location = data['location'];
        bio = data['bio'];
      });
    }
  }

  Future<void> _editField(String field, String? currentValue) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error updating: $e')));
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
    return Scaffold(
      appBar: AppBar(title: Text("personal_info".tr), centerTitle: true),
      body: ListView(
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
      ),
    );
  }
}
