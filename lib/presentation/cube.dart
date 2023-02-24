import 'dart:math' as math;
import 'package:flutter/material.dart';

class Cube extends StatefulWidget {

  const Cube({super.key});

  @override
  State<Cube> createState() => _CubeState();
}

class _CubeState extends State<Cube> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation!,
      builder: (BuildContext context, Widget? child) {
        final matrix = _calculateMatrix(_animation!.value);
        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: Stack(
            children: [
              _side(Colors.red, [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
              _side(Colors.green, [0.0, 100.0, 100.0],[90.0, 0.0, 0.0]),
              _side(Colors.blue, [100.0, 0.0, 100.0], [0.0, 90.0, 0.0]),
              _side(Colors.yellow, [-100.0, 0.0, 100.0], [0.0, 90.0, 0.0]),
              _side(Colors.purple, [0.0, 0.0, 200.0], [0.0, 0.0, 0.0]),
              _side(Colors.orange, [0.0, -100.0, 100.0], [90.0, 0.0, 0.0]),
            ],
          ),
        );
      },
    );
  }

  Widget _side(Color color, List degree, List rotate) {
    const sideSize = 200.0;
    final side = Container(
      width: sideSize,
      height: sideSize,
      color: color,
    );

    final poligonTransform = Matrix4.identity()
      ..translate(degree[0], degree[1],degree[2])
      ..rotateX(radians(rotate[0]))
      ..rotateY(radians(rotate[1]))
      ..rotateZ(radians(rotate[2]));

    return Transform(
      transform: poligonTransform,
      alignment: Alignment.center,
      child: side,
    );
  }

  double radians(double degrees) {
    const rad = 0.017453292519943;
    return degrees*rad;
  }

  Matrix4 _calculateMatrix(double value) {
    final rotationX = Matrix4.rotationX(value);
    final rotationY = Matrix4.rotationY(value);
    final perspective = Matrix4.identity()
      ..setEntry(3, 2, 0.0)
      ..setEntry(3, 3, 1.0);
    final view = Matrix4.translationValues(0, 0, -4);
    return perspective * view * rotationX * rotationY;
  }
}