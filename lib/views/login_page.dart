// import 'package:final_project/controllers/login_controller.dart';
// import 'package:final_project/views/register_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginPage extends StatelessWidget {
//   final LoginController controller =Get.put(LoginController());

//   LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 80),
//                 Icon(Icons.account_balance_wallet, size: 80, color: Colors.green),
//                 SizedBox(height: 20),
//                 Text(
//                   'Welcome Back',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green[800]),
//                 ),
//                 Text(
//                   'Login to Manage Your Finances',
//                   style: TextStyle(fontSize: 16, color: Colors.green[600]),
//                 ),
//                 SizedBox(height: 40),
//                 // TextFormField(
//                 //   controller: controller.emailController,
//                 //   decoration: InputDecoration(
//                 //     hintText: 'Email',
//                 //     border: OutlineInputBorder(
//                 //       borderRadius: BorderRadius.circular(12),
//                 //       borderSide: BorderSide(color: Colors.green),
//                 //     ),
//                 //     prefixIcon: Icon(Icons.email, color: Colors.green),
//                 //   ),
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Please enter your email';
//                 //     } else if (!value.contains('@')) {
//                 //       return 'Email must contain @';
//                 //     } else if (!value.contains('.com')) {
//                 //       return 'Email must contain .com';
//                 //     }
//                 //     return null;
//                 //   },
//                 // ),
//                 TextFormField(
//                   controller: controller.emailController,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.email , color: Colors.green),
//                     hintText: 'Email',
//                     hintStyle: TextStyle(color: Colors.green),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.green),
//                     ),
//                   ),
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Email is required";
//                     } else if (!value.contains('@')) {
//                       return "Email must contain @";
//                     } else if (!value.contains('.com')) {
//                       return "Email must contain .com";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 // Obx( ()=> TextFormField(
//                 //   controller: controller.passwordController,
//                 //   obscureText: controller.isPasswordVisible.value,
//                 //   decoration: InputDecoration(
//                 //     prefixIcon: Icon(Icons.lock, color: Colors.green),
//                 //     hintText: 'Password',
//                 //     border: OutlineInputBorder(
//                 //       borderRadius: BorderRadius.circular(12),
//                 //       borderSide: BorderSide(color: Colors.green),
//                 //     ),
//                 //     suffixIcon: IconButton(
//                 //       icon: Icon(
//                 //         controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
//                 //         color: Colors.green,
//                 //       ),
//                 //       onPressed: controller.togglePasswordVisibility,
//                 //     ),
//                 //   ),
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Please enter your password';
//                 //     }
//                 //     return null;
//                 //   },
//                 // )
//                 // ),
//                 Obx(() => TextFormField(
//                       controller: controller.passwordController,
//                       obscureText: controller.isPasswordVisible.value,
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.lock , color: Colors.green),
//                         hintText: 'Password',
//                         hintStyle: TextStyle(color: Colors.green),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.green),
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(controller.isPasswordVisible.value
//                               ? Icons.visibility
//                               : Icons.visibility_off),
//                               style: ButtonStyle(
//                                 iconColor: MaterialStatePropertyAll(Colors.green)
//                               ),
//                           onPressed: controller.togglePasswordVisibility,
//                         ),
//                       ),
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Password is required";
//                         } else if (value.length < 10) {
//                           return "Must be at least 10 characters";
//                         } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
//                           return "Must contain uppercase letter";
//                         } else if (!RegExp(r'[a-z]').hasMatch(value)) {
//                           return "Must contain lowercase letter";
//                         } else if (!RegExp(r'[0-9]').hasMatch(value)) {
//                           return "Must contain number";
//                         } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
//                           return "Must contain special character";
//                         }
//                         return null;
//                       },
//                     )),
//                 SizedBox(height: 30),
//                 //forgot password
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       // Navigate to forgot password page
//                     },
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(color: Colors.green[800]),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (controller.formKey.currentState!.validate()) {
//                       controller.login();
//                     }
//                   } ,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ) ,
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: (){
//                         // Handle facebook login
//                         controller.loginWithFacebook();
//                       }, 
//                       icon: Icon( Icons.facebook, color: Colors.blue[800], size: 35),
//                     ),
//                     SizedBox(width: 20),
//                     IconButton(
//                       onPressed: (){
//                         // Handle google login
//                         controller.loginWithGoogle();
//                       }, 
//                       icon: Icon( Icons.g_mobiledata, color: Colors.red, size: 40),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 40),
//                 GestureDetector(
//                   onTap: () {
//                     Get.to( () => RegisterPage());
//                   },
//                   child: Text.rich (
//                     TextSpan(
//                       text: "Don't have an account? ",
//                       style: TextStyle(color: Colors.green[800]),
//                       children: [
//                         TextSpan(
//                           text: 'Sign Up',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }



// }







//random comment
import 'package:final_project/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_page.dart';

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
                      color: Colors.green[800]),
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
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.green),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 20),

                const Text('- Or login with -',
                    style: TextStyle(color: Colors.green)),
                const SizedBox(height: 10),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon:
                          Icon(Icons.facebook, color: Colors.blue[800], size: 35),
                      onPressed: controller.loginWithFacebook,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.g_mobiledata,
                          color: Colors.red, size: 40),
                      onPressed: controller.loginWithGoogle,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.person_outline, color: Colors.grey, size: 35),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
