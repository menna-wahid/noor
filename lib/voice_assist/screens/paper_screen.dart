import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:noor/shared/shared_theme/shared_colors.dart';

class PaperScreen extends StatefulWidget {
  const PaperScreen({super.key});

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
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
