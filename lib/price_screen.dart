import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'information.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future initialize() async {
    updateUI('INR');
  }

  int rate = 0;
  List<String> toCurrency = [];
  String selected = "INR";
  String crypto = 'BTC';

  void updateUI(dynamic data) {
    setState(() {
      if (data != null) {
        double value = data['rate'];
        rate = value.toInt();
        selected = data['asset_id_quote'];
      }
    });
  }

  Widget iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
      toCurrency.add(currency);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        selected = toCurrency[selectedIndex];
        var data = await Information().getConversion(toCurrency[selectedIndex]);
        updateUI(data);
      },
      children: pickerItems,
    );
  }

  Widget androidDropDownList() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      DropdownMenuItem<String> newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selected,
        items: dropDownItems,
        onChanged: (value) {
          setState(() async {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ConversionCard(
            rate: rate,
            selected: selected,
            from: 'BTC',
          ),
          ConversionCard(
            rate: rate,
            selected: selected,
            from: 'ETC',
          ),
          ConversionCard(
            rate: rate,
            selected: selected,
            from: 'LTC',
            trigger: () {},
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iosPicker() : androidDropDownList()),
        ],
      ),
    );
  }
}

class ConversionCard extends StatelessWidget {
  final int rate;
  final String selected;
  final String from;
  final Function trigger;

  ConversionCard({this.rate, this.selected, this.from, this.trigger});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $from = $rate $selected',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
