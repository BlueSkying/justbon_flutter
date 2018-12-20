import 'package:flutter/material.dart';
import 'package:justbon_flutter/views/utils/Api.dart';
import 'package:justbon_flutter/views/utils/HttpUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginVcn extends StatefulWidget{
  @override
  _LoginVcnState createState() =>new _LoginVcnState();
}

class _LoginVcnState extends State<LoginVcn>{
  String phoneNum;
  String passwordNum;
  String isLoginSuccess = '失败';
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
             new Container(
                height: 90,
             ),
             new Row(
                children: <Widget>[
                  new Align(
                      alignment: FractionalOffset.centerLeft,
                      child: new Text('手机号码:', style: new TextStyle(color: const Color(0xff333333),fontSize: 14,),),
                  ),
                  new Container(
                    width: 150,
                    child: new TextField(
                         controller: _phonecontroller,
                         keyboardType: TextInputType.number,
                         decoration: InputDecoration(
                         contentPadding: EdgeInsets.all(10),
                         hintText: '请输入手机号',
                    ),
                  )
                  )
                ],
             ),
             new Divider(
               height: 2.0,
               color:Color(0xff2bb2c1),
             ),
             new Container(
                height: 20,
             ),
             new Row(
                children: <Widget>[
                  new Align(
                      alignment: FractionalOffset.centerLeft,
                      child: new Text('密  码:', style: new TextStyle(color: const Color(0xff333333),fontSize: 14,),),
                  ),
                  new Container(
                    width: 150,
                    child: new TextField(
                         controller: _passController,
                         decoration: InputDecoration(
                           contentPadding: EdgeInsets.all(10),
                           hintText: '请输入密码',
                         ),
                         obscureText:true,
                  )
                  )
                ],
             ),
             new Divider(
               height: 2.0,
               color:Color(0xff2bb2c1),
             ),
             new Container(
                height: 50,
             ),
             new Container(
               width: Api().kwidth-40,
               height: 44,
               child: new FlatButton(
               textColor: Color(0xffffffff),
               color: Color(0xff2bb2c1),
               child: new Text('登录', style:new TextStyle(color:Color(0xffffffff),fontSize:14),),
               textTheme: ButtonTextTheme.normal,
               splashColor: Colors.transparent,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(20))
               ),
               onPressed: (){
                 _login();
               },
             )
             )
           ],
        ),
     );
  }
  
  _closeWindow(){
     Navigator.of(context).pop(isLoginSuccess);
  }

  _login() async{
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
      String url = Api().USERLOGIN_URL;
        var params = {'params':{'loginName':_phonecontroller.text,'password':_passController.text,'xingeToken':''}};
        var response = await HttpUtil().post(url,data:params); 
        if (response['status'] == '1'){
           isLoginSuccess = '成功';
           SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.setString('USERPHONE', _phonecontroller.text);
           prefs.setString('USERID', response['data']['contactId'].toString());
           prefs.setString('USERPROJECTID', response['data']['projectId'].toString());
           prefs.setString('USERPROJECTNAME', response['data']['projectName']);
           prefs.setString('USERNAME', response['data']['name']);
           prefs.setString('USERTOKEN', response['token'].toString());

           _closeWindow();
        }
      // _phonecontroller.clear();        
      // _passController.clear();
    }
  }
}