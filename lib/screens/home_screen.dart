import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:snaky/screens/piece.dart';
import 'package:snaky/utilities/direction.dart';
import 'package:snaky/widgets/control_panel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? upperBondX;
  int? upperBondY;
  int? lowerBondX;
  int? lowerBondY;
  double? screenWidth;
  double? screenHeight;
  int step = 30;
  List<Offset> positions = [];
  int? length = 5;
  Direction direction = Direction.right;
  Timer? timer;
  Offset? foodPosition;
  late Piece food;
  int score = 0;
  double speed = 1.0;

  int getNearestTens(int number) {
    int outPutNumber;
    outPutNumber = (number ~/ step) * step;
    if (outPutNumber == 0) {
      outPutNumber += step;
    }
    return outPutNumber;
  }

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
  }

  void restart() {
    changeSpeed();
  }

  Widget getControls() {
    return ControlPanel(
      onTap: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBondY = step;
    lowerBondX = step;

    upperBondY = getNearestTens(screenHeight!.toInt() - step);
    upperBondX = getNearestTens(screenWidth!.toInt() - step);

    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControls(),
            food,
          ],
        ),
      ),
    );
  }

  Offset getRandomPosition() {
    Offset position;
    int positionX = Random().nextInt(upperBondX!) + lowerBondX!;
    int positionY = Random().nextInt(upperBondY!) + lowerBondY!;

    position = Offset(getNearestTens(positionX).toDouble(),
        getNearestTens(positionY).toDouble());

    return position;
  }

  Offset getNextPosition(Offset position) {
    late Offset nextPosition;
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    return nextPosition;
  }

  void drawSnake() {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while (length! > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = getNextPosition(positions[0]);
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }
    if(foodPosition == positions[0]){
      length = (length!+ 1);
      score = score +5;
      speed = speed+0.25;
      foodPosition = getRandomPosition();
    }
      food = Piece(
        positionX: foodPosition!.dx.toInt(),
        positionY: foodPosition!.dy.toInt(),
        size: step,
        color: Colors.red,
      );

  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    drawSnake();
    drawFood();
    for (int i = 0; i < length!; i++) {
      if(i >= positions.length){
        continue;
      }
      pieces.add(
        Piece(
          color: i.isEven ? Colors.red: Colors.green,
          positionX: positions[i].dx.toInt(),
          positionY: positions[0].dy.toInt(),
          size: step,
        ),
      );
    }

    return pieces;
  }
}
