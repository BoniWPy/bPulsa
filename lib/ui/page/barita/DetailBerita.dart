import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bpulsa/model/login.dart';
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, base64, JSON;
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'package:bpulsa/database/model/account.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:bpulsa/ui/page/home_page.dart';
import 'dart:async';
import 'package:bpulsa/ui/widgets/profile_tile.dart';
import 'package:bpulsa/ui/widgets/common_divider.dart';
import 'package:bpulsa/ui/widgets/common_scaffold.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:firebase_admob/firebase_admob.dart';



ConfigClass configClass = new ConfigClass();
class DetailBerita extends StatefulWidget { 
 final String idBerita;

   DetailBerita(this.idBerita) ;
  @override
   DetailBeritaState createState() => new DetailBeritaState();
}

class DetailBeritaState extends State<DetailBerita> {
  Size deviceSize;
  String judulBerita,contentBeritaHTML;
  int saldoMember;
  String jumlahPenukaran = "0";
  String jumlahAbsen = "0";
  ConfigClass configClass = new ConfigClass();
  BannerAd bannerAd;
  BannerAd buildBanner() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }
  void getContentBerita()  {
     http.post(configClass.getDetailBerita(), body: {"idBerita" :widget.idBerita}).then((response) {
          var extractdata = json.decode(response.body);
          List dataResult;
          List dataContent;
          String err,cek;
          dataResult = extractdata["result"];
          err = dataResult[0]["err"];
          cek = dataResult[0]["cek"];
          dataContent = dataResult[0]["content"];
          judulBerita = dataContent[0]["judulBerita"];
          String baseHTML = dataContent[0]["contentBerita"].toString();
          contentBeritaHTML = utf8.decode(base64.decode(baseHTML));
          print("DECODE : " + contentBeritaHTML);
          setState(() {
            
            //  print(contentBeritaHTML+ " ASU");
           });
      
         
        });

  }
  @override
  void initState() {
    super.initState();
    (() async {
         bannerAd = buildBanner()..load();
         await getContentBerita();
        setState(() {
        });
    })();
  
  }
  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }


   //Column1
  Widget headerBerita() => Container(
        height: deviceSize.height * 0.10,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      judulBerita,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ],
                ),
              ),
           
          ],
        ),
      );

  //column2

  //column3
    String chtml = '<h1>This is heading 1</h1> <h2>This is heading 2</h2><h3>This is heading 3</h3><h4>This is heading 4</h4><h5>This is heading 5</h5><h6>This is heading 6</h6><p><img alt="Test Image" src="https://i.ytimg.com/vi/RHLknisJ-Sg/maxresdefault.jpg" /></p>';
  
  Widget contentBerita() => Container(
        height: deviceSize.height * 0.80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new SingleChildScrollView(
              child: new Center(
                child: new HtmlView(data: "<b><h3>$judulBerita</h3> </b>"+"\n"+contentBeritaHTML.toString()),
              ),
            ),
          ),
      );
  //column4


  Widget bodyData() { 
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // headerBerita(),
          // CommonDivider(),
          contentBerita(),

          // accountColumn()
        ],
      ),
    );
  }

  Widget _scaffold() => CommonScaffold(
        appTitle: "News",
        bodyData: bodyData(),
        showFAB: false,
        // showDrawer: true,
        floatingIcon: Icons.edit,
        eventFloatButton: (){
          // AlertDialog dialog = new AlertDialog(
          //               content: new Text("Reload Activity")
          //             );
          // showDialog(context: context,child: dialog);
          Navigator.of(context).pushNamed(UIData.editProfileRoute);
        },
      );



  @override
  Widget build(BuildContext context) {
    bannerAd.show();
    
    deviceSize = MediaQuery.of(context).size;
    return _scaffold();
  }

}
