import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/custom_surfix_icon.dart';
import '../../../constants.dart';
import 'sign_up_form_2.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de entrada
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cedulaRucController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreComercialController = TextEditingController();

  bool _isLoading = false;
  String? _emailError;
  String? _cedulaError;
  String? _loginError;

  // Método para verificar si el email, cedula o login ya están registrados
  Future<void> _checkExistingValues() async {
    setState(() {
      _emailError = null;
      _cedulaError = null;
      _loginError = null;
    });

    setState(() {
      _isLoading = true;
    });

    try {
      // Realizar el GET a la API para obtener todos los clientes
      final clientesResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/clientes'));

      if (clientesResponse.statusCode == 200) {
        final data = json.decode(clientesResponse.body);

        if (data['datos'] != null && data['datos']['data'] != null) {
          final clientes = List<Map<String, dynamic>>.from(data['datos']['data']);

          bool emailExists = false;
          bool loginExists = false;
          bool cedulaExists = false;

          // Verificar si el email, cédula o login ya existen
          for (var cliente in clientes) {
            if (cliente['email'] == _emailController.text) {
              emailExists = true;
            }
            if (cliente['login'] == _loginController.text) {
              loginExists = true;
            }
            if (cliente['cedularuc'] == _cedulaRucController.text) {
              cedulaExists = true;
            }
          }

          // Mostrar los mensajes de error correspondientes
          if (emailExists) {
            setState(() {
              _emailError = "El correo electrónico ya está registrado";
            });
          }
          if (loginExists) {
            setState(() {
              _loginError = "El nombre de usuario ya está registrado";
            });
          }
          if (cedulaExists) {
            setState(() {
              _cedulaError = "La cédula o RUC ya está registrado";
            });
          }
        } else {
          print("No se encontraron datos de clientes.");
        }
      } else {
        print("Error al obtener los datos: ${clientesResponse.statusCode}");
      }
    } catch (e) {
      print("Error al hacer la solicitud: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: "Nombre",
              hintText: "Ingresa tu nombre completo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Ingresa tu correo electrónico",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El correo es obligatorio';
              } else if (!_isValidEmail(value)) {
                return 'El formato del correo es incorrecto';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          if (_emailError != null)
            Text(
              _emailError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _cedulaRucController,
            decoration: InputDecoration(
              labelText: "Cédula o RUC",
              hintText: "Ingresa tu cédula o RUC",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La cédula o RUC es obligatorio';
              } else if (!_isValidCedulaRuc(value)) {
                return 'El formato de la cédula o RUC es incorrecto';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          if (_cedulaError != null)
            Text(
              _cedulaError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _loginController,
            decoration: InputDecoration(
              labelText: "Usuario",
              hintText: "Ingresa tu nuevo usuario",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El usuario es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          if (_loginError != null)
            Text(
              _loginError!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Contraseña",
              hintText: "Ingresa tu contraseña",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es obligatoria';
              } else if (value.length < 8 || value.length > 15) {
                return 'La contraseña debe tener entre 8 y 15 caracteres';
              } else if (!_containsSpecialChars(value)) {
                return 'La contraseña debe contener al menos un carácter especial';
              } else if (!_containsLetter(value)) {
                return 'La contraseña debe contener al menos una letra';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nombreComercialController,
            decoration: const InputDecoration(
              labelText: "Nombre Comercial",
              hintText: "Ingresa el nombre comercial",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre comercial es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Verificar si el email, cedula o login ya están tomados
                await _checkExistingValues();

                if (_emailError == null && _cedulaError == null && _loginError == null) {
                  // Si no hay errores, continuar a la siguiente pantalla
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpForm2(
                        nombre: _nombreController.text,
                        email: _emailController.text,
                        cedulaRuc: _cedulaRucController.text,
                        login: _loginController.text,
                        password: _passwordController.text,
                        nombreComercial: _nombreComercialController.text,
                      ),
                    ),
                  );
                } else {
                  // Mostrar mensaje de error si alguno de los datos está ocupado
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Correo, cédula o usuario ya registrados")),
                  );
                }
              }
            },
            child: const Text("Siguiente"),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value);
  }

  bool _isValidCedulaRuc(String value) {
    final cedulaRucRegex = RegExp(r'^\d{10}$'); // Esto es solo un ejemplo, adapta según el formato de cédula o RUC
    return cedulaRucRegex.hasMatch(value);
  }

  bool _containsSpecialChars(String value) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
  }
  bool _containsLetter(String value) {
  return RegExp(r'[a-zA-Z]').hasMatch(value);
  }
}
