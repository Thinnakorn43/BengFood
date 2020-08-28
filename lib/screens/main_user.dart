import 'package:bengfood/utility/my_style.dart';
import 'package:bengfood/utility/signout_process.dart';
import 'package:bengfood/widget/show_list_shop_all.dart';
import 'package:bengfood/widget/show_status_food_odrder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShopAll();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : 'สวัสดีคุณ $nameUser'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Column(
          children: <Widget>[
            showHead(),
            menuListShop(),
            menuStatusFoodOrder(),
            menuSignOut(),
          ],
        ),
      );

  ListTile menuListShop() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowListShopAll();
          });
        },
        leading: Icon(Icons.home),
        title: Text('ร้านค้าที่อยู่ไกล้คูณ'),
      );

  ListTile menuStatusFoodOrder() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowStatusFoodOrder();
          });
        },
        leading: Icon(Icons.restaurant_menu),
        title: Text('รายการอาหารที่สั่ง'),
      );

  ListTile menuSignOut() => ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(Icons.exit_to_app),
        title: Text('ออกจากระบบ'),
      );
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(nameUser == null ? 'Name Login' : nameUser),
      accountEmail: Text('Login'),
    );
  }
}
