import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int? positionX, positionY, size;
  final Color? color;
  final bool? isAnimated;

  const Piece({
    Key? key,
    this.positionX,
    this.positionY,
    this.size,
    this.color,
    this.isAnimated = false
  }) : super(key: key);

  @override
  _PieceState createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.25,
      upperBound: 1.0,
      duration: Duration(milliseconds: 1000),
    );
    controller!.addStatusListener((status) {
         if(status == AnimationStatus.completed){
           controller!.reset();
         }else if(status == AnimationStatus.dismissed){
           controller!.forward();
         }
    });
  controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.positionY!.toDouble(),
      left: widget.positionX!.toDouble(),
      child: Opacity(
        opacity: widget.isAnimated!? controller!.value:1,
        child: Container(
          width: widget.size!.toDouble(),
          height: widget.size!.toDouble(),
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(width: 2, color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
