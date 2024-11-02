import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';
import 'main.dart';
import 'add_data.dart';

class MyData extends StatelessWidget {
  const MyData({super.key});

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
        body: Container(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: foodTable(),
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
      columns: [
        DataColumn(label: Text('Foto', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Nama Produk', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Harga', style: GoogleFonts.poppins(fontSize: 10))),
        DataColumn(label: Text('Aksi', style: GoogleFonts.poppins(fontSize: 10))),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Image.asset('assets/burger.png', width: 50, height: 50)),
          DataCell(Text('Burger King Medium', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(Text('Rp.50.000,00', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Image.asset('assets/sosro.png', width: 50, height: 50)),
          DataCell(Text('Teh Botol', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(Text('Rp.4.000,00', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Image.asset('assets/burger.png', width: 50, height: 50)),
          DataCell(Text('Burger King Small', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(Text('Rp.35.000,00', style: GoogleFonts.poppins(fontSize: 10))),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ),
        ]),
      ],
    );
  }
}