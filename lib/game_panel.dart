import 'package:flutter/material.dart';

class GamePanelScreen extends StatefulWidget {
  final String player1;
  final String player2;

  GamePanelScreen({required this.player1, required this.player2});

  @override
  _GamePanelScreenState createState() => _GamePanelScreenState();
}

class _GamePanelScreenState extends State<GamePanelScreen> {
  List<List<String>> _board = List.generate(
    3,
    (_) => List.generate(3, (_) => ''),
  );
  bool _player1Turn = true;
  int _player1Score = 0;
  int _player2Score = 0;
  int _round = 1;

  void _resetBoard() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _round = 1;
      _player1Turn = true;
      _player1Score = 0;
      _player2Score = 0;
    });
  }

  void _exitGame() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  String _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != '' &&
          _board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2]) {
        return _board[i][0];
      }
    }
    for (int i = 0; i < 3; i++) {
      if (_board[0][i] != '' &&
          _board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i]) {
        return _board[0][i];
      }
    }
    if (_board[0][0] != '' &&
        _board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2]) {
      return _board[0][0];
    }
    if (_board[0][2] != '' &&
        _board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0]) {
      return _board[0][2];
    }
    return '';
  }

  void _handleTap(int row, int col) {
    if (_board[row][col] != '') {
      return;
    }

    setState(() {
      _board[row][col] = _player1Turn ? 'X' : 'O';
      String winner = _checkWinner();

      if (winner != '') {
        if (winner == 'X') {
          _player1Score += 3;
        } else {
          _player2Score += 3;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Congratulations!'),
              content: Text(
                '${_player1Turn ? widget.player1 : widget.player2} won (+3 points)',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _board = List.generate(
                        3,
                        (_) => List.generate(3, (_) => ''),
                      );
                      _round++;
                      _player1Turn = !_player1Turn;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (_board.every((row) => row.every((cell) => cell != ''))) {
        _player1Score++;
        _player2Score++;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Draw!'),
              content: Text('One point for each player'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _board = List.generate(
                        3,
                        (_) => List.generate(3, (_) => ''),
                      );
                      _round++;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _player1Turn = !_player1Turn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Panel'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.player1} Score: $_player1Score',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                Text(
                  '${widget.player2} Score: $_player2Score',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Round: $_round',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Turn: ${_player1Turn ? widget.player1 : widget.player2} (${_player1Turn ? 'X' : 'O'})',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => _handleTap(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          _board[row][col],
                          style: TextStyle(
                            fontSize: 53,
                            color:
                                _board[row][col] == 'X'
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _resetBoard,
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
                ElevatedButton(
                  onPressed: _exitGame,
                  child: Text('Exit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
