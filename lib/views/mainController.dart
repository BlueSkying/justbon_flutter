import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:justbon_flutter/views/utils/HttpUtil.dart';
import 'package:justbon_flutter/views/utils/Api.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
class mainController extends StatefulWidget{
    @override
    _MainState createState()=> new _MainState();
}

class _MainState extends State<mainController>{
      String projectId = '';
      List projectPicAds = [];
      String city = '';
      String tempture = '';
      String limit = '';
    
     @override
      void initState() {
           // TODO: implement initState
           super.initState();
           _getProjectPic();
           _getWeatherinfo();
         }
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
              child: new ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                   _bannerScrollImg(),
                   _weatherItem(),
                ],
              ),
            ),
       );
     }
    // banner循环播放图片 
     _bannerScrollImg(){
          return new Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Swiper(
              itemBuilder: _SwiperBuilder,
              itemCount: projectPicAds.length,
              control: new SwiperControl(),
              scrollDirection: Axis.horizontal,
              autoplay: true,
              onTap: (index){
                  print('点击了$index个');
              }
            ),
          );
     }

    Widget _SwiperBuilder(BuildContext context,int index){
          return new Image.network(projectPicAds.length > 0 ? projectPicAds[index]['imgUrl'] : 'images/homebannerd.png',fit: BoxFit.fill,);
          
     }

    _weatherItem(){
      return new Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           new Divider(
               height: 15.0,
               color:Color(0xff2bb2c1),
             ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      flex: 1,
                      child: new Text('$city',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                  ),
                  new Expanded(
                      flex: 1,
                      child: new Text('$tempture',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                  ),
                  new Expanded(
                      flex: 1,
                      child: new Text('$limit',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                  ),
                ],
            ),
            new Divider(
               height: 15.0,
               color:Color(0xff2bb2c1),
             ),
         ],
      );
    }


     _scan(){
       print('点击了扫码按钮');
     }

     _getProjectPic() async{
         String url = Api().USERPROJECTADS_URL;
         var params = {'type':'index','projectId':projectId};
         var response = await HttpUtil().post(url,data:params);
         if (response['r'] == '0'){
             setState(() {
                            projectPicAds = response['ads'];
                          });
         }
     }

     _getWeatherinfo() async{
        String url = Api().WEATHER_URL;
        var params = {'location':'104.07,30.67'};
        var response = await HttpUtil().post(url,data:params);
        if (response['r'].toString() == '0'){
           setState(() {
                  city = response['city'];
                  tempture = response['weather'] + ' ' +response['cTemperature']+ '°C';  
                  limit = '今日限行  ' + response['xx']['xxnum'];     
                      });
        }
     }
}