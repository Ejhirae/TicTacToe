import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  static const String PLAYER_X = 'X';
  static const String PLAYER_Y = 'O';
  int playerOneScore = 0;
  int playerTwoScore = 0;

  late String currentPlayer;
  late bool isGameEnded;
  late List<String> occupied;

  @override
  void initState() {
    // TODO: implement initState
    startGame();
    super.initState();
  }

  void startGame() {
    currentPlayer = PLAYER_X;
    isGameEnded = false;
    occupied = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ]; //9 empty spaces
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f1f2f),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'X $playerOneScore - $playerTwoScore O',
                style: GoogleFonts.urbanist(fontSize: 70, color: Colors.white),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                    color: const Color(0xFF4c495f),
                    borderRadius: BorderRadius.circular(12)),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                            colors: [Color(0xFFf59972), Color(0xFFd877aa)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)
                        .createShader(bounds);
                  },
                  child: Text(
                    'Tic Tac Toe',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 5)),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.height / 2,
                margin: const EdgeInsets.all(8),
                child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (isGameEnded || occupied[index].isNotEmpty) {
                            return;
                          }
                          setState(() {
                            occupied[index] = currentPlayer;
                            nextPlayer();
                            checkForWinner();
                            drawGame();
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: occupied[index].isEmpty
                                    ? const Color(0xFF4c495f)
                                    : occupied[index] == PLAYER_X
                                        ? const Color(0xFFef927f)
                                        : const Color(0xFFdd7f9f),
                                borderRadius: BorderRadius.circular(30)),
                            margin: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                occupied[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                    fontSize: 60,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      );
                    })),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 35,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: currentPlayer == PLAYER_X
                            ? const Color(0xFFef927f)
                            : const Color(0xFF4c495f),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Text(
                      PLAYER_X,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.167),
                  Container(
                    width: 110,
                    height: 35,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: currentPlayer == PLAYER_Y
                            ? const Color(0xFFef927f)
                            : const Color(0xFF4c495f),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Text(
                      PLAYER_Y,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: resetGame,
                  child: const Icon(Icons.restart_alt_rounded),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  nextPlayer() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  checkForWinner() {
    List<List<int>> winnerList = [
      [0, 1, 2],
      [0, 3, 6],
      [0, 4, 8],
      [1, 4, 7],
      [2, 5, 8],
      [2, 4, 6],
      [3, 4, 5],
      [6, 7, 8]
    ];

    for (var winners in winnerList) {
      String playerPosition0 = occupied[winners[0]];
      String playerPosition1 = occupied[winners[1]];
      String playerPosition2 = occupied[winners[2]];

      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          displayWinner('Game over $playerPosition0 won');
          if (playerPosition0 == 'X') {
            setState(() {
              playerOneScore++;
            });
          } else {
            setState(() {
              playerTwoScore++;
            });
          }
          isGameEnded = true;
          return Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              startGame();
            });
          });
        }
      }
    }
  }

  displayWinner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15),
    )));
  }

  resetGame() {
    setState(() {
      startGame();
    });
  }

  drawGame() {
    if (isGameEnded) {
      return;
    }
    bool draw = true;
    for (var occupiedSpaces in occupied) {
      if (occupiedSpaces.isEmpty) {
        draw = false;
      }
    }
    if (draw) {
      displayWinner('It is a draw');
      return Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          startGame();
        });
      });
    }
  }
}


/*
  when a draw occurs, display draw then instant reset the game
*/