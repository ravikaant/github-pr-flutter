import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textEditingController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focus = FocusNode();
  bool _emptyMessage = true;

  @override
  Widget build(BuildContext context) {
    _focus.requestFocus();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: Column(children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (context, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          Container(
            child: _buildTextComposer(),
          )
        ]));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.black),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        child: Row(children: [
          Flexible(
            child: TextField(
              onChanged: (text) => {
                setState(() {
                  _emptyMessage = text.isEmpty;
                })
              },
              controller: _textEditingController,
              onSubmitted: _handleSubmit,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send A Message'),
              focusNode: _focus,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                disabledColor: Colors.black12,
                color: Theme.of(context).colorScheme.surface,
                onPressed: _emptyMessage
                    ? null
                    : () => _handleSubmit(_textEditingController.text),
                icon: const Icon(Icons.send)),
          )
        ]),
      ),
    );
  }

  void _handleSubmit(String input) {
    _textEditingController.clear();
    var message = ChatMessage(
      chatText: input,
      chatName: 'Ravi',
      animationController: AnimationController(
          duration: const Duration(milliseconds: 1000), vsync: this),
    );
    setState(() {
      _messages.insert(0, message);
      _emptyMessage = true;
    });
    _focus.requestFocus();
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {required this.chatText,
      required this.chatName,
      required this.animationController,
      Key? key})
      : super(key: key);

  final String chatText;
  final String chatName;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.elasticOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(chatName),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(chatText),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: const CircleAvatar(
                child: Icon(Icons.person),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
