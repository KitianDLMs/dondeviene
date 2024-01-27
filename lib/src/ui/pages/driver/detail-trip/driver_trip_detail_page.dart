import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dondeviene/src/data/models/models.dart';
import 'package:dondeviene/src/ui/pages/driver/detail-trip/driver_trip_detail_controller.dart';

class DriverTripDetailPage extends StatefulWidget {
  Trip? trip;

  DriverTripDetailPage({Key? key, this.trip}) : super(key: key);

  @override
  _DriverTripDetailPageState createState() => _DriverTripDetailPageState();
}

class _DriverTripDetailPageState extends State<DriverTripDetailPage> {
  DriverTripDetailController _con = new DriverTripDetailController();
  Trip? trip;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.trip!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      child: Column(
        children: [
          _textDescription(widget: widget),
          _tripDirection(),
          Divider(),
          _tripName(widget: widget),
          // widget.trip.status == 'Finalizado'
          //     ? _dropDownTrips(_con.usuarios)
          //     : Container(),
          widget.trip!.status == 'Finalizado' ? Container() : _buttonNext()
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  _buttonNext() {
    DriverTripDetailController _con = new DriverTripDetailController();

    return Container(
      margin: EdgeInsets.only(left: 28, right: 30, top: 30, bottom: 30),
      child: ElevatedButton(
          onPressed: () {
            _con.updateTrip(widget.trip!, context);
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
                    'Ir al mapa',
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

  final DriverTripDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(50),
      child: Text(
        '${widget.trip!.nombre ?? ''}',
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

  final DriverTripDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: FadeInImage(
                height: 70,
                placeholder: AssetImage('assets/logo.png'),
                image: AssetImage('assets/logo.png'),
                fadeInDuration: Duration(milliseconds: 50),
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Salida: ${widget.trip!.descripcion ?? ''}',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(70),
          color: (widget.trip!.online != true) ? Colors.red : Colors.green,
          child: Row(
            children: [
              Text(
                  'Estado: ${widget.trip!.status == 'EnCamino' ? 'EnCamino' : widget.trip!.status == 'Estacionado' ? 'Estacionado' : 'Finalizado'}',
                  style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      ],
    );
  }
}
