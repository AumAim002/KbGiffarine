import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class Ebook extends StatefulWidget {
  @override
  _EbookState createState() => _EbookState();
}

class _EbookState extends State<Ebook> {
  PDFDocument pdfDocument;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPDF();
  }

  Future<Null> loadPDF() async {
    String urlPDF = 'https://firebasestorage.googleapis.com/v0/b/kbgiffmap.appspot.com/o/ebook%2F2020-06-25_Specification%20Cleaning%20Tag%20Tracking%20For%20Developer_V07.pdf?alt=media&token=17bda5d0-0da9-44a4-9e3a-36e3af20c542';
        //'https://firebasestorage.googleapis.com/v0/b/kbgiffmap.appspot.com/o/ebook%2FFlutter%20for%20Beginners%20An%20introductory%20guide%20to%20building%20cross-platform%20mobile%20applications%20with%20Flutter%20and%20Dart%202%20by%20Alessandro%20Biessek%20(z-lib.org).pdf?alt=media&token=7abd0e46-e2f5-4bb9-a641-8ffdae23e68d';
    try {
      var result = await PDFDocument.fromURL(urlPDF);
      setState(() {
        pdfDocument = result;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pdfDocument == null
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(document: pdfDocument),
    );
  }
}
