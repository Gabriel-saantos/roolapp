import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({Key? key}) : super(key: key);

  

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> createAccount(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    // Verificar se o nome de usuário já está em uso
    bool usernameExists = await _checkUsernameExists(usernameController.text);
    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nome de usuário em uso")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Conta criada com sucesso!")),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'A senha fornecida é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        message = 'Esse e-mail já foi utilizado';
      } else {
        message = e.message ?? 'Ocorreu um erro';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<bool> _checkUsernameExists(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    return result.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Criar Conta", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
          ),
        ),
        padding: const EdgeInsets.all(27),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  // Lógica para selecionar a imagem de perfil
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.add_a_photo_rounded,
                        color: Colors.white70, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: nameController,
                cursorColor: Colors.orange,
                padding: const EdgeInsets.all(15),
                placeholder: "Seu Nome",
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: usernameController,
                cursorColor: Colors.orange,
                padding: const EdgeInsets.all(15),
                placeholder: "Nome de usuário @",
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: emailController,
                cursorColor: Colors.orange,
                padding: const EdgeInsets.all(15),
                placeholder: "Seu e-mail",
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: passwordController,
                padding: const EdgeInsets.all(15),
                cursorColor: Colors.orange,
                placeholder: "Crie sua senha",
                obscureText: true,
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: confirmPasswordController,
                padding: const EdgeInsets.all(15),
                cursorColor: Colors.orange,
                placeholder: "Confirme sua senha",
                obscureText: true,
                placeholderStyle:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade400,
                  child: const Text(
                    "CRIAR CONTA",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    createAccount(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
