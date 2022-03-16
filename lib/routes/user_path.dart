import 'package:flutter/material.dart';

import '/includes/lib.dart';
import '/routes/results.dart';

class UserPath extends StatefulWidget {
  static const routeName = '/fuel_type/user_path';   //for navigator

  const UserPath({Key? key}) : super(key: key);

  @override
  _UserPathState createState() => _UserPathState();
}

class _UserPathState extends State<UserPath> implements AppPage {
  final TextEditingController start = TextEditingController();  //first textfield
  final TextEditingController end = TextEditingController();  //second textfield

  bool error = false; //in case of invalid position

  @override
  void nextPage() {
    if(start.text.isNotEmpty && end.text.isNotEmpty) {
      final FuelInfo fuelType = ModalRoute.of(context)!.settings.arguments as FuelInfo; //info passed from fuelType route
      final String startPoint = start.text; //first textfield
      final String endPoint = end.text; //second textfield

      final FullInfo data = FullInfo(fuelType, startPoint, endPoint);

      Navigator.pushNamed(  //load results route
        context, 
        Results.routeName,
        arguments: data //data from fuelType + userPath
      ).then((result) => {  //if results calls Navigator.pop
        if(result != null) {
          setState(() => error = true)  //Navigator.pop called if the location does not exist
        } else {
          setState(() => error = false)  //in case of normal back button and previous location error
        }
      });
    }
  }

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

    return Scaffold(
      appBar: AppBar(title: const Text("Trip Calculator")), //at the moment same everywhere
      body: Center(
        child: Padding(
          child: Column(
            children: [
              Text(
                "Imposta il tuo percorso:",
                style: Theme.of(context).textTheme.headline6, //default headline styles
              ),
              Container(
                child: TextFormField( //differently from TextField this can be submitted (by clicking enter)
                  controller: start,  //textfield content
                  decoration: const InputDecoration(labelText: 'Partenza'),  //placeholder
                  textInputAction: TextInputAction.next,  //next button on keyboard
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), //indirectly set TextFormField width
              ),
              Container(
                child: TextFormField(
                  controller: end,  //textfield content
                  decoration: const InputDecoration(labelText: 'Arrivo'),  //placeholder
                  textInputAction: TextInputAction.search,  //send button on keyboard
                  onFieldSubmitted: (value) => nextPage(),  //submit using enter key from keyboard
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2), //indirectly set TextFormField width
              ),
              SizedBox(
                child: ElevatedButton(
                  child: const Text(
                    "Avanti",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(primary: error ? Colors.red : Colors.blue), //error in case of invalid location (detected in results.dart)
                ),
                width: 100.0,
                height: 40.0,
              ),
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