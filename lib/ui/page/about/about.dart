// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'backdrop.dart';
import 'package:bpulsa/ui/widgets/common_scaffold.dart';
import 'package:bpulsa/utils/uidata.dart';
import 'package:bpulsa/ui/widgets/common_divider.dart';
import 'package:bpulsa/ui/widgets/profile_tile.dart';
class About extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) =>
       CommonScaffold(
        scaffoldKey: scaffoldKey,
        appTitle: "About",
        showDrawer: false,
        showFAB: false,
        actionFirstIcon: Icons.payment,
        bodyData: SafeArea(child: Panels()),
      );
  // @override
  // Widget build(BuildContext context) =>
  //     Scaffold(body: SafeArea(child: Panels()));
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontLayer: FrontPanel(),
      backLayer: BackPanel(
        frontPanelOpen: frontPanelVisible,
      ),
      frontHeader: FrontPanelTitle(),
      panelVisible: frontPanelVisible,
      frontPanelOpenHeight: 40.0,
      frontHeaderHeight: 48.0,
      frontHeaderVisibleClosed: true,
    );
  }
}

class FrontPanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(
        'About Developer',
        style: Theme.of(context).textTheme.subhead,
      ),
    );
  }
}

class FrontPanel extends StatelessWidget {
  Size deviceSize;

  @override
  Widget build(BuildContext context) {
  deviceSize = MediaQuery.of(context).size;

    return Container(
        height: deviceSize.height * 0.24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProfileTile(
              title: "VulnWalker",
              subtitle: "rm-rf.studio",
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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
                    backgroundImage: AssetImage("assets/images/pk.jpg"),
                    foregroundColor: Colors.black,
                    radius: 40.0,
                  ),
                ),

              ],
            ),
            CommonDivider(),
            Container(
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
                        title: "Email",
                        subtitle: "vulnwalker@tuyul.online",
                      ),
                    ],
                  ),
                
                ],
              ),
            )
          ],
        ),
      );
  }
}

class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen});
  final ValueNotifier<bool> frontPanelOpen;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  void _subscribeToValueNotifier() =>
      setState(() => panelOpen = widget.frontPanelOpen.value);

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
  var deviceSize = MediaQuery.of(context).size;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top:10.0),
            child: Container(
              height: deviceSize.height * 0.8,
              child: Column(
                children : <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "BPulsa adalah aplikasi PPC, yang membayar para pengguna dalam bentuk pulsa. Aplikasi ini dibuat untuk memberikan pulsa secara gratis kepada pengguna yang telah memiliki point yang cukup untuk ditukar dalam bentuk pulsa.",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0
                      ),
                      textAlign: TextAlign.center,
                      maxLines:10,
                      softWrap: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0
                    ),
                    child: Container(
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
                  )
                ] 
              ),
            ),
          ),
          
         
          // will not be seen; covered by front panel
    
        ]);
  }
}
