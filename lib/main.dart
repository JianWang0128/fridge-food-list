import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'auth_service.dart';
import 'fridge_data_service.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 初始化Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // 等待一小段时间确保Firebase完全初始化
    await Future.delayed(const Duration(milliseconds: 500));
    print('Firebase delay completed');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FridgeDataService()),
      ],
      child: const FridgeApp(),
    ),
  );
}

class FridgeApp extends StatelessWidget {
  const FridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '冰箱食物清单',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    print('AuthWrapper build called');

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        print(
          'StreamBuilder state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}, error: ${snapshot.error}',
        );

        // 处理错误状态
        if (snapshot.hasError) {
          print('Firebase error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Firebase连接错误'),
                  const SizedBox(height: 16),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // 重新加载应用
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const FridgeApp()),
                      );
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Showing loading indicator');
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          print('User is authenticated, showing FridgeHome');
          return const FridgeHome();
        }

        print('User not authenticated, showing LoginPage');
        return LoginPage(authService: authService);
      },
    );
  }
}

class FridgeHome extends StatefulWidget {
  const FridgeHome({super.key});

  @override
  State<FridgeHome> createState() => _FridgeHomeState();
}

class _FridgeHomeState extends State<FridgeHome> {
  final TextEditingController _controller = TextEditingController();
  final FridgeDataService _dataService = FridgeDataService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFood() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      _dataService.addFridgeItem(name);
      _controller.clear();
    }
  }

  void _removeFood(String itemId) {
    _dataService.removeFridgeItem(itemId);
  }

  String _getIcon(String name) {
    // 根据名称返回对应的emoji图标，使用模糊匹配
    final Map<String, String> iconMap = {
      '苹果': '🍎',
      '牛肉': '🥩',
      '鸡蛋': '🥚',
      '番茄': '🍅',
      '香蕉': '🍌',
      '橙子': '🍊',
      '草莓': '🍓',
      '西瓜': '🍉',
      '葡萄': '🍇',
      '菠萝': '🍍',
      '柠檬': '🍋',
      '樱桃': '🍒',
      '桃子': '🍑',
      '梨': '🍐',
      '芒果': '🥭',
      '椰子': '🥥',
      '鳄梨': '🥑',
      '土豆': '🥔',
      '胡萝卜': '🥕',
      '玉米': '🌽',
      '洋葱': '🧅',
      '大蒜': '🧄',
      '辣椒': '🌶️',
      '黄瓜': '🥒',
      '西兰花': '🥦',
      '花椰菜': '🥬',
      '菠菜': '🥬',
      '蘑菇': '🍄',
      '面包': '🍞',
      '奶酪': '🧀',
      '肉': '🥩',
      '鱼': '🐟',
      '虾': '🦐',
      '蟹': '🦀',
      '鸡': '🐔',
      '猪': '🐖',
      '牛': '🐄',
      '羊': '🐑',
      '蛋': '🥚',
      '牛奶': '🥛',
      '黄油': '🧈',
      '冰激凌': '🍦',
      '饼干': '🍪',
      '蛋糕': '🍰',
      '披萨': '🍕',
      '汉堡': '🍔',
      '薯条': '🍟',
      '爆米花': '🍿',
      '糖果': '🍬',
      '巧克力': '🍫',
      '蜂蜜': '🍯',
      '咖啡': '☕',
      '茶': '🍵',
      '啤酒': '🍺',
      '葡萄酒': '🍷',
      '鸡尾酒': '🍸',
      '苏打水': '🥤',
      '水': '🥛',
    };

    // 首先检查食物emoji Map
    final Map<String, String> foodIconMap = {
      "葡萄": "🍇",
      "瓜": "🍈",
      "西瓜": "🍉",
      "柑橘": "🍊",
      "柠檬": "🍋",
      "酸橙": "🍋‍🟩",
      "香蕉": "🍌",
      "菠萝": "🍍",
      "芒果": "🥭",
      "红苹果": "🍎",
      "青苹果": "🍏",
      "梨": "🍐",
      "桃": "🍑",
      "樱桃": "🍒",
      "草莓": "🍓",
      "蓝莓": "🫐",
      "奇异果": "🥝",
      "番茄": "🍅",
      "橄榄": "🫒",
      "椰子": "🥥",
      "牛油果": "🥑",
      "茄子": "🍆",
      "土豆": "🥔",
      "胡萝卜": "🥕",
      "玉米穗": "🌽",
      "辣椒": "🌶️",
      "灯笼椒": "🫑",
      "黄瓜": "🥒",
      "绿叶": "🥬",
      "西兰花": "🥦",
      "蒜": "🧄",
      "洋葱": "🧅",
      "花生": "🥜",
      "豆子": "🫘",
      "板栗": "🌰",
      "姜根": "🫚",
      "豌豆荚": "🫛",
      "棕色蘑菇": "🍄‍🟫",
      "面包": "🍞",
      "羊角面包": "🥐",
      "长棍面包": "🥖",
      "大饼": "🫓",
      "椒盐卷饼": "🥨",
      "百吉饼": "🥯",
      "薄煎饼": "🥞",
      "胡扯": "🧇",
      "奶酪角": "🧀",
      "骨头上的肉": "🍖",
      "家禽腿": "🍗",
      "切肉": "🥩",
      "熏肉": "🥓",
      "汉堡包": "🍔",
      "炸薯条": "🍟",
      "比萨": "🍕",
      "热狗": "🌭",
      "三明治": "🥪",
      "墨西哥卷饼": "🌯",
      "塔可": "🫔",
      "墨西哥粽子": "🫓",
      "皮塔饼": "🥙",
      "法式煎蛋卷": "🥐",
      "煎蛋": "🥚",
      "煮沸": "🥘",
      "浅锅": "🫕",
      "碗": "🥣",
      "绿色沙拉": "🥗",
      "爆米花": "🍿",
      "黄油": "🧈",
      "盐": "🧂",
      "罐头食品": "🥫",
      "糖果": "🍬",
      "棒糖": "🍭",
      "卡仕达酱": "🍮",
      "蜜罐": "🍯",
      "婴儿奶瓶": "🍼",
      "一杯牛奶": "🥛",
      "热饮": "☕",
      "茶壶": "🫖",
      "无柄茶杯": "🍵",
      "清酒": "🍶",
      "软木塞爆开的瓶子": "🍾",
      "红酒杯": "🍷",
      "鸡尾酒杯": "🍸",
      "热带饮料": "🍹",
      "啤酒杯": "🍺",
      "叮当作响的啤酒杯": "🍻",
      "叮当作响的眼镜": "🥂",
      "玻璃杯": "🥃",
      "倾倒液体": "🫗",
      "带吸管的杯子": "🥤",
      "珍珠奶茶": "🧋",
      "饮料盒": "🧃",
      "伴侣": "🧉",
      "冰": "🧊",
      "筷子": "🥢",
      "带盘子的叉子和刀子": "🍽️",
      "刀叉": "🍴",
      "勺子": "🥄",
      "菜刀": "🔪",
      "罐": "🫙",
      "双耳瓶": "🏺",
    };

    // 首先检查食物emoji Map
    for (var entry in foodIconMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }

    // 然后检查关键词Map
    for (var entry in iconMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }

    // 默认图标
    return '🍽️';
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('冰箱食物清单'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 添加食物输入框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '输入食物名称...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addFood(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addFood, child: const Text('添加')),
              ],
            ),
          ),
          // 食物列表
          Expanded(
            child: StreamBuilder<List<FridgeItem>>(
              stream: _dataService.getFridgeItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('错误: ${snapshot.error}'));
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      '冰箱是空的！\n添加一些食物吧 🍽️',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _removeFood(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item.name} 已删除')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Text(
                            _getIcon(item.name),
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '添加时间: ${item.createdAt.toString().split('.')[0]}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(context, item),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFood,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FridgeItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除食物'),
        content: Text('确定要删除 "${item.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _removeFood(item.id);
              Navigator.of(context).pop();
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
