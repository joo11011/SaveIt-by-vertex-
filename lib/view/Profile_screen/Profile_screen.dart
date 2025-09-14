import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savelt_app/view/Home_screen/Home_screen.dart';
import '../Home_screen/Home_screen.dart';
import '../Settings_screen/Settings_screen.dart';
import 'widgets/personal_info.dart';
import '../Log_in_screen/Log_in_screen.dart';
import 'widgets/delete_account_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      final storageRef = FirebaseStorage.instance.ref().child(
        'users/${user.uid}/profile.jpg',
      );
      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'photoUrl': downloadUrl},
      );
    }
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String titleKey,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.4)
                : Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Theme.of(context).iconTheme.color,
        ),
        title: Text(
          titleKey.tr,
          style: TextStyle(
            fontSize: 16,
            color: iconColor ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".tr),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['name'] ?? "Unknown";
          String email = user.email ?? "";
          String? photoUrl = userData['photoUrl'];

          String initials = (name.isNotEmpty)
              ? name.split(" ").map((e) => e[0]).take(2).join()
              : "U";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.green[200],
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                          ? NetworkImage(photoUrl)
                          : null,
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  email,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),

                const SizedBox(height: 25),

                _buildProfileOption(
                  icon: Icons.person_outlined,
                  titleKey: "personal_info",
                  onTap: () => Get.to(() => const PersonalInfoPage()),
                ),

                _buildProfileOption(
                  icon: Icons.lock_outline,
                  titleKey: "login_password",
                  onTap: () => Get.to(() => LoginPage()),
                ),

                _buildProfileOption(
                  icon: Icons.shield_outlined,
                  titleKey: "privacy_security",
                  onTap: () {},
                ),

                _buildProfileOption(
                  icon: Icons.delete_outline,
                  titleKey: "delete",
                  iconColor: Colors.red,
                  onTap: () => Get.to(() => const DeleteAccountPage()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
