import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../AppColors/AppColors.dart';



class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.pColor,
            title: const Text(
              "নড়াইল জেলার মানচিত্র",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'kalpurush',
                  color: AppColors.wColor),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Adjust the radius for circular edges
              ),
            ),
          ),
          body: PDFScreen('assets/pdf/map.pdf'),
        ));
  }
}

class PDFScreen extends StatefulWidget {
  final String pdfPath;

  PDFScreen(this.pdfPath);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late String _pathPDF;
  bool _isLoading = true;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPDF(widget.pdfPath);
  }

  Future<void> _loadPDF(String assetPath) async {
    try {
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String path = '$dir/${assetPath.split('/').last}';

      if (!(await File(path).exists())) {
        final data = await rootBundle.load(assetPath);
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes);
      }

      setState(() {
        _pathPDF = path;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _pathPDF.isNotEmpty
          ? PDFView(
        filePath: _pathPDF,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: false,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (_pages) {
          setState(() {
            _totalPages = _pages!;
          });
          print('Rendered $_pages pages');
        },
        onError: (error) {
          print('PDFView error: $error');
        },
        onPageError: (page, error) {
          print('Error on page $page: $error');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // Do something with the controller
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = page ?? 0;
          });
          print('Page changed: $_currentPage/$total');
        },
      )
          : const Center(
        child: Text('Failed to load PDF'),
      ),
    );
  }
}
