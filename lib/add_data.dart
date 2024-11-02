import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';
import 'food_data.dart';

class MyAddData extends StatelessWidget {
  const MyAddData({super.key});

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
                topButton(Icons.arrow_back_ios_new_rounded, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyData())
                  );
                }),
                const Spacer(),
                topButton(Icons.person, () {}),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddField(label: 'Nama Produk'),
              const SizedBox(height: 10),
              AddField(label: 'Harga'),
              const SizedBox(height: 10),
              AddDropdownField(
                  label: 'Kategori Produk',
                  items: const ['All', 'Makanan', 'Minuman']),
              const SizedBox(height: 10),
              AddField(label: 'Image'),
              const SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
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
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddField extends StatelessWidget {
  final String label;

  const AddField({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true, 
            ),
          ),
        ),
      ],
    );
  }
}

class AddDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;

  const AddDropdownField(
      {required this.label, required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (value) {
              
            },
          ),
        ),
      ],
    );
  }
}