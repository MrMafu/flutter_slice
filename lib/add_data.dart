import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slice/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';
import 'food_data.dart';
import 'class/food.dart';
import 'class/food_service.dart';

class MyAddData extends StatefulWidget {
  const MyAddData({super.key});

  @override
  _MyAddDataState createState() => _MyAddDataState();
}

class _MyAddDataState extends State<MyAddData> {
  final FoodService _foodService = FoodService();
  List<FoodCategory> _categories = [];
  FoodCategory? _selectedCategory;
  String _productName = '';
  double _productPrice = 0.0;
  File? _selectedImage;
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      List<FoodCategory> categories = await _foodService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        String imageUrl = await _uploadImageToSupabase(pickedFile);

        setState(() {
          _selectedImage = File(pickedFile.path);
          _imageUrl = imageUrl;
        });
        print('Image URL: $_imageUrl');
      } else {
        throw Exception("No file selected");
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick or upload image')),
      );
    }
  }

  Future<String> _uploadImageToSupabase(XFile pickedFile) async {
    final fileName = 'food_images/${DateTime.now().millisecondsSinceEpoch}.jpg'; // Unique name
    final file = File(pickedFile.path);

    // Upload the file to Supabase storage
    final storageResponse = await supabase.storage.from('food_images').upload(fileName, file);

    // if (storageResponse.error != null) {
    //   throw Exception("Failed to upload image: ${storageResponse.error!.message}");
    // }

    // Get the public URL of the uploaded image
    // print(supabase.storage.from('food_images').getPublicUrl(fileName));
    final publicUrl = await supabase.storage.from('food_images').getPublicUrl(fileName);

    return publicUrl;
  }

  Future<void> _submitForm() async {
    if (_productName.isEmpty || _productPrice <= 0 || _selectedCategory == null || _imageUrl.isEmpty) {
      print('Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    print('Submitting with:');
    print('Product Name: $_productName');
    print('Product Price: $_productPrice');
    print('Category: ${_selectedCategory?.name}');
    print('Image URL: $_imageUrl');

    final food = Food(
      name: _productName,
      price: _productPrice,
      category: _selectedCategory!,
      image: _imageUrl,
      createdAt: DateTime.now(),
    );

    try {
      await _foodService.insertFood(food);
      print('Food inserted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food data added successfully')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyData()),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting data')),
      );
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
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                topButton(Icons.arrow_back_ios_new_rounded, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyData()));
                }),
                const Spacer(),
                topButton(Icons.person, () {}),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddField(
                    label: 'Nama Produk',
                    placeholder: 'Masukkan nama produk',
                    onChanged: (value) => _productName = value,
                  ),
                  const SizedBox(height: 10),
                  AddField(
                    label: 'Harga',
                    placeholder: 'Masukkan harga',
                    onChanged: (value) =>
                        _productPrice = double.tryParse(value) ?? 0.0,
                  ),
                  const SizedBox(height: 10),
                  AddDropdownField(
                    label: 'Kategori Produk',
                    items: _categories.map((category) => category.name).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        print('Selected category: $value');
                        setState(() {
                          _selectedCategory = _categories.firstWhere((category) => category.name == value);
                        });
                      } else {
                        print('No category selected');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  AddImageField(
                    onImagePicked: _pickImage,
                    selectedImage: _selectedImage,
                  ),
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
                      onTap: _submitForm,
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
        ),
      ),
    );
  }
}

extension on String {
  get error => null;
  
  get data => null;
}



class AddField extends StatelessWidget {
  final String label;
  final String placeholder;
  final ValueChanged<String> onChanged;

  const AddField(
      {required this.label,
      required this.placeholder,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
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
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.poppins(fontSize: 10),
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
  final ValueChanged<String?> onChanged;

  const AddDropdownField(
      {required this.label,
      required this.items,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class AddImageField extends StatelessWidget {
  final Future<void> Function() onImagePicked;
  final File? selectedImage;

  const AddImageField(
      {required this.onImagePicked, required this.selectedImage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
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
          child: InkWell(
            onTap: onImagePicked,
            child: selectedImage == null
                ? const Icon(Icons.add_a_photo_outlined)
                : Image.file(selectedImage!),
          ),
        ),
      ],
    );
  }
}