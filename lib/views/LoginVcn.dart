import 'package:flutter/material.dart';

class LoginVcn extends StatefulWidget{
  @override
  _LoginVcnState createState() =>new _LoginVcnState();
}

class _LoginVcnState extends State<LoginVcn>{
  String phoneNum;
  String passwordNum;
  // 手机号码的控制器
  final TextEditingController _phonecontroller = new TextEditingController();
  // 密码输入的控制器
  final TextEditingController _passController = new TextEditingController();
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
     return new Scaffold(
         body: new Container(
            child: new ListView(
               scrollDirection: Axis.vertical,
               children: <Widget>[
                   _topItem(),
                   _inputItem(),
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
  
  Widget _inputItem(){
     return new Container(
        padding: const EdgeInsets.all(20),
        child: new Column(
           children: <Widget>[
             new Row(
                children: <Widget>[
                  new Align(
                      alignment: FractionalOffset.centerLeft,
                      child: new Text('手机号码', style: new TextStyle(color: const Color(0xff333333),fontSize: 14,),),
                  ),
                  new TextField(
                    controller: _phonecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: '请输入手机号',
                      icon: Icon(Icons.phone)
                    ),
                  )
                ],
             ),
           ],
        ),
     );
  }
  
  _textChange(String text){
    print(text);
  }

  _closeWindow(){
     Navigator.pop(context);
  }

  _login(){
    if (_phonecontroller.text.length != 11) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('手机号码格式不对'),
              ));
    } else if (_passController.text.length == 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('请填写密码'),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('登录成功'),
              ));
      _phonecontroller.clear();        
      _phonecontroller.clear();
    }
  }
}