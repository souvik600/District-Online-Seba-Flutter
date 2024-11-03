import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';

import '../../../Styles/BackGroundStyle.dart';

class UserProfileScreen extends StatelessWidget {
  // Sample user data
  final String profileImageUrl = 'https://via.placeholder.com/150';
  final String name = 'John Doe';
  final String email = 'johndoe@example.com';
  final String location = 'New York, USA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("প্রোফাইল"),
      body: Stack(
        children: [
          ScreenBackground(context),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/souvik_das.png')
                  ),
                  SizedBox(height: 20),

                  // Name
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Email
                  Text(
                    email,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),

                  // Location
                  Text(
                    location,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 30),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      // Logout logic here
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Logout"),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Implement logout functionality
                                Navigator.pop(context);
                              },
                              child: Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
