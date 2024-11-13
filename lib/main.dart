import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/profile': (context) => ProfilePage(
              name: '', // Ini sebaiknya diatur saat navigasi
              email: '', // Ini sebaiknya diatur saat navigasi
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<void> _handleGoogleSignIn() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.signOut();
      }

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null && context.mounted) {
        print('Login berhasil: ${account.displayName}');
        print('Email: ${account.email}');
        print('ID: ${account.id}');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              name: account.displayName ?? '',
              email: account.email,
            ),
          ),
        );
      } else {
        print('Login dibatalkan oleh user');
      }
    } catch (error) {
      print('Error detail: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal login: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          onPressed: _handleGoogleSignIn,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'Login dengan Google!',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
