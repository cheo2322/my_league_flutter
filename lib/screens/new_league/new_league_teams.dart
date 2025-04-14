import 'package:flutter/material.dart';
import 'package:my_league_flutter/screens/main_screen.dart';

class NewLeagueTeams extends StatelessWidget {
  final String leagueId;

  const NewLeagueTeams({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final salir = await _mostrarAlerta(context);
        if (salir) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Agregar equipos')),
        body: Center(child: Text('League ID: $leagueId')),
      ),
    );
  }

  Future<bool> _mostrarAlerta(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¿Salir?'),
              content: Text(
                'No te preocupes, puedes continuar editando tu torneo después. Sólo buscalo en la sección \'Mi torneo\' desde la pantalla principal.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí, salir'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Seguir editando'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
