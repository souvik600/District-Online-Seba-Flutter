// import 'package:district_online_service/Authentication/user_login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../Screens/NavigationBerScreen.dart';
// import '../Screens/UsersPanel/UsersHomeScreen/users_home_screen.dart';
//
// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // If the snapshot has data, the user is logged in
//         if (snapshot.connectionState == ConnectionState.active) {
//           if (snapshot.hasData) {
//             return NavigationBerScreen(); // User is logged in, navigate to Home Screen
//           } else {
//             return UserLogInScreen(); // User is not logged in, navigate to Login Screen
//           }
//         }
//         return Center(
//             child: CircularProgressIndicator()); // Show loading indicator while checking auth state
//       },
//     );
//   }
// }