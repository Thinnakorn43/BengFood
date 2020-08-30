import 'dart:convert';

import 'package:bengfood/model/food_model.dart';
import 'package:bengfood/model/user_model.dart';
import 'package:bengfood/utility/my_constant.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;

    String url =
        '${MyConstant().domain}/bengfood/getfoodwhereidshop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    print('res ==>> $response');
    var result = json.decode(response.data);
    print('result = $result');

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
            itemBuilder: (context, index) => Row(
              children: <Widget>[
                showFoodImage(context, index),
                Container(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            foodModels[index].nameFood,
                            style: MyStyle().mainTitle,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5 - 8,
                            child: Text(foodModels[index].detail),
                          ),
                        ],
                      ),
                      Text(
                        '${foodModels[index].price} บาท',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyStyle().darkColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
}
