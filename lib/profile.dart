import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ProfilePage({
    super.key,
    required this.name,
    required this.email,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      if (context.mounted) {
        // Kembali ke halaman login dan hapus semua halaman sebelumnya
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/', // Ganti dengan nama route login page jika menggunakan named routes
          (route) => false,
        );
      }
    } catch (error) {
      print('Error signing out: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _handleSignOut(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
