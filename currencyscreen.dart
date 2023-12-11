import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'currency_data.dart';
import 'currency_provider.dart'; // Import the CurrencyProvider class

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}
class _CurrencyScreenState extends State<CurrencyScreen> {
  late ScrollController _scrollController;
  late Timer _autoScrollTimer;
  Temperatures? _temperatures;
//  late ScrollController _scrollController;
  int _selectedItemIndex = 0;
  String _selectedCurrencyCode = '';
  String _selectedCurrencyRate = '';
 // late Timer _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchData();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      context.read<CurrencyProvider>().setSelectedItemIndex(
          (context.read<CurrencyProvider>().selectedItemIndex + 1) %
              context.read<CurrencyProvider>().temperatures!.bpi.currencies.length);
      _scrollToSelectedIndex();
    });
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperatures = Temperatures.fromJson(data);
        context.read<CurrencyProvider>().setTemperatures(temperatures);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _scrollToSelectedIndex() {
    _scrollController.animateTo(
      context.read<CurrencyProvider>().selectedItemIndex * 120.0,
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
              child: ListWheelScrollView.useDelegate(
                itemExtent: 120,
                diameterRatio: 1.2,
                controller: _scrollController,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    _selectedItemIndex = index;
                    _selectedCurrencyCode = _temperatures!.bpi.currencies[index].code;
                    _selectedCurrencyRate = _temperatures!.bpi.currencies[index].rate;
                  });
                },
    childDelegate: ListWheelChildLoopingListDelegate(
    children: List<Widget>.generate(
    _temperatures!.bpi.currencies.length,
    (index) {
    final currency = _temperatures!.bpi.currencies[index];
    return _buildCurrencyCard(currency);
    },
    ),
    ),
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
  /*ListWheelScrollView.useDelegate(
  itemExtent: 120,
  diameterRatio: 1.2,
  controller: _scrollController,
  onSelectedItemChanged: (int index) {
  setState(() {
  _selectedItemIndex = index;
  _selectedCurrencyCode = _temperatures!.bpi.currencies[index].code;
  _selectedCurrencyRate = _temperatures!.bpi.currencies[index].rate;
  });
  },
  childDelegate: ListWheelChildLoopingListDelegate(
  children: List<Widget>.generate(
  _temperatures!.bpi.currencies.length,
  (index) {
  final currency = _temperatures!.bpi.currencies[index];
  return _buildCurrencyCard(currency);
*/
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
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

