import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String? name;
  String? location;
  String? bio;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      name = doc.data()?['name'] ?? "";
      location = doc.data()?['location'] ?? "";
      bio = doc.data()?['bio'] ?? "";
    });
  }

  Future<void> _editField(String field, String? currentValue) async {
    TextEditingController controller = TextEditingController(
      text: currentValue ?? "",
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({field.toLowerCase(): controller.text.trim()});
              setState(() {
                if (field == "Name") name = controller.text.trim();
                if (field == "Location") location = controller.text.trim();
                if (field == "Bio") bio = controller.text.trim();
              });
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personal Information".tr)),
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
