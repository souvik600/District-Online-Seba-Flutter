import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:district_online_service/Authentication/user_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../AppColors/AppColors.dart';
import '../Screens/NavigationBerScreen.dart';
import '../Styles/ElevatedBottonStyle.dart';
import '../Styles/InputDecorationStyle.dart';
import '../Widgets/custom_scaffold.dart';

class UserLogInScreen extends StatefulWidget {
  const UserLogInScreen({super.key});

  @override
  State<UserLogInScreen> createState() => _UserLogInScreenState();
}

class _UserLogInScreenState extends State<UserLogInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  // Function to handle login with Firestore for admin check first
  Future<void> _loginWithFirestoreOrAuth() async {
    if (_formSignInKey.currentState!.validate()) {
      try {
        // Query Firestore for admin credentials
        final adminSnapshot = await _firestore
            .collection('adminCredentials')
            .where('email', isEqualTo: _emailController.text)
            .where('password', isEqualTo: _passwordController.text)
            .get();

        if (adminSnapshot.docs.isNotEmpty) {
          // Navigate to AdminHomeScreen if credentials match
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationBerScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin Login Successful')),
          );
        } else {
          // If not admin, check Firebase Authentication for user login
          await _loginWithEmailAndPassword();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  // Function to handle Firebase Authentication login for regular users
  Future<void> _loginWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to UserHomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationBerScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: colorLight.withOpacity(.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pColor,
                          fontFamily: 'poppins',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: AppInputDecoration("Enter Your Email"),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.pColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: colorLightGray,
                          filled: false,
                          contentPadding: const EdgeInsets.fromLTRB(20, 8, 8, 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.sColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Enter Your Password',
                          labelStyle: const TextStyle(
                            color: Colors.black38,
                            fontFamily: 'poppins',
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButtonStyle(
                          onPressed: _loginWithFirestoreOrAuth,
                          text: 'Log In',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 10,
                            ),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Logo(Logos.facebook_f),
                          Logo(Logos.twitter),
                          Logo(Logos.google),
                          Logo(Logos.apple),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const UserSignUpScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.pColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
