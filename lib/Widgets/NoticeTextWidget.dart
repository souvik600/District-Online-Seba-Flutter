import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovingNoticeText extends StatefulWidget {
  @override
  _MovingNoticeTextState createState() => _MovingNoticeTextState();
}

class _MovingNoticeTextState extends State<MovingNoticeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String noticeText = 'Loading...';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the width of the container
    final containerWidth = MediaQuery.of(context).size.width;

    // Adjust the animation to start from the right edge of the container
    _animation = Tween<double>(
      begin: containerWidth, // Start from the right edge of the container
      end: -500, // Move out of the left edge; adjust this value if necessary
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 20),
      width: MediaQuery.of(context).size.width, // Full width of the screen
      height: 65,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Background color for the container
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.centerLeft, // Center the text
        children: [
          // Moving Text
          Positioned(
            left: 0, // Start from the left side of the container
            child: Transform.translate(
              offset: Offset(_animation.value, 0),
              child: Container(
                padding: EdgeInsets.only(left: 20), // Add padding to the left
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
        ],
      ),
    );
  }
}
