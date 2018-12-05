import 'package:flutter/material.dart';

class mineViewController extends StatefulWidget{
    @override
    MineState createState()=> new MineState();
}

class MineState extends State<mineViewController>{
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Text('我的'),
            ),
            body: new Center(
              child: new Text('这是我的界面'),
            ),
       );
     }
}