// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:bpulsa/ui/page/dashboard/dashboard_one/dashboard_menu_row.dart';
// import 'package:bpulsa/ui/widgets/login_background.dart';
// import 'package:bpulsa/ui/widgets/profile_tile.dart';
// import 'package:bpulsa/utils/uidata.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:bpulsa/config.dart';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:bpulsa/ui/page/dashboard/dashboard_two/dashboard_menu_row_two.dart';
// import 'package:bpulsa/ui/widgets/label_below_icon.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// //Database
// import 'package:bpulsa/database/DatabaseHelper.dart';
// import 'package:flushbar/flushbar.dart';

// const APP_ID = "<Put in your Device ID>";
// class Task extends StatefulWidget {
//   ConfigClass configClass = new ConfigClass();
//   @override
//   TaskState createState() {
//     return new TaskState();
//   }

// }

// class TaskState extends State<Task> {
//    static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     testDevices: APP_ID != null ? [APP_ID] : null,
//     keywords: ['Games', 'Puzzles'],
//   );
//   Size deviceSize;
//   String emailMember,namaMember;
//   int saldoMember;
//   String publicAdsName;
//   BannerAd bannerAd;
//   InterstitialAd interstitialAd;
//   InterstitialAd interstitialAdLuckyPoint;
//   InterstitialAd interstitialAdAbsen;
//   bool backButton = true;
//   bool showLoading = false;
 
//   var databaseHelper = new  DatabaseHelper() ;
//   void getDataAccount() async{
//     var dbClient = await databaseHelper.db;
//     List<Map> list = await dbClient.rawQuery('SELECT * FROM tabel_account');
//     namaMember = list[0]["nama"];
//     emailMember = list[0]["email"];
//     saldoMember = list[0]["saldo"];
//   }

//   BannerAd buildBanner() {
//     return BannerAd(
//         adUnitId: BannerAd.testAdUnitId,
//         size: AdSize.banner,
//         listener: (MobileAdEvent event) {
//           print(event);
//         });
//   }

//   InterstitialAd buildInterstitial() {
//     return InterstitialAd(
//         adUnitId: InterstitialAd.testAdUnitId,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) {
//           if (event == MobileAdEvent.failedToLoad) {
//             interstitialAd..load();
//           } else if (event == MobileAdEvent.closed) {
//             // interstitialAd = buildInterstitial()..load();
//           }else if (event == MobileAdEvent.loaded) {
//             interstitialAd.show();
//           }
//           print(event);
//         });
//   }
//   InterstitialAd buildInterstitialLuckyPoint(adUnit) {
//     return InterstitialAd(
//         adUnitId: InterstitialAd.testAdUnitId,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) {
//           if (event == MobileAdEvent.failedToLoad) {
//             interstitialAdLuckyPoint..load();
//           } else if (event == MobileAdEvent.closed) {
//             // interstitialAd = buildInterstitial()..load();
//           }else if (event == MobileAdEvent.loaded) {
//             setState(() {
//                       showLoading =false;
//                       backButton =true;
//             });
//             var dataPost = {
//                       "email":emailMember, 
//                       "adsName":publicAdsName, 
//                 };
//             http.post(widget.configClass.getReward(), body: dataPost).then((response) {
//               var extractdata = json.decode(response.body);
//               List dataResult;
//               List dataContent;
//               String err,cek;
//               dataResult = extractdata["result"];
//               err = dataResult[0]["err"];
//               cek = dataResult[0]["cek"];
//               dataContent = dataResult[0]["content"];
//               (() async {
//                 var dbClient = await databaseHelper.db;
//                 saldoMember = saldoMember + int.tryParse(dataContent[0]["point"]);
//                 await dbClient.rawQuery("update tabel_account set saldo = '"+saldoMember.toString()+"'");
//               })();
//               setState(() {
//                 Flushbar(
//                     flushbarPosition: FlushbarPosition.TOP, //Immutable
//                     reverseAnimationCurve: Curves.decelerate, //Immutable
//                     forwardAnimationCurve: Curves.elasticOut, //Immutable
                    
//                   )
//                     ..title = "Lucky Point"
//                     ..message = "Anda mendapatkan "+dataContent[0]["point"]+" Point dari lucky point"
//                     ..duration = Duration(seconds: 10)
//                     ..backgroundColor = Colors.red
//                     ..backgroundColor = Colors.red
//                     ..shadowColor = Colors.blue[800]
//                     ..isDismissible = true
//                     ..backgroundGradient = new LinearGradient(colors: [Colors.blue,Colors.black])
//                     ..icon = Icon(
//                       Icons.error,
//                       color: Colors.greenAccent,
//                     )
//                     ..linearProgressIndicator = LinearProgressIndicator(
//                       backgroundColor: Colors.blueGrey,
//                     )
//                     ..show(context);
//               });
//             });
//             interstitialAdLuckyPoint.show();
//           }
//           print(event);
//         });
//   }
//   InterstitialAd buildInterstitialAbsen(adUnit) {
//     return InterstitialAd(
//         adUnitId: InterstitialAd.testAdUnitId,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) {
//           if (event == MobileAdEvent.failedToLoad) {
//             interstitialAdLuckyPoint..load();
//           } else if (event == MobileAdEvent.closed) {
//             // interstitialAd = buildInterstitial()..load();
//           }else if (event == MobileAdEvent.loaded) {
//             setState(() {
//                       showLoading =false;
//                       backButton =true;
//             });
//             interstitialAdAbsen.show();
//           }
//           print(event);
//         });
//   }
  
//   void loadVideoAds(adsUnit) {
//     RewardedVideoAd.instance.load(
//       adUnitId: RewardedVideoAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//     );
//   }
//   void loadVideoAds2(adsUnit) {
//     RewardedVideoAd.instance.load(
//       adUnitId: RewardedVideoAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//     );
//   }
//   void loadVideoAds3(adsUnit) {
//     RewardedVideoAd.instance.load(
//       adUnitId: RewardedVideoAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//     );
//   }
//   void luckyPointAds(adsUnit) {
//     interstitialAdLuckyPoint = buildInterstitialLuckyPoint(adsUnit)..load();
//   }

//   @override
//   void initState() {
//     super.initState();
//     (() async {
//       var asu = await getDataAccount();
//       setState(() {
//       });
//     })();

//     FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//     bannerAd = buildBanner()..load();
//     interstitialAd = buildInterstitial()..load();
//      RewardedVideoAd.instance.listener =
//         (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//       print("RewardedVideoAd event $event");
//       if (event == RewardedVideoAdEvent.failedToLoad) {
//         setState(() {
//                       showLoading =false;
//                       backButton =true;
//           });
//         AlertDialog dialog = new AlertDialog(
//             content: new Text("Gagal Load Video")
//         );
//         showDialog(context: context,child: dialog);
//       } 
//       if(event == RewardedVideoAdEvent.loaded){
//         setState(() {
//                       showLoading =false;
//                       backButton =true;
//         });
//         RewardedVideoAd.instance.show();
//         print("Iklan terload");
//       }

//       //onRewardedVideo
//       if(event == RewardedVideoAdEvent.closed){
//         setState(() {
//                       showLoading =false;
//                       backButton =true;
//         });
//         var dataPost = {
//                    "email":emailMember, 
//                    "adsName":publicAdsName, 
//              };
//         http.post(widget.configClass.getReward(), body: dataPost).then((response) {
//           var extractdata = JSON.decode(response.body);
//           List dataResult;
//           List dataContent;
//           String err,cek;
//           dataResult = extractdata["result"];
//           err = dataResult[0]["err"];
//           cek = dataResult[0]["cek"];
//           dataContent = dataResult[0]["content"];
//           (() async {
//             var dbClient = await databaseHelper.db;
//             saldoMember = saldoMember + int.tryParse(dataContent[0]["point"]);
//             await dbClient.rawQuery("update tabel_account set saldo = '"+saldoMember.toString()+"'");
//           })();
//           setState(() {
//           });
//         });
//       }
//       //Test test test

//     };
   
   

//   }
// @override
//   void dispose() {
//     bannerAd?.dispose();
//     interstitialAd?.dispose();
//     super.dispose();
//   }

    

//   @override
//   Widget build(BuildContext context) {
//     deviceSize = MediaQuery.of(context).size;
    
//      @override
//      Widget appBarColumn(BuildContext context) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
//           child: new Column(
//             children: <Widget>[
//               new Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   new IconButton(
//                     icon: new Icon(
//                       defaultTargetPlatform == TargetPlatform.android
//                           ? Icons.arrow_back
//                           : Icons.arrow_back_ios,
//                       color: Colors.white,
//                     ),
//                     onPressed: () => Navigator.canPop(context)
//                         ? Navigator.pop(context)
//                         : null,
//                   ),
//                   new ProfileTile(
//                     title: "Hi, "+namaMember,
//                     subtitle: "Welcome to the "+ widget.configClass.app_name,
//                     textColor: Colors.white,
//                   ),
//                   new IconButton(
//                     icon: new Icon(
//                       Icons.do_not_disturb,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       AlertDialog dialog = new AlertDialog(
//                         content: new Text("Reload Activity")
//                       );
//                       showDialog(context: context,child: dialog);
//                     },
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );

//      void doAbsenHarian(){
//               setState(() {
//                       showLoading =true;
//                       backButton =false;
//               });
//               var dataPost = {
//                 "email":emailMember, 
//                 };
//               http.post(widget.configClass.absenHarian(), body: dataPost).then((response) {
//                 setState(() {
//                       showLoading =false;
//                       backButton =true;
//                  });
//                 var extractdata = JSON.decode(response.body);
//                 List dataResult;
//                 List dataContent;
//                 String err,cek;
//                 dataResult = extractdata["result"];
//                 err = dataResult[0]["err"];
//                 cek = dataResult[0]["cek"];
//                 dataContent = dataResult[0]["content"];
//                 print(err);
//                 if(err == ""){
//                   (() async {
//                     var dbClient = await databaseHelper.db;
//                     saldoMember = saldoMember + int.tryParse(dataContent[0]["point"]);
//                     await dbClient.rawQuery("update tabel_account set saldo = '"+saldoMember.toString()+"'");
                    
//                   })();
//                   Flushbar(
//                     flushbarPosition: FlushbarPosition.TOP, //Immutable
//                     reverseAnimationCurve: Curves.decelerate, //Immutable
//                     forwardAnimationCurve: Curves.elasticOut, //Immutable
                    
//                   )
//                     ..title = "Sukses"
//                     ..message = "Absen Harian Berhasil di lakukan, anda mendapatkan "+dataContent[0]["point"]+" Point"
//                     ..duration = Duration(seconds: 3)
//                     ..backgroundColor = Colors.red
//                     ..backgroundColor = Colors.red
//                     ..shadowColor = Colors.blue[800]
//                     ..isDismissible = true
//                     ..backgroundGradient = new LinearGradient(colors: [Colors.blue,Colors.black])
//                     ..icon = Icon(
//                       Icons.error,
//                       color: Colors.greenAccent,
//                     )
//                     ..linearProgressIndicator = LinearProgressIndicator(
//                       backgroundColor: Colors.blueGrey,
//                     )
//                     ..show(context);
//                      interstitialAdAbsen = buildInterstitialAbsen(dataContent[0]["ad_unit"])..load();

//                     setState((){
//                     });

//                 }else{
//                   Flushbar(
//                     flushbarPosition: FlushbarPosition.TOP, //Immutable
//                     reverseAnimationCurve: Curves.decelerate, //Immutable
//                     forwardAnimationCurve: Curves.elasticOut, //Immutable
                    
//                   )
//                     ..title = "Error"
//                     ..message = err
//                     ..duration = Duration(seconds: 3)
//                     ..backgroundColor = Colors.red
//                     ..backgroundColor = Colors.red
//                     ..shadowColor = Colors.blue[800]
//                     ..isDismissible = true
//                     ..backgroundGradient = new LinearGradient(colors: [Colors.blue,Colors.black])
//                     ..icon = Icon(
//                       Icons.error,
//                       color: Colors.greenAccent,
//                     )
//                     ..linearProgressIndicator = LinearProgressIndicator(
//                       backgroundColor: Colors.blueGrey,
//                     )
//                     ..show(context);
//                 }                

//                 });
//      }
//      void sendLogRequest(adsName){
       
//        var dataPost = {
//                    "email":emailMember, 
//                    "adsName":adsName, 
//              };
//         setState(() {
//                       showLoading =true;
//                       backButton =false;
//               });

//         http.post(widget.configClass.requestAds(), body: dataPost).then((response) {

//         var extractdata = JSON.decode(response.body);
//         List dataResult;
//         List dataContent;
//         String err,cek;
//         dataResult = extractdata["result"];
//         err = dataResult[0]["err"];
//         cek = dataResult[0]["cek"];
//         dataContent = dataResult[0]["content"];
//         print("ADS NAME  "+response.body);
//           if(err == ""){
//             publicAdsName = adsName;
//             if(adsName == "VIDEO I"){
//              loadVideoAds(dataContent[0]["ads_unit"]);
//             }else if(adsName == "VIDEO II"){
//               loadVideoAds2(dataContent[0]["ads_unit"]);
//             }else if(adsName == "VIDEO III"){
//               loadVideoAds3(dataContent[0]["ads_unit"]);
//             }else if(adsName == "LUCKY POINT"){
//               luckyPointAds(dataContent[0]["ads_unit"]);
//             }
//           }else{
//             setState(() {
//                       showLoading =false;
//                       backButton =true;
//             });
//             Flushbar(
//               flushbarPosition: FlushbarPosition.TOP, //Immutable
//               reverseAnimationCurve: Curves.decelerate, //Immutable
//               forwardAnimationCurve: Curves.elasticOut, //Immutable
              
//             )
//               ..title = "Warning"
//               ..message = err
//               ..duration = Duration(seconds: 3)
//               ..backgroundColor = Colors.red
//               ..backgroundColor = Colors.red
//               ..shadowColor = Colors.blue[800]
//               ..isDismissible = true
//               ..backgroundGradient = new LinearGradient(colors: [Colors.blue,Colors.black])
//               ..icon = Icon(
//                 Icons.error,
//                 color: Colors.greenAccent,
//               )
//               ..linearProgressIndicator = LinearProgressIndicator(
//                 backgroundColor: Colors.blueGrey,
//               )
//               ..show(context);
//           }                

//         });
//      }
//      Widget actionMenuCard() => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Card(
//           elevation: 2.0,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
                      
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.film,
//                           label: "Video",
//                           circleColor: Colors.orange,
//                           onPressed: () {
//                             sendLogRequest("VIDEO I");
                            
//                           },
//                         ),
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.film,
//                           label: "Video II",
//                           circleColor: Colors.blue,
//                           onPressed: () {
//                             sendLogRequest("VIDEO II");
//                           },
//                         ),
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.film,
//                           label: "Video III",
//                           circleColor: Colors.red,
//                           onPressed: () {
//                             sendLogRequest("VIDEO III");
//                           },
//                         ),
                        
//                       ],
//                     )
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.male,
//                           label: "Absen",
//                           circleColor: Colors.brown,
//                           onPressed: () {
//                             doAbsenHarian();
//                           },
//                         ),
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.random,
//                           label: "Lucky Point",
//                           circleColor: Colors.blue,
//                           onPressed: (){
//                             sendLogRequest("LUCKY POINT");
//                           },
//                         ),
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.gamepad,
//                           label: "Games",
//                           circleColor: Colors.green,
//                           onPressed: () {
//                             Navigator.of(context).pushNamed(UIData.gameRoute);
//                           },
//                         ),
//                       ],
//                     )
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         LabelBelowIcon(
//                           icon:  FontAwesomeIcons.mailchimp,
//                           label: "SMS Sender",
//                           circleColor: Colors.blue,
//                           onPressed: (){
//                             // setState(() {
//                             //  showLoading =true;
//                             //  backButton =false;
//                             // });
//                           },
//                         ),
//                       ],
//                     )
//                   ),
//                   // Row(
//                   //   mainAxisSize: MainAxisSize.max,
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   crossAxisAlignment: CrossAxisAlignment.center,
//                   //   children: <Widget>[
//                   //     SizedBox.fromSize(
//                   //       size: Size.square(deviceSize.width / 2.3),
//                   //       child: Card(
//                   //         color: Colors.grey.shade300,
//                   //         child: LabelBelowIcon(
//                   //           betweenHeight: 15.0,
//                   //           icon: FontAwesomeIcons.locationArrow,
//                   //           label: "firstLabel",
//                   //           iconColor: Colors.indigo.shade800,
//                   //           isCircleEnabled: false,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //     SizedBox.fromSize(
//                   //       size: Size.square(deviceSize.width / 2.3),
//                   //       child: Card(
//                   //         color: Colors.grey.shade300,
//                   //         child: LabelBelowIcon(
//                   //           betweenHeight: 15.0,
//                   //           icon: FontAwesomeIcons.locationArrow,
//                   //           label: "firstLabel 2",
//                   //           iconColor: Colors.indigo.shade800,
//                   //           isCircleEnabled: false,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );

//   Widget balanceCard() => Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Card(
//           elevation: 2.0,
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "Point",
//                       style: TextStyle(fontFamily: UIData.ralewayFont),
//                     ),
                    
//                   ],
//                 ),
//                 Text(
                  
//                   "₹ "+saldoMember.toString(),
//                   style: TextStyle(
//                       fontFamily: UIData.ralewayFont,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.green,
//                       fontSize: 25.0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     // Widget allCards(BuildContext context) => SingleChildScrollView(
      
//     //   child: Column(
//     //     children: <Widget>[
//     //       appBarColumn(context),
//     //       SizedBox(
//     //         height: deviceSize.height * 0.01,
//     //       ),
//     //       SizedBox(
//     //         height: deviceSize.height * 0.01,
//     //       ),
//     //       actionMenuCard(),
//     //       SizedBox(
//     //         height: deviceSize.height * 0.01,
//     //       ),
//     //       balanceCard(),
//     //     ],
//     //   ),
//     // );
//     List<Widget> allCards(BuildContext context) {
//       // <Widget>[
//       //             
//       //             allCards,
//       //           ],
//     var appBar = LoginBackground(
//                     showIcon: false,
//                   );
//     SingleChildScrollView form = new SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           appBarColumn(context),
//           SizedBox(
//             height: deviceSize.height * 0.01,
//           ),
//           SizedBox(
//             height: deviceSize.height * 0.01,
//           ),
//           actionMenuCard(),
//           SizedBox(
//             height: deviceSize.height * 0.01,
//           ),
//           balanceCard(),
//         ],
//       ),
//     );

//     var l = new List<Widget>();
//     l.add(appBar);
//     l.add(form);

//     if (showLoading) {
//       var modal = new Stack(
//         children: [
//           new Opacity(
//             opacity: 0.3,
//             child: const ModalBarrier(dismissible: false, color: Colors.grey),
//           ),
//           new Center(
//             child: new CircularProgressIndicator(),
//           ),
//         ],
//       );
//       l.add(modal);
//     }

//     return l;
//   }
//     Future<bool> _onWillPop() {

//       if(backButton == true){
//         bannerAd?.dispose();
//         interstitialAd?.dispose();
//        Navigator.of(context).pop(true);
//       }
//     // return showDialog(
//     //   context: context,
//     //   builder: (context) => new AlertDialog(
//     //     title: new Text('Are you sure?'),
//     //     content: new Text('Do you want to exit an App'),
//     //     actions: <Widget>[
//     //       new FlatButton(
//     //         onPressed: () => Navigator.of(context).pop(false),
//     //         child: new Text('No'),
//     //       ),
//     //       new FlatButton(
//     //         onPressed: () => Navigator.of(context).pop(true),
//     //         child: new Text('Yes'),
//     //       ),
//     //     ],
//     //   ),
//     // ) ?? false;

//   }


//     bannerAd.show();
//     return new WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         body:  Stack(
//                 fit: StackFit.expand,
//                 children: allCards(context)
//               )
//       ),
//     );
//   }
// }