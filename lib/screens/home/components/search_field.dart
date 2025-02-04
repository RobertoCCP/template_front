import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_app/models/producto.dart';
import 'package:shop_app/services/api_service.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
   List<Producto> searchResults = [];
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  void _onSearchChanged(String query) async {
    setState(() => isLoading = true);
    
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    try {
      final results = await _apiService.searchProducts(query);
      setState(() {
        print(results);
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintText: "Buscar producto",
            prefixIcon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.search),
          ),
        ),
        if (searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final producto = searchResults[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Costo: \$${producto.costo}'),
                  onTap: () {
                    // Implementar selección de producto
                    print('Seleccionado: ${producto.nombre}');
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}