import 'package:flutter/material.dart';

class mainController extends StatefulWidget{
    @override
    MainState createState()=> new MainState();
}

class MainState extends State<mainController>{
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Text('生活家'),
            ),
            body: new Center(
              child: new Text('这是主界面'),
            ),
       );
     }
}