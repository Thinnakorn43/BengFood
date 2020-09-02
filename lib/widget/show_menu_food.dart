import 'dart:convert';

import 'package:bengfood/model/food_model.dart';
import 'package:bengfood/model/user_model.dart';
import 'package:bengfood/utility/my_constant.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFood({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List();
  int amount = 1;
  double lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen((event) {
      lat1 = event.latitude;
      lng1 = event.longitude;
      // print('Lat1 = $lat1, Lng1 = $lng1');
    });
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;

    String url =
        '${MyConstant().domain}/bengfood/getfoodwhereidshop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    // print('res ==>> $response');
    var result = json.decode(response.data);
    // print('result = $result');

    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);

      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // print('You Click index = $index');
                amount = 1;
                confirmOrder(index);
              },
              child: Row(
                children: <Widget>[
                  showFoodImage(context, index),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.4,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              foodModels[index].nameFood,
                              style: MyStyle().mainTitle,
                            ),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 ,
                              child: Text(
                                foodModels[index].detail,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ราคา ${foodModels[index].price} บาท',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${foodModels[index].pathImage}'),
            fit: BoxFit.contain),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                foodModels[index].nameFood,
                style: MyStyle().mainTitle,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${MyConstant().domain}${foodModels[index].pathImage}'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      size: 40,
                      color: Colors.red.shade400,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                          // print('Amount ==>> $amount');
                        });
                      }
                    },
                  ),
                  Text(
                    amount.toString(),
                    style: MyStyle().mainTitle,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 40,
                      color: Colors.green.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                        // print('Amount ==>> $amount');
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 110.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.amber.shade300,
                      onPressed: () => Navigator.pop(context),
                      child: Text('ยกเลิก'),
                    ),
                  ),
                  Container(
                    width: 110.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.amber.shade300,
                      onPressed: () {
                        Navigator.pop(context);
                        print(
                            'คุณสั่งซื้อ${foodModels[index].nameFood} จำนวน $amount ชิ้น');

                        addOrderToCart(index);
                      },
                      child: Text('สั่งซื้อ'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {}
}
