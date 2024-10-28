import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Center(
                    child: Text(
                      'LOGO',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Welcome to Dhaf's Cakees",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(),
                const Text(
                  "Create New Accounts",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 35.0),
                Obx(() {
                  return ElevatedButton(
                    onPressed: controller.getIsloading()
                        ? null
                        : () {
                            controller.Register();
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                      backgroundColor: Color(0xFF383838),
                    ),
                    child: controller.getIsloading()
                        ? CircularProgressIndicator()
                        : Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                }),
                // ElevatedButton(
                //   onPressed: controller.Register,
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 50.0),
                //     textStyle: const TextStyle(fontSize: 18.0),
                //     backgroundColor: Color(0xFF383838),
                //   ),
                //   child: const Text('Sign Up',
                //       style: TextStyle(color: Colors.white)),
                // ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed("/login");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                    //backgroundColor: Color(0xFF383838),
                  ),
                  child: const Text('Login',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
