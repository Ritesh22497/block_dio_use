// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// // import 'package:path_provider/path_provider.dart';

// // // void main() {
// // //   runApp(const MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return const MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       home: SpeechScreen(),
// // //     );
// // //   }
// // // }

// // class SpeechScreen extends StatefulWidget {
// //   const SpeechScreen({super.key});

// //   @override
// //   State<SpeechScreen> createState() => _SpeechScreenState();
// // }

// // class _SpeechScreenState extends State<SpeechScreen> {
// //   late stt.SpeechToText _speech;
// //   bool _isListening = false;
// //   TextEditingController _controller = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _speech = stt.SpeechToText();
// //   }

// //   /// 🎤 Start Listening
// //   void _listen() async {
// //     if (!_isListening) {
// //       bool available = await _speech.initialize();
// //       if (available) {
// //         setState(() => _isListening = true);

// //         _speech.listen(
// //           onResult: (result) {
// //             setState(() {
// //               _controller.text = result.recognizedWords;
// //             });
// //           },
// //         );
// //       }
// //     } else {
// //       setState(() => _isListening = false);
// //       _speech.stop();
// //     }
// //   }

// //   /// 📄 Generate PDF
// //   Future<void> _generatePDF() async {
// //     final pdf = pw.Document();

// //     pdf.addPage(
// //       pw.Page(
// //         build: (pw.Context context) {
// //           return pw.Text(
// //             _controller.text,
// //             style: const pw.TextStyle(fontSize: 18),
// //           );
// //         },
// //       ),
// //     );

// //     final output = await getTemporaryDirectory();
// //     final file = File("${output.path}/speech_text.pdf");

// //     await file.writeAsBytes(await pdf.save());

// //     // Preview / Print / Share
// //     await Printing.layoutPdf(
// //       onLayout: (PdfPageFormat format) async => pdf.save(),
// //     );
// //   }

// //   /// 🗑 Clear Text
// //   void _clearText() {
// //     _controller.clear();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Speech to PDF App"),
// //         centerTitle: true,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             /// 📝 Editable Text Field
// //             TextField(
// //               controller: _controller,
// //               maxLines: 8,
// //               decoration: InputDecoration(
// //                 hintText: "Speak or edit text here...",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             /// 🎤 Mic Button
// //             ElevatedButton.icon(
// //               onPressed: _listen,
// //               icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
// //               label: Text(_isListening ? "Listening..." : "Start Recording"),
// //             ),

// //             const SizedBox(height: 10),

// //             /// 📄 Generate PDF Button
// //             ElevatedButton.icon(
// //               onPressed: _generatePDF,
// //               icon: const Icon(Icons.picture_as_pdf),
// //               label: const Text("Generate PDF"),
// //             ),

// //             const SizedBox(height: 10),

// //             /// 🗑 Clear Button
// //             ElevatedButton.icon(
// //               onPressed: _clearText,
// //               icon: const Icon(Icons.delete),
// //               label: const Text("Clear Text"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';

// class SpeechScreen extends StatefulWidget {
//   const SpeechScreen({super.key});

//   @override
//   State<SpeechScreen> createState() => _SpeechScreenState();
// }

// class _SpeechScreenState extends State<SpeechScreen> {
//   late stt.SpeechToText _speech;

//   bool _isListening = false;
//   bool _isPaused = false;

//   TextEditingController _controller = TextEditingController();

//   String _lastWords = "";

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   /// ▶ START
//   void _startListening() async {
//     bool available = await _speech.initialize();

//     if (available) {
//       setState(() {
//         _isListening = true;
//         _isPaused = false;
//       });

//       _speech.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             setState(() {
//               _controller.text =
//                   "${_controller.text} ${result.recognizedWords}";
//             });
//           } else {
//             _lastWords = result.recognizedWords;
//           }
//         },
//       );
//     }
//   }

//   /// ⏸ PAUSE
//   void _pauseListening() {
//     _speech.stop();
//     setState(() {
//       _isPaused = true;
//       _isListening = false;
//     });
//   }

//   /// ▶ RESUME
//   void _resumeListening() {
//     _startListening();
//   }

//   /// ⏹ STOP
//   void _stopListening() {
//     _speech.stop();
//     setState(() {
//       _isListening = false;
//       _isPaused = false;
//     });
//   }

//   /// 📄 PDF
//   Future<void> _generatePDF() async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Text(_controller.text);
//         },
//       ),
//     );

//     final dir = await getTemporaryDirectory();
//     final file = File("${dir.path}/speech.pdf");
//     await file.writeAsBytes(await pdf.save());

//     await Printing.layoutPdf(
//       onLayout: (format) async => pdf.save(),
//     );
//   }

//   /// 🗑 CLEAR (ONLY BUTTON SE)
//   void _clearText() {
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Speech Control App")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// 📝 Editable Text
//             TextField(
//               controller: _controller,
//               maxLines: 14,
//               decoration: InputDecoration(
//                 hintText: "Speak or edit...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// 🎤 CONTROLS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 /// ▶ Start
//                 ElevatedButton(
//                   onPressed: _isListening ? null : _startListening,
//                   child: const Text("Start"),
//                 ),

//                 // /// ⏸ Pause
//                 // ElevatedButton(
//                 //   onPressed: _isListening ? _pauseListening : null,
//                 //   child: const Text("Pause"),
//                 // ),

//                 // /// ▶ Resume
//                 // ElevatedButton(
//                 //   onPressed: _isPaused ? _resumeListening : null,
//                 //   child: const Text("Resume"),
//                 // ),

//                 /// ⏹ Stop
//                 ElevatedButton(
//                   onPressed: _isListening || _isPaused
//                       ? _stopListening
//                       : null,
//                   child: const Text("Stop"),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             /// 📄 PDF
//             ElevatedButton(
//               onPressed: _generatePDF,
//               child: const Text("Generate PDF"),
//             ),

//             const SizedBox(height: 10),

//             /// 🗑 Clear
//             ElevatedButton(
//               onPressed: _clearText,
//               child: const Text("Clear Text"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';



class SpeechUI extends StatefulWidget {
  const SpeechUI({super.key});

  @override
  State<SpeechUI> createState() => _SpeechUIState();
}

class _SpeechUIState extends State<SpeechUI> {
  late stt.SpeechToText _speech;

  bool _isListening = false;
  double _soundLevel = 0;

  TextEditingController _controller = TextEditingController();
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadHistory();
  }

  /// 🎤 START
  void startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => _isListening = true);

      _speech.listen(
        listenMode: stt.ListenMode.dictation,
      //  localeId: "hi_IN", // Hindi + English mix works
        onSoundLevelChange: (level) {
          setState(() {
            _soundLevel = level;
          });
        },
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              _controller.text += " ${result.recognizedWords}";
            });
          }
        },
      );

      _speech.statusListener = (status) {
        if (_isListening && status == "done") {
          restartListening();
        }
      };
    }
  }

  void restartListening() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_isListening) startListening();
  }

  /// ⏹ STOP
  void stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  //  saveHistory(_controller.text);
  }

  // /// 💾 SAVE HISTORY
  // Future<void> saveHistory(String text) async {
  //   if (text.trim().isEmpty) return;

  //   final prefs = await SharedPreferences.getInstance();
  //   history.insert(0, text);

  //   prefs.setString("notes", jsonEncode(history));
  // }


  /// 📂 LOAD HISTORY
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("notes");

    if (data != null) {
      setState(() {
        history = List<String>.from(jsonDecode(data));
      });
    }
  }

  /// 📄 PDF
  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Text(_controller.text),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  /// 🗑 CLEAR
  void clearText() {
    _controller.clear();
  }

  /// 🌊 Wave UI
  Widget wave() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(20, (index) {
          double height =
              (_soundLevel * Random().nextDouble() * 2).clamp(5, 50);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 4,
            height: height,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  /// 🟢 WhatsApp Style Button
  Widget recordButton() {
    return GestureDetector(
      onTap: _isListening ? stopListening : startListening,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: _isListening ? Colors.red : Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            )
          ],
        ),
        child: Icon(
          _isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  /// 📜 History UI
  Widget historyUI() {
    return Expanded(
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(history[index]),
              onTap: () {
                setState(() {
                  _controller.text = history[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F2027),
      appBar: AppBar(
        title: const Text("AI Voice Notes"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 📝 TEXT AREA
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: 10,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: "Speak something...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        
            /// 🌊 WAVE
            if (_isListening) wave(),
        
            const SizedBox(height: 10),
        
            /// 🎤 BUTTON
            recordButton(),
        
            const SizedBox(height: 10),
        
            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: generatePDF, child: const Text("PDF")),
                ElevatedButton(onPressed: clearText, child: const Text("Clear")),
              ],
            ),
        
            const SizedBox(height: 10),
        
            /// 📜 HISTORY
         //   historyUI(),
          ],
        ),
      ),
    );
  }
}