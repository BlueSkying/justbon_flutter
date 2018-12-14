import 'package:flutter/material.dart';
import './views/mainController.dart';
import './views/neighborViewController.dart';
import './views/shopMailController.dart';
import './views/mineViewController.dart';
import 'package:justbon_flutter/views/DetailVcn.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String,WidgetBuilder>{   //这里定义的是静态路由不能传递参数
        '/DetailVcn':(BuildContext context) => new DetailVcn()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int _counter = 0;
  TabController controller;

  @override
  void initState(){
    controller = new TabController(vsync: this,length: 4);
  }

  @override
  void dispose(){
     controller.dispose();
     super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: new TabBarView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
            controller: controller,
            children: <Widget>[
              new mainController(),
              new neighborViewController(),
              new shopMailController(),
              new mineViewController(),
            ],
      ),
      bottomNavigationBar: new Material(
        color: Colors.orangeAccent,
        child: new TabBar(
            controller: controller,
            tabs: <Widget>[
              new Tab(text: '首页', icon: new Image.asset('images/nav_icon_a01.png',width: 25,height: 25),),
              new Tab(text: '邻里', icon: new Image.asset('images/nav_icon_b01.png',width: 25,height: 25),),
              new Tab(text: '商城', icon: new Image.asset('images/nav_icon_c01.png',width: 25,height: 25),),
              new Tab(text: '我的', icon: new Image.asset('images/nav_icon_d01.png',width: 25,height: 25),),
            ],
        ),
      ),      
    );
  }
}
