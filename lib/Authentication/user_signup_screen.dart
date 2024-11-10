import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:district_online_service/Authentication/user_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../AppColors/AppColors.dart';
import '../Styles/ElevatedBottonStyle.dart';
import '../Styles/InputDecorationStyle.dart';
import '../Widgets/custom_scaffold.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool _isLoading = false; // New loading indicator flag
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isPasswordVisible = false;

  // Image picker
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    _imageFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  // Sign-up logic with image upload
  Future<void> _signUp() async {
    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      if (_passwordController.text == _confirmPasswordController.text) {
        setState(() {
          _isLoading = true; // Start loading
        });

        try {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          String? imageUrl;
          if (_imageFile != null) {
            final storageRef = FirebaseStorage.instance
                .ref()
                .child('user_avatars/${userCredential.user!.uid}.jpg');
            await storageRef.putFile(File(_imageFile!.path));
            imageUrl = await storageRef.getDownloadURL();
          }

          // Store additional details in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'full_name': _fullNameController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
            'address': _addressController.text.trim(),
            'avatar_url': imageUrl,
          });

          // Reset text fields and image picker after successful sign up
          _fullNameController.clear();
          _emailController.clear();
          _addressController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _imageFile = null;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserLogInScreen()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        } finally {
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the processing of personal data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 20.0),
              decoration: BoxDecoration(
                color: colorLight.withOpacity(.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pColor),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: _imageFile != null
                              ? FileImage(File(_imageFile!.path))
                              : null,
                          child: _imageFile == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Full name'
                            : null,
                        decoration: AppInputDecoration("Enter Your Full Name"),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Email'
                            : null,
                        decoration: AppInputDecoration("Enter Your Email"),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _addressController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Address'
                            : null,
                        decoration: AppInputDecoration("Enter Your Address"),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Password'
                            : null,
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 8, 8, 20),
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
                              // Change the icon based on the password visibility state
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Toggle password visibility state
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isPasswordVisible,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter Confirm Password'
                            : null,
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
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 8, 8, 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.sColor, width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Conform Your Password',
                          labelStyle: const TextStyle(
                            color: Colors.black38,
                            fontFamily: 'poppins',
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Change the icon based on the password visibility state
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              // Toggle password visibility state
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) =>
                                setState(() => agreePersonalData = value!),
                            activeColor: AppColors.pColor,
                          ),
                          const Text('I agree to the processing of ',
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 12)),
                          const Text('Personal data',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pColor)),
                        ],
                      ),
                      _isLoading // Show CircularProgressIndicator when loading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButtonStyle(
                                onPressed: _signUp,
                                text: 'Sign In',
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Do you have an account? ',
                              style: TextStyle(color: Colors.black45)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (e) => const UserLogInScreen()),
                              );
                            },
                            child: const Text('Sign up',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pColor)),
                          ),
                        ],
                      ),
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
