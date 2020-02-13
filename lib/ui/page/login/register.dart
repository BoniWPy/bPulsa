import 'package:flutter/material.dart';
import 'package:bpulsa/model/login.dart';
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'package:bpulsa/database/model/account.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'dart:async';
ConfigClass configClass = new ConfigClass();
class Register extends StatefulWidget {
  @override
   RegisterState createState() => new RegisterState();
}

class RegisterState extends State<Register> {
  String email,password,passwordConfirm,nama,nomorTelepon,referalEmail = "";
  Size deviceSize;
  bool backButton = true;
  bool showLoading = false;


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
              keyboardType: TextInputType.phone,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.email),
            title: new TextField(
              onChanged: (String text) {
                referalEmail = text;
              },
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Referal Email',
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
        title: new Text("Register"),
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
                  "referalEmail": referalEmail,
                  };
                http.post(configClass.register(), body: dataPost).then((response) {
                    setState(() {
                      showLoading =false;
                      backButton =true;
                    });
                    final jsonResponse = json.decode(response.body.toString());
                    String loginResponse ;
                    Resp resp = new Resp.fromJson(jsonResponse);
                    print("Welcome "+ resp.result.content.nama.toString());
                    if(resp.result.err == ''){
                      var db = new DatabaseHelper();
                      var dataAccount = new Account(
                        email,
                        password,
                        resp.result.content.nama,
                        resp.result.content.nomor_telepon,
                        0,
                        1,
                      );
                      db.saveAccount(dataAccount);
                      AlertDialog dialog = new AlertDialog(
                        content: new Text("Register Success")
                      );
                      showDialog(context: context,child: dialog);
                      Navigator.of(context).pushReplacementNamed(UIData.homeRoute);

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
