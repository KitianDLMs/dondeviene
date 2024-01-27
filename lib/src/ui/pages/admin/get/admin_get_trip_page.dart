import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:dondeviene/src/ui/pages/admin/get/admin_get_trip_controller.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AdminGetTripPage extends StatefulWidget {
  const AdminGetTripPage({Key? key}) : super(key: key);

  @override
  _AdminGetTripPageState createState() => _AdminGetTripPageState();
}

class _AdminGetTripPageState extends State<AdminGetTripPage> {
  AdminGetTripController _con = new AdminGetTripController();
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressDialog = ProgressDialog(context: context);
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
        drawer: DrawerAdmin(),
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

  Widget _cardTrip(dynamic trip) {
    return Container(
        height: 160,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _con.openBottomSheet(trip);
              },
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                          'Viaje ${trip.uid}',
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
                              'Salida: ${trip.descripcion}',
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
                    ),
                    Positioned(
                      top: 50,
                      right: 5,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _confirmDelete(trip.uid);
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text('Eliminar',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _confirmDelete(String tripUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que quieres eliminar el viaje?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
                _con.deleteTrip(
                    tripUid); // Llamar al método deleteTrip si se confirma
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
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
