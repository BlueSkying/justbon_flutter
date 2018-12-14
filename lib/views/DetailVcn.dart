import 'package:flutter/material.dart';

class DetailVcn extends StatefulWidget{
    // 接受从上一个页面传来的值
    DetailVcn({Key key,this.title}):super(key:key);
    final String title;  
    @override
    _DetailState createState()=> new _DetailState(title: title);
}
class _DetailState extends State<DetailVcn>{
  _DetailState({Key key,this.title});
  final String title;
    @override
   Widget build(BuildContext context){
       return new WillPopScope(
         child: new Scaffold(
           appBar: new AppBar(
              title: new Text('详情页面'),
              
            ),
            body: new Center(
               child: Text('详情测试${title}'),
               
            )
         ),
         onWillPop: _backMain
       );
    }

    Future<bool> _backMain(){
       _showDialog();
      // Navigator.of(context).pop('返回给你');
      return new Future.value(false);
    }
 
    _showDialog() {
     showDialog(
      context: context,
      child: new AlertDialog(content: new Text('退出当前界面'), actions: [
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pop('返回给你');
            },
            child: new Text('确定'))
      ]),
    );
  }
}

