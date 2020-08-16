import 'package:bengfood/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  // Field
  double lat, lng;

  @override
  void initState() {
    super.initState();
    findLatLog();
  }

  Future<Null> findLatLog() async {
    LocationData locationData = await findLocationData();
    lat = locationData.longitude;
    lng = locationData.longitude;
    print('lat = $lat, lng =$lng');
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infotion Shoop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizebox(),
            nameForm(),
            MyStyle().mySizebox(),
            addressForm(),
            MyStyle().mySizebox(),
            phoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            groupImageButton(),
            MyStyle().mySizebox(),
            showMap(),
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
        onPressed: () {},
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'บันทึกข้อมูล',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(14.991090, 103.102011);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

  Row groupImageButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: () {}),
        IconButton(icon: Icon(Icons.add_a_photo), onPressed: () {}),
      ],
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          child: Image.asset('images/myimage.png'),
        ),
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อร้าน',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้าน',
                prefixIcon: Icon(Icons.account_balance),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์',
                prefixIcon: Icon(Icons.local_phone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
