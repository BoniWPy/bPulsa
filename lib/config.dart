import 'package:progress_hud/progress_hud.dart';
import 'package:flutter/material.dart';
class ConfigClass {
  String app_name = "BPulsa New";
  String hostName ;
  
  String getHostName(){
    this.hostName = "http://bpulsa.rm-rf.studio/";
    return this.hostName;
  }
  String auth(){
    return getHostName()+"auth";
  }
  String syncData(){
    return getHostName()+"member/sync";
  }
  String getLogUser(){
    return getHostName()+"member/log";
  }
  String register(){
    return getHostName()+"member/add";
  }
  String editProfile(){
    return getHostName()+"member/update";
  }
  String gainedPoint(){
    return getHostName()+"member/gained_point";
  }
  String daftarTukarPoint(){
    return getHostName()+"daftar/point";
  }
  String daftarPayment(){
    return getHostName()+"daftar/payment";
  }
  String daftarBerita(){
    return getHostName()+"daftar/news";
  }
  String getDetailBerita(){
    return getHostName()+"berita/detail";
  }
  String absenHarian(){
    return getHostName()+"task/absen";
  }
  String requestAds(){
    return getHostName()+"ads";
  }
  String gameReward(){
    return getHostName()+"task/game";
  }
  String getReward(){
    return getHostName()+"ads/reward";
  }
  String tradePoint(){
    return getHostName()+"point/trade";
  }
  var loadingScreen = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
  );
  void showLoading(context){
    showDialog(
              context: context,
              child: this.loadingScreen
    );
  }
  void closeLoading(context){
      Navigator.pop(context);
  }




  // static Database databaseHelper;
  // Future<Database> get db async {
  //   if (databaseHelper != null) return databaseHelper;
  //   databaseHelper = await initDb();
  //   return databaseHelper;
  // }
  // initDb() async {
  //   io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "test.db");
  //   var theDb = await openDatabase(path, version: 1, onCreate: databaseSetup);
  //   return theDb;
  // }
  // void databaseSetup(Database db, int version) async{
  //   // When creating the db, create the table
  //   await db.execute("CREATE TABLE account (email text,nama text,saldo int(11),status int(11))");
  //   print("Created tables");
  // }
  // void sqlQuery(String query){
  //    databaseHelper.execute(query);
  // }


}