import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rool/criarconta.dart';
import 'package:rool/home.dart';
import 'package:rool/main.dart';
import 'package:rool/redefinirsenha.dart';
import 'package:rool/logingoogle.dart'; // Importe o serviço

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  bool _isSigningIn = false;
  String email = '';
  String password = '';

  Future<void> _handleSignIn(BuildContext context) async {
    setState(() {
      _isSigningIn = true;
    });

    User? user = await _googleSignInService.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => Home()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Falha ao fazer login com o Google."),
        ),
      );
    }

    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
          ),
        ),
        padding: const EdgeInsets.all(27),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.centerLeft,
              width: 55,
              child: Image.asset('images/logo0.png'),
            ),
            SizedBox(
              height: 8,
              width: 8,
            ),
            Row(
              children: [
                const Text(
                  "Entre para conferir as",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  " novidades",
                  style: TextStyle(color: baseColor, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CupertinoTextField(
              cursorColor: baseColor,
              padding: const EdgeInsets.all(15),
              placeholder: "Seu e-mail",
              placeholderStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (value) => email = value,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoTextField(
              padding: const EdgeInsets.all(15),
              cursorColor: baseColor,
              placeholder: "Digite sua senha",
              obscureText: true,
              placeholderStyle:
                  const TextStyle(color: Colors.white70, fontSize: 14),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (value) => password = value,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    " CLIQUE AQUI",
                    style: TextStyle(color: baseColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(8),
                color: Colors.orange.shade400,
                child: const Text(
                  "ACESSAR",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    // Se a autenticação for bem-sucedida, navegue para a próxima tela
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Home(),
                      ),
                    );
                  } catch (e) {
                    // Se ocorrer um erro durante a autenticação, exiba uma mensagem de erro
                    print("Erro de login: $e");
                    // Exemplo de exibição de uma mensagem de erro usando um SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Falha ao fazer login. Verifique suas credenciais.")),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 0.8),
                borderRadius: BorderRadius.circular(7),
              ),
              child: CupertinoButton(
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => CreateAccountPage(),
                    ),
                  );
                },
                child: const Text(
                  "CRIE UMA CONTA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      " OU ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await _handleSignIn(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/google.png', // Substitua pelo caminho do seu ícone do Google
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Entrar com o Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_isSigningIn)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
