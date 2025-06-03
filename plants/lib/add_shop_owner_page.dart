import 'package:flutter/material.dart';

class AddShopOwnerPage extends StatefulWidget {
  const AddShopOwnerPage({super.key});

  @override
  State<AddShopOwnerPage> createState() => _AddShopOwnerPageState();
}

class _AddShopOwnerPageState extends State<AddShopOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // هنا من الممكن إرسال البيانات للسيرفر أو تخزينها
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop owner added successfully!')),
      );

      // تفريغ الحقول
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D9773),
        elevation: 0,
        title: const Text('Add Shop Owner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,

                validator:
                    (value) => value!.isEmpty ? 'Enter owner name' : null,

              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,

                validator:
                    (value) =>
                        value!.contains('@') ? null : 'Enter valid email',

              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,

                validator:
                    (value) =>
                        value!.length < 7 ? 'Enter valid phone number' : null,

              ),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home,

                validator: (value) => value!.isEmpty ? 'Enter address' : null,

              ),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator:
                    (value) => value!.length < 6 ? 'Password too short' : null,

              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D9773),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Owner', style: TextStyle(fontSize: 18)),

                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6D9773)),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
