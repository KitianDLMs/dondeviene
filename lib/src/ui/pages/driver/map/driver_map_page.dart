import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dondeviene/src/ui/pages/driver/map/driver_map_controller.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';

class DriverMapPage extends StatefulWidget {
  DriverMapPage({Key? key}) : super(key: key);

  @override
  State<DriverMapPage> createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  DriverMapController _con = new DriverMapController();

  @override
  void initState() {
    // TODO: implement initState
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
      drawer: DrawerDriver(),
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
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ]),
      child: Column(
        children: [
          _listTileAddress(
              _con.trip.descripcion == null
                  ? 'espere...'
                  : _con.trip?.descripcion,
              _con.trip?.nombre == 'santiago'
                  ? 'Terminal Interregional Estación central'
                  : 'Primera parada Escuela La Merced',
              Icons.my_location),
          Divider(color: Colors.grey[400]),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _listTileAddress(String? title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title!,
          style: TextStyle(fontSize: 13),
        ),
        subtitle: Text(subtitle),
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
            _con.updateToFinish();
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
                    'Finalizar el viaje',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 70, top: 9),
                  height: 30,
                  child: Icon(
                    Icons.check,
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
      myLocationButtonEnabled: true,
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
