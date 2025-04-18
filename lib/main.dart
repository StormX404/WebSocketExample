import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_example/widgets/price_data.dart';
import 'package:web_socket_example/widgets/chart_card.dart';
import 'package:web_socket_example/widgets/custom_background.dart';
import 'package:web_socket_example/widgets/quantity_card.dart';
import 'package:web_socket_example/widgets/time_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  late WebSocketChannel channel;
  Timer? timer;

  String price = '';
  String rate = '';
  String time = '';

  final List<FlSpot> spots = [];
  final int maxSpots = 60;
  double xValue = 0;
  double lastParsedPrice = 0;

  @override
  void initState() {
    super.initState();
    int days = 7;
    connectToBinance();
    startMinuteTimer();

    fetchHistoricalPrices(days).then((prices) {
      setState(() {
        spots.addAll(convertToSpots(prices));
        xValue = spots.length.toDouble();
      });
    });
  }

  void connectToBinance() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://fstream.binance.com/stream?streams=btcusdt@markPrice'),
    );

    channel.stream.listen((message) {

      final parsed = jsonDecode(message);
      final data = parsed['data'];

      final String markPrice = data['p'];
      final String fundingRate = data['P'];
      final timestamp = data['E'];

      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formattedTime = DateFormat('hh:mm:ss').format(date);

      setState(() {
        price = markPrice;
        time = formattedTime;
        rate  = fundingRate;
        lastParsedPrice = double.tryParse(markPrice) ?? 0;
      });
    }, onError: (error) {
      print('❌ WebSocket error: $error');
    }, onDone: () {
      print('❌ WebSocket closed');
    });
  }


  void startMinuteTimer() {
    timer = Timer.periodic(Duration(minutes: 1), (_) {
      setState(() {
        spots.add(FlSpot(xValue, lastParsedPrice));
        xValue += 1;
        if (spots.length > maxSpots) spots.removeAt(0);
      });
    });
  }

  Future<List<double>> fetchHistoricalPrices(int days) async {
    final uri = Uri.parse(
      'https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1d&limit=$days',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => double.parse(e[4])).toList();
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  List<FlSpot> convertToSpots(List<double> prices) {
    return List.generate(prices.length, (i) => FlSpot(i.toDouble(), prices[i]));
  }

  @override
  void dispose() {
    channel.sink.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BTC/USDT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 2),
            const Text(
              'Live',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0A0A0A),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceData(price: price),
                ChartCard(spots: spots),
                FundingRateCard(rate: rate),
                TimeCard(time: time)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
