import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({super.key});

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  late CameraController controller;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  Future initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.max);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SharedColors.backGroundColor,
      body: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width / 1.3,
          child: CameraPreview(controller)),
    );
  }
}
