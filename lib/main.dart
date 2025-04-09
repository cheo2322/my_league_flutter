import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    const FirstPage(),
    const SecondPage(),
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
                      ? 'Página de Balón'
                      : 'Página de Notificaciones',
                ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menú Deslizable'),
            ),
            ListTile(
              title: const Text('Opción 1'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opción 1 seleccionada')),
                );
              },
            ),
            ListTile(
              title: const Text('Opción 2'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opción 2 seleccionada')),
                );
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.futbol),
            label: 'Cancha',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Balón',
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

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página de Cancha'));
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página de Balón'));
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Página de Notificaciones'));
  }
}
