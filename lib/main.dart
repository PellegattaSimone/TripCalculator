import 'package:flutter/material.dart';

import '/routes/root_page.dart';
import '/routes/fuel_type.dart';
import '/routes/user_path.dart';
import '/routes/results.dart';

void main() => runApp(const Policollege()); //run app

class Policollege extends StatelessWidget { //main app
  const Policollege({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( //no body (handled by navigator if there is a '/' route, in this case rootPage)
      title: 'Trip Calculator', //app name
      routes: { //used by Navigator
        RootPage.routeName: (context) => const RootPage(),  //routeName is a constant defined at class level
        FuelType.routeName: (context) => const FuelType(),
        UserPath.routeName: (context) => const UserPath(),
        Results.routeName: (context) => const Results(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue, //primary app color
      ),
    );
  }
}