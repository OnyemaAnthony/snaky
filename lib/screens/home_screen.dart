import 'dart:async';
import 'dart:html';
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
    timer = Timer.periodic(Duration(milliseconds: 200~/speed), (timer) {
      setState(() {});
    });
  }

  Direction getRandomDirection(){
    int randomDirection = Random().nextInt(4);
    direction = Direction.values[randomDirection];

    return direction;
  }

  void restart() {
    length =5;
    score = 0;
    score = 1;
    positions = [];
    direction = getRandomDirection();
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
            getScore(),
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

  bool detectCollision(Offset position) {
    if (position.dx >= upperBondX! && direction == Direction.right) {
      return true;
    } else if (position.dx >= lowerBondX! && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBondY! && direction == Direction.down) {
      return true;
    } else if (position.dy >= lowerBondX! && direction == Direction.up) {
      return true;
    }
    return false;
  }

  Future<Offset> getNextPosition(Offset position) async {
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
    if (detectCollision(position)) {
      if(timer != null && timer!.isActive){
        timer!.cancel();
      }
      await Future.delayed(Duration(milliseconds: 200), () => showGameOver());
      return position;
    }

    return nextPosition;
  }

  void drawSnake() async {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while (length! > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = await getNextPosition(positions[0]);
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }
    if (foodPosition == positions[0]) {
      length = (length! + 1);
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      positionX: foodPosition!.dx.toInt(),
      positionY: foodPosition!.dy.toInt(),
      size: step,
      color: Colors.red,
      isAnimated: true,
    );
  }

  Widget getScore() {
    return Positioned(
      top: 80,
      right: 50,
      child: Text(
        'Score : ${score.toString()}',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    drawSnake();
    drawFood();
    for (int i = 0; i < length!; i++) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(
        Piece(
          color: i.isEven ? Colors.red : Colors.green,
          positionX: positions[i].dx.toInt(),
          positionY: positions[0].dy.toInt(),
          size: step,
          isAnimated: false,
        ),
      );
    }

    return pieces;
  }

  void showGameOver() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            title: Text(
              'Game Over',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Your game is over you have a total score of ${score.toString()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  restart();
                },
                child: Text(
                  'Restart',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }
}
