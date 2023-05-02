import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:noor/main.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';

import 'object_detection/screens/camera_view.dart';
import 'newpro/vision_detector_views/painters/text_detector_painter.dart';

class ReadDocs extends StatefulWidget {
  @override
  State<ReadDocs> createState() => _ReadDocsState();
}

class _ReadDocsState extends State<ReadDocs> {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.chinese);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Read Docs', style: SharedFonts.primaryTxtStyle),
        iconTheme: IconThemeData(color: SharedColors.primaryColor, size: 25.0),
      ),
      body: CameraView(
        title: 'Text Detector',
        customPaint: _customPaint,
        text: _text,
        onImage: (inputImage) {
          processImage(inputImage);
        },
      ),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
      voiceController.speak(recognizedText.text, speech: 0.3);
    } else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
