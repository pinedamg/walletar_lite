class Account {
  final String id;
  final String nombre;
  final String tipo; // Bancaria, Tarjeta de Crédito, Efectivo
  final String etiqueta;
  final String descripcion;

  Account({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.etiqueta,
    required this.descripcion,
  });

  // Crear una instancia de Account desde un documento de Firestore
  factory Account.fromFirestore(String id, Map<String, dynamic> data) {
    return Account(
      id: id,
      nombre: data['nombre'] ?? 'Sin Nombre',
      tipo: data['tipo'] ?? 'Sin Tipo',
      etiqueta: data['etiqueta'] ?? '',
      descripcion: data['descripcion'] ?? '',
    );
  }

  // Convertir una instancia de Account a un Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'etiqueta': etiqueta,
      'descripcion': descripcion,
    };
  }
}
