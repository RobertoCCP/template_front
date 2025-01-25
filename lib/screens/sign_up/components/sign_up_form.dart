import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';
import '../../sign_in/sign_in_screen.dart';

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
  final TextEditingController _paisController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _limiteCreditoController = TextEditingController();
  final TextEditingController _saldoPendienteController = TextEditingController();
  final TextEditingController _cedulaRucController = TextEditingController();
  final TextEditingController _codListaPrecioController = TextEditingController();
  final TextEditingController _calificacionController = TextEditingController();
  final TextEditingController _nombreComercialController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Valores para los dropdown
  String? _selectedCodTipoCliente;
  String? _selectedCodFormaPago;
  String? _selectedCodVendedor;
  String? _selectedEstado;

  bool _isLoading = false;
  final List<String?> errors = [];
  
  List<Map<String, dynamic>> _tiposClientes = [];
  List<Map<String, dynamic>> _formasPago = [];
  List<Map<String, dynamic>> _vendedores = [];

  // Variables del formulario
  String? email;
  String? password;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  // Cargar datos de los dropdown desde la API
  Future<void> _loadDropdownData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tiposClientesResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/tiposclientes'));
      final formasPagoResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/formas-pago'));
      final vendedoresResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/vendedor'));

      if (tiposClientesResponse.statusCode == 200) {
        setState(() {
          _tiposClientes = List<Map<String, dynamic>>.from(json.decode(tiposClientesResponse.body));
        });
      }

      if (formasPagoResponse.statusCode == 200) {
        setState(() {
          _formasPago = List<Map<String, dynamic>>.from(json.decode(formasPagoResponse.body));
        });
      }

      if (vendedoresResponse.statusCode == 200) {
        setState(() {
          _vendedores = List<Map<String, dynamic>>.from(json.decode(vendedoresResponse.body)['datos']['data']);
        });
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generar el código del cliente basado en la Cédula/RUC
  String _generateCodCliente() {
    final cedulaRuc = _cedulaRucController.text;
    return 'CLI-$cedulaRuc';
  }

  // Función para registrar al cliente
  Future<void> _registrarCliente() async {
    setState(() {
      _isLoading = true;
    });

    final codCliente = _generateCodCliente();

    final url = Uri.parse('http://10.0.2.2:8000/api/clientes/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'codcliente': codCliente,
        'codtipocliente': _selectedCodTipoCliente,
        'nombre': _nombreController.text,
        'email': _emailController.text,
        'pais': _paisController.text,
        'provincia': _provinciaController.text,
        'ciudad': _ciudadController.text,
        'codvendedor': _selectedCodVendedor,
        'codformapago': _selectedCodFormaPago,
        'estado': _selectedEstado,
        'limitecredito': _limiteCreditoController.text,
        'saldopendiente': _saldoPendienteController.text,
        'cedularuc': _cedulaRucController.text,
        'codlistaprecio': _codListaPrecioController.text,
        'calificacion': _calificacionController.text,
        'nombrecomercial': _nombreComercialController.text,
        'login': _loginController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente registrado con éxito!')),
      );
      Navigator.pushNamed(context, SignInScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar cliente')),
      );
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
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Nombre",
              hintText: "Ingresa tu nombre completo",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
            onSaved: (newValue) => _nombreController.text = newValue ?? "",
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Ingresa tu correo electrónico",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
            onSaved: (newValue) => email = newValue,  // Definir variable email aquí
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
            onSaved: (newValue) => password = newValue,  // Definir variable password aquí
          ),
          const SizedBox(height: 20),
          // Dropdown para Tipo de Cliente
          DropdownButtonFormField<String>(
            value: _selectedCodTipoCliente,
            decoration: InputDecoration(labelText: 'Tipo de Cliente'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCodTipoCliente = newValue;
              });
            },
            items: _tiposClientes.map<DropdownMenuItem<String>>((tipo) {
              return DropdownMenuItem<String>(
                value: tipo['codtipocliente'],
                child: Text(tipo['descripcion']),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Dropdown para Forma de Pago
          DropdownButtonFormField<String>(
            value: _selectedCodFormaPago,
            decoration: InputDecoration(labelText: 'Forma de Pago'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCodFormaPago = newValue;
              });
            },
            items: _formasPago.map<DropdownMenuItem<String>>((forma) {
              return DropdownMenuItem<String>(
                value: forma['codformapago'],
                child: Text(forma['nombre']),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Dropdown para Vendedor
          DropdownButtonFormField<String>(
            value: _selectedCodVendedor,
            decoration: InputDecoration(labelText: 'Vendedor'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCodVendedor = newValue;
              });
            },
            items: _vendedores.map<DropdownMenuItem<String>>((vendedor) {
              return DropdownMenuItem<String>(
                value: vendedor['codvendedor'],
                child: Text(vendedor['nombre']),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Dropdown para Estado
          DropdownButtonFormField<String>(
            value: _selectedEstado,
            decoration: InputDecoration(labelText: 'Estado'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedEstado = newValue;
              });
            },
            items: [
              DropdownMenuItem<String>(value: 'A', child: Text('Activo')),
              DropdownMenuItem<String>(value: 'I', child: Text('Inactivo')),
            ],
          ),
          const SizedBox(height: 20),
          // Otros campos de entrada
          TextFormField(
            controller: _paisController,
            decoration: const InputDecoration(
              labelText: "País",
              hintText: "Ingresa tu país",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _provinciaController,
            decoration: const InputDecoration(
              labelText: "Provincia",
              hintText: "Ingresa tu provincia",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _ciudadController,
            decoration: const InputDecoration(
              labelText: "Ciudad",
              hintText: "Ingresa tu ciudad",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _limiteCreditoController,
            decoration: const InputDecoration(
              labelText: "Límite de Crédito",
              hintText: "Ingresa tu límite de crédito",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _saldoPendienteController,
            decoration: const InputDecoration(
              labelText: "Saldo Pendiente",
              hintText: "Ingresa tu saldo pendiente",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _cedulaRucController,
            decoration: const InputDecoration(
              labelText: "Cédula o RUC",
              hintText: "Ingresa tu cédula o RUC",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _codListaPrecioController,
            decoration: const InputDecoration(
              labelText: "Código Lista Precio",
              hintText: "Ingresa el código de lista de precios",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _calificacionController,
            decoration: const InputDecoration(
              labelText: "Calificación",
              hintText: "Ingresa tu calificación",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nombreComercialController,
            decoration: const InputDecoration(
              labelText: "Nombre Comercial",
              hintText: "Ingresa el nombre comercial",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _loginController,
            decoration: const InputDecoration(
              labelText: "Login",
              hintText: "Ingresa tu login",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 20),
          // Botón de Enviar
          ElevatedButton(
            onPressed: _registrarCliente,
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}
