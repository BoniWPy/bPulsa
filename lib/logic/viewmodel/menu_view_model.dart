import 'package:flutter/material.dart';
import 'package:bpulsa/model/menu.dart';
import 'package:bpulsa/utils/uidata.dart';

class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems});

  getMenuItems() {
    return menuItems = <Menu>[
      Menu(
        title: "Task",
        menuColor: Color(0xff261d33),
        icon: Icons.dashboard,
        image: UIData.dashboardImage,
        targetPage: "task"
      ),
      Menu(
        title: "Tukar Point",
        menuColor: Color(0xffc8c4bd),
        icon: Icons.shopping_cart,
        image: UIData.shoppingImage,
        targetPage: "Tukar Point"
      ),
      Menu(
        title: "Payment",
        menuColor: Color(0xffddcec2),
        icon: Icons.payment,
        image: UIData.paymentImage,
        targetPage: "payment"
      ),
      Menu(
        title: "News",
        menuColor: Color(0xff7f5741),
        icon: Icons.timeline,
        image: UIData.timelineImage,
        targetPage: "berita"
      ),
      Menu(
        title: "Profile",
        menuColor: Color(0xff050505),
        icon: Icons.person,
        image: UIData.profileImage,
        targetPage: "profile",
      ),
      Menu(
        title: "Share",
        menuColor: Color(0xff2a8ccf),
        icon: Icons.share,
        image: UIData.settingsImage,
        targetPage: "Share"
      ),
      Menu(
        title: "About",
        menuColor: Color(0xffc7d8f4),
        icon: Icons.help,
        image: UIData.loginImage,
        targetPage: "about"
      ),
      
      Menu(
        title: "Logout",
        menuColor: Color(0xffe19b6b),
        icon: Icons.settings_power,
        image: UIData.blankImage,
        targetPage: "logout"
      ),
  
    ];
  }
}
