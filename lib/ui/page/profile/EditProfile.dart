import 'package:flutter/material.dart';
import 'package:bpulsa/model/login.dart';
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'package:bpulsa/database/model/account.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:bpulsa/ui/page/home_page.dart';
import 'dart:async';
ConfigClass configClass = new ConfigClass();
class EditProfile extends StatefulWidget {
  @override
   EditProfileState createState() => new EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  Size deviceSize;
  String email,password,passwordConfirm,nama,nomorTelepon = "";
  String oldEmail ;
  ConfigClass configClass = new ConfigClass();
  var databaseHelper = new  DatabaseHelper() ;
  bool backButton = true;
  bool showLoading = false;

  void getDataAccount() async{
    var dbClient = await databaseHelper.db;
        List<Map> list = await dbClient.rawQuery('SELECT * FROM tabel_account');
        email = list[0]["email"];
        nama = list[0]["nama"];
        oldEmail = list[0]["email"];
        password = list[0]["password"];
        passwordConfirm = list[0]["password"];
        nomorTelepon = list[0]["nomor_telepon"]; 
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
  Future<bool> _onWillPop() {
    if(backButton == true){
      Navigator.of(context).pop(true);
    }
  }
  List<Widget> formRender(BuildContext context) {
    
    SingleChildScrollView form = new SingleChildScrollView(
      child: Column(
        children: <Widget>[
           new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              onChanged: (String text) {
                email = text;
              },
              controller: TextEditingController(
                text: email
              ),
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
          ),
           new ListTile(
            leading: const Icon(Icons.security),
            title: new TextField(
              onChanged: (String text) {
                password = text;
              },
              controller: TextEditingController(
                text: password
              ),
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
          ),
           new ListTile(
            leading: const Icon(Icons.security),
            title: new TextField(
              onChanged: (String text) {
                passwordConfirm = text;
              },
              controller: TextEditingController(
                text: passwordConfirm
              ),
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: new TextField(
              onChanged: (String text) {
                nama = text;
              },
              controller: TextEditingController(
                text: nama
              ),
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.phone),
            title: new TextField(
              onChanged: (String text) {
                nomorTelepon = text;
              },
              controller: TextEditingController(
                text: nomorTelepon
              ),
              keyboardType: TextInputType.phone,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
            ),
          ),
        ],
      ),
    );

    var l = new List<Widget>();
    l.add(form);

    if (showLoading) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      l.add(modal);
    }

    return l;
  }
  @override
  Widget build(BuildContext context) { 
    deviceSize = MediaQuery.of(context).size;
      return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text("Edit Profile"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: () {
            if(email!="" && password != "" && passwordConfirm != "" && nama != "" && nomorTelepon != ""){
              if(password != passwordConfirm ){
                AlertDialog dialog = new AlertDialog(
                      content: new Text("Confirm Password Tidak Sama ")
                    );
                showDialog(context : context, child: dialog);
              }else{
                setState(() {
                      showLoading =true;
                      backButton =false;
                 });
                var dataPost = {
                  "email":email, 
                  "password": passwordConfirm,
                  "nama": nama,
                  "nomorTelepon": nomorTelepon,
                  "oldEmail": oldEmail,
                  };
                http.post(configClass.editProfile(), body: dataPost).then((response) {
                    setState(() {
                      showLoading =false;
                      backButton =true;
                    });
                    final jsonResponse = json.decode(response.body.toString());
                    String loginResponse ;
                    Resp resp = new Resp.fromJson(jsonResponse);
                    if(resp.result.err == ''){
                      var db = new DatabaseHelper();
                     
                      var dataAccount = new Account(
                        email,
                        password,
                        resp.result.content.nama,
                        resp.result.content.nomor_telepon,
                        int.tryParse(resp.result.content.saldo),
                        1,
                      );
                      db.updateAccount(dataAccount);
                      AlertDialog dialog = new AlertDialog(
                        content: new Text("Update Profile Success")
                      );
                      showDialog(context: context,child: dialog);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      
                    }else{
                      loginResponse = resp.result.err;
                      AlertDialog dialog = new AlertDialog(
                        content: new Text(loginResponse)
                      );
                      showDialog(context: context,child: dialog);
                    }

                  });
              }
            }else{
              AlertDialog dialog = new AlertDialog(
                content: new Text("Semua Kolom Harus Di Isi")
              );
              showDialog(context: context,child: dialog);
            }
            

          })
        ],
      ),
      body:  Stack(
                fit: StackFit.expand,
                children: formRender(context)
              )
      ),
    );
    
  }
}
