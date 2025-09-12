import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/match_dto.dart';
import 'package:my_league_flutter/web/team_service.dart';

class NewRound extends StatefulWidget {
  final DefaultDto leagueDto;

  const NewRound({super.key, required this.leagueDto});

  @override
  State<NewRound> createState() => _NewRoundState();
}

class _NewRoundState extends State<NewRound> {
  TeamService teamService = TeamService();

  final List<DefaultDto> teams = [];
  final List<MatchDto> _matches = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadTeams();
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : teams.isEmpty
              ? const Center(child: Text("No hay equipos en esta liga."))
              : _buildMainContent(primaryColor),
    );
  }

  Column _buildMainContent(Color primaryColor) {
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAddMatchModal,
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar partido"),
                ),
              ),
              const SizedBox(height: 8),
              if (_matches.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _confirmCreation,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("Crear fecha", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

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
          child: _PartidoForm(onConfirm: _addMatch, teams: teams),
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
                  // print("✅ Fecha creada con ${_matches.length} partidos");
                },
                child: const Text("Confirmar"),
              ),
            ],
          ),
    );
  }

  void _loadTeams() async {
    final teamDtos = await teamService.getTeamsFromLeague(widget.leagueDto.id);

    setState(() {
      teams.addAll(teamDtos.map((dto) => dto).toList());
      isLoading = false;
    });
  }
}

class _PartidoForm extends StatefulWidget {
  final void Function(MatchDto) onConfirm;
  final List<DefaultDto> teams;

  const _PartidoForm({required this.onConfirm, required this.teams});

  @override
  State<_PartidoForm> createState() => _PartidoFormState();
}

class _PartidoFormState extends State<_PartidoForm> {
  String? homeTeam;
  String? homeTeamId;
  String? awayTeam;
  String? awayTeamId;
  DateTime? fecha;
  TimeOfDay? hora;

  @override
  Widget build(BuildContext context) {
    final equiposLocalDisponibles = widget.teams.where((e) => e.name != awayTeam).toList();
    final equiposVisitanteDisponibles = widget.teams.where((e) => e.name != homeTeam).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Equipo local"),
          items:
              equiposLocalDisponibles
                  .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                  .toList(),
          onChanged: (value) {
            setState(() {
              homeTeam = value;
              if (awayTeam == value) awayTeam = null;
            });
          },
          value: homeTeam,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Equipo visitante"),
          items:
              equiposVisitanteDisponibles
                  .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                  .toList(),
          onChanged: (value) {
            setState(() {
              awayTeam = value;
              if (homeTeam == value) homeTeam = null;
            });
          },
          value: awayTeam,
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
            if (homeTeam != null &&
                awayTeam != null &&
                fecha != null &&
                hora != null &&
                homeTeam != awayTeam) {
              final match = MatchDto(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                homeTeam: homeTeam!,
                visitTeam: awayTeam!,
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
