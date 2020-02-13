import 'package:flutter/material.dart';
import 'package:bpulsa/ui/widgets/common_divider.dart';
import 'package:bpulsa/ui/widgets/common_scaffold.dart';
import 'package:bpulsa/ui/widgets/profile_tile.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'package:bpulsa/config.dart';
import 'package:bpulsa/utils/uidata.dart';

class Profile extends StatefulWidget {
  BuildContext context;
  @override
  ProfileState createState() {
    return new ProfileState();
  }
}

class ProfileState extends State<Profile> {
  Size deviceSize;
  String emailMember,namaMember,teleponMember,referalEmail;
  int saldoMember;
  String jumlahPenukaran = "0";
  String jumlahAbsen = "0";
  ConfigClass configClass = new ConfigClass();
  var databaseHelper = new  DatabaseHelper() ;

  void getDataAccount() async{
    var dbClient = await databaseHelper.db;
        List<Map> list = await dbClient.rawQuery('SELECT * FROM tabel_account');
        namaMember = list[0]["nama"];
        emailMember = list[0]["email"];
        saldoMember = list[0]["saldo"];
        teleponMember = list[0]["nomor_telepon"];
        getLogUser();
  }

  void getLogUser()  {
     http.post(configClass.getLogUser(), body: {"email" : emailMember}).then((response) {
          print(response.body);
          var extractdata = json.decode(response.body);
          List dataResult;
          List dataContent;
          String err,cek;
          dataResult = extractdata["result"];
          err = dataResult[0]["err"];
          cek = dataResult[0]["cek"];
          dataContent = dataResult[0]["content"];
          setState(() {
             jumlahPenukaran = dataContent[0]["penukaran"];
             jumlahAbsen = dataContent[0]["absen"];
             referalEmail = dataContent[0]["referalEmail"];
           });
      
         
        });

  }
  @override
  void initState() {
    super.initState();
    (() async {
         await getDataAccount();
        setState(() {
        });
    })();
  
  }
  @override
  void didChangeDependencies() {
        (() async {
         await getDataAccount();
        setState(() {
                  
        });
    })();
    super.didChangeDependencies();
    
  }

   //Column1
  Widget profileColumn() => Container(
        height: deviceSize.height * 0.24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfileTile(
              title: namaMember,
              subtitle: emailMember,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.chat),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                    border: new Border.all(
                      color: Colors.black,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/logo.png"),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.black,
                    radius: 40.0,
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.call),
                //   color: Colors.black,
                //   onPressed: () {},
                // ),
              ],
            )
          ],
        ),
      );

  //column2

  //column3
  Widget descColumn() => Container(
        height: deviceSize.height * 0.13,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              "BPulsa mobile aplication is free app for you. This app like the minner point apps other. Give you prize arround your point",
              style: TextStyle(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 3,
              softWrap: true,
            ),
          ),
        ),
      );
  //column4
  Widget accountColumn() => Container(
        height: deviceSize.height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Website",
                  subtitle: "rm-rf.studio",
                ),
                ProfileTile(
                  title: "Phone",
                  subtitle: "+6281223744803",
                ),
                ProfileTile(
                  title: "YouTube",
                  subtitle: "youtube.com/vulnwalker",
                ),
              ],
            ),
           
          ],
        ),
      );

  Widget bodyData() { 
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          profileColumn(),
          CommonDivider(),
          followColumn(deviceSize),
          CommonDivider(),
          infoColumn(deviceSize),
          CommonDivider(),
          descColumn(),
          CommonDivider(),
          // accountColumn()
        ],
      ),
    );
  }

  Widget _scaffold() => CommonScaffold(
        appTitle: "Profile",
        bodyData: bodyData(),
        showFAB: true,
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
  Widget followColumn(Size deviceSize) => Container(
      height: deviceSize.height * 0.13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ProfileTile(
            title: "Telepon",
            subtitle: teleponMember.toString(),
          ),
          ProfileTile(
            title: "Penukaran",
            subtitle: jumlahPenukaran.toString(),
          ),
          ProfileTile(
            title: "Absen",
            subtitle: jumlahAbsen,
          ),
       
        ],
      ),
    );
  Widget infoColumn(Size deviceSize) => Container(
      height: deviceSize.height * 0.13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ProfileTile(
            title: "Point",
            subtitle: saldoMember.toString(),
          ),
          ProfileTile(
            title: "Referal",
            subtitle: referalEmail.toString(),
          ),

       
        ],
      ),
    );

  @override
  Widget build(BuildContext context) {
    // getDataAccount();
    deviceSize = MediaQuery.of(context).size;
    return _scaffold();
  }

}

