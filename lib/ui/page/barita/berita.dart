import 'dart:async';

import 'package:bpulsa/ui/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:bpulsa/model/berita.dart';
import 'package:bpulsa/ui/page/barita/DetailBerita.dart';
import 'package:bpulsa/ui/widgets/common_scaffold.dart';
import 'package:bpulsa/config.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:http/http.dart' as http;
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
class Berita extends StatefulWidget {
  

  @override
  BeritaState createState() {
    return new BeritaState();
  }
}

class BeritaState extends State<Berita> {
    final scaffoldKey = GlobalKey<ScaffoldState>();
  String email,password,passwordConfirm,nama,nomorTelepon = "";
  int limitFrom = 0;
  int limitTo = 10;
  String oldEmail ;
  int saldoMember;
  ConfigClass configClass = new ConfigClass();
  var databaseHelper = new  DatabaseHelper() ;

  
  List<int> items = List.generate(10, (i) => i);
  List<BeritaModel> kolom = [];
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  BannerAd bannerAd;
  BannerAd buildBanner() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  @override
  void initState() {
    super.initState();
    bannerAd = buildBanner()..load();

    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    bannerAd?.dispose();
    super.dispose();
  }

  _getMoreData() async {
         if (!isPerformingRequest) {
            setState(() => isPerformingRequest = true);
            List<int> newEntries = await fakeRequest(
                items.length, items.length + 10); //returns empty list
                if (newEntries.isEmpty) {
                  double edge = 200.0;
                  double offsetFromBottom = _scrollController.position.maxScrollExtent -
                      _scrollController.position.pixels;
                  if (offsetFromBottom < edge) {
                      _scrollController.animateTo(
                        _scrollController.offset - (edge - offsetFromBottom),
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut
                      );
                  }
                }
            setState(() {
              items.addAll(newEntries);
              isPerformingRequest = false;
            });
          }
         
   
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(1.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// from - inclusive, to - exclusive
  Future<List<int>> fakeRequest(int from, int to) async {
    await http.post(configClass.daftarBerita(), body: {"from" : limitFrom.toString(),"to":limitTo.toString()}).then((response) {
            List dataResult;
            List dataContent;
            var extractdata = json.decode(response.body);
            dataResult = extractdata["result"];
            if(dataResult[0]['err'] == ''){
              dataContent = dataResult[0]["content"];
              for (var i = 0; i < dataContent.length; i++) {
                kolom.add( 
                    BeritaModel(
                            idBerita: dataContent[i]['id'],
                            judulBerita: dataContent[i]['title'],
                            message: dataContent[i]['content'],
                            messageImage: dataContent[i]['gambar'],
                            postTime: dataContent[i]['tanggal'],
                        )
                  );     
              }
              limitFrom = limitFrom + dataContent.length ;
            }
            // print(response.body);
        
      });
      return List.generate(to - from, (i) => i + from);
  }


  Widget bodyData(context) {
    return  ListView.builder(
        itemCount: kolom.length,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Card(
                    elevation: 2.0, 
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                            new Flexible(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    kolom[index].judulBerita,   
                                  )
                                ],
                              ),
                            ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            kolom[index].message,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: UIData.ralewayFont),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              print("onTap called.");
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new DetailBerita(kolom[index].idBerita),
                                ));
                            },
                            child: Text(
                              "[ READ MODE ]",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue,
                                  fontFamily: UIData.ralewayFont),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        kolom[index].messageImage != null
                            ? Image.network(
                                kolom[index].messageImage,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        kolom[index].messageImage != null ? Container() : CommonDivider(),
                      ],
                    ),
                  ),
                );
          }
        },
        controller: _scrollController,
      );
  }

  @override
  Widget build(BuildContext context) {
    bannerAd.show();

    return CommonScaffold(
      scaffoldKey: scaffoldKey,
      appTitle: "News",
      showDrawer: false,
      showFAB: false,
      actionFirstIcon: Icons.payment,
      bodyData: bodyData(context),
    );
  }
}

class DetailPage {
}
