import 'dart:io';
import 'dart:math';

import 'package:bengfood/utility/my_constant.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:bengfood/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File file;
  String nameFood, price, detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเมนูอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleFood('รูปอาหาร'),
            groupImage(),
            buttonImage(),
            showTitleFood('รายละเอียดอาหาร'),
            nameFrom(),
            MyStyle().mySizebox(),
            priceFrom(),
            MyStyle().mySizebox(),
            detailFrom(),
            MyStyle().mySizebox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().darkColor,
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'กรุณาเลือกรูปภาพ และใส่ข้อมูลให้ครบ');
          } else if (nameFood == null ||
              nameFood.isEmpty ||
              price == null ||
              price.isEmpty ||
              detail == null ||
              detail.isEmpty) {
            normalDialog(context, 'กรุณาใส่ข้อมูลให้ครบทุกช่อง');
          } else {
            uploadFoodAndInsertData();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'save',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> uploadFoodAndInsertData() async {
    String urlUpload = '${MyConstant().domain}/bengfood/savefood.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'food$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);

      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String urlPathImage = '/bengfood/Food/$nameFile';
        print('urlPathImage = ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String idShop = preferences.getString('id');

        String urlInserData =
            '${MyConstant().domain}/bengfood/addfood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=$urlPathImage&Price=$price&Detail=$detail';
        await Dio().get(urlInserData).then(
              (value) => Navigator.pop(context),
            );
      });
    } catch (e) {}
  }

  Widget nameFrom() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => nameFood = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: 'ชื่ออาหาร',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceFrom() => Container(
        width: 250.0,
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.local_atm),
            labelText: 'ราคา',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detailFrom() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.star),
            labelText: 'รายละเอียด',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Row buttonImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          height: 250.0,
          child: file == null
              ? Image.asset('images/foodmenu.png')
              : Image.file(file),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget showTitleFood(String string) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          MyStyle().showTitle2(string),
        ],
      ),
    );
  }
}
