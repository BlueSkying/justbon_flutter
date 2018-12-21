import 'package:flutter/material.dart';

class mainController extends StatefulWidget{
    @override
    _MainState createState()=> new _MainState();
}

class _MainState extends State<mainController>{
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Center(
                child: new GestureDetector(
                    onTap: (){
                      print('切换项目');
                    },
                    child:new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                             new Text('生活家',style: new TextStyle(color: Color(0xff333333),fontSize: 14,),textAlign: TextAlign.center,),
                             new Image.asset('images/in-arrow.png',width: 10,height: 10,)
                        ],
                    ), 
                ) 
              ),
              leading: new IconButton(
                 icon: new Image.asset('images/in-scan-code.png',width: 22,height: 22,),
                 onPressed: (){
                   _scan();
                 },
              ),
              backgroundColor: Color(0xffffffff),
              actions: <Widget>[
                new Container(
                  width: 22,
                  height: 22,
                  color: Color(0xffffffff),
                )
              ],
            ),
            body: new Center(
              child: new Text('这是主界面'),
            ),
       );
     }

     _scan(){
       print('点击了扫码按钮');
     }
}