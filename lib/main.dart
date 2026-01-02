import 'package:flutter/material.dart'; // 导入Flutter的Material Design库，用于UI组件
// 用于加载assets

void main() {
  // 主函数，应用的入口点
  runApp(FridgeApp()); // 运行FridgeApp应用
}

class FridgeApp extends StatelessWidget {
  // 定义FridgeApp类，继承StatelessWidget，无状态组件
  const FridgeApp({super.key}); // 构造函数，接受key参数

  @override
  Widget build(BuildContext context) {
    // 构建UI
    return MaterialApp(
      // 返回MaterialApp，提供应用框架
      title: '冰箱食材列表', // 应用标题
      theme: ThemeData(primarySwatch: Colors.blue), // 主题
      home: FridgeHome(), // 主页
    );
  }
}

class FridgeHome extends StatefulWidget {
  // 定义FridgeHome类，继承StatefulWidget，有状态组件
  const FridgeHome({super.key}); // 构造函数

  @override
  State<FridgeHome> createState() => _FridgeHomeState(); // 创建状态
}

class _FridgeHomeState extends State<FridgeHome> {
  // 定义状态类
  final List<Map<String, dynamic>> _foods = [
    // 定义食材列表，使用final修饰
    {
      'id': 1,
      'name': '牛肉末',
      'quantity': '500g',
      'type': 'frozen',
      'icon': '🥩',
    }, // 初始食材1
    {
      'id': 2,
      'name': '鸡蛋',
      'quantity': '2个',
      'type': 'refrigerated',
      'icon': '🥚',
    }, // 初始食材2
  ];

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
      // 可以继续添加更多关键词
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
      "炸玉米饼": "🌮",
      "墨西哥卷饼": "🌯",
      "塔马利": "🫔",
      "酿大饼": "🥙",
      "沙拉三明治": "🧆",
      "蛋": "🥚",
      "烹饪": "🍳",
      "浅盘食物": "🥘",
      "一锅食物": "🍲",
      "火锅": "🫕",
      "带勺子的碗": "🥣",
      "绿色的沙拉": "🥗",
      "爆米花": "🍿",
      "黄油": "🧈",
      "盐": "🧂",
      "罐头食品": "🥫",
      "便当盒": "🍱",
      "米果": "🍘",
      "饭团": "🍙",
      "熟米饭": "🍚",
      "咖喱饭": "🍛",
      "蒸碗": "🍜",
      "意大利细面条": "🍝",
      "烤红薯": "🍠",
      "奥登": "🍢",
      "寿司": "🍣",
      "炒虾仁": "🍤",
      "带漩涡的鱼饼": "🍥",
      "月饼": "🥮",
      "团子": "🍡",
      "饺子": "🥟",
      "幸运饼干": "🥠",
      "外卖盒": "🥡",
      "螃蟹": "🦀",
      "龙虾": "🦞",
      "虾": "🦐",
      "乌贼": "🦑",
      "牡蛎": "🦪",
      "软冰淇淋": "🍦",
      "刨冰": "🍧",
      "冰淇淋": "🍨",
      "油炸圈饼": "🍩",
      "曲奇饼": "🍪",
      "生日蛋糕": "🎂",
      "脆饼": "🍰",
      "纸杯蛋糕": "🧁",
      "馅饼": "🥧",
      "巧克力吧": "🍫",
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

  void _addFood() {
    // 定义添加食材的方法
    String name = ''; // 食材名称变量
    String quantity = ''; // 食材数量变量
    String type = 'refrigerated'; // 食材类型，默认冷藏
    showDialog(
      // 显示对话框
      context: context, // 上下文
      builder: (context) {
        // 构建对话框
        return AlertDialog(
          // 返回AlertDialog
          title: Text('添加食材'), // 标题
          content: Column(
            // 内容列
            mainAxisSize: MainAxisSize.min, // 最小尺寸
            children: [
              // 子组件
              TextField(
                // 文本输入框
                decoration: InputDecoration(labelText: '名称'), // 装饰
                onChanged: (value) => name = value, // 改变时赋值
              ),
              TextField(
                // 数量输入框
                decoration: InputDecoration(labelText: '数量'), // 装饰
                onChanged: (value) => quantity = value, // 改变时赋值
              ),
              DropdownButton<String>(
                // 下拉按钮
                value: type, // 当前值
                items: [
                  // 选项
                  DropdownMenuItem(value: 'frozen', child: Text('冷冻')), // 冷冻选项
                  DropdownMenuItem(
                    // 冷藏选项
                    value: 'refrigerated',
                    child: Text('冷藏'),
                  ),
                ],
                onChanged: (value) => setState(() => type = value!), // 改变时更新状态
              ),
            ],
          ),
          actions: [
            // 动作按钮
            TextButton(
              // 取消按钮
              onPressed: () => Navigator.pop(context), // 关闭对话框
              child: Text('取消'),
            ),
            TextButton(
              // 添加按钮
              onPressed: () {
                // 点击时
                if (name.isNotEmpty && quantity.isNotEmpty) {
                  // 检查输入
                  print(
                    'Adding: name=$name, quantity=$quantity, type=$type',
                  ); // 调试打印
                  print('Foods before: $_foods'); // 调试打印
                  setState(() {
                    // 更新状态
                    _foods.add({
                      // 添加到列表
                      'id': DateTime.now().millisecondsSinceEpoch, // 唯一ID
                      'name': name,
                      'quantity': quantity,
                      'type': type,
                      'icon': _getIcon(name), // 根据名称获取图标
                    });
                  });
                  print('Foods after: $_foods'); // 调试打印
                  Navigator.pop(context); // 关闭对话框
                }
              },
              child: Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _removeFood(Map<String, dynamic> food) {
    // 定义删除食材的方法
    print('Removing food: $food'); // 调试打印
    setState(() {
      // 更新状态
      _foods.remove(food); // 从列表移除
    });
    print('Foods after removal: $_foods'); // 调试打印
  }

  @override
  Widget build(BuildContext context) {
    // 构建UI
    return Scaffold(
      // 返回Scaffold，提供基本页面结构
      appBar: AppBar(title: Text('冰箱食材列表')), // 应用栏
      body: Container(
        // 主体容器
        decoration: BoxDecoration(
          // 装饰
          image: DecorationImage(
            // 背景图片
            image: AssetImage('assets/images/fridge.jpg'), // 图片资源
            fit: BoxFit.cover, // 覆盖方式
          ),
          borderRadius: BorderRadius.circular(20), // 圆角
          border: Border.all(color: Colors.black, width: 4), // 边框
        ),
        margin: EdgeInsets.all(16), // 外边距
        child: Column(
          // 子组件列
          children: [
            // 子组件列表
            // 冷冻层
            Expanded(
              // 扩展
              child: Container(
                // 容器
                decoration: BoxDecoration(
                  // 装饰
                  color: Colors.blue.shade100, // 背景色
                  borderRadius: BorderRadius.only(
                    // 圆角
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  // 列
                  children: [
                    // 子组件
                    Padding(
                      // 内边距
                      padding: const EdgeInsets.all(8.0), // 内边距值
                      child: Container(
                        // 添加背景容器
                        color: Colors.white.withValues(alpha: 0.8), // 半透明白色背景
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ), // 内边距
                        child: Text(
                          // 文本
                          '冷冻层', // 内容
                          style: TextStyle(
                            // 样式
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // 确保黑色
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // 扩展
                      child: GridView.extent(
                        // 网格视图
                        maxCrossAxisExtent: 100, // 最大交叉轴范围，决定格子大小
                        children: _foods
                            .where((food) => food['type'] == 'frozen')
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                // 手势检测器
                                onTap: () {
                                  // 点击时显示名称
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(entry.value['name']),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  // 长按删除
                                  _removeFood(entry.value);
                                },
                                child: Container(
                                  // 容器
                                  margin: EdgeInsets.all(4), // 外边距
                                  decoration: BoxDecoration(
                                    // 装饰
                                    color: Colors.white.withValues(
                                      alpha: 0.8,
                                    ), // 背景色
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // 圆角
                                  ),
                                  child: Stack(
                                    // 堆栈
                                    children: [
                                      Center(
                                        // 居中
                                        child: Text(
                                          // emoji图标
                                          entry.value['icon'],
                                          style: TextStyle(fontSize: 40), // 大小
                                        ),
                                      ),
                                      Positioned(
                                        // 定位
                                        bottom: 4,
                                        right: 4,
                                        child: Text(
                                          // 数量文本
                                          entry.value['quantity'],
                                          style: TextStyle(
                                            // 样式
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
                            .toList(), // 转换为列表
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 分隔线
            Container(height: 4, color: Colors.black), // 分隔线
            // 冷藏层
            Expanded(
              // 扩展
              child: Container(
                // 容器
                decoration: BoxDecoration(
                  // 装饰
                  color: Colors.green.shade100, // 背景色
                  borderRadius: BorderRadius.only(
                    // 圆角
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  // 列
                  children: [
                    // 子组件
                    Padding(
                      // 内边距
                      padding: const EdgeInsets.all(8.0), // 内边距值
                      child: Container(
                        // 添加背景容器
                        color: Colors.white.withValues(alpha: 0.8), // 半透明白色背景
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ), // 内边距
                        child: Text(
                          // 文本
                          '冷藏层', // 内容
                          style: TextStyle(
                            // 样式
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // 确保黑色
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      // 扩展
                      child: GridView.extent(
                        // 网格视图
                        maxCrossAxisExtent: 100, // 最大交叉轴范围，决定格子大小
                        children: _foods
                            .where((food) => food['type'] == 'refrigerated')
                            .toList()
                            .asMap()
                            .entries
                            .map(
                              (entry) => GestureDetector(
                                // 手势检测器
                                onTap: () {
                                  // 点击时显示名称
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(entry.value['name']),
                                    ),
                                  );
                                },
                                onLongPress: () {
                                  // 长按删除
                                  _removeFood(entry.value);
                                },
                                child: Container(
                                  // 容器
                                  margin: EdgeInsets.all(4), // 外边距
                                  decoration: BoxDecoration(
                                    // 装饰
                                    color: Colors.white.withValues(
                                      alpha: 0.8,
                                    ), // 背景色
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // 圆角
                                  ),
                                  child: Stack(
                                    // 堆栈
                                    children: [
                                      Center(
                                        // 居中
                                        child: Text(
                                          // emoji图标
                                          entry.value['icon'],
                                          style: TextStyle(fontSize: 40), // 大小
                                        ),
                                      ),
                                      Positioned(
                                        // 定位
                                        bottom: 4,
                                        right: 4,
                                        child: Text(
                                          // 数量文本
                                          entry.value['quantity'],
                                          style: TextStyle(
                                            // 样式
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
                            .toList(), // 转换为列表
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 浮动操作按钮
        onPressed: _addFood, // 点击回调
        child: Icon(Icons.add), // 图标
      ),
    );
  }
}
