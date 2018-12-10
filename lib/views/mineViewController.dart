import 'package:flutter/material.dart';
import 'dart:ui';

var kwidth = window.physicalSize.width;
var kheight = window.physicalSize.height;
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
              child: new ListView(
                scrollDirection: Axis.vertical,
                 children:<Widget>[
                   _headerBanner(),
                   _rowItem('我的商城','images/my_icon_01.png'),
                   _rowItem('我的嘉豆','images/my_icon_02.png'),
                   _rowItem('我的邮包','images/my_icon_03.png'),
                   _rowItem('商务合作','images/my_icon_04.png'),
                   _rowItem('我的消息','images/my_icon_05.png'),
                   _rowItem('我的帖子','images/my_icon_06.png'),
                   _rowItem('房屋管理','images/my_icon_07.png'),
                   _rowItem('我的房源','images/my_icon_08.png'),
                   _rowItem('意见反馈','images/my_icon_09.png'),
                   _rowItem('关于生活家','images/my_icon_10.png'),
                 ]
              )
            ),
       );
     }

     Widget _rowItem(String title,String iconName){
        return new Container(
            child: new ListTile(
                leading: new Image.asset(iconName,width: 25,height: 25,),
                title: new Text(title),
                trailing: new Image.asset('images/ic_next.png',width: 8,height: 14,),
            ),
        );
     }
     
     Widget _headerBanner(){
          return new Stack(
           alignment: const FractionalOffset(0.5, 0.2),
           children: <Widget>[
             new Image.asset('images/my_bg.png',width: kwidth,height: 150,),
             new Column(
               children: <Widget>[
                 new CircleAvatar(
                   backgroundImage: new AssetImage('images/my_head.png'),
                 ),
                 new Text('生活家',style: new TextStyle(fontSize: 14,color: Color(0xff333333),),),
                 new Center(
                   child: new Stack(
                     alignment: const FractionalOffset(0.5, 0.1),
                     children: <Widget>[
                        new Image.asset('images/filter40.png',width: 50,height: 20,),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             new Image.asset('images/jiadou_icon.png',width: 12,height: 13,),
                             new Text('1000个',style: new TextStyle(fontSize: 12,color: Color(0xff333333),),),
                             new Image.asset('images/ic_next.png',width: 8,height: 14,),
                          ],
                        )
                     ],
                   ),
                 ),
                 new Text('生活家,～您的生活管家',style: new TextStyle(fontSize: 14,color: Color(0xff333333),),),
               ],
             )
           ],
        );
     }
}