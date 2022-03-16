import 'package:flutter/material.dart';

import '/routes/root_page.dart';

class RuntimeException implements Exception { //custom exception to recognise user-defined throw
  final String message;

  const RuntimeException([this.message = ""]);

  @override
  String toString() => "RuntimeException: $message";  //same as Exception class (different name)
}

abstract class AppPage {  //constraints for every route
  static const String home = RootPage.routeName;

  void nextPage();  //the last route is going to have an empty method
  void goToHome();
}

enum FuelEnum { //fuel type for dropdown menu
  gasoline, diesel, lpg
}

class FuelInfo {  //info from fuelType route
  final FuelEnum fuelType;
  final double consumption;

  FuelInfo(this.fuelType, this.consumption);
}

class FullInfo {  //all necessary info (fuelType + userPath)
  final FuelInfo fuel;
  final String start;
  final String end;

  FullInfo(this.fuel, this.start, this.end);
}

class Copyright extends StatelessWidget { //bottom credit info (displayed in every page)
  const Copyright({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Row(
        children: const [
          Padding(
            child: Text(
              "Pellegatta Simone © 2022",
              style: TextStyle(color: Colors.grey),
            ),
          padding: EdgeInsets.symmetric(vertical: 20),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      visible: MediaQuery.of(context).size.aspectRatio < 1, //hide in case of large screens
    );
  }
}

class Home extends StatelessWidget {  //home button
  final void Function() goToHome; //defined in every class implementing AppPage

  const Home({Key? key, required this.goToHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: goToHome,
      tooltip: 'Torna alla home',
      child: const Icon(Icons.home),
    );
  }
}