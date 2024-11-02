import 'package:flutter/material.dart';
import 'package:flutter_slice/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

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
                // Back Button (widgets.dart)
                topButton(Icons.arrow_back_ios_new_rounded, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp())
                  );
                }),
                const Spacer(),
                Text(
                  'Cart',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // User Button (widgets.dart)
                topButton(Icons.person, () {}),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              cartList(),
              SizedBox(height: 20),
              cartDetails(),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 55),
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
                  child: Text(
                    'Checkout',
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

  Widget cartList() {
    final cartItems = [
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
      {
        'name': 'Burger King Small',
        'price': 'Rp. 35.000,00',
        'image': 'assets/burger.png'
      },
    ];

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return cartListContainer(
            item['name'] ?? 'Burger King Medium',
            item['price'] ?? '50.000,00',
            item['image'] ?? 'assets/burger.png',
          );
        },
      ),
    );
  }

  Widget cartListContainer(String name, String price, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                price,
                style: GoogleFonts.poppins(),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.remove),
                      iconSize: 10,
                      onPressed: () => {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(fontSize: 10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add),
                      iconSize: 10,
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => {},
          ),
        ),
      ],
    );
  }

  Widget cartDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Belanja',
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text('PPN 11%'),
              const Spacer(),
              Text('Rp 10.000,00'),
            ],
          ),
          Row(
            children: [
              Text('Total Belanja'),
              const Spacer(),
              Text('Rp 94.000,00'),
            ],
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black,
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
          Row(
            children: [
              Text(
                'Total Pembayaran',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Rp 10.000,00',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}