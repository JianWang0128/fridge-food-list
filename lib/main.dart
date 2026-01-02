import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'local_auth_service.dart';
import 'local_fridge_data_service.dart';
import 'local_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = LocalAuthService();
  await authService.initializeAuth();

  runApp(
    ChangeNotifierProvider.value(
      value: authService,
      child: const FridgeApp(),
    ),
  );
}

class FridgeApp extends StatelessWidget {
  const FridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('FridgeApp build called');

    // 星露谷风格主题
    const pixelFontFamily = 'PressStart2P';

    return MaterialApp(
      title: '冰箱食物清单',
      theme: ThemeData(
        // 星露谷配色：深绿 + 金色 + 土色
        primaryColor: const Color(0xFF2D5016), // 深绿
        scaffoldBackgroundColor: const Color(0xFFF4E4C1), // 米色背景
        useMaterial3: false,
        fontFamily: pixelFontFamily,

        // 文本主题 - 像素风格
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: pixelFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5016),
          ),
          bodyMedium: TextStyle(
            fontFamily: pixelFontFamily,
            fontSize: 14,
            color: Color(0xFF2D5016),
          ),
          labelLarge: TextStyle(
            fontFamily: pixelFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),

        // 按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xCC8B4513), // 土棕色
            foregroundColor: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: const BorderSide(color: Color(0xFF2D5016), width: 3),
            ),
            textStyle: const TextStyle(
              fontFamily: pixelFontFamily,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 下拉按钮主题
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF2D5016), width: 3),
              borderRadius: BorderRadius.zero,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF2D5016), width: 3),
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),

        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF2D5016), width: 3),
            borderRadius: BorderRadius.zero,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF2D5016), width: 3),
            borderRadius: BorderRadius.zero,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCC8B00), width: 3),
            borderRadius: BorderRadius.zero,
          ),
          hintStyle: const TextStyle(
            fontFamily: pixelFontFamily,
            color: Color(0xFF999999),
          ),
        ),

        // AppBar主题
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D5016),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: pixelFontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<LocalAuthService>(context);

    if (authService.isLoggedIn && authService.currentUser != null) {
      return FridgeHome(username: authService.currentUser!);
    }

    return LocalLoginPage(authService: authService);
  }
}

class FridgeHome extends StatefulWidget {
  final String username;

  const FridgeHome({super.key, required this.username});

  @override
  State<FridgeHome> createState() => _FridgeHomeState();
}

class _FridgeHomeState extends State<FridgeHome> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  late final LocalFridgeDataService _dataService;
  String _selectedType = 'refrigerated';

  @override
  void initState() {
    super.initState();
    _dataService = LocalFridgeDataService(widget.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addFood() {
    final name = _nameController.text.trim();
    final quantity = _quantityController.text.trim();
    if (name.isNotEmpty && quantity.isNotEmpty) {
      _dataService.addFridgeItem(
        name,
        type: _selectedType,
        quantity: quantity,
      );
      _nameController.clear();
      _quantityController.clear();
      setState(() {
        _selectedType = 'refrigerated';
      });
    }
  }

  void _removeFood(String itemId) {
    _dataService.removeFridgeItem(itemId);
  }

  IconData _getFoodIcon(String name) {
    // 根据名称返回对应的Material Icon
    if (name.contains('苹果') || name.contains('果')) return Icons.apple;
    if (name.contains('肉') ||
        name.contains('牛') ||
        name.contains('猪') ||
        name.contains('羊')) return Icons.food_bank;
    if (name.contains('蛋')) return Icons.egg;
    if (name.contains('菜') ||
        name.contains('蔬') ||
        name.contains('萝卜') ||
        name.contains('黄瓜') ||
        name.contains('西兰花') ||
        name.contains('菠菜')) return Icons.grass;
    if (name.contains('鱼') ||
        name.contains('虾') ||
        name.contains('蟹') ||
        name.contains('海鲜')) return Icons.set_meal;
    if (name.contains('面包') || name.contains('饼')) return Icons.bakery_dining;
    if (name.contains('奶') || name.contains('牛奶')) return Icons.water_drop;
    if (name.contains('冰') || name.contains('雪糕') || name.contains('冰激凌'))
      return Icons.icecream;
    if (name.contains('咖啡')) return Icons.coffee;
    if (name.contains('茶')) return Icons.emoji_food_beverage;
    if (name.contains('酒') || name.contains('啤')) return Icons.liquor;
    if (name.contains('水') || name.contains('饮料')) return Icons.local_drink;
    if (name.contains('糖') || name.contains('巧克力') || name.contains('甜'))
      return Icons.cake;
    if (name.contains('米') || name.contains('饭')) return Icons.rice_bowl;

    // 默认图标
    return Icons.restaurant;
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
    final authService = Provider.of<LocalAuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}的冰箱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 添加食物输入框
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: '输入食物名称...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addFood(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          hintText: '数量',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addFood(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedType,
                        items: [
                          DropdownMenuItem(
                            value: 'frozen',
                            child: const Text('冷冻层'),
                          ),
                          DropdownMenuItem(
                            value: 'refrigerated',
                            child: const Text('冷藏层'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value ?? 'refrigerated';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addFood,
                      child: const Text('添加'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 食物列表 - 网格布局
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

                return Column(
                  children: [
                    // 冷冻层 - 星露谷蓝色
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB3D9FF), // 冰蓝色
                          border: Border.all(
                            color: const Color(0xFF2D5016),
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: const Color(0xFF4A90E2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: const Text(
                                  '冷冻层',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.extent(
                                maxCrossAxisExtent: 100,
                                children: items
                                    .where((food) => food.type == 'frozen')
                                    .toList()
                                    .map(
                                      (item) => GestureDetector(
                                        onLongPress: () {
                                          _showDeleteDialog(context, item);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF8DC),
                                            border: Border.all(
                                              color: const Color(0xFF2D5016),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Icon(
                                                  _getFoodIcon(item.name),
                                                  size: 40,
                                                  color:
                                                      const Color(0xFF2D5016),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                right: 4,
                                                child: Text(
                                                  item.quantity,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 分隔线 - 星露谷风格
                    Container(height: 4, color: const Color(0xFF2D5016)),
                    // 冷藏层 - 星露谷绿色
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4EFC7), // 淡绿色
                          border: Border.all(
                            color: const Color(0xFF2D5016),
                            width: 4,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: const Color(0xFF6DAB3B),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: const Text(
                                  '冷藏层',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: 'PressStart2P',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.extent(
                                maxCrossAxisExtent: 100,
                                children: items
                                    .where(
                                      (food) => food.type == 'refrigerated',
                                    )
                                    .toList()
                                    .map(
                                      (item) => GestureDetector(
                                        onLongPress: () {
                                          _showDeleteDialog(context, item);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF8DC),
                                            border: Border.all(
                                              color: const Color(0xFF2D5016),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Icon(
                                                  _getFoodIcon(item.name),
                                                  size: 40,
                                                  color:
                                                      const Color(0xFF2D5016),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 4,
                                                right: 4,
                                                child: Text(
                                                  item.quantity,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: null,
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
