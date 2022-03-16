import 'package:flutter/material.dart';

import '/includes/lib.dart';
import '/routes/fuel_type.dart';

class RootPage extends StatefulWidget {
  static const routeName = '/';  //for navigator

  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> implements AppPage {
  @override
  void nextPage() { //fuelType is the first "actual" route
    Navigator.pushNamed(
      context,
      FuelType.routeName,
    );
  }

  @override
  void goToHome() { //just for completeness (floatingActionButton not defined)
    Navigator.pushNamed(
      context,
      AppPage.home, //costant defined in lib.dart
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //at the moment same everywhere
        title: const Text("Trip Calculator"),
        automaticallyImplyLeading: false, //prevent back button from home page
      ),
      body: Center(
        child: Padding(
          child: Column(
            children: [
              SizedBox(
                child: ElevatedButton(
                  child: const Text(
                    "Iniziamo!",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: nextPage,  //fuelType
                ),
                width: 140.0,
                height: 50.0,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07),  //in every scaffold (compensates Copyright class)
        ),
      ),
      bottomSheet: const Copyright(), //defined in lib.dart
    );
  }
}