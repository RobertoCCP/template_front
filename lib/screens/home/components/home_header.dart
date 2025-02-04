import 'package:flutter/material.dart';
import 'package:shop_app/services/api_service.dart';
import 'search_field.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _isLoading = false; // Estado de carga
  List<Map<String, String>> _categories = []; // Lista de categorías con codtipoproducto
  String? _selectedCategory = 'Todas las categorías'; // Valor por defecto

  // Método para obtener las categorías de la API
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true; // Iniciar carga
    });

    try {
      final apiService = ApiService();
      final categories = await apiService.getCategories();
      setState(() {
        _categories = [{'codtipoproducto': '0', 'descripcion': 'Todas las categorías'}]; // Agregar "Todas las categorías"
        _categories.addAll(categories); // Añadir categorías obtenidas desde la API
      });
    } catch (e) {
      print('Error al cargar categorías: $e');
    } finally {
      setState(() {
        _isLoading = false; // Detener carga
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Cargar categorías cuando inicie el widget
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                // Barra de búsqueda y dropdown de categorías
                Row(
                  children: [
                    Expanded(
                      child: SearchField(
                        selectedCategory: _selectedCategory, // Pasar la categoría seleccionada
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Dropdown de categorías
                    _isLoading
                        ? const CircularProgressIndicator()
                        : DropdownButton<String>(
                            value: _selectedCategory,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!; // Actualizar la categoría seleccionada
                              });
                            },
                            items: _categories.map<DropdownMenuItem<String>>((Map<String, String> category) {
                              return DropdownMenuItem<String>(
                                value: category['descripcion'],
                                child: Text(category['descripcion']!),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
