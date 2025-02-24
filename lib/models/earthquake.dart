// Se define la clase Earthquake que representa un terremoto con varias propiedades
class Earthquake {
  // Propiedades finales (inmutables) que representan la información de un terremoto
  final String id; // Identificador único del terremoto
  final double magnitude; // Magnitud del terremoto
  final String place; // Ubicación donde ocurrió el terremoto
  final DateTime time; // Momento en que ocurrió el terremoto
  final double longitude; // Coordenada de longitud del epicentro
  final double latitude; // Coordenada de latitud del epicentro
  final double depth; // Profundidad del terremoto en kilómetros
  final String status; // Estado del evento (ej. 'reviewed', 'automatic')

  // Constructor de la clase Earthquake, que requiere todos los atributos obligatoriamente
  Earthquake({
    required this.id,
    required this.magnitude,
    required this.place,
    required this.time,
    required this.longitude,
    required this.latitude,
    required this.depth,
    required this.status,
  });

  // Método de fábrica para crear una instancia de Earthquake desde un JSON
  factory Earthquake.fromJson(Map<String, dynamic> json) {
    return Earthquake(
      id: json['id'], // Se obtiene el identificador del JSON

      // Se obtiene la magnitud desde la clave 'properties' -> 'mag', si no existe, se asigna 0.0
      magnitude: json['properties']['mag']?.toDouble() ?? 0.0,

      // Se obtiene la ubicación desde 'properties' -> 'place', si no existe, se asigna 'Unknown location'
      place: json['properties']['place'] ?? 'Unknown location',

      // Se obtiene el tiempo en milisegundos y se convierte a un objeto DateTime
      time: DateTime.fromMillisecondsSinceEpoch(json['properties']['time']),

      // Se obtienen las coordenadas del epicentro desde 'geometry' -> 'coordinates'
      longitude: json['geometry']['coordinates'][0], // Longitud
      latitude: json['geometry']['coordinates'][1], // Latitud
      depth: json['geometry']['coordinates'][2], // Profundidad en kilómetros

      // Se obtiene el estado del terremoto desde 'properties' -> 'status', si no existe, se asigna 'unknown'
      status: json['properties']['status'] ?? 'unknown',
    );
  }
}
