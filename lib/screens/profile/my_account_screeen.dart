import 'package:flutter/material.dart';
import 'package:shop_app/models/usuario.dart';
import 'components/my_account_form.dart';

class MyAccountScreen extends StatelessWidget {
  static String routeName = "/my_account";

  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Cuenta"),
      ),
      body: const MyAccountForm(),
    );
  }
}