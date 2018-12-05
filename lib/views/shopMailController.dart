import 'package:flutter/material.dart';

class shopMailController extends StatefulWidget{
    @override
    ShomMailState createState()=> new ShomMailState();
}

class ShomMailState extends State<shopMailController>{
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Text('商城'),
            ),
            body: new Center(
              child: new Text('这是商城界面'),
            ),
       );
     }
}