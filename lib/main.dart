import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:synpulse_challenge/screens/stock_search_screen/stock_search_screen.dart';
import 'api_manager.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/stock_detail_screen/stock_detail_screen.dart';
import 'screens/login_screen/login_screen.dart';

// APIKEY M8EGV7V9H8YDSROH
void main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

// Screen to manage all the screen
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String currentScreen;

  void login() async {
    final tickerList = await tickerListApi();
    tickerList.forEach((ticker) {
      tickers.add(
        Ticker(
          name: ticker['Name'],
          prices: [],
          symbol: ticker['Code'],
        ),
      );
    });
  }

  void setScreen(String screen) {
    currentScreen = screen;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    currentScreen = 'login';
  }

  Widget get _getScreen {
    switch (currentScreen) {
      case 'login':
        return LoginScreen();
      case 'dashboard':
        return SafeArea(
          child: DashboardScreen(
            setScreen: setScreen,
          ),
        );
      case 'stock detail':
        return SafeArea(
          child: StockDetailScreen(
            setScreen: setScreen,
            ticker: Ticker(
              name: 'GameStop',
              symbol: 'IBM',
              quote: {
                'change': -50,
                'change percent': -0.013,
                'price': 113,
              },
            ),
          ),
        );

      case 'stock search':
        return SafeArea(
          child: StockSearchScreen(
            setScreen: setScreen,
          ),
        );
      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _getScreen,
      ),
    );
  }
}
