import 'package:dondeviene/src/data/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:dondeviene/src/ui/pages/user/get/user_get_trip_controller.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserGetTripPage extends StatefulWidget {
  const UserGetTripPage({Key? key}) : super(key: key);

  @override
  _UserGetTripPageState createState() => _UserGetTripPageState();
}

class _UserGetTripPageState extends State<UserGetTripPage> {
  UserGetTripController _con = new UserGetTripController();
  List<String> statusFor = ['Estacionado', 'EnCamino', 'Finalizado'];

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            leading: _menuDrawer(),
            bottom: TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.green,
                isScrollable: true,
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                    child: Text(_con.status[index]),
                  );
                })),
          ),
        ),
        drawer: DrawerUsr(),
        body: TabBarView(
          children: _con.status.map((String status) {
            return FutureBuilder(
              future: _con.getTripsByStatus(status),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.data == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        itemCount: snapshot.data.length ?? 0,
                        itemBuilder: (_, index) {
                          return _cardTrip(snapshot.data[index]);
                        });
              },
            );
          }).toList(),
          //  return;
          // }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _cardTrip(Trip trip) {
    final _storage = new FlutterSecureStorage();
    return GestureDetector(
      onTap: () async {
        _con.openBottomSheet(trip);
        await _storage.write(key: 'uidUsrTrip', value: trip.uid);
      },
      child: Container(
        height: 160,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    trip.status == 'EnCamino' || trip.status == 'Estacionado'
                        ? 'Viaje ${trip.uid}'
                        : 'Viaje finalizado',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        'Dirección: ${trip.nombre}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        trip.status == 'EnCamino' ||
                                trip.status == 'Estacionado'
                            ? 'Salida: ${trip.descripcion}'
                            : 'Salio: ${trip.descripcion}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        'Estado: ${trip.status}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
