import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justbon_flutter/views/utils/HttpUtil.dart';
import 'package:justbon_flutter/views/utils/Api.dart';
import 'package:justbon_flutter/views/DetailVcn.dart';

var kwidth = window.physicalSize.width;
var kheight = window.physicalSize.height;
class mineViewController extends StatefulWidget{
    @override
    
    _MineState createState()=> new _MineState();
}
class _MineState extends State<mineViewController>{
    //数据源
     String userName = '';
     String headImgUrl = '';
     String nikeName = '';
     String jiadouCount = '';
     @override
     void initState(){
        super.initState();
        // _selectLocalUser();
        // 网络请求
        _pullUserInfo();
        _pullUserJiadou();
     }
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
                onTap:(){
                  _itemClick(title);
                }
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
                     radius: 30,
                     backgroundImage: headImgUrl.length > 0 ? NetworkImage(headImgUrl) : AssetImage('images/my_head.png'),
                 ),
                 new Text(nikeName.length > 0 ? nikeName:'生活家',style: new TextStyle(fontSize: 14,color: Color(0xff333333),),),
                 new Center(
                   child: new Stack(
                     alignment: const FractionalOffset(0.5, 0.05),
                     children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             new Image.asset('images/jiadou_icon.png',width: 12,height: 13,),
                             new Text(jiadouCount.length > 0 ? '${jiadouCount}个':'0个',style: new TextStyle(fontSize: 12,color: Color(0xff333333),),),
                             new Image.asset('images/ic_next.png',width: 8,height: 14,),
                          ],
                        ),
                        new Stack(
                              children: <Widget>[
                                 new Image.asset('images/filter40.png',width: 80,height: 20,),
                                 new Positioned(
                                   left: 0,top: 0,right: 0,bottom: 0,
                                   child: new FlatButton(onPressed: (){
                                     _itemClick('嘉豆点击');
                                 },color: Colors.transparent,),
                                 )
                              ],
                          ),
                     ],
                   ),
                 ),
                 new Text('生活家,～您的生活管家',style: new TextStyle(fontSize: 14,color: Color(0xff333333),),),
               ],
             )
           ],
        );
     }
    //获取用户信息
     void _pullUserInfo() async{
        String url = Api().USERINFO_URL;
        var params = {'sCommandName':'getMember','sInput':{'ID':'1285858633'}};
        var response = await HttpUtil().post(url,data:params); 
        setState(() {
                headImgUrl = response['Item']['sHeadImg']; 
                nikeName =  response['Item']['sNickName'];  
                    });
     }
    // 获取用户嘉豆信息
    void _pullUserJiadou() async{
      String url = Api().USERJIADOU_URL;
      var params = {'requestData':{'userId':'1285858633'}};
      var response = await HttpUtil().post(url,data:params);
      setState(() {
              jiadouCount = response['resultData']['total'].toString();
            });
    }
    // 选中我的列表
    void _itemClick(String itemTitle){
        if (userName.length > 0 ){
           Navigator.of(context).push(new MaterialPageRoute(builder: (_){
           return new DetailVcn(title: itemTitle,);
           })).then((value){
            print('回传的值$value');
           });
        }else{
           Navigator.pushNamed(context, '/LoginVcn');
        }
    }
      
    // 本地查询是否存在登录用户
    _selectLocalUser() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String username = prefs.get('USERNAME');
        if (username.length > 0){
          setState(() {
                 userName = username;     
                    });
        }
    }
}