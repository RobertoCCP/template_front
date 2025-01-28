import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List orders = []; // Aquí almacenamos los pedidos como una lista
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    const String apiUrl = 'http://10.0.2.2:8000/api/cliente/pedidos'; // API de los pedidos

    try {
      final response = await http.get(Uri.parse(apiUrl)); // Realizamos la petición GET

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body); // Decodificamos la respuesta JSON

        // Imprimimos el contenido de la respuesta para depuración
        print(responseData);

        // Verificamos si la clave 'datos' existe y contiene la clave 'data' con una lista
        if (responseData.containsKey('datos') && responseData['datos'] != null && responseData['datos']['data'] is List) {
          setState(() {
            orders = responseData['datos']['data']; // Asignamos la lista de pedidos
            isLoading = false; // Desactivamos el estado de carga
          });
        } else {
          setState(() {
            orders = []; // Si no se encuentra la lista, dejamos orders vacía
            isLoading = false;
          });
        }
      } else {
        throw Exception('Error al obtener los pedidos.');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            "Mis Órdenes",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: orders.length, // Cantidad de elementos en 'orders'
                      itemBuilder: (context, index) {
                        final order = orders[index]; // Accedemos a cada pedido
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pedido #${order['srorden'] ?? 'No disponible'}", // Mostramos el número de pedido
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Estado: ${order['estado'] == 'E' ? 'Enviado' : 'No enviado'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: order['estado'] == 'E' ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
