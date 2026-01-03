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

  void _updateFoodQuantity(FridgeItem item, String newQuantity) {
    _dataService.updateFridgeItem(item.copyWith(quantity: newQuantity));
  }

  void _showQuantityDialog(FridgeItem item) {
    int quantity = int.tryParse(item.quantity) ?? 1;
    final quantityController = TextEditingController(text: quantity.toString());
    
    // 格式化添加日期
    final dateFormat = '${item.createdAt.year}-${item.createdAt.month.toString().padLeft(2, '0')}-${item.createdAt.day.toString().padLeft(2, '0')} ${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.name),
            const SizedBox(height: 8),
            Text(
              '添加时间: $dateFormat',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('数量'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (quantity > 1) {
                      quantity--;
                      quantityController.text = quantity.toString();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('−'),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: quantityController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        quantity = parsed;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    quantity++;
                    quantityController.text = quantity.toString();
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateFoodQuantity(item, quantity.toString());
                    Navigator.of(context).pop();
                  },
                  child: const Text('确认'),
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
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(FridgeItem? item) {
    if (item == null) {
      // 空格子
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: const Color(0xFF2D5016), width: 3),
          borderRadius: BorderRadius.circular(0),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showQuantityDialog(item),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8DC),
          border: Border.all(color: const Color(0xFF2D5016), width: 2),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.network(
                _getEmojiUrl(_getIcon(item.name)),
                width: 48,
                height: 48,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    _getIcon(item.name),
                    style: const TextStyle(fontSize: 40),
                  );
                },
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
    );
  }

  List<FridgeItem?> _buildGridItems(List<FridgeItem> items, int gridSize) {
    final result = <FridgeItem?>[];
    result.addAll(items);
    // 填充空格子直到达到 gridSize
    while (result.length < gridSize) {
      result.add(null);
    }
    return result;
  }

  String _getEmojiUrl(String emoji) {
    final codePoints = emoji.runes.map((r) => r.toRadixString(16)).join('-');
    return 'https://cdn.jsdelivr.net/npm/emoji-datasource-apple/img/apple/64/$codePoints.png';
  }

  String _getIcon(String name) {
    const foodIconMap = {
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

    for (final entry in foodIconMap.entries) {
      if (name.contains(entry.key)) {
        return entry.value;
      }
    }
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

                // 分离冷冻层和冷藏层的食物
                final frozenItems =
                    items.where((food) => food.type == 'frozen').toList();
                final refrigeratedItems =
                    items.where((food) => food.type == 'refrigerated').toList();

                // 创建固定大小的网格（各层 5x4 = 20 格）
                final frozenGridItems = _buildGridItems(frozenItems, 20);
                final refrigeratedGridItems =
                    _buildGridItems(refrigeratedItems, 20);

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
                              child: GridView.count(
                                crossAxisCount: 5,
                                children: frozenGridItems
                                    .map(_buildFoodCard)
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
                              child: GridView.count(
                                crossAxisCount: 5,
                                children: refrigeratedGridItems
                                    .map(_buildFoodCard)
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
}
