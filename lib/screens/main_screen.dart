import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _items = ['Elemento 1', 'Elemento 2', 'Elemento 3'];

  LeagueService leagueService = LeagueService();

  Future<DefaultDto?> _createLeague(LeagueDto body) async {
    leagueService.postLeague(body).then((response) {
      if (response != null) {
        print("Liga creada: ${response.name}");
        return response;
      } else {
        print("Error al crear la liga.");
      }
    });

    return null;
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

  void _showAddOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController majorController = TextEditingController();
        bool isAddEnabled = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void updateButtonState() {
              setState(() {
                isAddEnabled =
                    nameController.text.trim().length > 2 &&
                    majorController.text.trim().length > 2;
              });
            }

            // Vinculamos los listeners a los controladores
            nameController.addListener(updateButtonState);
            majorController.addListener(updateButtonState);

            return AlertDialog(
              title: const Text('Crea tu propio torneo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Nombre del torneo',
                    ),
                  ),
                  TextField(
                    controller: majorController,
                    decoration: const InputDecoration(
                      labelText: 'Organizador',
                      hintText: 'Nombre del organizador del torneo',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed:
                      isAddEnabled
                          ? () {
                            Navigator.pop(context);

                            _createLeague(
                              LeagueDto(
                                name: nameController.text,
                                major: majorController.text,
                              ),
                            );
                          }
                          : null,
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
