library bing_map_portals;

import '/includes/lib.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

const _endpoint = 'http://dev.virtualearth.net/REST/v1/Routes/Driving'; //API offered by bing maps portal
const _key = 'AinV9t1-LwtOyehdg7nQtKNg-XsHKCgVFZDbxwETMpMXHpE9MkoDMnAyIfToWIX3';  //API key from account at https://www.bingmapsportal.com/

const _optimize = 'distance'; //optimize path by shortest distance or time
const int _maxSolutions = 1;  //maximum possible paths
const _distanceUnit = 'km'; //either km or mi

class PathInfo {
  double distanceTraveled;
  String startLocation;
  String endLocation;

  PathInfo(this.distanceTraveled, this.startLocation, this.endLocation);
}

Future<PathInfo> requestPath(String start, String end) async {
  if(start == '') {
    throw const RuntimeException("Inserire il punto di partenza");
  }
  if(end == '') {
    throw const RuntimeException("Inserire il punto di arrivo");
  }

  final String request = _endpoint +
    '?wp.1=' + start +  //starting point
    '&wp.2=' + end +  //destination (there can be up to 25 waypoints)
    '&optimize=' + _optimize +
    '&maxSolutions=' + _maxSolutions.toString() + 
    '&distanceUnit=' + _distanceUnit +
    '&key=' + _key;

  final response = await http.get(Uri.parse(request));  //api request
  final responseJson = json.decode(response.body);

  if (responseJson['statusCode'] == 200) {  //successful request
    double distanceTraveled = responseJson['resourceSets'][0]['resources'][0]['travelDistance'];  //every map contains a one-element list accessed using [0]
    String startLocation = responseJson['resourceSets'][0]['resources'][0]['routeLegs'][0]['startLocation']['name'];
    String endLocation = responseJson['resourceSets'][0]['resources'][0]['routeLegs'][0]['endLocation']['name'];

    return PathInfo(distanceTraveled, startLocation, endLocation);

  } else if (responseJson['errorDetails'] != null) {
    throw RuntimeException(responseJson['errorDetails'][0]);

  } else {
    throw const RuntimeException("Unknown error");
  }
}