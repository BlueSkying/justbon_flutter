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
      String userId = '';
      List projectPicAds = [];
      String city = '';
      String tempture = '';
      String limit = '';
      List middleBtn = [];
      List hotAds = [];
      List shopMailAds = [];
      List bindHouses = [];
     @override
      void initState() {
           // TODO: implement initState
           super.initState();
           _selectLocalUser();
           _getWeatherinfo();
           _getMiddleBtn();
         }
     @override
     Widget build(BuildContext context){
       return new Scaffold(
            appBar: new AppBar(
              title: new Center(
                child: new GestureDetector(
                    onTap: (){
                      _getUserBindHouse();
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
                   _middleBtnItem(),
                   _hotAdsItem(),
                   _shopMailItem(),
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
              itemCount: projectPicAds.length > 0 ? projectPicAds.length : 0,
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
                      child: new Text(city.length > 0 ? '$city' : '成都',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                  ),
                  new Expanded(
                      flex: 1,
                      child: new Text(tempture.length > 0 ? '$tempture' : '10',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
                  ),
                  new Expanded(
                      flex: 1,
                      child: new Text(limit.length > 0 ? '$limit' : '今日限行',style: new TextStyle(fontSize: 14.0),textAlign: TextAlign.center,),
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

    _middleBtnItem(){
       return new GridView.custom(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 7.0,
            crossAxisSpacing: 4.0,
          ),
          childrenDelegate: new SliverChildBuilderDelegate(
            (context,index){
               return new Column(
                    children: <Widget>[
                       new Center(
                           child: new Image.network(middleBtn.length > 0 ? middleBtn[index]['realName'] : 'images/homebannerd.png',width: 65,height: 65,),
                    ),
                       new Center(
                       child: new Text(middleBtn.length > 0 ? middleBtn[index]['funcName'] : '一键开门', style: new TextStyle(color: Color(0xff333333),fontSize: 14)),
                    )
                    ],
                );
            },
            childCount: 8,
          ),
       );
    }
    
    _hotAdsItem(){
       return new Container(
         padding: EdgeInsets.all(0),
         margin: EdgeInsets.all(0),
         height: 148,
         child: new Row(
          children: <Widget>[
            new Image.network(hotAds.length > 0 ? hotAds[0]['imgUrl'] : 'images/homebannerd.png',width: (MediaQuery.of(context).size.width)/2,),
            new Expanded(
              child:  new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                     new Image.network(hotAds.length > 0 ? hotAds[1]['imgUrl'] : 'images/homebannerd.png',width: (MediaQuery.of(context).size.width)/2,),
                     new Image.network(hotAds.length > 0 ? hotAds[2]['imgUrl'] : 'images/homebannerd.png',width: (MediaQuery.of(context).size.width)/2,),
                ],
              ),
            )
          ],
        )
      );
    }

    _shopMailItem(){
       return ListView.builder(
           shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
           scrollDirection: Axis.vertical,
           itemCount: shopMailAds.length > 0 ? shopMailAds.length : 0,
           itemBuilder: (BuildContext context,int position){
              return new Center(
                  child: new Column(
                    children: <Widget>[
                        new Divider(
                             height: 15.0,
                             color:Color(0xffffffff),
                        ),
                        new Text(shopMailAds.length > 0 ? shopMailAds[position]['mainTitle'] : '商城',style: new TextStyle(color: Color(0xff333333),fontSize: 16),),
                        new Text(shopMailAds.length > 0 ? shopMailAds[position]['subTitle'] : '商城',style: new TextStyle(color: Color(0xff666666),fontSize: 14),),
                        new Image.network(shopMailAds.length > 0 ? shopMailAds[position]['imgUrl'] : 'images/homebannerd.png',width: MediaQuery.of(context).size.width,height: 200,),

                    ],
                  ),
              );
           }
       );
    } 

    _exchangeProject(){
      showDialog<Null>(
           context: context,
           builder: (BuildContext context){
               return new SimpleDialog(
                  title: new Text('请选择房屋'),
                  children: <Widget>[
                     buildGrid()
            ],
         );
        }
      );
    }
    
    Widget buildGrid(){
       List<Widget> houses = [];
       Widget content;
       for (var item in bindHouses){
         houses.add(
           new SimpleDialogOption(
             child: new Text(item['projectName']+item['resourceName']),
             onPressed: (){
               Navigator.of(context).pop();
             },
           )
         );
       }
       content = new Column(
            children: houses,
       );
       return content;
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

     _getMiddleBtn() async{
       String url = Api().MIDDLEBTN_URL;
       var response = await HttpUtil().get(url);
       if (response['r'].toString() == '0'){
           setState(() {
                    middleBtn = response['top'];
                  });
       }  
     }

     _getShopMailAds() async{
       String url = Api().SHOPMAILADS_URL;
       var params = {'projectId':projectId};
       var response =await HttpUtil().post(url,data:params);
       if (response['r'].toString() == '0'){
          setState(() {
                      hotAds = response['shop'];
                      shopMailAds = response['ad'];
                    });
       }
     }

    _getUserBindHouse() async{
       String url = Api().USERBINDHOUSE_URL;
       var params = {'contactid':userId};
       var response = await HttpUtil().post(url,data:params);
       print(response);
       if (response['r'].toString() == '0'){
          setState(() {
                      bindHouses = response['data'];
                    });
          _exchangeProject();
       }
    }
     // 本地查询是否存在登录用户
    _selectLocalUser() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String projectid = prefs.get('USERPROJECTID');
        String userid = prefs.get('USERID');
        if (projectid !=null && projectid.length > 0){
           projectId = projectid;  
        }
        if (userid != null && userid.length > 0){
           userId = userid;
        }
        _getProjectPic();
        _getShopMailAds();
    }
}