import 'package:flutter/material.dart';
import 'package:bpulsa/model/login.dart';
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bpulsa/database/DatabaseHelper.dart';
import 'package:bpulsa/database/model/account.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:device_info/device_info.dart';
ConfigClass configClass = new ConfigClass();

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email,password = "";
  String deviceUniqueKey = "";
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  var databaseHelper = new  DatabaseHelper() ;
  void logoutProcess() async{
     databaseHelper.deleteAccount();


  }
  @override
  void initState() {
    super.initState();
    (() async {
        await logoutProcess();
        DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceUniqueKey =androidInfo.manufacturer+";"+androidInfo.model.toString()+";"+androidInfo.hardware.toString()+";"+androidInfo.id.toString()+";"+androidInfo.supported64BitAbis.toString()+";"+androidInfo.supported32BitAbis.toString()+";"+androidInfo.device.toString()+";"+androidInfo.type.toString()+";"+androidInfo.host.toString()+";"+androidInfo.fingerprint.toString();
        setState(() {
        });
    })();
  
  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: this._emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      style: new TextStyle(color: Colors.white),
      // initialValue: 'vulnwalker@tuyul.online',
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: new TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: new BorderSide(color: Colors.lightBlueAccent, style: BorderStyle.solid),
        ),
      ),
    );

    final password = TextFormField(
      controller: this._passController,
      autofocus: false,
      style: new TextStyle(color: Colors.white),
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: 'Password',
        hintStyle: new TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: new BorderSide(color: Colors.lightBlueAccent, style: BorderStyle.solid),
          
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: (){
             configClass.showLoading(context);
             http.post(configClass.auth(), body: {"email":_emailController.text, "password": _passController.text, "deviceCode": deviceUniqueKey}).then((response) {
                configClass.closeLoading(context);
                final jsonResponse = json.decode(response.body.toString());
                String loginResponse ;
                Resp resp = new Resp.fromJson(jsonResponse);
                if(resp.result.err == ''){
                  print("Welcome "+ resp.result.content.nama.toString());
                  var db = new DatabaseHelper();
                  var dataAccount = new Account(
                    _emailController.text,
                    _passController.text,
                    resp.result.content.nama,
                    resp.result.content.nomor_telepon,
                    int.tryParse(resp.result.content.saldo),
                    1,
                  );
                  db.saveAccount(dataAccount);
                  Navigator.of(context).pushReplacementNamed(UIData.homeRoute);

                }else{
                  loginResponse = resp.result.err;
                  AlertDialog dialog = new AlertDialog(
                    content: new Text(loginResponse)
                  );
                  showDialog(context: context,child: dialog);
                }

              });

          },
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final registerText = FlatButton(
      child: Text(
        "Don't Have Account ? Click here",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(UIData.registerRoute);
      },
    );

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            registerText
          ],
        ),
      ),
    );
  }
}
