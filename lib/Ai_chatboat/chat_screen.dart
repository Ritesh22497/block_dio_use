import 'package:block_dio_use/Ai_chatboat/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quiz_screen.dart';

class ChatScreen2 extends StatefulWidget {
  const ChatScreen2({super.key});

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final VoiceService _voice = VoiceService();
  final ImageService _image = ImageService();

  void send() {
    if (controller.text.trim().isEmpty) return;
    context.read<ChatProvider1>().sendMessage(controller.text);
    controller.clear();
  }

  void scrollBottom() {
    Future.delayed(Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider1>();
    scrollBottom();

    return Scaffold(
      appBar: AppBar(
        title: Text("AI Study Assistant 🎓"),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => QuizScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => provider.clearChat(),
          )
        ],
      ),
      body: Column(
        children: [
          /// CHAT LIST
          Expanded(
            child: provider.messages.isEmpty
                ? Center(
                    child: Text(
                      "Ask anything...",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.all(12),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, i) {
                      final msg = provider.messages[i];
                      final isUser = msg.isUser;

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(14),
                          constraints:
                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg.message,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          /// LOADING
          if (provider.isLoading)
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 10),
                  Text("AI thinking..."),
                ],
              ),
            ),

          /// INPUT BAR
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ],
            ),
            child: Row(
              children: [
                /// IMAGE BUTTON
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    final img = await _image.pickImage();
                    if (img != null) {
                      context.read<ChatProvider1>().sendMessage(
                          "Solve this question from image: ${img.path}");
                    }
                  },
                ),

                /// VOICE BUTTON
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () async {
                    String text = await _voice.listen();
                    controller.text = text;
                  },
                ),

                /// TEXT FIELD
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Ask question...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                /// SEND BUTTON
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}