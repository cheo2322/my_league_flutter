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
    return const MaterialApp(home: HomePage());
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
  final FocusNode _searchFocusNode =
      FocusNode(); // Para detectar el cierre del teclado.

  final List<Widget> _pages = [
    const MainScreen(),
    const MyField(),
    const ThirdPage(),
  ];

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
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
              ? 'Partidos'
              : _selectedIndex == 1
              ? 'Mi cancha'
              : 'Notificaciones',
        ),
        elevation: 3,
        centerTitle: true,
      ),
      drawer: UserDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.futbol),
            label: 'Partidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Mi cancha',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
