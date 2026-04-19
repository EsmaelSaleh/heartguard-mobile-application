import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import '../models/chat_models.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(role: ChatRole.assistant, content: 'Hello Esmael! I am your HeartHealth AI. How can I help you today?'),
  ];
  final List<ChatHistoryItem> _history = [
    ChatHistoryItem(title: 'Heart rate query', dateTime: DateTime.now()),
    ChatHistoryItem(title: 'ECG result help', dateTime: DateTime.now().subtract(const Duration(days: 1))),
    ChatHistoryItem(title: 'Blood pressure tips', dateTime: DateTime.now().subtract(const Duration(days: 2))),
    ChatHistoryItem(title: 'Exercise recommendations', dateTime: DateTime.now().subtract(const Duration(days: 3))),
  ];
  bool _isTyping = false;

  void _handleSend() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, content: userMessage));
      _controller.clear();
      _isTyping = true;
    });

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          role: ChatRole.assistant, 
          content: 'That is a great question about ${userMessage.toLowerCase()}. For a personalized answer, please ensure your latest assessment metrics are up to date.'
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(),
      endDrawer: _buildHistoryDrawer(),
      appBar: AppBar(
        title: const Text('Heart Health AI'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            tooltip: 'Chat History',
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Padding(
              padding: EdgeInsets.only(right: 16, left: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primary,
                child: Text('ES', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessage(msg);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                   _buildAvatar(ChatRole.assistant),
                   const SizedBox(width: 8),
                   const Text('AI is typing...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(msg.role),
          if (!isUser) const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
                boxShadow: [
                  if (!isUser) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                msg.content,
                style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15, height: 1.4),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 12),
          if (isUser) _buildAvatar(msg.role),
        ],
      ),
    );
  }

  Widget _buildAvatar(ChatRole role) {
    final isUser = role == ChatRole.user;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primary : const Color(0xFFFEF2F2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isUser 
          ? const Text('ES', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
          : const Icon(LucideIcons.bot, color: Colors.red, size: 18),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Ask about heart health...',
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 64, 20, 24),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.history, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text('Chat History', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                SizedBox(height: 8),
                Text('Manage your past health inquiries', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _history[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(LucideIcons.messageSquare, size: 20, color: AppTheme.primary),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    subtitle: Text(item.formattedDate, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    onTap: () {
                      context.pop();
                      // Logic to load history would go here
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
