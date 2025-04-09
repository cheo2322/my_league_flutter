import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _items = ['Elemento 1', 'Elemento 2', 'Elemento 3'];

  void _showAddOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sports_soccer, color: Colors.green),
                title: const Text('Agregar Campeonato'),
                onTap: () {
                  Navigator.pop(context); // Cerrar el diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opción: Agregar Campeonato seleccionada'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.people, color: Colors.blue),
                title: const Text('Agregar Equipo'),
                onTap: () {
                  Navigator.pop(context); // Cerrar el diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opción: Agregar Equipo seleccionada'),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partidos')),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_items[index]} seleccionado')),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        tooltip: 'Agregar opciones',
        child: const Icon(Icons.add),
      ),
    );
  }
}
