import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('LOGIN'),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('ENTRAR'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Não Possui conta? Criar conta'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
