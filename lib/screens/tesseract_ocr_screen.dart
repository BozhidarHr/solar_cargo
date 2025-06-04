import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';

class TesseractOCRScreen extends StatefulWidget {
  @override
  _TesseractOCRScreenState createState() => _TesseractOCRScreenState();
}

class _TesseractOCRScreenState extends State<TesseractOCRScreen> {
  String _extractedText = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageAndExtractText() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    try {
      String text = await FlutterTesseractOcr.extractText(image.path,language: 'bul+eng'
          );
      setState(() {
        _extractedText = text;
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Error recognizing text: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tesseract OCR Example")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImageAndExtractText,
              child: Text("Scan Document"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_extractedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
