import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/web/main_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final List<Tab> tabs = [Tab(icon: Icon(Icons.star)), Tab(icon: Icon(Icons.location_on))];

  final MainService _mainService = MainService();

  List<RoundDto> _rounds = [];

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
                  // Favourites Tab
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _rounds.isEmpty
                      ? Builder(builder: (context) => _buildDefaultTab(context))
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

                  // Near to you Tab
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

  Center _buildDefaultTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search,
            size: 48,
            color: Colors.grey,
          ), // TODO: make it open the search bar
          const SizedBox(height: 12),
          const Text(
            "Aún no tienes favoritos",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              final controller = DefaultTabController.of(context);
              controller.animateTo(1);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on, size: 20, color: Colors.blueGrey),
                SizedBox(width: 4),
                Text(
                  "Buscar partidos cerca de ti",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> readSavedCredentials() async {
    token = await secureStorage.read(key: 'auth_token');
    username = await secureStorage.read(key: 'username');
  }

  Future<void> _initializeScreen() async {
    await readSavedCredentials();

    if (token != null && username != null) {
      await _fetchFavourites();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchFavourites() async {
    final favourites = await _mainService.getFavourites(token!);

    if (favourites != null) {
      setState(() {
        _rounds = favourites.leagues.map((league) => league.roundDto).toList();
      });
    }
  }
}
