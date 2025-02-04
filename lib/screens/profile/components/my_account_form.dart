import 'package:flutter/material.dart';
import 'package:shop_app/services/user_preferences.dart';
import '../../../models/usuario.dart';

class MyAccountForm extends StatefulWidget {
  const MyAccountForm({Key? key}) : super(key: key);

  @override
  State<MyAccountForm> createState() => _MyAccountFormState();
}

class _MyAccountFormState extends State<MyAccountForm> {
  final _formKey = GlobalKey<FormState>();
  Usuario? usuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    usuario = await UserPreferences().getUsuario();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              enabled: false,
              initialValue: usuario?.codcliente ?? '',
              decoration: const InputDecoration(
                labelText: "Código Cliente",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: usuario?.nombre ?? '',
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: usuario?.email ?? '',
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos guardados')),
                  );
                }
              },
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}