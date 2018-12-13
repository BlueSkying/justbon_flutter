import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class shopMailController extends StatefulWidget{
    @override
    _ShomMailState createState()=> new _ShomMailState();
}

class _ShomMailState extends State<shopMailController>{

     FlutterWebviewPlugin  flutterWebviewPlugin = FlutterWebviewPlugin();
     var urlString = 'http://mall.justbon.com.cn/m/project.html?uid=1285858633&userToken=CA1FC79A7910241C1479B3ABADD1EB2B';
     
     launchUrl(){
       setState(() {
                flutterWebviewPlugin.reloadUrl(urlString);
              });
     }
     
     @override
     void initState(){
       super.initState();
       flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state){
        switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          setState(() {
            
          });
          break;
        case WebViewState.startLoad:
          // 开始加载
         
          break;
        case WebViewState.finishLoad:
          
          break;
         }
       });
     }

     @override
     Widget build(BuildContext context){
       return WebviewScaffold(
            appBar: new AppBar(
              title: new Text('商城'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: ()=>launchUrl(),
                )
              ],
            ),
            url: urlString,
            withZoom: true,
            withLocalStorage: true,
            initialChild: Container(
              color: Colors.redAccent,
              child: const Center(
                child: Text('Waiting....'),
              ),
            ),
       );
     }
}