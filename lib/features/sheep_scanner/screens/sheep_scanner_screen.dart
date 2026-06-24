import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/services.dart';
import 'package:gosheep_mobile/features/sheep_scanner/screens/scan_result_screen.dart';

class SheepScannerScreen extends StatefulWidget {
  const SheepScannerScreen({super.key});

  @override
  State<SheepScannerScreen> createState() => _SheepScannerScreenState();
}

class _SheepScannerScreenState extends State<SheepScannerScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isTorchOn = false;
  bool _isScanLocked = false;
  final _textRecognizer = TextRecognizer();

  bool _isProcessing = false;
  String _detectedText = '';

  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const double _viewfinderWidth = 320;
  static const double _viewfinderHeight = 200;
  static const Color _accentColor = Color(0xFFF5F0E8);

  Rect _viewfinderScreenRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateViewfinderRect(MediaQuery.of(context).size);
  }

  void _initAnimations() {
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _updateViewfinderRect(Size screenSize) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height * 0.42;
    _viewfinderScreenRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: _viewfinderWidth,
      height: _viewfinderHeight,
    );
  }

  Rect _cameraRectToScreen(Rect cameraRect, Size imageSize, Size screenSize) {
    final camAspectRatio = imageSize.width / imageSize.height;
    final screenAspectRatio = screenSize.width / screenSize.height;

    double scaleX, scaleY, offsetX = 0, offsetY = 0;

    if (camAspectRatio > screenAspectRatio) {
      scaleY = screenSize.height / imageSize.height;
      scaleX = scaleY;
      offsetX = (screenSize.width - imageSize.width * scaleX) / 2;
    } else {
      scaleX = screenSize.width / imageSize.width;
      scaleY = scaleX;
      offsetY = (screenSize.height - imageSize.height * scaleY) / 2;
    }

    return Rect.fromLTRB(
      cameraRect.left * scaleX + offsetX,
      cameraRect.top * scaleY + offsetY,
      cameraRect.right * scaleX + offsetX,
      cameraRect.bottom * scaleY + offsetY,
    );
  }

  bool _isInsideViewfinder(Rect blockScreenRect) {
    if (_viewfinderScreenRect == Rect.zero) return false;
    return _viewfinderScreenRect.contains(blockScreenRect.center);
  }

  InputImage? _inputImageFromCamera(CameraImage image) {
    if (_controller == null) return null;

    final camera = _controller!.description;
    final rotation = InputImageRotationValue.fromRawValue(
      camera.sensorOrientation,
    );
    if (rotation == null) return null;

    final inputFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputFormat == null) return null;
    if (image.planes.isEmpty) return null;

    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: inputFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing || _isScanLocked || !mounted || _controller == null || !_controller!.value.isInitialized) return;
    _isProcessing = true;

    try {
      final inputImage = _inputImageFromCamera(image);
      if (inputImage == null) return;

      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (!mounted || _controller == null || !_controller!.value.isInitialized) return;

      final screenSize = MediaQuery.of(context).size;

      final sensorOrientation = _controller!.description.sensorOrientation;
      final Size imageSize;
      if (sensorOrientation == 90 || sensorOrientation == 270) {
        imageSize = Size(image.height.toDouble(), image.width.toDouble());
      } else {
        imageSize = Size(image.width.toDouble(), image.height.toDouble());
      }

      final buffer = StringBuffer();
      for (final block in recognizedText.blocks) {
        final bb = block.boundingBox;
        final screenRect = _cameraRectToScreen(bb, imageSize, screenSize);
        if (_isInsideViewfinder(screenRect)) {
          buffer.writeln(block.text);
        }
      }

      final detected = buffer.toString().trim();
      if (detected.isNotEmpty) {
        if (_controller != null && _controller!.value.isInitialized && _controller!.value.isStreamingImages) {
          await _controller?.stopImageStream();
        }
        _scanController.stop();
        if (!mounted) return;
        setState(() {
          _detectedText = detected;
          _isScanLocked = true;
        });
      }
    } catch (e) {
      debugPrint('OCR Error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _scanAgain() async {
    if (_controller == null) return;

    if (_controller!.value.isStreamingImages) return;

    setState(() {
      _detectedText = '';
      _isScanLocked = false;
    });
    _scanController.repeat();
    await _controller!.startImageStream(_processCameraImage);
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await _controller!.initialize();
      await _controller!.startImageStream(_processCameraImage);

      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Camera Error: $e');
    }
  }

  Future<void> _toggleTorch() async {
    if (_controller == null) return;
    try {
      _isTorchOn = !_isTorchOn;
      await _controller!.setFlashMode(
        _isTorchOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Torch Error: $e');
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _textRecognizer.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized ? _buildScanner() : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildCameraPreview(Size screenSize) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final camAspect = _controller!.value.aspectRatio;
    final portraitAspect = camAspect > 1 ? 1 / camAspect : camAspect;

    return Center(
      child: AspectRatio(
        aspectRatio: portraitAspect,
        child: CameraPreview(_controller!),
      ),
    );
  }

  Widget _buildScanner() {
    final size = MediaQuery.of(context).size;

    const vfW = _viewfinderWidth;
    const vfH = _viewfinderHeight;
    final centerX = size.width / 2;
    final centerY = size.height * 0.42;

    final vfLeft = centerX - vfW / 2;
    final vfTop = centerY - vfH / 2;
    final vfRight = centerX + vfW / 2;
    final vfBottom = centerY + vfH / 2;

    return Stack(
      children: [
        Positioned.fill(child: _buildCameraPreview(size)),
        _buildSplitOverlays(size, vfLeft, vfTop, vfRight, vfBottom),
        _buildViewfinder(centerX, centerY, vfLeft, vfTop),
        _buildStatusBadge(centerX, vfTop),
        _buildTopBar(),
        _buildBottomUI(size),
      ],
    );
  }

  Widget _buildSplitOverlays(
    Size size,
    double vfLeft,
    double vfTop,
    double vfRight,
    double vfBottom,
  ) {
    const overlayColor = Color(0x8C000000);
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: vfTop,
          child: Container(color: overlayColor),
        ),
        Positioned(
          top: vfBottom,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(color: overlayColor),
        ),
        Positioned(
          top: vfTop,
          left: 0,
          width: vfLeft,
          height: _viewfinderHeight,
          child: Container(color: overlayColor),
        ),
        Positioned(
          top: vfTop,
          left: vfRight,
          right: 0,
          height: _viewfinderHeight,
          child: Container(color: overlayColor),
        ),
      ],
    );
  }

  Widget _buildViewfinder(
    double centerX,
    double centerY,
    double vfLeft,
    double vfTop,
  ) {
    return Positioned(
      left: vfLeft,
      top: vfTop,
      width: _viewfinderWidth,
      height: _viewfinderHeight,
      child: Stack(
        children: [
          _buildGridLines(),
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, _) {
              final progress = _scanAnimation.value;
              final opacity = progress < 0.08
                  ? progress / 0.08
                  : progress > 0.92
                  ? (1 - progress) / 0.08
                  : 1.0;
              final top = progress * (_viewfinderHeight - 6);

              return Positioned(
                top: top,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              _accentColor.withValues(alpha: 0.06),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              _accentColor.withValues(alpha: 0.6),
                              _accentColor,
                              _accentColor.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                            stops: const [0, 0.2, 0.5, 0.8, 1],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ..._buildCorners(),
        ],
      ),
    );
  }

  Widget _buildGridLines() {
    return Positioned.fill(child: CustomPaint(painter: _GridPainter()));
  }

  List<Widget> _buildCorners() {
    return [
      Positioned(
        top: 0,
        left: 0,
        child: _Corner(position: _CornerPosition.topLeft),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: _Corner(position: _CornerPosition.topRight),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: _Corner(position: _CornerPosition.bottomLeft),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: _Corner(position: _CornerPosition.bottomRight),
      ),
    ];
  }

  Widget _buildStatusBadge(double centerX, double vfTop) {
    final locked = _isScanLocked;
    return Positioned(
      top: vfTop - 30,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: locked
                ? Colors.green.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: locked
                  ? Colors.green.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (locked)
                const Icon(Icons.check_circle, color: Colors.green, size: 12)
              else
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) => Opacity(
                    opacity: _pulseAnimation.value,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 6),
              Text(
                locked ? 'Ear tag terdeteksi' : 'Mencari ear tag…',
                style: TextStyle(
                  color: locked
                      ? Colors.green
                      : Colors.white.withValues(alpha: 0.85),
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            _IconButton(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
            const Spacer(),
            _IconButton(
              onTap: _toggleTorch,
              child: Icon(
                _isTorchOn ? Icons.flashlight_on : Icons.flashlight_off,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomUI(Size size) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scan Ear Tag',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Arahkan kamera ke ear tag domba',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isScanLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 7),
                      const Text(
                        'Posisikan ear tag di dalam kotak',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isScanLocked
                    ? Column(
                        key: const ValueKey('locked'),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              _detectedText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Material(
                                  color: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: _scanAgain,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 13,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Scan Ulang',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ScanResultScreen(
                                          earTag: _detectedText,
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 13,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Lihat Hasil',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('scanning')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 0.5,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}

enum _CornerPosition { topLeft, topRight, bottomLeft, bottomRight }

class _Corner extends StatelessWidget {
  const _Corner({required this.position});

  final _CornerPosition position;

  static const double size = 22;
  static const double thickness = 3;
  static const double radius = 6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CornerPainter(position)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter(this.position);
  final _CornerPosition position;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F0E8)
      ..strokeWidth = _Corner.thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const s = _Corner.size;
    const r = _Corner.radius;
    const t = _Corner.thickness / 2;

    final path = Path();

    switch (position) {
      case _CornerPosition.topLeft:
        path.moveTo(t, s);
        path.lineTo(t, r + t);
        path.arcToPoint(
          Offset(r + t, t),
          radius: const Radius.circular(r),
          clockwise: true,
        );
        path.lineTo(s, t);
        break;
      case _CornerPosition.topRight:
        path.moveTo(0, t);
        path.lineTo(s - r - t, t);
        path.arcToPoint(
          Offset(s - t, r + t),
          radius: const Radius.circular(r),
          clockwise: true,
        );
        path.lineTo(s - t, s);
        break;
      case _CornerPosition.bottomLeft:
        path.moveTo(t, 0);
        path.lineTo(t, s - r - t);
        path.arcToPoint(
          Offset(r + t, s - t),
          radius: const Radius.circular(r),
          clockwise: false,
        );
        path.lineTo(s, s - t);
        break;
      case _CornerPosition.bottomRight:
        path.moveTo(0, s - t);
        path.lineTo(s - r - t, s - t);
        path.arcToPoint(
          Offset(s - t, s - r - t),
          radius: const Radius.circular(r),
          clockwise: false,
        );
        path.lineTo(s - t, 0);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter oldDelegate) =>
      oldDelegate.position != position;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 0.5;

    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
