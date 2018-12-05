import 'package:flutter/material.dart';

class neighborViewController extends StatefulWidget{
    @override
    NeighborState createState()=> new NeighborState();
}

class NeighborState extends State<neighborViewController>{
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Text('邻里'),
            ),
            body: new Center(
              child: new Text('这是邻里界面'),
            ),
       );
     }
}