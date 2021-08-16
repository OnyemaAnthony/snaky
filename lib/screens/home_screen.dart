import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:snaky/screens/piece.dart';
import 'package:snaky/utilities/direction.dart';

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


  int getNearestTens(int number) {
    int outPutNumber;
    outPutNumber = (number ~/ step) * step;
    if (outPutNumber == 0) {
      outPutNumber += step;
    }
    return outPutNumber;
  }
  
  void changeSpeed(){

    if(timer!= null && timer!.isActive){
      timer!.cancel();
    }
    timer = Timer.periodic(Duration(microseconds: 200), (timer) {
      setState(() {

      });
    });
  }
  
  void restart(){
    changeSpeed();
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
            )
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
  Offset getNextPosition(Offset position){
    late Offset nextPosition;
     if(direction == Direction.right){
       nextPosition = Offset(position.dx+step, position.dy);
     }else if(direction == Direction.left){
       nextPosition = Offset(position.dx-step, position.dy);
     }else if(direction == Direction.up){
       nextPosition = Offset(position.dx, position.dy-step);
     }else if(direction == Direction.down){
       nextPosition = Offset(position.dx, position.dy+step);
     }
   return  nextPosition;
  }

  void draw() {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while(length! > positions.length ){
      positions.add(positions[positions.length -1]);
    }

    for(int i = positions.length-1; i> 0; i--){
      positions[i] =positions[i-1];


    }
    positions[0]= getNextPosition(positions[0]);
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
   for(int i =0; i<length!; i++){
     pieces.add(
       Piece(
         color: Colors.red,
         positionX: positions[0].dx.toInt(),
         positionY: positions[0].dy.toInt(),
         size: step,
       ),
     );
   }

    return pieces;
  }
}
