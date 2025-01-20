import 'dart:io';
import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Styles/BackGroundStyle.dart';
import 'package:district_online_service/Widgets/Custom_appBar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../../../Utilitys/utilitys.dart'; // Import the intl package for date formatting

class Comment {
  final String userId;
  final String userName;
  final String userImage;
  final String commentText;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.commentText,
    required this.timestamp,
  });

  factory Comment.fromFirestore(Map<String, dynamic> data) {
    return Comment(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      commentText: data['commentText'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'commentText': commentText,
      'timestamp': timestamp,
    };
  }
}

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? userImage, userName;

  // Fetch user data (name and avatar)
  Future<void> _fetchUserData() async {
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    setState(() {
      userName = userDoc['full_name']; // Replace with the field for user's name
      userImage = userDoc['avatar_url'];
    });
  }

  // Submit a comment
  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final comment = Comment(
      userId: FirebaseAuth.instance.currentUser!.uid,
      userName: userName ?? 'Anonymous',
      // Use fetched userName, or fallback to 'Anonymous'
      userImage: userImage!,
      commentText: _commentController.text.trim(),
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('comments')
        .add(comment.toMap());

    setState(() {
      _commentController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar('Comments'),
      appBar: AppBar(
        backgroundColor: AppColors.pColor,
        title: Text('Comments'),
        actions: [
          FutureBuilder<String>(
            future: loadProfileImage(), // Your method to load the profile image URL
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Icon(Icons.error); // Display an error icon if there's an error
              }
              if (snapshot.hasData) {
                // Replace with your widget for showing the profile image
                return CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!),
                );
              }
              return SizedBox(); // Return an empty widget if no data is available
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // Adjust the radius for circular edges
          ),
        ),
      ),

      body: Stack(
        children: [
          ScreenBackground(context),
          userImage == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Display Comments Section
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final comments = snapshot.data!.docs.map((doc) {
                            return Comment.fromFirestore(
                                doc.data() as Map<String, dynamic>);
                          }).toList();

                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];

                              // Format the timestamp to show date and time
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(comment.timestamp);

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                elevation: 5,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(comment.userImage),
                                  ),
                                  title: Text(comment.userName,style:  TextStyle(color: AppColors.pColor,fontSize: 16,fontWeight: FontWeight.w500),),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(comment.commentText),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const SizedBox(width: 4),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 2, // Allow multiple lines
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _submitComment,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
