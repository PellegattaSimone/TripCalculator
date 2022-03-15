import 'package:flutter/material.dart';

import 'package:flutter/services.dart'; //FilteringTextInputFormatter

import '/lib.dart';
import '/routes/user_path.dart';

class FuelType extends StatefulWidget {
  static const routeName = '/fuel_type';  //for navigator

  const FuelType({Key? key}) : super(key: key);

  @override
  _FuelTypeState createState() => _FuelTypeState();
}

class _FuelTypeState extends State<FuelType> implements AppPage {
  static const List<String> values = <String>["Scegli un tipo di carburante", "Benzina", "Diesel", "Gas metano"]; //values[0] can't be selected as final choice

  final TextEditingController fuelPrice = TextEditingController(text: "11");  //default value

  String? dropDownValue;  //current selected fuel type

  _FuelTypeState() {
    dropDownValue = values[0];
  }

  @override
  void nextPage() {
    if(dropDownValue != null && dropDownValue != values[0] && fuelPrice.text.isNotEmpty) {
      FuelEnum fuelType;  //convert text to enum fuelType choice
      if(dropDownValue == values[1]) {  //can't use switch statement non non-const values
        fuelType = FuelEnum.gasoline;

      } else if(dropDownValue == values[2]) {
        fuelType = FuelEnum.diesel;

      } else {
        fuelType = FuelEnum.lpg;
      }

      final FuelInfo data = FuelInfo(fuelType, double.parse(fuelPrice.text)); //data to be sent to userPath

      Navigator.pushNamed(  //load userPath route
        context, 
        UserPath.routeName,
        arguments: data,  //push partial data to userPath (it will add more data and send to results)
      );
    }
  }

  @override
  void goToHome() { //push home on top of the stack (cannot go back from there)
    Navigator.pushNamed(
      context,
      AppPage.home, //costant defined in lib.dart
    );
  }

  void setDropDownValue(String? newValue) {
    if(newValue != values[0]) { //can't select label text
      setState(() => dropDownValue = newValue);
      nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Calculator")), //at the moment same everywhere
      body: Center(
        child: Padding(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    child: Text(
                      "Scegli il tipo di carburante:",
                      style: Theme.of(context).textTheme.headline6, //default headline styles
                    ),
                    height: MediaQuery.of(context).size.height * 0.07,  //distance between label and dropdown menu
                  ),
                  DropdownButton(
                    value: dropDownValue, //current selected fuel type
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                    underline: Container(
                      color: Colors.blue,
                      height: 2,
                    ),
                    onChanged: setDropDownValue,  //update dropdown many value
                    items: values //constant defined on top of class
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  Align(  //allows to change the textfield width
                    child: SizedBox(
                      child: TextField(
                        controller: fuelPrice,  //textfield content
                        decoration: const InputDecoration(labelText: 'Consumo'),  //placeholder
                        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true), //for smartphone keyboard
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, //only allow numeric values
                          LengthLimitingTextInputFormatter(3),  //maximum of three digits
                        ], //only numbers can be entered (in case of physical keyboard)
                        style: const TextStyle(fontSize: 16),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3, //textfield width
                    ),
                    alignment: Alignment.center,  //center the textfield inside row (MainAxisAlignment not enough)
                  ),
                  const Text("km/L"), //label next to textfield
                ],
                mainAxisAlignment: MainAxisAlignment.center,
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