import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dondeviene/src/data/services/services.dart';
import 'package:dondeviene/src/ui/pages/pages.dart';

class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('auth-verify...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => authService.usuario!.role == 'user'
                  ? UserHomeMainPage()
                  : authService.usuario!.role == 'driver'
                      ? DriverHomePage()
                      : HomeAdminMainPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacementNamed(context, 'login-ios');
    }
  }
}
