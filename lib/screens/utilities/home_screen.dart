import 'package:flutter/material.dart';

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
  int step = 20;

  int getNearestTens(int number){
    int outPutNumber;
    outPutNumber = (number ~/step) *step;
    if(outPutNumber == 0){
      outPutNumber+= step;
    }
    return outPutNumber;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth= MediaQuery.of(context).size.width;
    lowerBondY = step;
    lowerBondX = step;


    upperBondY = getNearestTens(screenHeight!.toInt()-step);
    upperBondX = getNearestTens(screenWidth!.toInt()-step);


    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Stack(
          children: [

          ],
        ),
      ),
    );
  }
}
