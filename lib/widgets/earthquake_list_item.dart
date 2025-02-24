// Importamos los paquetes necesarios para la interfaz y el manejo de fechas.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/earthquake.dart'; // Importamos el modelo de datos de terremotos.

/// Widget que representa un ítem de la lista de terremotos.
class EarthquakeListItem extends StatelessWidget {
  final Earthquake earthquake; // Objeto de terremoto que se mostrará en este ítem.

  /// Constructor del widget que recibe un objeto `Earthquake` como parámetro requerido.
  const EarthquakeListItem({Key? key, required this.earthquake}) : super(key: key);

  /// Método para determinar el color del indicador según la magnitud del terremoto.
  Color _getMagnitudeColor() {
    if (earthquake.magnitude < 2) return Colors.green; // Magnitudes menores a 2 → Verde.
    if (earthquake.magnitude < 4) return Colors.yellow; // Magnitudes entre 2 y 4 → Amarillo.
    if (earthquake.magnitude < 6) return Colors.orange; // Magnitudes entre 4 y 6 → Naranja.
    return Colors.red; // Magnitudes mayores a 6 → Rojo.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Margen del Card.
      child: ListTile(
        leading: CircleAvatar( // Ícono circular con la magnitud.
          backgroundColor: _getMagnitudeColor(), // Color según la magnitud.
          child: Text(
            earthquake.magnitude.toStringAsFixed(1), // Magnitud con un decimal.
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(earthquake.place), // Muestra la ubicación del terremoto.
        subtitle: Text(
          DateFormat('dd/MM/yyyy HH:mm').format(earthquake.time), // Formatea la fecha y hora.
        ),
        onTap: () {
          // Al tocar el elemento, se muestra un diálogo con más detalles.
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Magnitud ${earthquake.magnitude}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ubicación: ${earthquake.place}'),
                  Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(earthquake.time)}'),
                  Text('Latitud: ${earthquake.latitude}'),
                  Text('Longitud: ${earthquake.longitude}'),
                  Text('Profundidad: ${earthquake.depth} km'),
                  Text('Estado: ${earthquake.status}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), // Cierra el diálogo.
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
