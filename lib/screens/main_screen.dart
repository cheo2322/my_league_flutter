import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/web/league_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<RoundDto> _rounds = [];
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final List<Tab> tabs = [Tab(icon: Icon(Icons.star)), Tab(icon: Icon(Icons.location_on))];

  bool isLoading = true;
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();

    _initializeScreen();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: primaryColor,
              child: TabBar(
                tabs: tabs,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                unselectedLabelColor: Colors.white,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _rounds.isEmpty
                      ? const Center(child: Text("No hay partidos disponibles"))
                      : ListView.builder(
                        itemCount: _rounds.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RoundCard(
                              round: _rounds[index],
                              title:
                                  '${_rounds[index].leagueName} - ${_rounds[index].phase} (Fecha ${_rounds[index].order})',
                              isRoundSelectable: true,
                            ),
                          );
                        },
                      ),
                  const Center(child: Text("Cerca de ti - En desarrollo")),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton:
            (token != null && username != null)
                ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewLeague()));
                  },
                  tooltip: 'Agregar',
                  backgroundColor: primaryColor,
                  splashColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.white),
                )
                : null,
      ),
    );
  }

  Future<void> _fetchRounds() async {
    final service = LeagueService();
    final rounds = await service.getMainPage();

    if (mounted) {
      setState(() {
        _rounds.addAll(rounds);
        isLoading = false;
      });
    }
  }

  Future<void> readSavedCredentials() async {
    token = await secureStorage.read(key: 'auth_token');
    username = await secureStorage.read(key: 'username');
  }

  Future<void> _initializeScreen() async {
    await readSavedCredentials();

    if (token != null && username != null) {
      await _fetchRounds();
    }

    setState(() {
      isLoading = false;
    });
  }
}
