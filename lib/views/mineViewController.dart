import 'package:flutter/material.dart';

class mineViewController extends StatefulWidget{
    @override
    
    MineState createState()=> new MineState();
}

class MineState extends State<mineViewController>{
     double kwidth = 0.0;
     double kheight = 0.0;
     @override
     Widget build(BuildContext context){
       kwidth = MediaQuery.of(context).size.width;
       kheight = MediaQuery.of(context).size.height;
       return new Scaffold(
            appBar: new AppBar(
              title: new Text('我的'),
            ),
            body: new Center(
              child: new ListView(
                 children: list,
              )
            ),
       );
     }

     List<Widget> list = <Widget>[
         new Stack(
            alignment: const FractionalOffset(0.5, 0.5),
            children: <Widget>[
               new Image.asset('images/my_bg.png',width: 375,height: 150,),
               new Container(
                   decoration: new BoxDecoration(
                     borderRadius: BorderRadius.all(30),
                   ),
               ),
               new Image.asset('images/my_head.png',width: 60,height: 60,)
            ],
         ) 
     ];
}