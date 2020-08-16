import 'package:bengfood/screens/add_info_shop.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:flutter/material.dart';

class InfotionShopMenu extends StatefulWidget {
  @override
  _InfotionShopMenuState createState() => _InfotionShopMenuState();
}

class _InfotionShopMenuState extends State<InfotionShopMenu> {
  void routeToAddInfo() {
    print('routeToAddInfo');
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInfoShop(),
    );
    Navigator.push(context, materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyStyle().titleCenter(context, 'ยังไม่มีข้อมูล กรุณาเพิ่มอมูลด้วยคะ'),
        addAndEditButton(),
      ],
    );
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  print('You Click');
                  routeToAddInfo();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
