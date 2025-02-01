import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../sign_in/sign_in_screen.dart';
import 'dart:convert';

class SignUpForm2 extends StatefulWidget {
  final String nombre;
  final String email;
  final String cedulaRuc;
  final String login;
  final String password;
  final String nombreComercial;

  const SignUpForm2({
    required this.nombre,
    required this.email,
    required this.cedulaRuc,
    required this.login,
    required this.password,
    required this.nombreComercial,
    super.key,
  });

  @override
  _SignUpForm2State createState() => _SignUpForm2State();
}

class _SignUpForm2State extends State<SignUpForm2> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  bool _isLoading = false;

  // Datos de las APIs
  List<Map<String, dynamic>> _tiposClientes = [];
  List<Map<String, dynamic>> _formasPago = [];
  List<Map<String, dynamic>> _vendedores = [];

  // Datos predefinidos para los países, provincias y ciudades
  final Map<String, List<String>> _paises = {
    'Ecuador': ['Pichincha', 'Azuay', 'Guayas'],
    'Perú': ['Lima', 'Cusco', 'Arequipa'],
    'Colombia': ['Bogotá', 'Medellín', 'Cali'],
  };

  final Map<String, Map<String, List<String>>> _ciudades = {
    'Ecuador': {
      'Pichincha': ['Quito', 'Rumiñahui'],
      'Azuay': ['Cuenca', 'Azogues'],
      'Guayas': ['Guayaquil', 'Duran'],
    },
    'Perú': {
      'Lima': ['Lima City', 'Callao'],
      'Cusco': ['Cusco', 'Sicuani'],
      'Arequipa': ['Arequipa City', 'Cayma'],
    },
    'Colombia': {
      'Bogotá': ['Chapinero', 'Teusaquillo'],
      'Medellín': ['El Poblado', 'Laureles'],
      'Cali': ['San Fernando', 'La Flora'],
    }
  };

  // Variables del formulario
  String? _selectedCodTipoCliente;
  String? _selectedCodFormaPago;
  String? _selectedCodVendedor;
  String? _estado = 'A'; // Default value: 'Activo'
  String? _paisSeleccionado;
  String? _provinciaSeleccionada;
  String? _ciudadSeleccionada;
  String? _limiteCredito;
  String? _saldoPendiente;
  String? _listaPrecio;
  String? _calificacion;

  // Método para cargar los datos de los vendedores
  Future<void> _loadDropdownData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final vendedoresResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/vendedor'));

      if (vendedoresResponse.statusCode == 200) {
        final data = json.decode(vendedoresResponse.body);

        if (data['datos'] != null && data['datos']['data'] != null) {
          setState(() {
            _vendedores = List<Map<String, dynamic>>.from(data['datos']['data']);
            if (_vendedores.isNotEmpty) {
              _selectedCodVendedor = _vendedores[0]['codvendedor']; // Establecer el valor por defecto
            }
          });
        } else {
          print("Datos de vendedores no encontrados.");
        }
      } else {
        print("Error en la solicitud: ${vendedoresResponse.statusCode}");
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para cargar los datos de los otros dropdowns (tipos clientes, formas pago, etc.)
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tiposClientesResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/tiposclientes'));
      final formasPagoResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/formas-pago'));

      // Procesar Tipos de Clientes
      if (tiposClientesResponse.statusCode == 200) {
        setState(() {
          final responseData = json.decode(tiposClientesResponse.body);
          _tiposClientes = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        print('Error al cargar los tipos de clientes');
      }

      // Procesar Formas de Pago
      if (formasPagoResponse.statusCode == 200) {
        setState(() {
          final responseData = json.decode(formasPagoResponse.body);
          _formasPago = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        print('Error al cargar las formas de pago');
      }
    } catch (e) {
      print('Error al cargar los datos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para registrar el cliente
  Future<void> _registrarCliente() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('http://10.0.2.2:8000/api/clientes/register');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'codcliente': 'CLI-' + widget.cedulaRuc, // o un código único generado
          'codtipocliente': _selectedCodTipoCliente,
          'nombre': widget.nombre,
          'email': widget.email,
          'pais': _paisSeleccionado,
          'provincia': _provinciaSeleccionada,
          'ciudad': _ciudadSeleccionada,
          'codvendedor': _selectedCodVendedor,
          'codformapago': _selectedCodFormaPago,
          'estado': _estado,
          'limitecredito': _limiteCredito,
          'saldopendiente': _saldoPendiente,
          'cedularuc': widget.cedulaRuc,
          'codlistaprecio': _listaPrecio,
          'calificacion': _calificacion,
          'nombrecomercial': widget.nombreComercial,
          'login': widget.login,
          'password': widget.password,
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
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Cargar los datos de los otros dropdowns
    _loadDropdownData(); // Cargar los datos de los vendedores
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Registro")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey, // Agregamos la clave para el formulario
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Dropdown para Tipo de Cliente
                      DropdownButtonFormField<String>(
                        value: _selectedCodTipoCliente,
                        decoration: const InputDecoration(labelText: 'Tipo de Cliente'),
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
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Dropdown para Forma de Pago
                      DropdownButtonFormField<String>(
                        value: _selectedCodFormaPago,
                        decoration: const InputDecoration(labelText: 'Forma de Pago'),
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
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Dropdown para Vendedor
                      DropdownButtonFormField<String>(
                        value: _selectedCodVendedor,
                        decoration: const InputDecoration(labelText: 'Vendedor'),
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
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
const SizedBox(height: 20),
// Dropdown para Estado con valores "A" o "I"
DropdownButtonFormField<String>(
  value: _estado,
  decoration: const InputDecoration(labelText: 'Estado'),
  onChanged: (String? newValue) {
    setState(() {
      _estado = newValue;
    });
  },
  items: const [
    DropdownMenuItem<String>(
      value: 'A',
      child: Text('Activo'),
    ),
    DropdownMenuItem<String>(
      value: 'I',
      child: Text('Inactivo'),
    ),
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  },
),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _paisSeleccionado,
                        decoration: const InputDecoration(labelText: 'País'),
                        onChanged: (value) {
                          setState(() {
                            _paisSeleccionado = value;
                            _provinciaSeleccionada = null;
                            _ciudadSeleccionada = null;
                          });
                        },
                        items: _paises.keys
                            .map((pais) => DropdownMenuItem(value: pais, child: Text(pais)))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _provinciaSeleccionada,
                        decoration: const InputDecoration(labelText: 'Provincia'),
                        onChanged: _paisSeleccionado == null
                            ? null
                            : (value) {
                                setState(() {
                                  _provinciaSeleccionada = value;
                                  _ciudadSeleccionada = null;
                                });
                              },
                        items: _paisSeleccionado == null
                            ? []
                            : _paises[_paisSeleccionado]!
                                .map((provincia) => DropdownMenuItem(value: provincia, child: Text(provincia)))
                                .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _ciudadSeleccionada,
                        decoration: const InputDecoration(labelText: 'Ciudad'),
                        onChanged: _provinciaSeleccionada == null
                            ? null
                            : (value) {
                                setState(() {
                                  _ciudadSeleccionada = value;
                                });
                              },
                        items: _provinciaSeleccionada == null
                            ? []
                            : _ciudades[_paisSeleccionado]![_provinciaSeleccionada]!
                                .map((ciudad) => DropdownMenuItem(value: ciudad, child: Text(ciudad)))
                                .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Este campo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
TextFormField(
  decoration: const InputDecoration(labelText: 'Límite de Crédito'),
  initialValue: _limiteCredito,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  onChanged: (value) {
    setState(() {
      _limiteCredito = value;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    // Validación para solo números o decimales
    if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value)) {
      return 'Por favor ingrese un número válido';
    }
    return null;
  },
),
const SizedBox(height: 20),
TextFormField(
  decoration: const InputDecoration(labelText: 'Saldo Pendiente'),
  initialValue: _saldoPendiente,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  onChanged: (value) {
    setState(() {
      _saldoPendiente = value;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    // Validación para solo números o decimales
    if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value)) {
      return 'Por favor ingrese un número válido';
    }
    return null;
  },
),
const SizedBox(height: 20),
TextFormField(
  decoration: const InputDecoration(labelText: 'Código Lista de Precio'),
  initialValue: _listaPrecio,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  onChanged: (value) {
    setState(() {
      _listaPrecio = value;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    // Validación para solo números o decimales
    if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value)) {
      return 'Por favor ingrese un número válido';
    }
    return null;
  },
),
const SizedBox(height: 20),
TextFormField(
  decoration: const InputDecoration(labelText: 'Calificación'),
  initialValue: _calificacion,
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  onChanged: (value) {
    setState(() {
      _calificacion = value;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    // Validación para solo números o decimales
    if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(value)) {
      return 'Por favor ingrese un número válido';
    }
    return null;
  },
),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _registrarCliente,
                        child: const Text('Registrar Cliente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
