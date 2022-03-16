library collect_api;

import '/includes/lib.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

const _endpoint = 'https://api.collectapi.com/gasPrice/europeanCountries';  //API not working for other available countries (e.g. coordinates endpoint)
const _key = '0qnJj0AVQTBTB2atEVFYD5:6qH3sdNHp5ZPiQlU0rgLCD'; //API key from account at https://www.collectapi.com

Future<double> requestFuelPrice(FuelInfo fuel) async {
  if(fuel.consumption <= 0) {
    throw const RuntimeException("Consumo del mezzo di trasposto non valido");  //should not be possible anyway due to textfield limitations
  }

  String type = fuel.fuelType.name; //convert enum to string

  //in case of non-matching name between FuelEnum and collect api
  // if(fuel.fuelType == FuelEnum.gasoline) {
  //   type = "gasoline";
  // } else if(fuel.fuelType == FuelEnum.diesel) {
  //   type = "diesel";
  // } else {  //FuelEnum.lpg
  //   type = "lpg";
  // }

  const String request = _endpoint; //conversion in case of query string needed in future
  final headers = <String, String>{ 'authorization': 'apikey ' + _key };  //header for authorization

  final response = await http.get(Uri.parse(request), headers: headers);  //api request

  dynamic responseJson;
  try {
    responseJson = json.decode(response.body);  //format exception in case of Unauthorized error (non json-formatted)

  } on FormatException {
    throw const RuntimeException("Chiave di accesso all'API non valida");
  }

  if (responseJson['success'] == true) {
    dynamic results = responseJson['results'];

    for(int i = 0; i < (results as List<dynamic>).length; i++) {  //loop through european countries
      if(results[i]['country'] == "Italy") {  //return fuel price for Italy only
        return double.parse(results[i][type].toString().replaceAll(",", '.')); //replace comma with dot
      }
    }

    throw const RuntimeException("Impossibile trovare il prezzo del carburante in Italia");

  } else if (responseJson['error'] != null) { //I found two possible error messages
    throw RuntimeException(responseJson['error']);

  } else if (responseJson['message'] != null) {
    throw RuntimeException(responseJson['message']);

  } else {
    throw const RuntimeException("Unknown error");
  }
}