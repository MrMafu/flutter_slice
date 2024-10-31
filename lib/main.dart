import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart.dart';
import 'food_data.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project Kinan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          scrolledUnderElevation: 0,
          title: Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                topButton(Icons.menu),
                const Spacer(),
                topButton(Icons.person),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              categoryList(),
              const SizedBox(height: 30),
              Expanded(child: foodItem()),
            ],
          ),
        ),
        bottomNavigationBar: Builder(
          builder: (context) => BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCart()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyData()),
                  );
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryItem('All', 'assets/burger.png'),
        categoryItem('Makanan', 'assets/burger.png'),
        categoryItem('Minuman', 'assets/sosro.png'),
      ],
    );
  }

  Widget categoryItem(String categoryName, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:
                selectedCategory == categoryName ? Colors.blue : Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() {
              selectedCategory =
                  selectedCategory == categoryName ? null : categoryName;
            }),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          categoryName,
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget foodItem() {
    final foodList = [
      {
        'name': 'Burger King Medium',
        'price': 'Rp. 50.000,00',
        'image': 'assets/burger.png'
      },
      {
        'name': 'Teh Botol',
        'price': 'Rp. 4.000,00',
        'image': 'assets/sosro.png'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Food',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: foodList.length,
            itemBuilder: (context, index) {
              final item = foodList[index];
              return foodItemContainer(
                item['name'] ?? 'Item',
                item['price'] ?? 'Rp. 0',
                item['image'] ?? 'assets/placeholder.png',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget foodItemContainer(String name, String price, String image) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => {},
        child: Column(
          children: [
            Expanded(
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      Text(price, style: GoogleFonts.poppins(fontSize: 10)),
                    ],
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, color: Colors.white),
                    iconSize: 10,
                    onPressed: () => {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}