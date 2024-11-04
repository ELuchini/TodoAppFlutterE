import 'package:dio/dio.dart';

class RequestQueue {
  final List<Map<String, dynamic>> _queue = [];
  final Dio _dio = Dio();

  void addToQueue(String url, String method, {Map<String, dynamic>? data}) {
    _queue.add({
      'url': url,
      'method': method,
      'data': data,
    });
    _processNextRequest();
  }

  Future<void> _processNextRequest() async {
    if (_queue.isEmpty) return;

    final request = _queue.removeAt(0);
    try {
      final response = await _dio.request(
        request['url'],
        data: request['data'],
        options: Options(
          method: request['method'],
        ),
      );
      print('Respuesta: $response');
    } catch (e) {
      print('Error: $e');
    }

    _processNextRequest();
  }
}

// Ejemplo de uso:

// final requestQueue = RequestQueue();


// Agregar peticiones a la cola

// requestQueue.addToQueue('https://api.example.com/users', 'GET');
// requestQueue.addToQueue('https://api.example.com/posts/1', 'PUT', data: {'title': 'Nuevo título'});
// requestQueue.addToQueue('https://api.example.com/comments/2', 'DELETE');