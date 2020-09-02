

import 'package:bengfood/model/user_model.dart';
import 'package:bengfood/utility/my_api.dart';
import 'package:bengfood/utility/my_constant.dart';
import 'package:bengfood/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  AboutShop({Key key, this.userModel}) : super(key: key);

  @override
  _AboutShopState createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel userModel;
  double lat1, lng1, lat2, lng2, distance;
  String distanceString;
  int transport;
  CameraPosition position;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    findLat1Lng1();
  }

  Future<Null> findLat1Lng1() async {
    LocationData locationData = await findLocationDate();
    setState(() {
      lat1 = locationData.latitude;
      lng1 = locationData.longitude;
      lat2 = double.parse(userModel.lat);
      lng2 = double.parse(userModel.lng);
      print('Lat1 = $lat1, Lng1 = $lng1, Lat2 = $lat2, Lng2 = $lng2');
      distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);

      var myFormat = NumberFormat('##0.0#', 'en_US');
      distanceString = myFormat.format(distance);

      transport = MyAPI().calculateTransport(distance);

      print('distance = $distance');
      print('transport = $transport');
    });
  }

  Future<LocationData> findLocationDate() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${MyConstant().domain}${userModel.urlPicture}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.amber,
              size: 35.0,
            ),
            title: Text(
              'ที่อยู่ร้าน ${userModel.address}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Colors.amber,
              size: 35.0,
            ),
            title: Text(
              'เบอร์โทรศัพท์ ${userModel.phone}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: Colors.amber,
              size: 35.0,
            ),
            title: Text(
              distance == null
                  ? ''
                  : 'ระยะทางการจัดส่ง $distanceString  กิโลเมตร',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.local_atm,
              color: Colors.amber,
              size: 35.0,
            ),
            title: Text(
              transport == null ? '' : 'ค่าจัดส่ง $transport บาท',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          showMap()
        ],
      ),
    );
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1, lng1);
      position = CameraPosition(
        target: latLng1,
        zoom: 16.0,
      );
    }

    Marker userMarker() {
      return Marker(
        markerId: MarkerId('UserMarker'),
        position: LatLng(lat1, lng1),
        icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
        infoWindow: InfoWindow(title: 'ตำแหน่งของฉัน'),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('UserMarker'),
        position: LatLng(lat2, lng2),
        icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
        infoWindow: InfoWindow(title: userModel.nameShop),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[userMarker(), shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.all(16.0),
      height: 300.0,
      child: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
}
