import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/match_dto.dart';

class NewRound extends StatefulWidget {
  final DefaultDto leagueDto;

  const NewRound({super.key, required this.leagueDto});

  @override
  State<NewRound> createState() => _NewRoundState();
}

class _NewRoundState extends State<NewRound> {
  final List<MatchDto> _matches = [];

  void _addMatch(MatchDto match) {
    setState(() {
      _matches.add(match);
    });
  }

  void _showAddMatchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: _PartidoForm(onConfirm: _addMatch),
        );
      },
    );
  }

  void _confirmCreation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("¿Crear esta fecha?"),
            content: Text("Se crearán ${_matches.length} partidos."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Aquí podrías enviar los datos al backend o continuar el flujo
                  print("✅ Fecha creada con ${_matches.length} partidos");
                },
                child: const Text("Confirmar"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Crear una nueva fecha",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _matches.isEmpty
                    ? const Center(child: Text("Aún no has agregado partidos."))
                    : ListView.builder(
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final match = _matches[index];
                        return ListTile(
                          title: Text("${match.homeTeam} vs ${match.visitTeam}"),
                          subtitle: Text("${match.date} - ${match.time}"),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddMatchModal,
                icon: const Icon(Icons.add),
                label: const Text("Agregar partido"),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _matches.isNotEmpty
              ? FloatingActionButton(onPressed: _confirmCreation, child: const Icon(Icons.check))
              : null,
    );
  }
}

class _PartidoForm extends StatefulWidget {
  final void Function(MatchDto) onConfirm;

  const _PartidoForm({required this.onConfirm});

  @override
  State<_PartidoForm> createState() => _PartidoFormState();
}

class _PartidoFormState extends State<_PartidoForm> {
  String? equipoLocal;
  String? equipoVisitante;
  DateTime? fecha;
  TimeOfDay? hora;

  final List<String> equipos = ["Equipo A", "Equipo B", "Equipo C"];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Equipo local"),
          items: equipos.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => equipoLocal = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Equipo visitante"),
          items: equipos.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() => equipoVisitante = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                fecha != null
                    ? "Fecha: ${fecha!.toLocal().toString().split(' ')[0]}"
                    : "Selecciona una fecha",
              ),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => fecha = picked);
              },
              child: const Text("Elegir fecha"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(hora != null ? "Hora: ${hora!.format(context)}" : "Selecciona una hora"),
            ),
            TextButton(
              onPressed: () async {
                final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (picked != null) setState(() => hora = picked);
              },
              child: const Text("Elegir hora"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (equipoLocal != null &&
                equipoVisitante != null &&
                fecha != null &&
                hora != null &&
                equipoLocal != equipoVisitante) {
              final match = MatchDto(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                homeTeam: equipoLocal!,
                visitTeam: equipoVisitante!,
                homeResult: 0,
                visitResult: 0,
                status: "pendiente",
                date: fecha!.toIso8601String().split("T")[0],
                time: hora!.format(context),
              );
              widget.onConfirm(match);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Completa todos los campos correctamente")),
              );
            }
          },
          child: const Text("Confirmar"),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
