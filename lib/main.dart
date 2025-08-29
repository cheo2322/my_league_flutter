import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_league_flutter/screens/main_screen.dart';
import 'package:my_league_flutter/screens/second_page.dart';
import 'package:my_league_flutter/screens/third_page.dart';
import 'package:my_league_flutter/widgets/user_drawer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();

  final List<Widget> _pages = [const MainScreen(), const MyField(), const ThirdPage()];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        // Cuando el teclado se cierra, ocultar la barra de búsqueda.
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading:
            _isSearching
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
                : null,
        // TODO: Add logic for Search bar
        title: Text(
          _selectedIndex == 0
              ? 'Principal'
              : _selectedIndex == 1
              ? 'Mi cancha'
              : 'Notificaciones',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 3,
        centerTitle: true,
      ),
      drawer: UserDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.futbol), label: 'Partidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mi cancha'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
