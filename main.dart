import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'currency_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: CurrencyScreen(),
    );
  }
}

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}
class _CurrencyScreenState extends State<CurrencyScreen> {
  Temperatures? _temperatures;
  late ScrollController _scrollController;
  int _selectedItemIndex = 0;
  String _selectedCurrencyCode = '';
  String _selectedCurrencyRate = '';
  late Timer _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchData();
    // Set up an auto-scroll timer
    _autoScrollTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      // Auto-scroll to the next item
      _selectedItemIndex = (_selectedItemIndex + 1) % _temperatures!.bpi.currencies.length;
      _scrollToSelectedIndex();

      // Update the selected currency code and rate
      _selectedCurrencyCode = _temperatures!.bpi.currencies[_selectedItemIndex].code;
      _selectedCurrencyRate = _temperatures!.bpi.currencies[_selectedItemIndex].rate;

      // Trigger a rebuild to update the UI
      setState(() {});
    });
  }
  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _autoScrollTimer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperatures = Temperatures.fromJson(data);

        setState(() {
          _temperatures = temperatures;
          _selectedCurrencyCode = temperatures.bpi.currencies[_selectedItemIndex].code;
          _selectedCurrencyRate = temperatures.bpi.currencies[_selectedItemIndex].rate;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  void _scrollToSelectedIndex() {
    _scrollController.animateTo(
      _selectedItemIndex * 120.0, // itemExtent
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar( backgroundColor: Colors.lightBlueAccent,
        title:Center(child: Text('Bitcoin Tracker',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
      ),
      body: Column(
        children: [
          Center( child: Container( padding: EdgeInsets.fromLTRB(10, 20, 10, 10), width: 200, height:150,child:Image.network(
              'https://tse1.mm.bing.net/th?id=OIP.GQieQka4wpoC4CPZRooffwHaHa&pid=Api&P=0&h=180')) ,

          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press, e.g., update price for the selected currency
                //print('Selected currency code: $_selectedCurrencyCode');
                print('Selected currency rate: $_selectedCurrencyRate');
                // You can add logic here to update the price based on the selected currency
              },
              child: Text('$_selectedCurrencyRate'),
            ),
          ),
          _temperatures != null
              ? Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              child: ListWheelScrollView(
                itemExtent: 120,
                diameterRatio: 1.2,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedItemIndex = index;
                    _selectedCurrencyCode = _temperatures!.bpi.currencies[index].code;
                    _selectedCurrencyRate = _temperatures!.bpi.currencies[index].rate;
                  });
                },
                children: _temperatures!.bpi.currencies.map((currency) {
                  return _buildCurrencyCard(currency);
                }).toList(),
              ),
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(Eur currency) {
    return GestureDetector(
      onTap: () {
        // Handle item selection as needed
        setState(() {
          _selectedItemIndex = _temperatures!.bpi.currencies.indexOf(currency);
          _selectedCurrencyCode = currency.code;
          _selectedCurrencyRate = currency.rate;
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        color: _selectedItemIndex == _temperatures!.bpi.currencies.indexOf(currency)
            ? Colors.orange
            : Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${currency.code}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




