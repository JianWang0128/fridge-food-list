import 'package:flutter/material.dart';
import 'local_auth_service.dart';

class LocalLoginPage extends StatefulWidget {
  final LocalAuthService authService;

  const LocalLoginPage({super.key, required this.authService});

  @override
  State<LocalLoginPage> createState() => _LocalLoginPageState();
}

class _LocalLoginPageState extends State<LocalLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _errorMessage = '请输入昵称';
      });
      return;
    }

    final success = await widget.authService.login(username);
    if (success) {
      setState(() {
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4E4C1), // 米色背景
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 标题
                  const Text(
                    '冰箱食物\n清单',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5016),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 欢迎文本
                  const Text(
                    '输入你的昵称\n开始冰箱之旅',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 12,
                      color: Color(0xFF2D5016),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 昵称输入框
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: '输入昵称...',
                      hintStyle: const TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 10,
                        color: Color(0xFF999999),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF2D5016),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF2D5016),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFFCC8B00),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 12,
                      color: Color(0xFF2D5016),
                    ),
                    onSubmitted: (_) => _login(),
                  ),

                  const SizedBox(height: 16),

                  // 错误提示
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        border: Border.all(
                          color: const Color(0xFFCC0000),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 10,
                          color: Color(0xFFCC0000),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // 进入按钮
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xCC8B4513),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: const BorderSide(
                            color: Color(0xFF2D5016),
                            width: 3,
                          ),
                        ),
                      ),
                      child: const Text(
                        '进入冰箱',
                        style: TextStyle(
                          fontFamily: 'PressStart2P',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
