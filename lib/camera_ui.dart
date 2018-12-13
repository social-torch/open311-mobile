import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'page.dart';
import 'globals.dart' as globals;

class CameraUiPage extends Page {
  CameraUiPage() : super(const Icon(Icons.map), 'Camera View');

  @override
  Widget build(BuildContext context) {
    return const CameraUiBody();
  }
}

class CameraUiBody extends StatefulWidget {
  const CameraUiBody();

  @override
  State<StatefulWidget> createState() => CameraUiBodyState();
}

class CameraUiBodyState extends State<CameraUiBody> {
  CameraUiBodyState();
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(globals.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}