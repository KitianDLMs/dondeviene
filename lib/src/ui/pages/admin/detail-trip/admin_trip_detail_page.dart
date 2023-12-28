import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dondeviene/src/data/models/models.dart';
import 'package:dondeviene/src/ui/pages/admin/detail-trip/admin_trip_detail_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminTripDetailPage extends StatefulWidget {
  Trip trip;

  AdminTripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  _AdminTripDetailPageState createState() => _AdminTripDetailPageState();
}

class _AdminTripDetailPageState extends State<AdminTripDetailPage> {
  AdminTripDetailController _con = new AdminTripDetailController();

  final _storage = new FlutterSecureStorage();

  Trip? trip;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.trip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _textDescription(widget: widget),
          _tripDirection(),
          _tripName(widget: widget),
          widget.trip.status != 'Estacionado'
              ? Container()
              : _dropDownTrips(_con.usuarios),
          widget.trip.status == 'Estacionado'
              ? _buttonNext()
              : widget.trip.status == 'Finalizado'
                  ? Container()
                  : _buttonNextMapa(),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  Widget _dropDownTrips(List<Usuario> usuarios) {
    AdminTripDetailController _con = new AdminTripDetailController();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.blue,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                    'Seleccionar conductor',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownItems(usuarios),
                  value: _con.idDriver,
                  onChanged: (option) {
                    setState(() {
                      _con.idDriver = option as String;
                      _storage.write(key: 'driveruid', value: option);
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Usuario> usuarios) {
    List<DropdownMenuItem<String>> list = [];
    usuarios.forEach((usuario) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Icon(Icons.person_2_outlined),
            SizedBox(
              width: 10,
            ),
            Text(usuario.nombre)
          ],
        ),
        value: usuario.uid,
      ));
    });
    return list;
  }

  _buttonNext() {
    AdminTripDetailController _con = new AdminTripDetailController();
    final _storage = new FlutterSecureStorage();

    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: ElevatedButton(
          onPressed: () async {
            _con.updateTrip(widget.trip);
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
                    'Despachar viaje',
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

  _buttonNextMapa() {
    AdminTripDetailController _con = new AdminTripDetailController();

    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: ElevatedButton(
          onPressed: () async {
            _con.updateTripTo(widget.trip);
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
                    'Actualizar a detenido',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 50, top: 9),
                  height: 30,
                  child: Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class _tripName extends StatelessWidget {
  const _tripName({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final AdminTripDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: Text(
        '${widget.trip.nombre ?? ''}',
        style: TextStyle(fontSize: 50),
      ),
    );
  }
}

class _tripDirection extends StatelessWidget {
  const _tripDirection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: Text(
        'Viaje con dirección:',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class _textDescription extends StatelessWidget {
  const _textDescription({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final AdminTripDetailPage widget;

  @override
  Widget build(BuildContext context) {
    AdminTripDetailController _con = new AdminTripDetailController();

    return Column(
      children: [
        Row(
          children: [
            FadeInImage(
              height: 100,
              placeholder: AssetImage('assets/logodv.png'),
              image: AssetImage('assets/logodv.png'),
              fadeInDuration: Duration(milliseconds: 50),
              fit: BoxFit.contain,
            ),
            Text(
              'Salida: ${widget.trip.descripcion ?? ''}',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(70),
          color: (widget.trip.online != true) ? Colors.red : Colors.green,
          child: Row(
            children: [
              Text(
                'Estado: ${widget.trip.status == 'EnCamino' ? 'EnCamino' : widget.trip.status == 'Estacionado' ? 'Estacionado' : 'Finalizado'}',
                style: Platform.isIOS
                    ? TextStyle(fontSize: 30)
                    : TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
