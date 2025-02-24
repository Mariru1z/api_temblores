// Importamos las librerías necesarias para la UI y la gestión del estado
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos el proveedor que maneja los datos de terremotos
import '../providers/earthquake_provider.dart';

// Importamos los widgets personalizados utilizados en la pantalla
import '../widgets/earthquake_list_item.dart'; // Item de la lista de terremotos
import '../widgets/magnitude_filter.dart'; // Filtro de magnitud
import 'earthquake_map_screen.dart'; // Pantalla del mapa de terremotos

// Definimos la pantalla de la lista de terremotos como un StatefulWidget
class EarthquakeListScreen extends StatefulWidget {
  const EarthquakeListScreen({Key? key}) : super(key: key);

  @override
  _EarthquakeListScreenState createState() => _EarthquakeListScreenState();
}

class _EarthquakeListScreenState extends State<EarthquakeListScreen> {
  // Controlador para manejar el scroll de la lista
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Cargamos los terremotos al iniciar la pantalla
    Future.microtask(() => 
      Provider.of<EarthquakeProvider>(context, listen: false).fetchEarthquakes()
    );

    // Agregamos un listener para detectar cuando se llega al final de la lista
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Eliminamos el listener y liberamos el controlador cuando se destruye el widget
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Método que se ejecuta cuando el usuario se acerca al final de la lista
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Obtenemos el proveedor de terremotos
      final provider = Provider.of<EarthquakeProvider>(context, listen: false);
      
      // Si no está cargando y hay más datos, cargamos más terremotos
      if (!provider.isLoading && provider.hasMoreData) {
        provider.loadMoreEarthquakes();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terremotos en Tiempo Real'), // Título de la pantalla
        actions: [
          IconButton(
            icon: const Icon(Icons.map), // Botón de acceso a la pantalla del mapa
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EarthquakeMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const MagnitudeFilter(), // Widget de filtrado por magnitud
          Expanded(
            child: Consumer<EarthquakeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.earthquakes.isEmpty) {
                  // Muestra un indicador de carga si está cargando y no hay datos
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.error.isNotEmpty && provider.earthquakes.isEmpty) {
                  // Muestra un mensaje de error si ocurrió un problema al cargar los datos
                  return Center(child: Text('Error: ${provider.error}'));
                }
                
                if (provider.earthquakes.isEmpty) {
                  // Muestra un mensaje si no se encontraron terremotos con los filtros aplicados
                  return const Center(
                    child: Text('No se encontraron terremotos con estos filtros'),
                  );
                }
                
                // Lista de terremotos con soporte para scroll infinito
                return ListView.builder(
                  controller: _scrollController, // Asigna el controlador de scroll
                  itemCount: provider.earthquakes.length + (provider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.earthquakes.length) {
                      // Muestra un indicador de carga al final de la lista si hay más datos por cargar
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    
                    // Muestra un item de la lista de terremotos
                    final earthquake = provider.earthquakes[index];
                    return EarthquakeListItem(earthquake: earthquake);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Botón para recargar la lista de terremotos manualmente
          Provider.of<EarthquakeProvider>(context, listen: false).fetchEarthquakes();
        },
        tooltip: 'Actualizar',
        child: const Icon(Icons.refresh), // Icono de actualización
      ),
    );
  }
}
