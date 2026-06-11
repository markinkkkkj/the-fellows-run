import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState(); 
}

class _CameraState extends State<Camera> {
  CameraController? _controller;
  String? _cameraError;
  bool _isTakingPicture = false;

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if(cameras.isEmpty){
        if (!mounted) return;
        setState(() {
          _cameraError = "Nenhuma câmera encontrada no dispositivo";
        });
        return;
      }
      final frontCamera = cameras.firstWhere(
        (cameras) => cameras.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first, 
      );
      _controller = CameraController(frontCamera, ResolutionPreset.high);
      await _controller!.initialize();
      setState((){});
    } on CameraException catch (error) {
      if (!mounted) return;
      setState((){
        _cameraError = "Erro ao iniciar câmera: ${error.description}";
      });
    } catch (error) {
      if (!mounted) return;
      setState((){
        _cameraError = "Erro ao iniciar a câmera: $error";
      });
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || controller.value.isTakingPicture) {
      return;
    }
    setState(() {
      _isTakingPicture = true;
    });
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file);
    } on CameraException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao tentar tirar a foto: ${error.description}"))
      );
    } finally {
      if (mounted) {
        setState((){
          _isTakingPicture = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    if (_cameraError != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Câmera', style: TextStyle(color: theme.onPrimary)),
          backgroundColor: theme.primary,
          iconTheme: IconThemeData(color: theme.onPrimary),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _cameraError!,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.onSurface),
            ),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tirar foto', style: TextStyle(color: theme.onPrimary)),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(child: CameraPreview(_controller!)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: Colors.black,
              child: Center(
                child: GestureDetector(
                  onTap: _isTakingPicture ? null : _takePicture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primary, width: 4),
                    ),
                    child: Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isTakingPicture
                              ? theme.primary.withOpacity(0.5)
                              : theme.primary,
                        ),
                        child: _isTakingPicture
                            ? const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}