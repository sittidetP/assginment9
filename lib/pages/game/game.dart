import 'dart:math';

class Game{
  final int _answer;
  int _totalGuess = 0;
  List<int> guessNum = [];
  bool _isOver = false;
  bool _isCorrect = false;

  Game() : _answer = Random().nextInt(100) + 1{
    print('The answer is: $_answer');
  }

  /*int getTotalGuesses(){
    return _totalGuess;
  }
  */
  bool get isGuessCorrect{
    return _isCorrect;
  }

  bool get isGameOver{
    return _isOver;
  }

  int get totalGuess{
    return _totalGuess;
  }

  int doGuess(int num){
    _totalGuess++;
    guessNum.add(num);
    if(num > _answer){
      return 1;
    }else if(num < _answer){
      return -1;
    }else{
      _isCorrect = true;
      _isOver = true;
      return 0;
    }
  }

  String getListGuess(){
    String listGuess = "";
    listGuess += "The answer is $_answer\n";
    listGuess += "You have made $_totalGuess guesses.\n\n";
    for(int i = 0; i < guessNum.length; ++i){
      listGuess += "${guessNum[i].toString()}";
      if(i != guessNum.length -1){
        listGuess += " -> ";
      }
    }
    return listGuess;
  }


}