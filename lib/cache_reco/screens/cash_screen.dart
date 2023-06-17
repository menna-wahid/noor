import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noor/main.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';
import 'package:noor/shared/shared_theme/shared_fonts.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class CashScreen extends StatefulWidget {
  @override
  _CashScreenState createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  late List _output;
  CustomPaint? _customPaint;
  String? _text;
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    openCamera();
    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(String imagePath) async {

    var x = tfl.Interpreter.fromAsset('labels.txt');

    var output = await Tflite.runModelOnImage(
        path: imagePath,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.6,
        imageStd: 127.5);
    setState(() {
      _output = output!;
    });
    if (_output.length > 0) {
      voiceController.speak('${_output[0]['label']}');
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    XFile? img = await controller.takePicture();
    if (img != null) {
      classifyImage(img.path);
    }
  }

  openCamera() async {
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      appBar: AppBar(
        backgroundColor: SharedColors.backGroundColor,
        elevation: 0.0,
        title: Text('Cash Rec', style: SharedFonts.primaryTxtStyle),
        iconTheme: IconThemeData(color: SharedColors.primaryColor, size: 25.0),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
            onDoubleTap: () {
              pickImage();
            },
            child: CameraPreview(controller)),
      ),
    );
  }
}
