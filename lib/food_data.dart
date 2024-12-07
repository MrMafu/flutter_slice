import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';
import 'main.dart';
import 'add_data.dart';
import 'class/food_service.dart';
import 'class/food.dart';

class MyData extends StatefulWidget {
  const MyData({super.key});

  @override
  _MyDataState createState() => _MyDataState();
}

class _MyDataState extends State<MyData> {
  List<Food> _foodList = [];
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    _fetchFoodData();
  }

  Future<void> _fetchFoodData() async {
    try {
      final foodList = await _foodService.fetchFoods();
      if (mounted) {
        setState(() {
          _foodList = foodList;
        });
      }
    } catch (e) {
      print("Error fetching food data: $e");
    }
  }

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
            margin: const EdgeInsets.all(40),
            child: Row(
              children: [
                // Back Button (widgets.dart)
                topButton(Icons.arrow_back_ios_new_rounded, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp())
                  );
                }),
                const Spacer(),
                // User Button (widgets.dart)
                topButton(Icons.person, () {}),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAddData())
                    )
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add Data',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Wrap the DataTable in an Expanded widget
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Horizontal scroll
                  child: foodTable(), // foodTable widget
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget foodTable() {
    return DataTable(
      columnSpacing: 15,
      horizontalMargin: 0,
      columns: [
        DataColumn(label: Text('Foto', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Nama Produk', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Harga', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Aksi', style: GoogleFonts.poppins(fontSize: 10))),
      ],
      rows: _foodList.map((food) {
        return DataRow(cells: [
          DataCell(
            Image.network(food.image, width: 50, height: 50),
          ),
          DataCell(Text(food.name, style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(Text('Rp. ${food.price.toStringAsFixed(2)}', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                try {
                  await _foodService.deleteFoodByName(food.name);
                  setState(() {
                    _foodList.remove(food);
                  });
                  await _fetchFoodData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${food.name} deleted successfully.')),
                  );
                } catch (e) {
                  print("Error deleting food: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete ${food.name}. Reason: $e')),
                  );
                }
              },
            ),
          ),
        ]);
      }).toList(),
    );
  }
}