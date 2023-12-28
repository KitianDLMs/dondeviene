import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dondeviene/src/ui/pages/user/map/user_map_controller.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';

class UserMapPage extends StatefulWidget {
  UserMapPage({Key? key}) : super(key: key);

  @override
  State<UserMapPage> createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  UserMapController _con = new UserMapController();
  String duration = '';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerUsr(),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _googleMaps()),
          SafeArea(
            child: Column(
              children: [
                Spacer(),
                _cardOrderInfo(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardOrderInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.39,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: Column(
        children: [
          _listTileAddress(
              _con.trip.descripcion == null
                  ? 'espere...'
                  : _con.trip.descripcion,
              _con.trip.nombre == 'santiago'
                  ? 'Terminal Estación central'
                  : 'Primera parada Escuela La Merced',
              Icons.my_location),
          Divider(color: Colors.grey[400]),
          // FutureBuilder(
          //   future: _con.getTime(
          //     Location(
          //         latitude: _con.position?.latitude,
          //         longitude: _con.position?.longitude),
          //     Location(latitude: _con.timeLat, longitude: _con.timeLng),
          //   ),
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData) {
          //       return _listTileTimer('Tiempo estimado de llegada',
          //           '${snapshot.data}', Icons.timelapse_outlined);
          //     } else {
          //       return CircularProgressIndicator(
          //         strokeWidth: 1,
          //       );
          //     }
          //   },
          // ),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _listTileAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle,
            style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        trailing: Icon(iconData),
      ),
    );
  }

  Widget _listTileTimer(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle,
            style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        trailing: Icon(iconData),
      ),
    );
  }

  _buttonNext() {
    return Container(
      margin: Platform.isIOS
          ? EdgeInsets.only(
              left: 30,
              right: 30,
              top: 200,
            )
          : EdgeInsets.only(
              left: 30,
              right: 30,
              top: 100,
            ),
      child: ElevatedButton(
          onPressed: () {
            _con.back();
            // socketService.socket.disconnect();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Atras',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 70, top: 9),
                  height: 30,
                  child: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: Platform.isAndroid ? true : false,
      myLocationEnabled: true,
      zoomControlsEnabled: true,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
