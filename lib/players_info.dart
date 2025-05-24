import 'package:flutter/material.dart';

import 'game_panel.dart';

class PlayersInfoScreen extends StatefulWidget {
  @override
  _PlayersInfoScreenState createState() => _PlayersInfoScreenState();
}

class _PlayersInfoScreenState extends State<PlayersInfoScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  List<String> heroesList = [];

  void swapPlayers() {
    String temp = player1Controller.text;
    player1Controller.text = player2Controller.text;
    player2Controller.text = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Players Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: TextField(
                  controller: player1Controller,
                  decoration: InputDecoration(labelText: 'Player 1'),
                ),
                trailing: CircleAvatar(backgroundColor: Colors.blue),
              ),
            ),
            IconButton(icon: Icon(Icons.swap_vert), onPressed: swapPlayers),
            Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: TextField(
                  controller: player2Controller,
                  decoration: InputDecoration(labelText: 'Player 2'),
                ),
                trailing: CircleAvatar(backgroundColor: Colors.red),
              ),
            ),
            SizedBox(height: 20),
            Text('Heroes List:'),
            Expanded(
              child: ListView.builder(
                itemCount: heroesList.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(heroesList[index]));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => GamePanelScreen(
                    player1: player1Controller.text,
                    player2: player2Controller.text,
                  ),
            ),
          );

          if (result != null && result is String) {
            setState(() {
              heroesList.add(result);
            });
          }
        },
      ),
    );
  }
}
