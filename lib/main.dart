import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart.dart';
import 'food_data.dart';
import 'widgets.dart';
import 'class/food.dart';
import 'class/food_service.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://lrznhaxrcvcjomtxnfio.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxyem5oYXhyY3Zjam9tdHhuZmlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM0ODYyMTIsImV4cCI6MjA0OTA2MjIxMn0.tIka0oPfqZrRnkvZed-pTOujrSMl5g3MQ5YiBFHxhhw',
  );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  
  FlutterNativeSplash.remove();
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedCategory;
  List<Food> filteredFoodItems = [];

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
                topButton(Icons.menu, () {}),
                const Spacer(),
                topButton(Icons.person, () {}),
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
            onTap: () {
              setState(() {
                selectedCategory =
                    selectedCategory == categoryName ? null : categoryName;
                filteredFoodItems.clear(); // Clear previous filter
              });
              fetchFilteredFoods(categoryName);
            },
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
    return FutureBuilder<List<Food>>(
      future: FoodService().fetchFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No food items available.'));
        }

        final foodList = snapshot.data!;

        // Filter the food list based on the selected category
        final filteredFoods = selectedCategory == null
            ? foodList
            : foodList
                .where((food) =>
                    food.category?.name == selectedCategory)
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCategory ?? 'All Food',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
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
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final foodItem = filteredFoods[index];
                  return foodItemContainer(
                    foodItem.name,
                    'Rp. ${foodItem.price.toStringAsFixed(2)}',
                    foodItem.image,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to fetch foods based on selected category
  Future<void> fetchFilteredFoods(String categoryName) async {
    final allFoods = await FoodService().fetchFoods();
    setState(() {
      filteredFoodItems = allFoods
          .where((food) => food.category?.name == categoryName)
          .toList();
    });
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
              child: Image.network(image, fit: BoxFit.contain),
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