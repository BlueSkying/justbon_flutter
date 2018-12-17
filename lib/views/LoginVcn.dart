import 'package:flutter/material.dart';

class LoginVcn extends StatefulWidget{
  @override
  _LoginVcnState createState() =>new _LoginVcnState();
}

class _LoginVcnState extends State<LoginVcn>{
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
     return new Scaffold(
         body: new Center(
            child: new ListView(
               scrollDirection: Axis.vertical,
               children: <Widget>[
                   _topItem(),
               ],
            ),
         ),
         
     );
  }

  Widget _topItem(){
      return new Container(
        child: new Column(
          children: <Widget>[
            new Align(
                alignment: FractionalOffset.centerLeft,
                child: new IconButton(icon: new Image.asset('images/close.png'),alignment: Alignment.topLeft,onPressed: (){
                    _closeWindow();
                })
            ),
            new Center(
              child: new Image.asset('images/login_logo_icon.png',width: 80,height: 80,),
            ),
          ],
        ),
      );
  }

  _closeWindow(){
     Navigator.pop(context);
  }
}