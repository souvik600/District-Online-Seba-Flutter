import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:district_online_service/AppColors/AppColors.dart';
import 'package:district_online_service/Styles/BackGroundStyle.dart';

class AdminCommentScreen extends StatefulWidget {
  @override
  _AdminCommentScreenState createState() => _AdminCommentScreenState();
}
class _AdminCommentScreenState extends State<AdminCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  String? userImage, userName;
  // Fetch user data
  Future<void> _fetchUserData() async {
    var userUid = FirebaseAuth.instance.currentUser!.uid;
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    setState(() {
      userName = userDoc['full_name'];
      userImage = userDoc['avatar_url'];
    });
  }
  // Submit a comment
  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('comments').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': userName ?? 'Anonymous',
      'userImage': userImage!,
      'commentText': _commentController.text.trim(),
      'timestamp': DateTime.now(),
    });

    setState(() {
      _commentController.clear();
    });
  }

  // Submit a reply
  Future<void> _submitReply(String commentId) async {
    if (_replyController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': userName ?? 'Anonymous',
      'userImage': userImage!,
      'replyText': _replyController.text.trim(),
      'timestamp': DateTime.now(),
    });

    setState(() {
      _replyController.clear();
    });
  }

  // Confirm and delete a comment
  Future<void> _deleteComment(String commentId) async {
    bool confirmed = await _showConfirmationDialog("Delete this comment?");
    if (confirmed) {
      await FirebaseFirestore.instance.collection('comments').doc(commentId).delete();
    }
  }

  // Confirm and delete a reply
  Future<void> _deleteReply(String commentId, String replyId) async {
    bool confirmed = await _showConfirmationDialog("Delete this reply?");
    if (confirmed) {
      await FirebaseFirestore.instance
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId)
          .delete();
    }
  }

  // Confirmation dialog
  Future<bool> _showConfirmationDialog(String message) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pColor,
        title: const Text('Admin Comments'),
      ),
      body: Stack(
        children: [
          ScreenBackground(context),
          userImage == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final comments = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentId = comment.id;

                        String formattedDate =
                        DateFormat('yyyy-MM-dd HH:mm')
                            .format(comment['timestamp'].toDate());

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      comment['userImage']),
                                ),
                                title: Text(comment['userName'],
                                    style: const TextStyle(
                                        color: AppColors.pColor,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(comment['commentText']),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _deleteComment(commentId),
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('comments')
                                    .doc(commentId)
                                    .collection('replies')
                                    .orderBy('timestamp',
                                    descending: true)
                                    .snapshots(),
                                builder: (context, replySnapshot) {
                                  if (!replySnapshot.hasData) {
                                    return const SizedBox();
                                  }

                                  final replies =
                                      replySnapshot.data!.docs;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: replies.length,
                                    itemBuilder:
                                        (context, replyIndex) {
                                      final reply =
                                      replies[replyIndex];
                                      String replyDate = DateFormat(
                                          'yyyy-MM-dd HH:mm')
                                          .format(reply['timestamp']
                                          .toDate());

                                      return Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 48.0,
                                            right: 16.0),
                                        child: Card(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage:
                                              NetworkImage(reply[
                                              'userImage']),
                                            ),
                                            title: Text(
                                                reply['userName']),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                    reply['replyText']),
                                                const SizedBox(
                                                    height: 4),
                                                Text(
                                                  replyDate,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  _deleteReply(
                                                      commentId,
                                                      reply.id),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _replyController,
                                  decoration: InputDecoration(
                                    hintText: 'Reply...',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () =>
                                          _submitReply(commentId),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                  maxLines: 2,
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
