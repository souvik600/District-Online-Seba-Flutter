import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminImageSlideShow extends StatefulWidget {
  @override
  _AdminImageSlideShowState createState() => _AdminImageSlideShowState();
}

class _AdminImageSlideShowState extends State<AdminImageSlideShow> {
  int _currentPage = 0;
  final PageController _controller = PageController(initialPage: 0);
  final List<Map<String, String>> _images = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchImages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('images')
        .orderBy('timestamp')
        .get();
    final imageList = snapshot.docs
        .map((doc) => {
      'url': doc['url'] as String,
      'docId': doc.id,
    })
        .toList();

    setState(() {
      _images.addAll(imageList);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _addImage({String? docId, int? index}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      if (docId != null && index != null) {
        await FirebaseFirestore.instance
            .collection('images')
            .doc(docId)
            .update({'url': url});
        await FirebaseStorage.instance
            .refFromURL(_images[index]['url']!)
            .delete();

        setState(() {
          _images[index]['url'] = url;
        });
      } else {
        if (_images.length == 5) {
          final oldestImage = _images.removeAt(0);
          await FirebaseFirestore.instance
              .collection('images')
              .doc(oldestImage['docId'])
              .delete();
          await FirebaseStorage.instance
              .refFromURL(oldestImage['url']!)
              .delete();
        }

        final docRef = await FirebaseFirestore.instance
            .collection('images')
            .add({'url': url, 'timestamp': FieldValue.serverTimestamp()});

        setState(() {
          _images.add({'url': url, 'docId': docRef.id});
        });
      }
    }
  }

  void _showEditBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 220,
          child: Row(
            children: List.generate(5, (index) {
              final imageExists = index < _images.length;
              return Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[300],
                        image: imageExists
                            ? DecorationImage(
                          image: NetworkImage(_images[index]['url']!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            imageExists ? Icons.edit : Icons.add,
                            color: Colors.blue,
                          ),
                          onPressed: () => imageExists
                              ? _addImage(
                              docId: _images[index]['docId'], index: index)
                              : _addImage(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for image slideshow
          PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _images[index]['url']!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            },
          ),

          // Edit button at the top left
          Positioned(
            top: 16.0,
            left: MediaQuery.of(context).size.width * 0.7, // Adjust for screen width
            child: ElevatedButton.icon(
              onPressed: _showEditBottomSheet,
              label: const Text("Edit", style: TextStyle(color: Colors.red)),
              icon: const Icon(Icons.edit, color: Colors.blue),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
          ),

          // Dot indicators at the bottom center
          Positioned(
            bottom: 10.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: _currentPage == index ? 20.0 : 10.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
