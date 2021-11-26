import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/stock.dart';
import 'package:synpulse_challenge/models/user.dart';
import 'package:synpulse_challenge/screens/stock_detail_screen/news_screen.dart';
import 'package:synpulse_challenge/screens/stock_search_screen/stock_search_screen.dart';
import 'api_manager.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/stock_detail_screen/stock_detail_screen.dart';
import 'screens/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synpulse Challenge',
      theme: ThemeData(
        primarySwatch: Colors.grey,
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
  late Ticker selectedTicker;

  void login() async {
    // final tickerList = await tickerListApi();
    // tickers = [];
    // tickerList.forEach((ticker) {
    //   tickers.add(
    //     Ticker(
    //       name: ticker['Name'],
    //       prices: {},
    //       symbol: ticker['Code'],
    //     ),
    //   );
    // });
    setScreen('dashboard');
  }

  void testFunction() async {
    firestore = FirebaseFirestore.instance;
    final doc = firestore.collection('users').doc('$testId');
    final data = await doc.get();
    appUser = AppUser(id: '$testId');
    appUser.savedTickerSymbols =
        data.data()!['savedTickerSymbols'].cast<String>();
    setState(() {});
  }

  void setScreen(String screen) {
    currentScreen = screen;
    setState(() {});
  }

  void setTicker(String symbol) async {
    selectedTicker = tickers.firstWhere((element) => element.symbol == symbol);
    if (selectedTicker.notGetQuote) {
      final quoteData = await tickerQuoteApi(selectedTicker.symbol);
      selectedTicker.quote = getQuote(quoteData);
    }
  }

  @override
  void initState() {
    appUser = AppUser(id: '');
    // testFunction();
    super.initState();
    currentScreen = 'login';
  }

  Widget get _getScreen {
    switch (currentScreen) {
      case 'login':
        return LoginScreen(login: login);
      case 'dashboard':
        return SafeArea(
          child: DashboardScreen(
            setScreen: setScreen,
            setTicker: setTicker,
          ),
        );
      case 'stock detail':
        return SafeArea(
          child: StockDetailScreen(
            setScreen: setScreen,
            ticker: selectedTicker,
          ),
        );

      case 'stock search':
        return SafeArea(
          child: StockSearchScreen(
            setScreen: setScreen,
            setTicker: setTicker,
          ),
        );
      case 'news':
        return SafeArea(
          child: NewsScreen(
            ticker: selectedTicker,
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
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: _getScreen,
        ),
      ),
    );
  }
}
