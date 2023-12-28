import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dondeviene/src/ui/pages/admin/map/admin_map_controller.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';

class AdminMapPage extends StatefulWidget {
  AdminMapPage({Key? key}) : super(key: key);

  @override
  State<AdminMapPage> createState() => _AdminMapPageState();
}

class _AdminMapPageState extends State<AdminMapPage> {
  AdminMapController _con = new AdminMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerAdmin(),
      body: Stack(
        children: [
          _googleMaps(),
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              alignment: Alignment.bottomCenter,
              child:
                  BotonAzul(onPressed: () {}, text: 'Seleccionar este punto'),
            ),
          )
        ],
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      // myLocationButtonEnabled: true ,
      // myLocationEnabled: true,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
