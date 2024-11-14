import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Crea una instancia de FlutterSecureStorage
final storage = FlutterSecureStorage();

// Guardar un token de forma segura
Future<void> saveToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

// Leer un token de forma segura
Future<String?> readToken() async {
  return await storage.read(key: 'auth_token');
}

// Eliminar un token de forma segura
Future<void> deleteToken() async {
  await storage.delete(key: 'auth_token');
}
