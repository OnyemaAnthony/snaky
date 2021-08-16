import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int? positionX, positionY, size;
  final Color? color;

  const Piece({
    Key? key,
    this.positionX,
    this.positionY,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  _PieceState createState() => _PieceState();
}

class _PieceState extends State<Piece> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.positionY!.toDouble(),
      left: widget.positionX!.toDouble() ,
      child: Opacity(
        child: ,
      ),
    );
  }
}
