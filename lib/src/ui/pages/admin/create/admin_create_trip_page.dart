import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:dondeviene/src/ui/pages/admin/create/admin_create_trip_controller.dart';

class AdminCreateTripPage extends StatefulWidget {
  const AdminCreateTripPage({Key? key}) : super(key: key);

  @override
  _AdminCreateTripPageState createState() => _AdminCreateTripPageState();
}

class _AdminCreateTripPageState extends State<AdminCreateTripPage> {
  AdminCreateTripController _con = new AdminCreateTripController();

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
      appBar: AppBar(
        title: Text('Nuevo viaje'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: CustomInput(
              icon: Icons.bus_alert_outlined,
              placeholder: 'Dirección',
              textController: _con.nombreCtrl,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: CustomInput(
              icon: Icons.description_outlined,
              placeholder: 'Hora salida',
              textController: _con.descripcionCtrl,
            ),
          )
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _buttonCreate() {
    return Container(
        margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
        child: BotonAzul(text: 'Crear Viaje', onPressed: _con.createTrip));
  }

  void refresh() {
    setState(() {});
  }
}
