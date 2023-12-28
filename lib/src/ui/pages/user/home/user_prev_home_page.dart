import 'package:dondeviene/src/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../../data/services/auth_service.dart';

class UserHomeMainPage extends StatefulWidget {
  const UserHomeMainPage({Key? key}) : super(key: key);

  @override
  State<UserHomeMainPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserHomeMainPage> {
  UserPrevHomePageController _con = new UserPrevHomePageController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      key: _con.key,
      drawer: DrawerUsr(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: _menuDrawer(),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 10),
            child: Text(
              'Invitado',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
              child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: ListView(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 100,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Text(
                                'En esta app conoceras la ubicación exacta de tu viaje',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Text(
                                  'Ingresa a la lista de viajes, en la pestaña "EnCamino" selecciona tu viaje y lo podras ver en el mapa en tiempo real, en la pestaña estacionado veras el siguiente si lo perdiste',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              Divider(height: 10, color: Colors.transparent),
                              Container(
                                  margin: EdgeInsets.all(50),
                                  child: Center(child: Container())),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.grey[400],
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SafeArea(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      color: Colors.grey,
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Image.asset(
                                              'assets/dv-logo.png',
                                              width: 70,
                                            ),
                                          )
                                        ],
                                      ),
                                      margin: EdgeInsets.all(2),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    color: Colors.grey,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/dv-logo.png',
                                            width: 70,
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.all(2),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    color: Colors.grey,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/dv-logo.png',
                                            width: 70,
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.all(2),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.32,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    color: Colors.grey,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/dv-logo.png',
                                            width: 70,
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.all(2),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'user/info', (route) => false);
                        },
                        child: Container(
                          width: 100,
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Text(
                                'Lista de viajes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Divider(height: 10, color: Colors.transparent),
                              Container(
                                  margin: EdgeInsets.all(50),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _dropDownTrips() {
    // AdminTripDetailController _con = new AdminTripDetailController();
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
                    'Selecciona tu comuna',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropDownItems(),
                  value: '_con.idDriver',
                  onChanged: (option) {
                    setState(() {
                      // _con.idDriver = option as String;
                      // _storage.write(key: 'driveruid', value: option);
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

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<DropdownMenuItem<String>> list = [];

    return list;
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
}
