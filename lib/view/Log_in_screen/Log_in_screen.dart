import '../../controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Create_account_screen/Create_account_screen.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.lock, size: 60, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.green[300]),
                ),
                const SizedBox(height: 30),

                // Email
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.green),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordVisible.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.green),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  '- Or login with -',
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 10),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.blue[800],
                        size: 35,
                      ),
                      onPressed: controller.loginWithFacebook,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(
                        Icons.g_mobiledata,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: controller.loginWithGoogle,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 35,
                      ),
                      onPressed: controller.loginAnonymously,
                      tooltip: "Guest",
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Get.to(() => RegisterPage());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(color: Colors.green[800]),
                      children: const [
                        TextSpan(
                          text: 'Sign Up',
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
