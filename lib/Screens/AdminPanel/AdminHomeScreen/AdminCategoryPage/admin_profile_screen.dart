import 'package:district_online_service/Authentication/user_login_screen.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';// Replace with the actual path to your login screen

class AdminLogoutScreen extends StatelessWidget {
  const AdminLogoutScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Navigate back to the Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserLogInScreen()),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    } catch (e) {
      // Handle errors if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Admin Panel'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
