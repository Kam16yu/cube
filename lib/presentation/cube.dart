import 'package:flutter/material.dart';

/// Camera example home widget.
class CubePage extends StatefulWidget {
  /// Default Constructor
  const CubePage({Key? key}) : super(key: key);

  @override
  State<CubePage> createState() {
    return _CubePageState();
  }
}

class _CubePageState extends State<CubePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 360).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Cube'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(_animation.value * 0.0174533)
                ..rotateY(_animation.value * 0.0174533),
              alignment: FractionalOffset.center,
              child: Container(
                height: 200,
                width: 200,
                child: Stack(
                  children: [
                    CubeFace(
                        color: Colors.blue, rotation: Quaternion(0, 0, 0, 1)),
                    CubeFace(
                        color: Colors.red, rotation: Quaternion(1, 0, 0, 1)),
                    CubeFace(
                        color: Colors.green, rotation: Quaternion(0, 1, 0, 1)),
                    CubeFace(
                        color: Colors.yellow, rotation: Quaternion(0, 0, 1, 1)),
                    CubeFace(
                        color: Colors.purple,
                        rotation: Quaternion(0, 0, 1, -1)),
                    CubeFace(
                        color: Colors.orange,
                        rotation: Quaternion(0, 1, 0, -1)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CubeFace extends StatelessWidget {
  final Color color;
  final Quaternion rotation;

  const CubeFace({Key? key, required this.color, required this.rotation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: rotation.toMatrix(),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class Quaternion {
  final double x;
  final double y;
  final double z;
  final double w;

  const Quaternion(this.x, this.y, this.z, this.w);

  Matrix4 toMatrix() {
    final double xx = x * x;
    final double xy = x * y;
    final double xz = x * z;
    final double xw = x * w;
    final double yy = y * y;
    final double yz = y * z;
    final double yw = y * w;
    final double zz = z * z;
    final double zw = z * w;

    return Matrix4(
      1 - 1 * (yy + zz), 1 * (xy - zw), 1 * (xz + yw), 0,
      1 * (xy + zw), 1 - 1 * (xx + zz), 1 * (yz - xw), 0,
      1 * (xz - yw), 1 * (yz + xw), 1 - 1 * (xx + yy), 0,
      0, 0, 0, 1,
    );
  }
}
