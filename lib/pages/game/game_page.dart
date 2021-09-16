import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;
  final TextEditingController _controller = TextEditingController();
  String? _guessNumber;
  String? _feedback;

  //bool _isNum = true;

  @override
  void initState() {
    //initialize ค่่า
    super.initState();
    _game = Game();
  }

  @override
  void dispose() {
    //เก็บกวาดค่า

    _controller.dispose();
    super.dispose();
  }

  void newGame() {
    setState(() {
      _controller.clear();
      _guessNumber = null;
      _feedback = null;
      _game = Game();
    });
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please enter the number."),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUESS THE NUMBER'),
      ),
      body: Container(
        color: Colors.yellow.shade100,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(),
              _buildMainContent(),
              _buildInputPanel()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputPanel() {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple.shade300,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(5.0, 0.0),
                  color: Colors.grey,
                  spreadRadius: 3,
                  blurRadius: 5.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  enabled: !_game.isGameOver,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: Colors.yellow,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    isDense: true,
                    // กำหนดลักษณะเส้น border ของ TextField ในสถานะปกติ
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    // กำหนดลักษณะเส้น border ของ TextField เมื่อได้รับโฟกัส
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Enter the number here',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: !_game.isGameOver
                      ? () {
                          setState(() {
                            //_guessNumber = _controller.text;
                            int? guess = int.tryParse(_controller.text);
                            print(guess);
                            if (guess != null) {
                              _guessNumber = _controller.text;
                              var result = _game.doGuess(guess);
                              if (result == 0) {
                                // ทายถูก
                                _feedback = 'CORRECT!';
                                _showMaterialDialog(
                                    "GOOD JOB!", _game.getListGuess());
                              } else if (result == 1) {
                                // ทายมากไป
                                _feedback = 'TOO HIGH!';
                              } else {
                                // ทายน้อยไป
                                _feedback = 'TOO LOW!';
                              }
                              _controller.clear();
                            } else {
                              if (_controller.text == "") {
                                _showErrorDialog();
                                _controller.clear();
                              }
                            }
                          });
                        }
                      : null,
                  child: Text(
                    'GUESS',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return _guessNumber == null
        ? Column(
            children: [
              Text(
                "I'm thinking of a number between 1 and 100.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Can you guess it? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30.0)),
                  Icon(
                    Icons.favorite,
                    size: 38.0,
                    color: Colors.pinkAccent,
                  )
                ],
              )
            ],
          )
        : Column(
            children: [
              Text(
                _guessNumber!,
                style: GoogleFonts.kanit(fontSize: 100.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _game.isGuessCorrect
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 50.0,
                        )
                      : Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 50.0,
                        ),
                  Text(
                    _feedback!,
                    style: GoogleFonts.kanit(fontSize: 45.0),
                  ),
                ],
              ),
              _game.isGameOver
                  ? TextButton(
                      onPressed: () {
                        newGame();
                      },
                      child: Text('NEW GAME'),
                    )
                  : SizedBox.shrink(),
            ],
          );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_number.png',
            width: 300.0, // 96 = 1 inch
          ),
          Text(
            'Guess The Number',
            style: GoogleFonts.kanit(
                fontSize: 25.0,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
