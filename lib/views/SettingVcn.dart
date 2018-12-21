import 'package:flutter/material.dart';
import 'package:justbon_flutter/views/utils/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingVcn extends StatefulWidget{
  @override
  _SettingVcnState createState()=> new _SettingVcnState();
}

class _SettingVcnState extends State<SettingVcn>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
       return new Scaffold(
           appBar: new AppBar(
             title: new Text('设置'),
           ),
           body: new Center(
             child: new Container(
                padding: const EdgeInsets.all(10),
                width: Api().kwidth-40,
                height: 54,
                child: new FlatButton(
                   color: Color(0xff2bb2c1),
                   textColor: Color(0xffffffff),
                   child: new Text('退出'),
                   textTheme: ButtonTextTheme.normal,
                   splashColor: Colors.transparent,
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(20))
                   ),
                   onPressed: (){
                    _logout();
                   },
                ),
             ),
           ),
       );
  }

  _logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('宽度==''${Api().kwidth}');
    Navigator.pushNamed(context, '/LoginVcn').then((value){
             if (value == '成功'){
                Navigator.of(context).pop('成功');
             }
           });
  }
}