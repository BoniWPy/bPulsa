import 'package:flutter/material.dart';
import 'package:bpulsa/ui/page/dashboard/dashboard_one.page.dart';
import 'package:bpulsa/ui/page/dashboard/dashboard_two_page.dart';
import 'package:bpulsa/ui/page/home_page.dart';
import 'package:bpulsa/ui/page/login/login.dart';
import 'package:bpulsa/ui/page/notfound/notfound_page.dart';
import 'package:bpulsa/ui/page/payment/credit_card_page.dart';
import 'package:bpulsa/ui/page/payment/payment_success_page.dart';
import 'package:bpulsa/ui/page/profile/profile.dart';
import 'package:bpulsa/ui/page/profile/EditProfile.dart';
import 'package:bpulsa/ui/page/settings/settings_one_page.dart';

import 'package:bpulsa/ui/page/timeline/timeline_one_page.dart';
import 'package:bpulsa/ui/page/timeline/timeline_two_page.dart';
import 'package:bpulsa/CheckRoute.dart';
import 'package:bpulsa/ui/page/tukarpoint/TukarPoint.dart';
import 'package:bpulsa/ui/page/login/register.dart';
import 'package:bpulsa/ui/page/task/task.dart';
import 'package:bpulsa/ui/page/task/game.dart';
import 'package:bpulsa/ui/page/about/about.dart';
import 'package:bpulsa/ui/page/payment/payment.dart';
import 'package:bpulsa/ui/page/barita/berita.dart';
import 'package:bpulsa/ui/page/barita/DetailBerita.dart';

import 'package:bpulsa/utils/uidata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bpulsa/model/berita.dart';

class MyApp extends StatelessWidget {
  // BeritaModel beritaModel = new BeritaModel();

  // List<String> titles = [];
  final materialApp = MaterialApp(
      title: UIData.appName,
      theme: ThemeData(
          primaryColor: Colors.blue,
          fontFamily: UIData.quickFont,
          primarySwatch: Colors.amber),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      home: CheckRoute(),
      // initialRoute: UIData.notFoundRoute,

      //routes
      routes: <String, WidgetBuilder>{
        UIData.beritaRoute: (BuildContext context) => Berita(),
        // UIData.detailBerita: (BuildContext context ) => DetailBerita(beritaModel.idBerita.toString()),
        //UIData.gameRoute: (BuildContext context) => Game(),
        UIData.aboutRoute: (BuildContext context) => About(),
        UIData.paymentRoute: (BuildContext context) => Payment(),
        UIData.logoutRoute: (BuildContext context) => LoginPage(),
        UIData.profileRoute: (BuildContext context) => Profile(),
        UIData.editProfileRoute: (BuildContext context) => EditProfile(),
        UIData.checkRoute: (BuildContext context) => CheckRoute(),
        UIData.registerRoute: (BuildContext context) => Register(),
      //  UIData.taskRoute: (BuildContext context) =>Task(),
       // UIData.tukarPointRoute: (BuildContext context) => TukarPoint(),
        UIData.homeRoute: (BuildContext context) => HomePage(),
        UIData.timelineOneRoute: (BuildContext context) => TimelineOnePage(),
        UIData.timelineTwoRoute: (BuildContext context) => TimelineTwoPage(),
        UIData.notFoundRoute: (BuildContext context) => NotFoundPage(),
        UIData.settingsOneRoute: (BuildContext context) => SettingsOnePage(),
        UIData.loginRoute: (BuildContext context) => LoginPage(),
        UIData.paymentOneRoute: (BuildContext context) => CreditCardPage(),
        UIData.paymentTwoRoute: (BuildContext context) => PaymentSuccessPage(),
        UIData.dashboardOneRoute: (BuildContext context) => DashboardOnePage(),
        UIData.dashboardTwoRoute: (BuildContext context) => DashboardTwoPage(),
      },
      onUnknownRoute: (RouteSettings rs) => new MaterialPageRoute(
          builder: (context) => new NotFoundPage(
                appTitle: UIData.coming_soon,
                icon: FontAwesomeIcons.solidSmile,
                title: UIData.coming_soon,
                message: "Under Development",
                iconColor: Colors.green,
              )));

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
