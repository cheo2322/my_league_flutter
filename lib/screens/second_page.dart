import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';

class MyField extends StatefulWidget {
  const MyField({super.key});

  @override
  State<StatefulWidget> createState() => _MyFieldState();
}

class _MyFieldState extends State<MyField> {
  LeagueService leagueService = LeagueService();
  List<DefaultDto> leagues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    leagueService.getLeagues().then((response) {
      setState(() {
        leagues = response;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: leagues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(leagues[index].name),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${leagues[index].id} selected'),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
