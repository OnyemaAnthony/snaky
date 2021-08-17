import 'package:flutter/material.dart';
import 'package:snaky/utilities/control_button.dart';
import 'package:snaky/utilities/direction.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction direction)? onTap;

  const ControlPanel({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(

      left: 0,
      right: 0,
      bottom: 50,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                ControlButton(
                  onPressed: (){
                   onTap!(Direction.left);
                  },
                  icon: Icon(Icons.arrow_left),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ControlButton(
                  onPressed: (){
                    onTap!(Direction.up);
                  },
                  icon: Icon(Icons.arrow_drop_up),
                ),
                SizedBox(height: 17,),
                ControlButton(
                  onPressed: (){
                    onTap!(Direction.down);
                  },
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [

                ControlButton(
                  onPressed: (){
                    onTap!(Direction.right);
                  },
                  icon: Icon(Icons.arrow_right),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
