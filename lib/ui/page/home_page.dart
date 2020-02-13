import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bpulsa/logic/bloc/menu_bloc.dart';
import 'package:bpulsa/model/menu.dart';
import 'package:bpulsa/ui/widgets/about_tile.dart';
import 'package:bpulsa/ui/widgets/profile_tile.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:flutter/foundation.dart';
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'dart:async';
import 'package:share/share.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  //menuStack
  Widget menuStack(BuildContext context, Menu menu) => InkWell(
        onTap: () => _showModalBottomSheet(context, menu),
        splashColor: Colors.blue,
        child: Card(
          elevation: 5.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              menuImage(menu),
              menuColor(),
              menuData(menu),
            ],
          ),
        ),
      );

  //stack 1/3
  Widget menuImage(Menu menu) => AspectRatio(
        aspectRatio: 1.0,
        child: Image.asset(
          menu.image,
          fit: BoxFit.cover,
        ),
      );

  //stack 2/3
  Widget menuColor() => new Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 5.0,
          ),
        ]),
      );

  //stack 3/3
  Widget menuData(Menu menu) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            menu.icon,
            color: Colors.white,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            menu.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      );

  //appbar
  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        pinned: true,
        elevation: 10.0,
        forceElevated: true,
        expandedHeight: 150.0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          background: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: UIData.kitGradients)),
          ),
          title: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(UIData.appName)
            ],
          ),
        ),
      );

  //bodygrid
  Widget bodyGrid(List<Menu> menu) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return menuStack(context, menu[index]);
        }, childCount: menu.length),
      );

  Widget homeScaffold(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
        child: new WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(key: _scaffoldState, body: bodySliverList()),
        ),
      );

  Widget bodySliverList() {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  slivers: <Widget>[
                    appBar(),
                    bodyGrid(snapshot.data),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget header() => Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: UIData.kitGradients2)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage(UIData.pkImage),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileTile(
                  title: "VulnWalker",
                  subtitle: "vulnwalker@tuyul.online",
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  void _showModalBottomSheet(BuildContext context, Menu menu) { 
    if(menu.targetPage == "logout"){
       var databaseHelper = new  DatabaseHelper() ;
       databaseHelper.deleteAccount();
       Navigator.pushReplacementNamed(context, "/${menu.targetPage}");
    }else if(menu.targetPage == "Share"){
      Share.share("Ayo bergabung dengan kami di BPulsa, banyak hadiah menarik setiap hari nya. Gunakan Email Referal saya $emailMember Download Applikasi nya di  https://play.google.com/store/apps/details?id=com.bonuspulsa.bpulsa&hl=en");
    }else{
      Navigator.pushNamed(context, "/${menu.targetPage}");
    }
    
    // showModalBottomSheet(
    //     context: context,
    //     builder: (context) => Material(
    //         color: Colors.white,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: new BorderRadius.only(
    //                 topLeft: new Radius.circular(15.0),
    //                 topRight: new Radius.circular(15.0))),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             header(),
    //             Expanded(
    //               child: ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: menu.items.length,
    //                 itemBuilder: (context, i) => Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
    //                       child: ListTile(
    //                           title: Text(
    //                             menu.items[i],
    //                           ),
    //                           onTap: () {
    //                             Navigator.pop(context);
    //                             Navigator.pushNamed(
    //                                 context, "/${menu.items[i]}");
    //                           }),
    //                     ),
    //               ),
    //             ),
    //             MyAboutTile()
    //           ],
    //         )));
  }

  Widget iosCardBottom(Menu menu, BuildContext context) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 3.0, color: Colors.white),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        menu.image,
                      ))),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              menu.title,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 20.0,
            ),
            FittedBox(
              child: CupertinoButton(
                onPressed: () => _showModalBottomSheet(context, menu),
                borderRadius: BorderRadius.circular(50.0),
                child: Text(
                  "Go",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                color: Colors.white,
              ),
            )
          ],
        ),
      );

  Widget menuIOS(Menu menu, BuildContext context) {
    return Container(
      height: deviceSize.height / 2,
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        margin: EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            menuImage(menu),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menu.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              height: 60.0,
              child: Container(
                width: double.infinity,
                color: menu.menuColor,
                child: iosCardBottom(menu, context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyDataIOS(List<Menu> data, BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
            data.map((menu) => menuIOS(menu, context)).toList()),
      );

  Widget homeBodyIOS(BuildContext context) {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
        stream: menuBloc.menuItems,
        initialData: List(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? bodyDataIOS(snapshot.data, context)
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget homeIOS(BuildContext context) => Theme(
        data: ThemeData(
          fontFamily: '.SF Pro Text',
        ).copyWith(canvasColor: Colors.transparent),
        child: CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                // border: Border(bottom: BorderSide.none),
                backgroundColor: CupertinoColors.white,
                largeTitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(UIData.appName),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: CupertinoColors.black,
                        child: FlutterLogo(
                          size: 15.0,
                          colors: Colors.yellow,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              homeBodyIOS(context)
            ],
          ),
        ),
      );
  Future<bool> _onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () => SystemNavigator.pop(),
              child: new Text('Yes'),
            ),
          ],
        ),
      ) ?? false;
  }


  var databaseHelper = new  DatabaseHelper() ;
  String emailMember = "";
  void getDataAccount() async{
    var dbClient = await databaseHelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM tabel_account');
    emailMember = list[0]["email"];
  }
  @override
  void initState() {
    super.initState();
    (() async {
      var asu = await getDataAccount();
      setState(() {
      });
    })();
  }
  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return defaultTargetPlatform == TargetPlatform.iOS
        ? homeIOS(context)
        : homeScaffold(context);
  }
}
