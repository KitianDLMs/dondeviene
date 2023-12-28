import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:dondeviene/src/ui/pages/admin/update/admin_update_trip_controller.dart';

class AdminUpdateTripPage extends StatefulWidget {
  const AdminUpdateTripPage({Key? key}) : super(key: key);

  @override
  _AdminUpdateTripPageState createState() => _AdminUpdateTripPageState();
}

class _AdminUpdateTripPageState extends State<AdminUpdateTripPage> {
  AdminUpdateTripController _con = new AdminUpdateTripController();

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
              placeholder: 'Nombre del viaje',
              textController: _con.nombreCtrl,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: CustomInput(
              icon: Icons.description_outlined,
              placeholder: 'Descripción',
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
        child: BotonAzul(text: 'Actualizar Viaje', onPressed: _con.createTrip));
  }

  void refresh() {
    setState(() {});
  }
}
