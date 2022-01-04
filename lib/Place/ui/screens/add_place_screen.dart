import 'dart:io';

import 'package:flutter/material.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';

class AddPlaceScreen extends StatefulWidget{
  File? image;

  AddPlaceScreen({Key? key, this.image});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  
}

class _AddPlaceScreen extends State<AddPlaceScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(height: 300.0),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 50.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 45,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
}