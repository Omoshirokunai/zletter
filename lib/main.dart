// #region imports
import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
// import 'package:url_launcher/url_launcher_string.dart';
import 'randomletter.dart';
import 'package:flutter/material.dart';
import 'entities/englishwords.dart';
import 'package:zletter_game/widgets/letter_box.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// #endregion

void main() => runApp(ZLetter());

class ZLetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      home: InputPage(),
    );
  }
}

// #region playsound

void playsound(int sound) {
  final player = AudioCache();
  player.play('winpoint$sound.wav');
}
// #endregion

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
// #region class variables
  static int numofletters = Random().nextInt(5) + 3;
  Color bdcolor = Colors.grey;
  List<TextEditingController> field =
      List.generate(numofletters, (i) => TextEditingController());
  List<String> word = List.filled(numofletters, "0", growable: true);
  int timeleft = 30;
  String firstletter = generateRandomString(1);
  String oldfirstletter;
  bool _buttonvisible = true;
  int score = 0;
  double progress = 1;
  List vwords = list_english_words[numofletters];

// #endregion

// #region reset
  void reset() {
    setState(() {
      numofletters = Random().nextInt(5) + 3;
      word = List.filled(numofletters, "0", growable: true);
      field = List.generate(numofletters, (i) => TextEditingController());
      // firstletter = generateRandomString(1);
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   reset();
  // }
// #endregion
// #region share

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share("30 seconds, $score points \nZletter word",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        subject: 'Look at my Zletter Score!');
  }

// #endregion
// #region timer_logic
  void _starttime() {
    // ? game timer
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeleft > 0) {
          progress = (timeleft / 30);
          _buttonvisible = false;
          timeleft--;
        } else {
          // print(score);
          progress = 0;
          _buttonvisible = true;
          timer.cancel();

          // #region game_end_dialog
          showDialog(
              context: context,
              builder: (_) {
                Color bg = Colors.green;
                if (score < 10) {
                  bg = Colors.orangeAccent;
                }
                return AlertDialog(
                  title: Text("Game Over"),
                  content: Text(
                    "You Scored: $score",
                    style: TextStyle(
                      fontFamily: "RobotoSlab",
                    ),
                  ),
                  actions: [
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade500),
                        onPressed: () {
                          reset();
                          timeleft = 30;
                          score = 0;
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "REPLAY",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade500),
                        onPressed: () {
                          // reset();
                          // timeleft = 30;
                          // score = 0;
                          share(context);
                          // Navigator.pop(context, true);
                        },
                        child: Text(
                          "SHARE",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                  elevation: 23.0,
                  backgroundColor: bg,
                );
              });
          // #endregion
        }
      });
    });
  }
// #endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // #region appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Center(
          child: Text('Z-letter Word',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontFamily: "RobotoSlab",
              )),
        ),
      ),
      // #endregion
      // #region body
      body: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // #region progressbar
            SizedBox(
              // width: 220,
              height: 12,
              child: Visibility(
                visible: !(_buttonvisible),
                // child: Stack(
                // fit: StackFit.expand,
                // children: [
                child: LinearProgressIndicator(
                  value: double.parse(progress.toStringAsFixed(3)),
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(255, 21, 218, 70)),
                  backgroundColor: Color.fromARGB(150, 229, 5, 5),
                ),
                // Center(
                //   child: Text(timeleft.toString(),
                //       style: TextStyle(
                //         fontFamily: "RobotoSlab",
                //         fontSize: 8,
                //       )),
                // )
                // ],
                // ),
              ),
            ),
            // #endregion
            // #region spacer
            SizedBox(
              height: 25.0,
            ),
            // #endregion
            Form(
              // #region mainbody
              child: Center(
                // #region maintext
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // direction: Axis.vertical,
                  children: <Widget>[
                    Visibility(
                      visible: !(_buttonvisible),
                      child: Container(
                        // setstate((){}),
                        child: Text(
                            "Enter a ${numofletters + 1} letter word starting with $firstletter",
                            style: TextStyle(
                              fontFamily: "RobotoSlab",
                              fontSize: 20,
                            )),
                      ),
                    ),
                    // #endregion
                    // #region spacer_maintext_2_boxes
                    SizedBox(
                      height: 30.0,
                    ),
                    // #endregion
                    // #region boxes_visible
                    Stack(
                      children: [
                        // #region rules
                        Visibility(
                          visible: _buttonvisible,
                          child: RichText(
                            // textWidthBasis: TextWidthBasis.longestLine,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(height: 2),
                              // style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                    text: 'Rlues: \n',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        '1) Enter a word starting with the first letter given\n'),
                                TextSpan(
                                    text:
                                        '2) The last letter of your previous word\n\t\t\t\t\tis now the first letter for your next word.\n'),
                                TextSpan(text: '3) You have '),
                                TextSpan(
                                  text: '30 ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                TextSpan(text: 'seconds\n'),
                                TextSpan(
                                    text:
                                        'every correct word earns you 3 seconds',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic))
                              ],
                            ),
                          ),
                        ),
                        // #endregion
                        // #region inputboxes
                        Visibility(
                          visible: !(_buttonvisible),
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                  runSpacing: 9,
                                  alignment: WrapAlignment.center,
                                  spacing: 9,
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    // #region firstletter
                                    SizedBox(
                                      height: 70,
                                      width: 55,
                                      child: TextFormField(
                                        enabled: false,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            hintText: firstletter,
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    217, 232, 229, 229)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                                gapPadding: 5.0,
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        style: TextStyle(
                                            fontFamily: "RobotoSlabB",
                                            fontSize: 25),
                                      ),
                                    ),
                                    // #endregion

                                    // #region generate inputboxes
                                    ...List.generate(numofletters, (index) {
                                      // print(numofletters);
                                      return LetterBox(
                                        borderColor: bdcolor,
                                        mycontrol: field[index],
                                      );
                                    }),

                                    //#endregion
                                  ]),
                            ),
                          ),
                        ),
                        // #endregion
                      ],
                    ),
                    // #endregion
                    // #region spacer_boxes_2_buttons
                    SizedBox(
                      height: 30.0,
                    ),
                    // #endregion
                    Stack(
                      // #region startbutton
                      children: [
                        Visibility(
                          visible: _buttonvisible,
                          child: ElevatedButton(
                            onPressed: () {
                              _starttime();
                              if (timeleft == 0) {
                                setState(() {
                                  reset();
                                  timeleft = 30;
                                  score = 0;
                                });
                              }
                            },
                            child: Text(
                              "S T A R T",
                              style: TextStyle(fontFamily: "Fredoka"),
                            ),
                          ),
                        ),

                        // #endregion
                        // #region enterbutton
                        Visibility(
                          visible: !(_buttonvisible),
                          // maintainState: ,
                          child: ElevatedButton(
                            child: Text(
                              "E N T E R",
                              style: TextStyle(fontFamily: "Fredoka"),
                            ),
                            onPressed: () {
                              setState(() {
                                field.forEach((element) {
                                  if (element.text != "") {
                                    word[field.indexOf(element)] =
                                        element.value.text;
                                  }
                                });

                                if (!word.contains("0")) {
                                  // print((firstletter + word.join())
                                  //     .toString()
                                  //     .toLowerCase());

                                  // String wordl = firstletter + word.join().toLowerCase();
                                  // if (list_english_words[numofletters].contains(
                                  //     word.join().toString().toLowerCase())) {
                                  if (list_english_words[numofletters + 1]
                                      .contains((firstletter + word.join())
                                          .toString()
                                          .toLowerCase())) {
                                    playsound(1);
                                    score = score + 5;
                                    // print("$firstletter is firstletter now");
                                    oldfirstletter = firstletter.toLowerCase();
                                    // print("$oldfirstletter is the old first");

                                    if (word.last.toLowerCase() ==
                                        oldfirstletter) {
                                      firstletter = generateRandomString(1);
                                    } else {
                                      firstletter = word.last;
                                    }

                                    // #region is_a_word_alert
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 185),
                                      backgroundColor: Colors.green,
                                      content: Row(children: <Widget>[
                                        Icon(
                                          Icons.thumb_up,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            'Nice',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                    ));
                                    // #endregion
                                    if (timeleft < 30 && timeleft != 0) {
                                      timeleft += 3;
                                      reset();
                                      // reset_square();
                                      // reset_controller();
                                      // reset_word();
                                    }

                                    // word = List.filled(numofletters, "0",
                                    //     growable: true);
                                  } else {
                                    // print("Not a word");
                                    playsound(0);
                                    if (score > 0) {
                                      score = score - 5;
                                    }

                                    // #region not_a_word_alert
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: Duration(milliseconds: 187),
                                      backgroundColor: Colors.orangeAccent,
                                      content: Row(children: <Widget>[
                                        Icon(
                                          Icons.thumb_down,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            'Not A word',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ]),
                                    ));
                                    // #endregion
                                  }
                                }
                              });
                            },
                          ),
                        ),
                        // #endregion
                      ],
                    ),
                  ],
                ),
              ),
              // #endregion
            ),
          ],
        ),
      ),
      // #endregion
      // #region about_me
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "made with ❤️️ by ",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
                TextSpan(
                  text: "norman bellenger",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      //Code to launch your URL
                      launchUrl(Uri.parse('https://twitter.com/a_shadyghost'));
                    },
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 98, 116, 166),
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        ],
      ),
      // #endregion
    );
  }
}
