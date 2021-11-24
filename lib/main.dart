import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/stock_detail_screen/stock_detail_screen.dart';
import 'screens/login_screen/login_screen.dart';

// APIKEY M8EGV7V9H8YDSROH
void main() {
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

  @override
  void initState() {
    super.initState();
    currentScreen = 'stock detail';
  }

  Widget get _getScreen {
    switch (currentScreen) {
      case 'login':
        return LoginScreen();
      case 'dashboard':
        return SafeArea(
          child: DashboardScreen(),
        );
      case 'stock detail':
        return SafeArea(
          child: StockDetailScreen(),
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
