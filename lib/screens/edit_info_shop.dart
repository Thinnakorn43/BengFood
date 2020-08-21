import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bengfood/model/user_model.dart';
import 'package:bengfood/utility/my_constant.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:bengfood/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;
  Location location = Location();
  double lat, lng;
  File file;

  @override
  void initState() {
    super.initState();
    readCurrentInfo();

    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat, lng = $lng');
      });
    });
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString('id');
    print('idShop ==>> $idShop');

    String url =
        '${MyConstant().domain}/bengfood/getuserwhereid.php?isAdd=true&id=$idShop';

    Response response = await Dio().get(url);
    print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showContent(),
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลของร้าน'),
      ),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox(),
            nameShopFrom(),
            MyStyle().mySizebox(),
            showImage(),
            buttonShowEditImage(),
            MyStyle().mySizebox(),
            addressFrom(),
            MyStyle().mySizebox(),
            phoneFrom(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton()
          ],
        ),
      );

  Widget editButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: MyStyle().darkColor,
        onPressed: () => confirmDialog(),
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        label: Text(
          'แก้ไขข้อมูล',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการที่จะแก้ไขข้อมูลใช่หรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  editThread();
                },
                child: Text('ใช่'),
              ),
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ไม่'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'editShop$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/bengfood/saveshop.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      urlPicture = '/bengfood/Shop/$nameFile';
      String id = userModel.id;
      // print('id = $id');

      String url =
          '${MyConstant().domain}/bengfood/edituserwhereid.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยังไม่สามารถแก้ไขข้อมูลได้ กรุราลองใหม่');
      }
    });
  }

  Set<Marker> currenMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(lat, lng),
        infoWindow:
            InfoWindow(title: 'ร้านของฉัน', snippet: 'Lat =$lat, Lng = $lng'),
      )
    ].toSet();
  }

  Container showMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: currenMarker(),
      ),
    );
  }

  Row buttonShowEditImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add_a_photo,
            size: 30.0,
          ),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 30.0,
          ),
          onPressed: () => chooseImage(ImageSource.gallery),
        )
      ],
    );
  }

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        width: 250,
        height: 250.0,
        child: file == null
            ? Image.network('${MyConstant().domain}$urlPicture')
            : Image.file(file),
      );

  Widget nameShopFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ชื่อร้าน'),
            ),
          ),
        ],
      );
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

  Widget addressFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'ที่อยู่'),
            ),
          ),
        ],
      );

  Widget phoneFrom() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'เบอร์โทรศัพท์'),
            ),
          ),
        ],
      );
}
