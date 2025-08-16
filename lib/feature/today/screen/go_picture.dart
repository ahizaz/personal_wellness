// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:personal_wellness/core/utils/constants/image_path.dart';

// class GoPicture extends StatelessWidget {
//   const GoPicture({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ValueNotifier<int> stage = ValueNotifier(0); // 0: Left, 1: Right, 2: Front, 3: Text
//     final List<String> imagePaths = [];

//     // Initialize camera
//     Future<CameraControllerManager?> initializeCamera() async {
//       final status = await Permission.camera.request();
//       if (status.isDenied || status.isPermanentlyDenied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Camera permission is required to proceed')),
//         );
//         return null;
//       }
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );
//       return CameraControllerManager(frontCamera);
//     }

//     void transitionToNextStage(int currentStage) {
//       Timer(const Duration(seconds: 3), () {
//         if (stage.value < 3) {
//           stage.value = currentStage + 1;
//         }
//       });
//     }

//     return FutureBuilder<CameraControllerManager?>(
//       future: initializeCamera(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (snapshot.hasError || snapshot.data == null) {
//           return const Scaffold(
//             body: Center(child: Text('Failed to initialize camera')),
//           );
//         }

//         final controllerManager = snapshot.data!;

//         return ValueListenableBuilder<int>(
//           valueListenable: stage,
//           builder: (context, currentStage, child) {
//             if (currentStage == 3) {
//               controllerManager.dispose(); // Clean up controller
//               return TextPage(imagePaths: imagePaths);
//             }

//             final screenWidth = MediaQuery.of(context).size.width;
//             final screenHeight = MediaQuery.of(context).size.height;

//             return Scaffold(
//               appBar: AppBar(
//                 title: Text(
//                   currentStage == 0
//                       ? 'Capture Left Side of Face'
//                       : currentStage == 1
//                           ? 'Capture Right Side of Face'
//                           : 'Capture Front of Face',
//                 ),
//               ),
//               body: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // Camera Preview
//                   FutureBuilder<void>(
//                     future: controllerManager.initializeControllerFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         return CameraPreview(controllerManager.controller);
//                       } else {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                     },
//                   ),
//                   // Overlay
//                   CustomPaint(
//                     painter: OverlayPainter(screenWidth: screenWidth, screenHeight: screenHeight),
//                   ),
//                   // Instruction Text
//                   Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: EdgeInsets.only(top: screenHeight * 0.35),
//                       child: Text(
//                         currentStage == 0
//                             ? 'Show the left side of your face'
//                             : currentStage == 1
//                                 ? 'Show the right side of your face'
//                                 : 'Show the front of your face',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Progress Bar
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: LinearProgressIndicator(
//                         value: currentStage / 3, // 0/3, 1/3, 2/3
//                         backgroundColor: Colors.grey[300],
//                         valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//                         minHeight: 10,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () async {
//                   try {
//                     await controllerManager.initializeControllerFuture;
//                     final image = await controllerManager.controller.takePicture();
//                     imagePaths.add(image.path);
//                     transitionToNextStage(currentStage);
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Error capturing image: $e')),
//                     );
//                   }
//                 },
//                 backgroundColor: const Color(0xff485908),
//                 shape: const CircleBorder(),
//                 child: const Icon(Icons.camera_alt, color: Colors.white),
//               ),
//               floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//             );
//           },
//         );
//       },
//     );
//   }
// }

// // Manager class to handle camera controller state
// class CameraControllerManager {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   final CameraDescription camera;

//   CameraControllerManager(this.camera) {
//     _controller = CameraController(
//       camera,
//       ResolutionPreset.high,
//     );
//     _initializeControllerFuture = _controller!.initialize();
//   }

//   CameraController get controller => _controller!;
//   Future<void> get initializeControllerFuture => _initializeControllerFuture!;

//   void dispose() {
//     _controller?.dispose();
//   }
// }

// // Custom painter for dimmed overlay with circular hole
// class OverlayPainter extends CustomPainter {
//   final double screenWidth;
//   final double screenHeight;

//   OverlayPainter({required this.screenWidth, required this.screenHeight});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final ovalSize = screenWidth * 0.85; // Equal width and height for circular shape
//     final strokeWidth = 2.0;

//     final ovalPath = Path()
//       ..addOval(
//         Rect.fromCenter(
//           center: Offset(screenWidth / 2, screenHeight / 3),
//           width: ovalSize,
//           height: ovalSize, // Set height equal to width for circular shape
//         ),
//       );

//     final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
//     final overlayPath = Path.combine(PathOperation.difference, outerPath, ovalPath);

//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.7)
//       ..style = PaintingStyle.fill;

//     final borderPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;

//     canvas.drawPath(overlayPath, paint);
//     canvas.drawOval(
//       Rect.fromCenter(
//         center: Offset(screenWidth / 2, screenHeight / 3),
//         width: ovalSize,
//         height: ovalSize, // Circular shape
//       ),
//       borderPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// // Text page after capturing all images
// class TextPage extends StatelessWidget {
//   final List<String> imagePaths;

//   const TextPage({super.key, required this.imagePaths});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               ImagePath.takingpicture,
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Content
//           Positioned.fill(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Thank you for capturing all sides of your face!',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 // Display captured images at the bottom
//                 if (imagePaths.length >= 3)
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ClipOval(
//                           child: Image.file(
//                             File(imagePaths[0]),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         ClipOval(
//                           child: Image.file(
//                             File(imagePaths[1]),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         ClipOval(
//                           child: Image.file(
//                             File(imagePaths[2]),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           // AppBar content without actual AppBar to blend with background
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                     const Text(
//                       'Capture Complete',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(width: 48), // Space for alignment
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }  
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:personal_wellness/core/utils/constants/image_path.dart';

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
              appBar: AppBar(
                title: Text(
                  currentStage == 0
                      ? 'Capture Left Side of Face'
                      : currentStage == 1
                          ? 'Capture Right Side of Face'
                          : 'Capture Front of Face',
                ),
              ),
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
                  // Overlay
                  CustomPaint(
                    painter: OverlayPainter(screenWidth: screenWidth, screenHeight: screenHeight),
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
                  // Progress Bar
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LinearProgressIndicator(
                        value: currentStage / 3, // 0/3, 1/3, 2/3
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 10,
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

// Custom painter for dimmed overlay with circular hole
class OverlayPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;

  OverlayPainter({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final ovalSize = screenWidth * 0.85; // Equal width and height for circular shape
    final strokeWidth = 2.0;

    final ovalPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(screenWidth / 2, screenHeight / 3),
          width: ovalSize,
          height: ovalSize, // Set height equal to width for circular shape
        ),
      );

    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    final overlayPath = Path.combine(PathOperation.difference, outerPath, ovalPath);

    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(overlayPath, paint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(screenWidth / 2, screenHeight / 3),
        width: ovalSize,
        height: ovalSize, // Circular shape
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Text page after capturing all images
class TextPage extends StatelessWidget {
  final List<String> imagePaths;

  const TextPage({super.key, required this.imagePaths});

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
                if (imagePaths.length >= 3)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Image.file(
                            File(imagePaths[0]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.file(
                            File(imagePaths[1]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipOval(
                          child: Image.file(
                            File(imagePaths[2]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
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
                      onPressed: () => Navigator.of(context).pop(),
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