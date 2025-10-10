
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';
import 'package:personal_wellness/feature/progress/controller/progress_controller.dart';

class GoPicture extends StatelessWidget {
  const GoPicture({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> stage = ValueNotifier(0); // 0: Left, 1: Right, 2: Front, 3: Text
    final List<String> imagePaths = [];

    // Initialize camera
    Future<CameraControllerManager?> initializeCamera() async {
      final status = await Permission.camera.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to proceed')),
        );
        return null;
      }
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      return CameraControllerManager(frontCamera);
    }

    void transitionToNextStage(int currentStage) {
      Timer(const Duration(seconds: 3), () {
        if (stage.value < 3) {
          stage.value = currentStage + 1;
        }
      });
    }

    return FutureBuilder<CameraControllerManager?>(
      future: initializeCamera(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('Failed to initialize camera')),
          );
        }

        final controllerManager = snapshot.data!;

        return ValueListenableBuilder<int>(
          valueListenable: stage,
          builder: (context, currentStage, child) {
            if (currentStage == 3) {
              controllerManager.dispose(); // Clean up controller
              return TextPage(imagePaths: imagePaths);
            }

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return Scaffold(
              
              body: Stack(
                fit: StackFit.expand,
                children: [
                  // Camera Preview
                  FutureBuilder<void>(
                    future: controllerManager.initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(controllerManager.controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),

                  // Overlay with Progress Arc Border
                  CustomPaint(
                    painter: OverlayPainter(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      progress: currentStage / 3, // এখানে progress পাঠানো হয়েছে
                    ),
                  ),

                  // Instruction Text
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.35),
                      child: Text(
                        currentStage == 0
                            ? 'Show the left side of your face'
                            : currentStage == 1
                                ? 'Show the right side of your face'
                                : 'Show the front of your face',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  try {
                    await controllerManager.initializeControllerFuture;
                    final image = await controllerManager.controller.takePicture();
                    imagePaths.add(image.path);
                    transitionToNextStage(currentStage);
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error capturing image: $e')),
                    );
                  }
                },
                backgroundColor: const Color(0xff485908),
                shape: const CircleBorder(),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }
}

// Manager class to handle camera controller state
class CameraControllerManager {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final CameraDescription camera;

  CameraControllerManager(this.camera) {
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  CameraController get controller => _controller!;
  Future<void> get initializeControllerFuture => _initializeControllerFuture!;

  void dispose() {
    _controller?.dispose();
  }
}

// Custom painter for dimmed overlay with circular progress border
class OverlayPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;
  final double progress; // 0.0 -> 1.0

  OverlayPainter({
    required this.screenWidth,
    required this.screenHeight,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ovalSize = screenWidth * 0.85;
    final center = Offset(screenWidth / 2, screenHeight / 3);
    final rect = Rect.fromCenter(center: center, width: ovalSize, height: ovalSize);

    // বাইরের Dim অংশ
    final ovalPath = Path()..addOval(rect);
    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    final overlayPath = Path.combine(PathOperation.difference, outerPath, ovalPath);

    final dimPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(overlayPath, dimPaint);

    // Progress Arc Border
    final borderPaint = Paint()
      ..color = Color(0xff485908)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final startAngle = -90 * 3.1416 / 180; // Top থেকে শুরু
    final sweepAngle = 2 * 3.1416 * progress; // Progress অনুযায়ী ঘুরবে

    canvas.drawArc(rect, startAngle, sweepAngle, false, borderPaint);
  }

  @override
  bool shouldRepaint(covariant OverlayPainter oldDelegate) => true;
}

// Text page after capturing all images
class TextPage extends StatefulWidget {
  final List<String> imagePaths;

  const TextPage({super.key, required this.imagePaths});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  @override
  void initState() {
    super.initState();
    // Save images to ProgressController after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ProgressController progressController = Get.put(ProgressController());
      progressController.saveCapturedImages(widget.imagePaths);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              ImagePath.takingpicture,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Thank you for capturing all sides of your face!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Display captured images at the bottom
                if (widget.imagePaths.length >= 3)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Image.file(
                            File(widget.imagePaths[0]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.file(
                            File(widget.imagePaths[1]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.file(
                            File(widget.imagePaths[2]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                // Processing indicator - will auto-navigate after upload completes
                Column(
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff485908)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Processing your photos...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You will be redirected automatically',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // AppBar content without actual AppBar to blend with background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Capture Complete',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48), // Space for alignment
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
                