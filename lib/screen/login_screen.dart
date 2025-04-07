import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;  // Variabel untuk mengatur visibilitas password

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Bagian atas biru
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Color(0xFF0076C0), // Biru
            ),
          ),
          // Bagian bawah putih
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              color: Colors.white, // Putih
            ),
          ),
          // Konten berada di tengah (Overlay)
          Center(
            child: SingleChildScrollView(  // Menggunakan SingleChildScrollView untuk memastikan konten tetap scrollable
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul "Masuk" di luar box, warna putih
                    Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,  // Warna teks putih
                      ),
                    ),
                    SizedBox(height: 20),

                    // Box input fields
                    Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,  // White box
                        borderRadius: BorderRadius.circular(10),  // Mengurangi rounded corner
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0076C0).withOpacity(0.5), // Blue shadow
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Input NIPP menggantikan Email
                          _buildInputField("NIPP", Icons.person), // Mengganti ikon email dengan ikon user

                          SizedBox(height: 16),

                          // Input Password dengan visibility toggle
                          _buildInputField("Password", Icons.lock, isPassword: true),

                          SizedBox(height: 16),

                          // Forgot Password
                          Text(
                            "Lupa Password?",
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                          ),

                          SizedBox(height: 20),

                          // Tombol Login dengan efek 3D
                          _build3DButton("Masuk", Color(0xFF0076C0), screenWidth * 0.8),

                          SizedBox(height: 16),

                          // Signup Link
                          Text(
                            "Belum memiliki akun? Daftar",
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword && !_isPasswordVisible,
      style: TextStyle(color: Colors.black),
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
          borderSide: BorderSide(color: Color(0xFF0076C0), width: 2),  // Border biru saat fokus
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
    );
  }

  Widget _build3DButton(String text, Color color, double width) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 15,
            offset: Offset(3, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
