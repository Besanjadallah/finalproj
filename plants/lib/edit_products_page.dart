import 'package:flutter/material.dart';
import 'admin_dashboard.dart'; // تأكدي أنك ضيفتي هاي الصفحة عندك

class EditProductsPage extends StatefulWidget {
  const EditProductsPage({super.key});

  @override
  State<EditProductsPage> createState() => _EditProductsPageState();
}

class _EditProductsPageState extends State<EditProductsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: 'Rose Plant');
  final TextEditingController _priceController =
      TextEditingController(text: '15.99');
  final TextEditingController _descriptionController =
      TextEditingController(text: 'A beautiful rose plant for your garden.');

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // احفظ التعديلات هنا
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
      // ممكن ترجع المستخدم للداشبورد أو تحدث القائمة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: const Text('Edit Product'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminDashboard()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Product Name',
                    icon: Icons.local_florist,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter product name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _priceController,
                    hint: 'Price',
                    icon: Icons.attach_money,
                    inputType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _descriptionController,
                    hint: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8DBF67),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
