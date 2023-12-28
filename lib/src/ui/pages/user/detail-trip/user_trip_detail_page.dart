import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dondeviene/src/data/models/models.dart';
import 'package:dondeviene/src/ui/pages/user/detail-trip/user_trip_detail_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserTripDetailPage extends StatefulWidget {
  Trip trip;

  UserTripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  _UserTripDetailPageState createState() => _UserTripDetailPageState();
}

class _UserTripDetailPageState extends State<UserTripDetailPage> {
  UserTripDetailController _con = new UserTripDetailController();
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
          widget.trip.status != 'Estacionado' &&
                  widget.trip.status != 'Finalizado'
              ? _buttonNext()
              : Container()
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
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
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
      child: ElevatedButton(
          onPressed: _con.updateTrip,
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
                    'Ver en el mapa',
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
                  margin: EdgeInsets.only(left: 80, top: 9),
                  height: 30,
                  child: Icon(
                    Icons.directions,
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

  final UserTripDetailPage widget;

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

  final UserTripDetailPage widget;

  @override
  Widget build(BuildContext context) {
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
                    ? TextStyle(fontSize: 20)
                    : TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
