import 'package:bengfood/model/user_model.dart';
import 'package:bengfood/utility/my_constant.dart';
import 'package:flutter/material.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  UserModel userModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('แสดงรายการอาหารที่ลูกค้าสั่ง');
  }
}
