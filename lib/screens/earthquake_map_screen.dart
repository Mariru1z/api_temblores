// Importamos los paquetes necesarios para la pantalla del mapa.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Paquete para integrar Google Maps en Flutter.
import 'package:provider/provider.dart'; // Para la gestión del estado con Provider.
import '../providers/earthquake_provider.dart'; // Importamos el proveedor que contiene los datos de los terremotos.

/// Pantalla que muestra un mapa con la ubicación de los terremotos.
class EarthquakeMapScreen extends StatefulWidget {
  const EarthquakeMapScreen({Key? key}) : super(key: key);

  @override
  _EarthquakeMapScreenState createState() => _EarthquakeMapScreenState();
}

class _EarthquakeMapScreenState extends State<EarthquakeMapScreen> {
  GoogleMapController? _mapController; // Controlador del mapa de Google.

  /// Genera un conjunto de marcadores a partir de la lista de terremotos del proveedor.
  Set<Marker> _createMarkers(EarthquakeProvider provider) {
    return provider.earthquakes.map((earthquake) {
      return Marker(
        markerId: MarkerId(earthquake.id), // ID único para cada marcador.
        position: LatLng(earthquake.latitude, earthquake.longitude), // Posición geográfica del terremoto.
        infoWindow: InfoWindow(
          title: 'Magnitud ${earthquake.magnitude}', // Muestra la magnitud en la ventana de información.
          snippet: earthquake.place, // Muestra el lugar del terremoto como una descripción breve.
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerHue(earthquake.magnitude), // Define el color del marcador basado en la magnitud.
        ),
      );
    }).toSet();
  }

  /// Devuelve el color del marcador dependiendo de la magnitud del terremoto.
  double _getMarkerHue(double magnitude) {
    if (magnitude < 2) return BitmapDescriptor.hueGreen; // Verde para terremotos menores a magnitud 2.
    if (magnitude < 4) return BitmapDescriptor.hueYellow; // Amarillo para terremotos entre 2 y 4.
    if (magnitude < 6) return BitmapDescriptor.hueOrange; // Naranja para terremotos entre 4 y 6.
    return BitmapDescriptor.hueRed; // Rojo para terremotos de magnitud 6 o mayor.
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene el proveedor que maneja la lista de terremotos.
    final provider = Provider.of<EarthquakeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Terremotos'), // Título de la pantalla en la barra superior.
      ),
      body: provider.isLoading // Si está cargando, muestra un indicador de carga.
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga centrado en la pantalla.
          : GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0), // Posición inicial centrada en el ecuador.
                zoom: 2, // Nivel de zoom inicial.
              ),
              markers: _createMarkers(provider), // Añade los marcadores de los terremotos al mapa.
              onMapCreated: (controller) {
                _mapController = controller; // Guarda el controlador del mapa para futuras interacciones.
              },
            ),
    );
  }
}
