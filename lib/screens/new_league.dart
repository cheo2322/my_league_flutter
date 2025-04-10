import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';
import 'package:my_league_flutter/constants/constants.dart';

class NewLeague extends StatefulWidget {
  const NewLeague({super.key});

  @override
  State<NewLeague> createState() => _NewLeagueState();
}

class _NewLeagueState extends State<NewLeague> {
  TextEditingController nameController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  TextEditingController customLocationController = TextEditingController();

  bool isButtonEnabled = false;
  bool isLoading = false;

  bool isCustomLocationChecked = false;
  bool isMultipleLocationsChecked = false;

  String? selectedProvince;
  String? selectedCity;

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

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.trim().length > 2 &&
          organizerController.text.trim().length > 2;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateButtonState);
    organizerController.addListener(updateButtonState);
    customLocationController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    nameController.dispose();
    organizerController.dispose();
    customLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu propio torneo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'No te preocupes si no tienes todos los datos, por ahora, sólo las casillas marcadas con * son obligatorias.',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Información general del torneo',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del torneo *',
                  hintText: 'Ingresa el nombre del torneo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: organizerController,
                decoration: const InputDecoration(
                  labelText: 'Organizador *',
                  hintText: 'Ingresa el nombre del organizador',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Lugar a desarrollarse el torneo',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Provincia',
                  border: OutlineInputBorder(),
                ),
                value: selectedProvince,
                items:
                    ecuadorLocations.keys
                        .map(
                          (province) => DropdownMenuItem(
                            value: province,
                            child: Text(province),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProvince = value;
                    selectedCity = null;
                  });
                  updateButtonState();
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
                value: selectedCity,
                items:
                    selectedProvince == null
                        ? []
                        : ecuadorLocations[selectedProvince]!
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                  updateButtonState();
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Si tu cuidad/provincia no aparece en la lista, puedes ingresarlas aquí',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customLocationController,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa la ciudad/provincia',
                        labelText: 'Lugar del torneo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Selecciona la casilla de abajo si el torneo se desarrolla en varias ciudades/provincias',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  Checkbox(
                    value: isMultipleLocationsChecked,
                    onChanged: (value) {
                      setState(() {
                        isMultipleLocationsChecked = value!;
                      });
                      updateButtonState();
                    },
                  ),
                  Flexible(
                    child: const Text(
                      'El torneo se desarrolla en varias ciudades y/o provincias',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customLocationController,
                      decoration: const InputDecoration(
                        labelText: 'Si deseas, especifica el lugar del torneo',
                        hintText: 'Parroquia, barrio, etc',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  isButtonEnabled
                      ? () {
                        print('Pressed Siguiente');
                        // Lógica adicional para el botón "Siguiente"
                      }
                      : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Siguiente'),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
