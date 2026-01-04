import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'local_auth_service.dart';
import 'local_fridge_data_service.dart';
import 'local_login_page.dart';

// 可展开/收缩的单值选择器 - 点击后在原位置悬浮显示3行滚轮，中心对齐覆盖原行
class PickerField<T> extends StatefulWidget {
  final List<T> items;
  final T currentValue;
  final ValueChanged<T> onChanged;
  final String Function(T) itemBuilder;
  final String label;

  const PickerField({
    Key? key,
    required this.items,
    required this.currentValue,
    required this.onChanged,
    required this.itemBuilder,
    required this.label,
  }) : super(key: key);

  @override
  State<PickerField<T>> createState() => _PickerFieldState<T>();
}

class _PickerFieldState<T> extends State<PickerField<T>> {
  late FixedExtentScrollController _controller;
  bool _isExpanded = false;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.items.indexOf(widget.currentValue);
    _currentIndex = initialIndex >= 0 ? initialIndex : 0;
    _controller = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double collapsedHeight = 44;
    const double wheelHeight = 150; // 三行可见（itemExtent=50）
    final double overlayTop = (collapsedHeight - wheelHeight) / 2; // 让中间一行盖住原行

    return SizedBox(
      height: collapsedHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 单值显示（收缩状态）
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              height: collapsedHeight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF2D5016),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                color:
                    _isExpanded ? const Color(0xFFE8DDB0) : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.itemBuilder(widget.currentValue),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5016),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF2D5016),
                  ),
                ],
              ),
            ),
          ),

          // 悬浮滚轮选择器（展开状态，中心对齐覆盖原行）
          if (_isExpanded)
            Positioned(
              top: overlayTop,
              left: 0,
              right: 0,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: wheelHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2D5016),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFFE8DDB0),
                  ),
                  child: Stack(
                    children: [
                      ListWheelScrollView(
                        controller: _controller,
                        itemExtent: 50,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                          widget.onChanged(widget.items[index]);
                        },
                        children: List.generate(widget.items.length, (idx) {
                          final item = widget.items[idx];
                          final isSelected = idx == _currentIndex;
                          return Center(
                            child: Text(
                              widget.itemBuilder(item),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D5016)
                                    .withOpacity(isSelected ? 1.0 : 0.45),
                              ),
                            ),
                          );
                        }),
                      ),
                      // 中心项点击区：点击选中项来关闭滚轮
                      Positioned(
                        top: (wheelHeight - 50) / 2,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = false;
                            });
                          },
                          behavior: HitTestBehavior.translucent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
  int _expirationYear = 2026;
  int _expirationMonth = 1;
  int _expirationDay = 1;
  bool _isAddPanelOpen = false;
  String _selectedTypeForAdd = 'frozen'; // 记录从哪一层点击了添加

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
        expirationYear: _expirationYear,
        expirationMonth: _expirationMonth,
        expirationDay: _expirationDay,
      );
      _nameController.clear();
      _quantityController.clear();
      setState(() {
        _selectedType = _selectedTypeForAdd; // 使用选定的类型
        _expirationYear = 2026;
        _expirationMonth = 1;
        _expirationDay = 1;
        _isAddPanelOpen = false;
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

    // 格式化添加日期 - 仅显示日期
    final dateFormat =
        '${item.createdAt.year}-${item.createdAt.month.toString().padLeft(2, '0')}-${item.createdAt.day.toString().padLeft(2, '0')}';

    // 格式化过期日期显示
    final expirationDisplay = item.expirationYear != null &&
            item.expirationMonth != null &&
            item.expirationDay != null
        ? '保质期至: ${item.expirationYear}-${item.expirationMonth.toString().padLeft(2, '0')}-${item.expirationDay.toString().padLeft(2, '0')}'
        : '保质期至: 未设置';

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
              '添加日期: $dateFormat',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              expirationDisplay,
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

  List<int> _getYearRange() {
    return List.generate(11, (i) => 2026 + i); // 2026-2036
  }

  List<int> _getMonthRange() {
    return List.generate(12, (i) => i + 1); // 1-12
  }

  List<int> _getDayRange() {
    // 根据选择的年月返回该月的天数
    final daysInMonth = DateTime(_expirationYear, _expirationMonth + 1, 0).day;
    return List.generate(daysInMonth, (i) => i + 1);
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  String _getShelfLifeUnitLabel(String unit) {
    const unitLabels = {
      'day': '天',
      'month': '月',
      'year': '年',
    };
    return unitLabels[unit] ?? unit;
  }

  String _getUnitLabel(String unit) {
    return _getShelfLifeUnitLabel(unit);
  }

  String _getUnitFromLabel(String label) {
    const labelToUnit = {
      '日': 'day',
      '月': 'month',
      '年': 'year',
    };
    return labelToUnit[label] ?? 'day';
  }

  List<int> _getNumberRangeForUnit(String unit) {
    switch (unit) {
      case 'day':
        return List.generate(30, (i) => i + 1); // 1-30
      case 'month':
        return List.generate(24, (i) => i + 1); // 1-24
      case 'year':
        return List.generate(10, (i) => i + 1); // 1-10
      default:
        return List.generate(30, (i) => i + 1);
    }
  }

  Widget _buildFoodCard(dynamic item) {
    if (item == 'add') {
      // 添加按钮卡片
      return GestureDetector(
        onTap: () {
          setState(() {
            _isAddPanelOpen = true;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E4C1),
            border: Border.all(color: const Color(0xFF2D5016), width: 2),
            borderRadius: BorderRadius.circular(0),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: Color(0xFF2D5016),
            ),
          ),
        ),
      );
    }

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

    final foodItem = item as FridgeItem;

    return GestureDetector(
      onTap: () => _showQuantityDialog(foodItem),
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
                _getEmojiUrl(_getIcon(foodItem.name)),
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
                    _getIcon(foodItem.name),
                    style: const TextStyle(fontSize: 40),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Text(
                foodItem.quantity,
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

  List<dynamic> _buildGridItems(List<FridgeItem> items, int gridSize) {
    final result = <dynamic>[];
    result.addAll(items);
    // 最后一个位置放一个特殊的'add'标记
    if (result.length < gridSize) {
      result.add('add'); // 特殊标记表示这是一个添加按钮
      // 填充剩余的空格子
      while (result.length < gridSize) {
        result.add(null);
      }
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
      body: Stack(
        children: [
          // 禁用背景交互（当添加面板打开时）
          IgnorePointer(
            ignoring: _isAddPanelOpen,
            child: Column(
              children: [
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
                      final refrigeratedItems = items
                          .where((food) => food.type == 'refrigerated')
                          .toList();

                      // 创建固定大小的网格（各层 5x4 = 20 格）
                      final frozenGridItems = _buildGridItems(frozenItems, 10);
                      final refrigeratedGridItems =
                          _buildGridItems(refrigeratedItems, 10);

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
                                      children: frozenGridItems.map((item) {
                                        if (item == 'add') {
                                          _selectedTypeForAdd = 'frozen';
                                        }
                                        return _buildFoodCard(item);
                                      }).toList(),
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
                                      children:
                                          refrigeratedGridItems.map((item) {
                                        if (item == 'add') {
                                          _selectedTypeForAdd = 'refrigerated';
                                        }
                                        return _buildFoodCard(item);
                                      }).toList(),
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
          ),
          // 添加面板打开时的半透明遮罩层
          if (_isAddPanelOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isAddPanelOpen = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          if (_isAddPanelOpen)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4E4C1),
                      border:
                          Border.all(color: const Color(0xFF2D5016), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: '输入食物名称...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addFood(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                ),
                                onPressed: () {
                                  final current = int.tryParse(
                                        _quantityController.text,
                                      ) ??
                                      1;
                                  if (current > 1) {
                                    _quantityController.text =
                                        (current - 1).toString();
                                  }
                                },
                                child: const Text('−'),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TextField(
                                  controller: _quantityController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '数量',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (_) => _addFood(),
                                ),
                              ),
                              const SizedBox(width: 4),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                ),
                                onPressed: () {
                                  final current = int.tryParse(
                                        _quantityController.text,
                                      ) ??
                                      1;
                                  _quantityController.text =
                                      (current + 1).toString();
                                },
                                child: const Text('+'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addFood,
                                child: const Text('添加'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('保质期至:'),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 年份选择
                                  Expanded(
                                    child: PickerField<int>(
                                      items: _getYearRange(),
                                      currentValue: _expirationYear,
                                      onChanged: (value) {
                                        setState(() {
                                          _expirationYear = value;
                                          // 检查日期是否有效
                                          final maxDay = _getDaysInMonth(
                                              _expirationYear,
                                              _expirationMonth);
                                          if (_expirationDay > maxDay) {
                                            _expirationDay = maxDay;
                                          }
                                        });
                                      },
                                      itemBuilder: (value) => value.toString(),
                                      label: '年',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 月份选择
                                  Expanded(
                                    child: PickerField<int>(
                                      items: _getMonthRange(),
                                      currentValue: _expirationMonth,
                                      onChanged: (value) {
                                        setState(() {
                                          _expirationMonth = value;
                                          // 检查日期是否有效
                                          final maxDay = _getDaysInMonth(
                                              _expirationYear,
                                              _expirationMonth);
                                          if (_expirationDay > maxDay) {
                                            _expirationDay = maxDay;
                                          }
                                        });
                                      },
                                      itemBuilder: (value) => value.toString(),
                                      label: '月',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 日期选择
                                  Expanded(
                                    child: PickerField<int>(
                                      items: _getDayRange(),
                                      currentValue: _expirationDay,
                                      onChanged: (value) {
                                        setState(() {
                                          _expirationDay = value;
                                        });
                                      },
                                      itemBuilder: (value) => value.toString(),
                                      label: '日',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: null,
    );
  }
}
