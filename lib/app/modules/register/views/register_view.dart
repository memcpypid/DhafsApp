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
                  child: Center(
                    child: Image.asset(
                      'images/logo.jpg', // Path to your logo image
                      width: 200.0, // Adjust the width as needed
                      height: 200.0, // Adjust the height as needed
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
                  "Create New Account",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                // Username Field
                TextField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Email Field
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Password Field
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Phone Number Field
                TextField(
                  controller: controller.phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Birthdate Field
                TextField(
                  controller: controller.birthDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Birth Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.birthDateController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                // Role Dropdown
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.selectedRole.value,
                    items: controller.roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedRole.value = value!;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.group),
                      hintText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                  );
                }),
                const SizedBox(height: 35.0),
                // Register Button
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
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                }),
                const SizedBox(height: 20.0),
                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed("/login");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50.0),
                    textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
