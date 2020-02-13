// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:async';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:bpulsa/database/DatabaseHelper.dart';
// import 'package:bpulsa/config.dart';
// import 'package:bpulsa/utils/uidata.dart';

// import 'package:bpulsa/ui/widgets/common_scaffold.dart';

// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flushbar/flushbar.dart';


// const APP_ID = "<Put in your Device ID>";

// enum TileState { covered, blown, open, flagged, revealed }


// class Game extends StatefulWidget {
//   @override
//   GameState createState() {
//     return new GameState();
//   }
// }

// class GameState extends State<Game> {
//  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     testDevices: APP_ID != null ? [APP_ID] : null,
//     keywords: ['Games', 'Puzzles'],
//   );
//   int yourTap = 0;
//   String emailMember,namaMember;
//   int saldoMember;
//   String publicAdsName;
//   BannerAd bannerAd;
//   InterstitialAd interstitialAd;
//   RewardedVideoAd rewardedVideoAd;
//   bool backButton = true;
//   bool showLoading = false;
//   ConfigClass configClass = new ConfigClass();

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
    
//   void loadVideoAds(adsUnit) {
//     RewardedVideoAd.instance.load(
//       adUnitId: RewardedVideoAd.testAdUnitId,
//       targetingInfo: targetingInfo,
//     );
//   }

//   InterstitialAd buildInterstitial(adUnit) {
//     return InterstitialAd(
//         adUnitId: InterstitialAd.testAdUnitId,
//         targetingInfo: targetingInfo,
//         listener: (MobileAdEvent event) {
//           if (event == MobileAdEvent.failedToLoad) {
//             interstitialAd..load();
//           } else if (event == MobileAdEvent.closed) {
//             // interstitialAd = buildInterstitial()..load();
//           }else if (event == MobileAdEvent.loaded) {
//             var dataPost = {
//                       "email":emailMember, 
//                       "adsName":publicAdsName, 
//                 };
//             http.post(configClass.getReward(), body: dataPost).then((response) {
//               // var extractdata = JSON.decode(response.body);
//               // List dataResult;
//               // List dataContent;
//               // String err,cek;
//               // dataResult = extractdata["result"];
//               // err = dataResult[0]["err"];
//               // cek = dataResult[0]["cek"];
//               // dataContent = dataResult[0]["content"];
//             });
//             interstitialAd.show();
//           }
//           print(event);
//         });
//   }
//   void postReward(adsName){
//        var dataPost = {
//                    "email":emailMember, 
//                    "adsName":adsName, 
//              };
//         setState(() {
//                       showLoading =true;
//                       backButton =false;
//               });

//         http.post(configClass.requestAds(), body: dataPost).then((response) {

//         var extractdata = json.decode(response.body);
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
//             if(adsName == "GAME WIN"){
//              loadVideoAds(dataContent[0]["ads_unit"]);
//             }else{
//              interstitialAd = buildInterstitial(dataContent[0]["ads_unit"])..load();
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
//             );
//               ..title = "Game Over"
//               ..message = "Bonus belum tersedia. Silahkan coba beberapa saat lagi"
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

//   final int rows = 12;
//   final int cols = 9;
//   final int numOfMines = 10;

//   List<List<TileState>> uiState;
//   List<List<bool>> tiles;

//   bool alive;
//   bool wonGame;
//   int minesFound;
//   Timer timer;
//   Stopwatch stopwatch = Stopwatch();

//   @override
//   void dispose() {
//     timer?.cancel();
//     bannerAd?.dispose();
//     interstitialAd?.dispose();
//     super.dispose();
//   }

//   void resetBoard() {
//     yourTap = 0;
//     alive = true;
//     wonGame = false;
//     minesFound = 0;
//     stopwatch.reset();

//     timer?.cancel();
//     timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {});
//     });

//     uiState = new List<List<TileState>>.generate(rows, (row) {
//       return new List<TileState>.filled(cols, TileState.covered);
//     });

//     tiles = new List<List<bool>>.generate(rows, (row) {
//       return new List<bool>.filled(cols, false);
//     });

//     Random random = Random();
//     int remainingMines = numOfMines;
//     while (remainingMines > 0) {
//       int pos = random.nextInt(rows * cols);
//       int row = pos ~/ rows;
//       int col = pos % cols;
//       if (!tiles[row][col]) {
//         tiles[row][col] = true;
//         remainingMines--;
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     (() async {
//       var asu = await getDataAccount();
//       setState(() {
//       });
//     })();
//     resetBoard();

//     FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//     bannerAd = buildBanner()..load();
//     RewardedVideoAd.instance.listener =
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
//         http.post(configClass.getReward(), body: dataPost).then((response) {
//           var extractdata = json.decode(response.body);
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
//           Flushbar(
//               flushbarPosition: FlushbarPosition.TOP, //Immutable
//               reverseAnimationCurve: Curves.decelerate, //Immutable
//               forwardAnimationCurve: Curves.elasticOut, //Immutable
//             )
//               ..title = "Game Over"
//               ..message = "Anda mendapatkan point "+dataContent[0]["point"]
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
//           setState(() {
//           });
//         });
//       }

//     };
//   }

//   Widget buildBoard() {
//     bool hasCoveredCell = false;
//     List<Row> boardRow = <Row>[];
//     for (int y = 0; y < rows; y++) {
//       List<Widget> rowChildren = <Widget>[];
//       for (int x = 0; x < cols; x++) {
//         TileState state = uiState[y][x];
//         int count = mineCount(x, y);

//         if (!alive) {
//           if (state != TileState.blown)
//             state = tiles[y][x] ? TileState.revealed : state;
//         }

//         if (state == TileState.covered || state == TileState.flagged) {
//           rowChildren.add(GestureDetector(
//             onLongPress: () {
//               flag(x, y);
//             },
//             onTap: () {
//               if (state == TileState.covered) probe(x, y);
//             },
//             child: Listener(
//                 child: CoveredMineTile(
//               flagged: state == TileState.flagged,
//               posX: x,
//               posY: y,
//             )),
//           ));
//           if (state == TileState.covered) {
//             hasCoveredCell = true;
//           }
//         } else {
//           rowChildren.add(OpenMineTile(
//             state: state,
//             count: count,
//           ));
//         }
//       }
//       boardRow.add(Row(
//         children: rowChildren,
//         mainAxisAlignment: MainAxisAlignment.center,
//         key: ValueKey<int>(y),
//       ));
//     }
//     if (!hasCoveredCell) {
//       if ((minesFound == numOfMines) && alive) {
//         wonGame = true;
//         stopwatch.stop();
//       }
//     }
//     int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;

//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         children: <Widget>[
//           Column(
//            children: boardRow,
//          ),
//          Column(children: <Widget>[
//               FlatButton(
//                 child: Text(
//                   'Reset Board',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   resetBoard();

//                   // interstitialAd
//                   //   ..load()
//                   //   ..show();
//                 },
//                 highlightColor: Colors.green,
//                 splashColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                     color: Colors.blue[200],
//                   ),
//                 ),
//                 color: Colors.blueAccent[100],
//               ),
//               Container(
//                 height: 40.0,
//                 alignment: Alignment.center,
//                 child: RichText(
//                   text: TextSpan(
//                       text: wonGame
//                           ? "You've Won! $timeElapsed seconds"
//                           : alive
//                               ? "[Mines Found: $minesFound] [Total Mines: $numOfMines] [$timeElapsed seconds]"
//                               : "You've Lost! $timeElapsed seconds"),
//                 ),
//               ),
//             ]),
//         ],
//       )
//     );
//   }

//   Widget _scaffold() => CommonScaffold(
//         appTitle: "Game",
//         bodyData: Center(
//           child: buildBoard(),
//         ),
//         showFAB: false,
//         // showDrawer: true,
//         // floatingIcon: Icons.edit,
//         // eventFloatButton: (){
//         //   // AlertDialog dialog = new AlertDialog(
//         //   //               content: new Text("Reload Activity")
//         //   //             );
//         //   // showDialog(context: context,child: dialog);
//         //   Navigator.of(context).pushNamed(UIData.editProfileRoute);
//         // },
//       );
//   @override
//   Widget build(BuildContext context) {
//     bannerAd..show();
//     return _scaffold();
 
//   }

//   void probe(int x, int y) {
//     if (!alive) return;
//     if (uiState[y][x] == TileState.flagged) return;
//     setState(() {
//       if (tiles[y][x]) {
//         uiState[y][x] = TileState.blown;
//         alive = false;
//         timer.cancel();
//         stopwatch.stop(); // force the stopwatch to stop.
//          Flushbar(
//               flushbarPosition: FlushbarPosition.TOP, //Immutable
//               reverseAnimationCurve: Curves.decelerate, //Immutable
//               forwardAnimationCurve: Curves.elasticOut, //Immutable
//             )
//               ..title = "Game Over"
//               ..message = "Your tap "+yourTap.toString()
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
//         if(yourTap >= 10){
//           postReward("GAME WIN");
//         }else{
//           postReward("GAME LOSE");
//         }
//       } else {
//         open(x, y);
//         yourTap = yourTap + 1;
//         if (!stopwatch.isRunning) stopwatch.start();
//       }
//     });
//   }

//   void open(int x, int y) {
//     if (!inBoard(x, y)) return;
//     if (uiState[y][x] == TileState.open) return;
//     uiState[y][x] = TileState.open;

//     if (mineCount(x, y) > 0) return;

//     open(x - 1, y);
//     open(x + 1, y);
//     open(x, y - 1);
//     open(x, y + 1);
//     open(x - 1, y - 1);
//     open(x + 1, y + 1);
//     open(x + 1, y - 1);
//     open(x - 1, y + 1);
//   }

//   void flag(int x, int y) {
//     if (!alive) return;
//     setState(() {
//       if (uiState[y][x] == TileState.flagged) {
//         uiState[y][x] = TileState.covered;
//         --minesFound;
//       } else {
//         uiState[y][x] = TileState.flagged;
//         ++minesFound;
//       }
//     });
//   }

//   int mineCount(int x, int y) {
//     int count = 0;
//     count += bombs(x - 1, y);
//     count += bombs(x + 1, y);
//     count += bombs(x, y - 1);
//     count += bombs(x, y + 1);
//     count += bombs(x - 1, y - 1);
//     count += bombs(x + 1, y + 1);
//     count += bombs(x + 1, y - 1);
//     count += bombs(x - 1, y + 1);
//     return count;
//   }

//   int bombs(int x, int y) => inBoard(x, y) && tiles[y][x] ? 1 : 0;
//   bool inBoard(int x, int y) => x >= 0 && x < cols && y >= 0 && y < rows;
// }

// Widget buildTile(Widget child) {
//   return Container(
//     padding: EdgeInsets.all(1.0),
//     height: 30.0,
//     width: 30.0,
//     color: Colors.grey[400],
//     margin: EdgeInsets.all(2.0),
//     child: child,
//   );
// }

// Widget buildInnerTile(Widget child) {
//   return Container(
//     padding: EdgeInsets.all(1.0),
//     margin: EdgeInsets.all(2.0),
//     height: 20.0,
//     width: 20.0,
//     child: child,
//   );
// }

// class CoveredMineTile extends StatelessWidget {
//   final bool flagged;
//   final int posX;
//   final int posY;

//   CoveredMineTile({this.flagged, this.posX, this.posY});

//   @override
//   Widget build(BuildContext context) {
//     Widget text;
//     if (flagged) {
//       text = buildInnerTile(RichText(
//         text: TextSpan(
//           text: "\u2691",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textAlign: TextAlign.center,
//       ));
//     }
//     Widget innerTile = Container(
//       padding: EdgeInsets.all(1.0),
//       margin: EdgeInsets.all(2.0),
//       height: 20.0,
//       width: 20.0,
//       color: Colors.grey[350],
//       child: text,
//     );

//     return buildTile(innerTile);
//   }
// }

// class OpenMineTile extends StatelessWidget {
//   final TileState state;
//   final int count;
//   OpenMineTile({this.state, this.count});

//   final List textColor = [
//     Colors.blue,
//     Colors.green,
//     Colors.red,
//     Colors.purple,
//     Colors.cyan,
//     Colors.amber,
//     Colors.brown,
//     Colors.black,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     Widget text;

//     if (state == TileState.open) {
//       if (count != 0) {
//         text = RichText(
//           text: TextSpan(
//             text: '$count',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: textColor[count - 1],
//             ),
//           ),
//           textAlign: TextAlign.center,
//         );
//       }
//     } else {
//       text = RichText(
//         text: TextSpan(
//           text: '\u2739',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//         textAlign: TextAlign.center,
//       );
//     }
//     return buildTile(buildInnerTile(text));
//   }
// }


