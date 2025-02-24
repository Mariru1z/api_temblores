// Importamos los paquetes necesarios.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/earthquake_provider.dart'; // Importamos el proveedor de datos.

/// Widget que permite filtrar los terremotos según la magnitud mínima seleccionada.
class MagnitudeFilter extends StatelessWidget {
  /// Constructor del widget.
  const MagnitudeFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia del provider que gestiona el estado de los terremotos.
    final provider = Provider.of<EarthquakeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0), // Espaciado alrededor del widget.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Texto que muestra la magnitud mínima seleccionada.
          Text(
            'Filtrar por magnitud mínima: ${provider.minMagnitude.toStringAsFixed(1)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // Control deslizante para seleccionar la magnitud mínima.
          Slider(
            min: 0.0, // Valor mínimo de magnitud.
            max: 9.0, // Valor máximo de magnitud.
            divisions: 18, // Número de divisiones para valores intermedios (0.5 en 0.5).
            value: provider.minMagnitude, // Valor actual.
            label: provider.minMagnitude.toStringAsFixed(1), // Etiqueta flotante.
            onChanged: (value) {
              provider.setMinMagnitude(value); // Actualiza el valor en el provider.
            },
          ),
        ],
      ),
    );
  }
}
