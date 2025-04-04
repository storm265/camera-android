import 'dart:async';
import 'dart:developer';
import 'package:camera_bg/camera.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  int counter = 0;
  late DateTime currentUseTime;
  Timer? lockChecker, cameraChecker;
  bool alreadyChecking = false;
  late CameraDescription description;
  late CameraController _cameraController;

  // void checkIfCameraInUse() {
  //   cameraChecker = Timer.periodic(const Duration(seconds: 7), (_timer) async {
  //     final lastTimeInUse =
  //         DateTime.now().difference(currentUseTime).abs().inSeconds;
  //     if (lastTimeInUse > 4 && !alreadyChecking) {
  //       alreadyChecking = true;
  //   await    initCamera();
  //       _timer.cancel();
  //       await Future.delayed(const Duration(seconds: 10));
  //   await    initCamera();
  //     }
  //     log("Last time in use: $lastTimeInUse");
  //   });
  // }

  Future<void> initCamera() async {
    description = await availableCameras().then(
      (cameras) => cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
    );
    _cameraController = CameraController(
      description,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await _cameraController.initialize();

    _cameraController.startImageStream((img) async {
      currentUseTime = DateTime.now();
      log("Image captures: ${img.width} x ${img.height}");
    });
    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   log('Is Camera Avaialble: ${await _cameraController.isCameraAvailable()}');
    // });
  }

  // @override
  // Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
  //   initCamera();
  //   // checkIfCameraInUse();
  //   // Timer.periodic(const Duration(seconds: 5), (timer) async {
  //   //   BgLauncher.bringAppToForeground(
  //   //       action: 'REQUEST_EXERCICE', extras: 'FBI OPEN UP');
  //   // });
  // }

  // @override
  // Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  // @override
  // Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
  //   await FlutterForegroundTask.clearAllData();
  // }

  // @override
  // void onButtonPressed(String id) {
  //   _cameraController.destroyCamera();
  //   log('onButtonPressed >> $id -- $updateCount');
  // }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    await FlutterForegroundTask.clearAllData();
    _cameraController.destroyCamera();
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await initCamera();
  }
}
