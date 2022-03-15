import 'package:flutter/material.dart';

import '/lib.dart';
import '/maps.dart' as bing;
import '/price.dart' as collect;

class Results extends StatefulWidget {
  static const routeName = '/fuel_type/user_path/results';  //for navigator

  const Results({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Results> implements AppPage {
  bool requested = false;

  //if null, loading is displayed
  String? distance; 
  String? startLocation; 
  String? endLocation; 
  String? price; 
  String? trip;

  static const String loading = "Caricamento..."; //loading temporary text

  late FullInfo data; //data from fuelType + userPath routes

  Future<double?> getDistance() async {
    data = ModalRoute.of(context)?.settings.arguments as FullInfo;  //get data from previous routes
    late bing.PathInfo result;

    try {
      result = await bing.requestPath(data.start, data.end);  //get data from bing
      setState(() {
        distance = result.distanceTraveled.toStringAsFixed(2) + " km";  //double to string
        startLocation = result.startLocation; //string
        endLocation = result.endLocation; //string
      });

      return result.distanceTraveled;  //returns a double (useful for calculateTrip method)

    } on Exception {
      Navigator.pop(context, "Posizione di partenza o di arrivo errata"); //back to userPath route (awaiting for error)
      return null;  //mandatory for method execution but never displayed
    } 
  }

  Future<double?> getPrice() async {
    late String result; //can be either the numeric result or an exception text

    try {
      double numeric;
      numeric = await collect.requestFuelPrice(data.fuel);  //get data from collect api
      
      result = "€" + numeric.toStringAsFixed(2);  //converted to string
      return numeric;  //returns a double (useful for calculateTrip method)

    } on Exception {
      result = "Impossibile ottenere il prezzo del carburante al momento. Riprova";
      return null;

    } finally {
      setState(() => price = result);
    }
  }

  String calculateTrip({required double? distance, required double? price}) { //required but named for clarity
    if(distance != null && price != null) { //distance should never be null anyway (Navigator.pop in case of error)
      return "€" + (distance * price / data.fuel.consume).toStringAsFixed(2);
    }
    return "N/A"; //in case of error retrieving price
  }

  void getData() async {
    requested = true;
    List responses = await Future.wait([getDistance(), getPrice()]);  //await methods in parallel

    trip = calculateTrip(distance: responses[0], price: responses[1]);  //calculates trip after distance and price are retrieved via the apis
  }

  @override
  void nextPage() { } //dummy but mandatory

  @override
  void goToHome() { //push home on top of the stack (cannot go back from there)
    Navigator.pushNamed(
      context,
      AppPage.home, //costant defined in lib.dart
    );
  }

  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context)?.settings.arguments == null) {
      Future.microtask(() => goToHome()); //this has to be executed right after build completion (can't setState during build)
      return const Scaffold(body: Text(""));  //prevent further execution of library
    }

    if(!requested) {  //avoid repetition
      getData();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Trip Calculator")), //at the moment same everywhere
      body: Center(
        child: Padding(
          child: Column(
            children: [
              ResultElement(label: "Punto di partenza: ", text: startLocation, altText: loading), //user-defined class
              ResultElement(label: "Punto di arrivo: ", text: endLocation, altText: loading),
              ResultElement(label: "Distanza percorsa: ", text: distance, altText: loading),
              ResultElement(label: "Prezzo del carburante: ", text: price, altText: loading),
              ResultElement(label: "Spesa totale del viaggio: ", text: trip, altText: loading),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07),  //in every scaffold (compensates Copyright class)
        ),
      ),
      floatingActionButton: Home(goToHome: goToHome),
      bottomSheet: const Copyright(), //defined in lib.dart
    );
  }
}

class ResultElement extends StatelessWidget { //one of the result elements
  final String label;
  final String? text; //if null, altText is displayed
  final String altText;

  const ResultElement({Key? key, required this.label, required this.text, this.altText = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich( //text containing different styles
      TextSpan(
        children: [
          TextSpan(
            text: label + '\n', //label on top of actual value
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: text ?? altText,  //if the text has not been loaded yet, display "loading"
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 20), //common style
      textAlign: TextAlign.center,  //center spans along the main axis
    );
  }
}