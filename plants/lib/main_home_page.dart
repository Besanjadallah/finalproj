// ✅ main_home.dart (بعد استبدال زر "الأسئلة" بزر تحليل النبتة)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:shared_preferences/shared_preferences.dart';
import 'view_orders_page.dart';
import 'profile_page.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'store_detail_page.dart';
import 'plant_chat_page.dart';


class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final List<Map<String, dynamic>> stores = [
    {
      'name': 'Green Garden',
      'image': 'assets/images/store1.jpg',
      'description': 'Indoor & Outdoor Plants',
    },
    {
      'name': 'Nature Bloom',
      'image': 'assets/images/store2.jpg',
      'description': 'Succulents and Herbs',
    },
    {
      'name': 'Leafy Living',
      'image': 'assets/images/store3.jpg',
      'description': 'Exotic Plants & Trees',
    },
  ];

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  String userName = '';
  String userEmail = '';
  String searchQuery = '';
  String selectedCategory = 'All Stores';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
      userEmail = prefs.getString('email') ?? 'Email';
    });
  }

  Future<void> chooseImageAndSend() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    if (kIsWeb) {
                      Uint8List bytes = await pickedFile.readAsBytes();
                      await _uploadWebImage(bytes);
                    } else {
                      File file = File(pickedFile.path);
                      await _uploadMobileImage(file);
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  if (pickedFile != null) {
                    if (kIsWeb) {
                      Uint8List bytes = await pickedFile.readAsBytes();
                      await _uploadWebImage(bytes);
                    } else {
                      File file = File(pickedFile.path);
                      await _uploadMobileImage(file);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadMobileImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8080/api/plant/analyze-plant'));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    var response = await request.send();
    _handleResponse(response);
  }

  Future<void> _uploadWebImage(Uint8List bytes) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8080/api/plant/analyze-plant'));
    request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: 'web_img.jpg'));
    var response = await request.send();
    _handleResponse(response);
  }

  Future<void> _handleResponse(http.StreamedResponse response) async {
    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🔬 تحليل النبتة"),
          content: Text(res),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    } else {
      print("❌ Upload failed");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStores = stores.where((store) {
      final name = store['name'].toString().toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: const Color(0xFF8DBF67),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const Text("🌿 Plant Shops", style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.receipt_long),
                        tooltip: 'My Orders',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ViewOrdersPage()),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFa5d88e), Color(0xFF8DBF67)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Icon(Icons.search, color: Colors.white),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Search stores...',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: chooseImageAndSend,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                            icon: const Icon(Icons.science, color: Colors.white),
                            tooltip: "Plant analysis",
                            onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PlantChatPage()),
                        );
                       },
                       ),

                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFa5d88e), Color(0xFF8DBF67)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var cat in ['All Stores', 'Succulents', 'Outdoor Shops', 'Indoor Shops'])
                    CategoryButton(
                      title: cat,
                      isSelected: selectedCategory == cat,
                      onTap: () => setState(() => selectedCategory = cat),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: filteredStores.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final store = filteredStores[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StoreDetailPage(storeName: store['name']),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.asset(
                              store['image'],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(store['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(store['description'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
