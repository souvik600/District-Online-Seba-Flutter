import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Styles/ElevatedBottonStyle.dart';

class AdminMovingNoticeText extends StatefulWidget {
  @override
  _AdminMovingNoticeTextState createState() => _AdminMovingNoticeTextState();
}

class _AdminMovingNoticeTextState extends State<AdminMovingNoticeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String noticeText = 'Loading...';
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat(); // Repeats the animation continuously
    fetchNoticeText();
  }

  Future<void> fetchNoticeText() async {
    try {
      final noticeDoc = await FirebaseFirestore.instance
          .collection('notices')
          .doc('notice1') // Adjust document ID as necessary
          .get();

      if (noticeDoc.exists) {
        setState(() {
          noticeText = noticeDoc['text'];
        });
      } else {
        print("Document does not exist in Firestore.");
      }
    } catch (e) {
      print("Error fetching notice text: $e");
    }
  }

  Future<void> updateNoticeText(String newText) async {
    try {
      await FirebaseFirestore.instance.collection('notices').doc('notice1').set(
          {'text': newText},
          SetOptions(merge: true)); // Merging updates the existing document

      print("Notice text updated successfully!");
      setState(() {
        noticeText = newText;
      });
    } catch (e) {
      print("Error updating notice text: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    _animation = Tween<double>(
      begin: screenWidth, // Start off the right side of the screen
      end: -screenWidth, // Move entirely off the left side
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _showEditBottomSheet(BuildContext context) {
    _editController.text = noticeText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to resize with the keyboard
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0, // Adjusts for keyboard height
          ),
          child: SingleChildScrollView( // Allows content to scroll when keyboard appears
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editController,
                  maxLines: 1, // Ensure the TextField is single line
                  decoration: InputDecoration(
                    labelText: 'Edit Notice Text',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButtonStyle(
                  text: 'Save',
                  onPressed: () async {
                    final newText = _editController.text.trim();
                    if (newText.isNotEmpty) {
                      await updateNoticeText(newText);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 20),
      width: MediaQuery.of(context).size.width, // Full width of the screen
      height: 65,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //color: Colors.blue.withOpacity(0.1), // Replace AppColors.pColor with your desired color
        borderRadius: BorderRadius.circular(10),

      ),
      child: Stack(
        alignment: Alignment.centerLeft, // Center the text
        children: [
          // Moving Text
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.only(top: 0),
              alignment: Alignment.centerLeft,
              height: 40, // Set a fixed height if needed
              child: Transform.translate(
                offset: Offset(_animation.value, 0),
                child: Text(
                  noticeText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kalpurush',
                    color: Colors.red.shade900,
                  ),
                  overflow: TextOverflow.visible, // Prevent wrapping
                  softWrap: false, // Ensure it does not wrap
                ),
              ),
            ),
          ),
          // Edit Button
          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}
