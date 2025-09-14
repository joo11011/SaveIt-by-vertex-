import '../../controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'Start managing your finances today',
                  style: TextStyle(fontSize: 16, color: Colors.green[300]),
                ),
                SizedBox(height: 30),

                // Username
                TextFormField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.green),
                    hintStyle: TextStyle(color: Colors.green),
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required";
                    } else if (value.length < 3) {
                      return "Username must be at least 3 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!value.contains('@')) {
                      return "Email must contain @";
                    } else if (!value.contains('.com')) {
                      return "Email must contain .com";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Password
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      hintStyle: TextStyle(color: Colors.green),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        style: ButtonStyle(
                          iconColor: MaterialStatePropertyAll(Colors.green),
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 10) {
                        return "Must be at least 10 characters";
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Must contain uppercase letter";
                      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return "Must contain lowercase letter";
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Must contain number";
                      } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                        return "Must contain special character";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Confirm Password
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      hintStyle: TextStyle(color: Colors.green),
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        style: ButtonStyle(
                          iconColor: MaterialStatePropertyAll(Colors.green),
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      } else if (value != controller.passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30),

                // Button
                ElevatedButton(
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  '- Or sign up with -',
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
                SizedBox(height: 10),

                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.blue[800],
                        size: 35,
                      ),
                      onPressed: controller.registerWithFacebook,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: controller.registerWithGoogle,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 35,
                      ),
                      onPressed: controller.registerAnonymously,
                      tooltip: "Guest",
                    ),
                  ],
                ),

                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.back(); // Navigate back to Sign in screen
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.green[800]),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
