import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMessages = prefs.getString('chat_messages');

    if (savedMessages != null) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(
          json.decode(savedMessages) as List,
        );
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        for (var i = 0; i < _messages.length; i++) {
          _listKey.currentState?.insertItem(i);
        }
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', json.encode(_messages));
  }

  void _sendMessage({bool isUser = true}) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final newMessage = {
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
        'isUser': isUser,
        'senderName': isUser ? 'You' : 'Teammate',
        'avatarColor': isUser ? Colors.blueAccent.value : Colors.grey.value,
      };

      setState(() {
        _messages.add(newMessage);
        _listKey.currentState?.insertItem(_messages.length - 1);
        _controller.clear();
      });

      _saveMessages();
      _scrollToBottom();
    }
  }

  void _simulateOtherMessage() {
    final newMessage = {
      'text': 'Hey! I just joined the group 😎',
      'timestamp': DateTime.now().toIso8601String(),
      'isUser': false,
      'senderName': 'Teammate',
      'avatarColor': Colors.grey.value,
    };

    setState(() {
      _messages.add(newMessage);
      _listKey.currentState?.insertItem(_messages.length - 1);
    });

    _saveMessages();
    _scrollToBottom();
  }

  void _deleteMessage(int index) {
    final removedMessage = _messages.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildMessageBubble(removedMessage, index),
      ),
      duration: const Duration(milliseconds: 300),
    );
    _saveMessages();
  }

  // FIXED: Cache the message before removing it for edit.
  void _editMessage(int index) {
    final originalText = _messages[index]['text'];
    _controller.text = originalText;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Editing message...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Cache the message before removing it.
    final removedMessage = _messages[index];
    setState(() {
      _messages.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _buildMessageBubble(removedMessage, index),
        ),
        duration: const Duration(milliseconds: 300),
      );
    });
    _saveMessages();
  }

  void _showMessageOptions(int index, bool isUserMessage) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isUserMessage)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    _editMessage(index);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, int index) {
    final isUserMessage = message['isUser'] as bool;
    final timestamp = DateTime.parse(message['timestamp']);

    return GestureDetector(
      onLongPress: () => _showMessageOptions(index, isUserMessage),
      child: Column(
        crossAxisAlignment:
            isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUserMessage)
                CircleAvatar(
                  backgroundColor: Color(message['avatarColor']),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? Colors.blueAccent
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        isUserMessage ? const Radius.circular(16) : Radius.zero,
                    bottomRight:
                        isUserMessage ? Radius.zero : const Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUserMessage)
                      Text(
                        message['senderName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    Text(
                      message['text'],
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUserMessage)
                CircleAvatar(
                  backgroundColor: Color(message['avatarColor']),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyLink Group Chat 💬'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: _simulateOtherMessage,
            tooltip: 'Add Members',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet 🗨️',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    initialItemCount: _messages.length,
                    itemBuilder: (context, index, animation) {
                      final message = _messages[index];
                      return SizeTransition(
                        sizeFactor: animation,
                        child: _buildMessageBubble(message, index),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
