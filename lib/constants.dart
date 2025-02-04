import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 255, 67, 67);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color.fromARGB(255, 255, 62, 62), Color.fromARGB(255, 255, 67, 67)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Errores del Formulario
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Por favor, ingresa tu correo electrónico";
const String kInvalidEmailError = "Por favor, ingresa un correo electrónico válido";
const String kPassNullError = "Por favor, ingresa tu contraseña";
const String kShortPassError = "La contraseña es muy corta";
const String kMatchPassError = "Las contraseñas no coinciden";
const String kNamelNullError = "Por favor, ingresa tu nombre";
const String kPhoneNumberNullError = "Por favor, ingresa tu número de teléfono";
const String kAddressNullError = "Por favor, ingresa tu dirección";
const String kLoginNullError = "Por favor ingrese su usuario";
const String kInvalidLoginError = "Usuario inválido";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
