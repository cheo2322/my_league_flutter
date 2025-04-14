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
        leading:
            _isSearching
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false; // Cerrar la barra de búsqueda.
                    });
                  },
                )
                : null,
        title:
            _selectedIndex == 0
                ? _isSearching
                    ? TextField(
                      focusNode: _searchFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Buscar...',
                        border: InputBorder.none,
                      ),
                      autofocus: true,
                      onSubmitted: (value) {
                        // Lógica de búsqueda
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Buscando: $value')),
                        );
                      },
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          child: const Icon(Icons.search),
                        ),
                      ],
                    )
                : Text(
                  _selectedIndex == 1
                      ? 'Mi cancha'
                      : 'Página de Notificaciones',
                ),
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
