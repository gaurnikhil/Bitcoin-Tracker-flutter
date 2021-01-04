import 'package:flutter/material.dart';
import 'Networking.dart';

class Information {
  Future getConversion(String to) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$to?apikey=A87B10B8-2727-480F-9897-FDC5B2B7F91F';

    NetworkHelper networkHelper = NetworkHelper(url);

    var data = await networkHelper.getData();

    return data;
  }
}
