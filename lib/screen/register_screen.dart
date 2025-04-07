import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  String? selectedTerminal;
  String? selectedJabatan;

  List<String> terminals = [];
  List<String> jabatans = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController nippController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      // Ambil daftar Terminal dari Firestore
      QuerySnapshot terminalSnapshot =
      await FirebaseFirestore.instance.collection('terminals').get();
      List<String> terminalList = terminalSnapshot.docs
          .map((doc) => doc['name'].toString()) // Ambil field 'name'
          .toList();

      // Ambil daftar Jabatan dari Firestore
      QuerySnapshot roleSnapshot =
      await FirebaseFirestore.instance.collection('roles').get();
      List<String> roleList = roleSnapshot.docs
          .map((doc) => doc['name'].toString()) // Ambil field 'name'
          .toList();

      setState(() {
        terminals = terminalList;
        jabatans = roleList;
      });
    } catch (e) {
      print("Error fetching dropdown data: $e");
    }
  }

  Future<void> _registerUser() async {
    try {
      // Buat akun baru di Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Simpan data pengguna ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nama_lengkap': nameController.text.trim(),
        'nipp': nippController.text.trim(),
        'email': emailController.text.trim(),
        'terminal': selectedTerminal,
        'jabatan': selectedJabatan,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Berhasil! Pindah ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi gagal: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Daftar", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInputField("Nama Lengkap", Icons.person, screenWidth, nameController),
              SizedBox(height: 16),
              _buildInputField("NIPP", Icons.badge, screenWidth, nippController),
              SizedBox(height: 16),
              _buildInputField("Email", Icons.email, screenWidth, emailController),
              SizedBox(height: 16),
              _buildDropdownField("Terminal", terminals, (value) => setState(() => selectedTerminal = value), screenWidth),
              SizedBox(height: 16),
              _buildDropdownField("Jabatan", jabatans, (value) => setState(() => selectedJabatan = value), screenWidth),
              SizedBox(height: 16),
              _buildInputField("Password", Icons.lock, screenWidth, passwordController, isPassword: true),
              SizedBox(height: 24),
              _build3DButton("Daftar", Color(0xFF0076C0), screenWidth, _registerUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, IconData icon, double width, TextEditingController controller, {bool isPassword = false}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF0076C0), width: 2),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, List<String> items, ValueChanged<String?> onChanged, double width) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF0076C0), width: 2),
          ),
        ),
        hint: Text(hint, style: TextStyle(color: Colors.black45)),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _build3DButton(String text, Color color, double width, VoidCallback onPressed) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
