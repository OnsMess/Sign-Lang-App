import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginScreen.dart';

class RegScreen extends StatefulWidget {
  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _username = '';

  void _inscription() async {
    if (_password != _confirmPassword) {
      _afficherErreur('Les mots de passe ne correspondent pas!');
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Update the user's display name (username)
      await userCredential.user?.updateDisplayName(_username);

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Vous êtes enregistré'),
        ));
      } else {
        _afficherErreur("L'enregistrement a échoué");
      }
    } catch (e) {
      _afficherErreur('Une erreur s\'est produite : ${e.toString()}');
    }
  }

  void _afficherErreur(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inscription",
          style: TextStyle(
            color: Color.fromARGB(255, 227, 39, 220),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 190, 237, 248),
              Color.fromARGB(255, 126, 204, 250),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(
                  color: Color.fromARGB(255, 114, 98, 233),
                ),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(
                  color: Color.fromARGB(255, 114, 98, 233),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Color.fromARGB(255, 114, 98, 233), // Text color
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Confirmer mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Color.fromARGB(255, 114, 98, 233),
                ),
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _inscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 227, 39, 220),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                "S'inscrire",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
