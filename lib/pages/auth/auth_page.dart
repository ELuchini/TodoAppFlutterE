//Generado por V0.dev en implementación de autenticación. 11-11-24
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myapp/pages/home/main_page.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/st.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final urlLoginSignup = _isLogin ? '$url/login' : '$url/signup';
      final dio = Dio();
      final data = jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      if (kDebugMode) {
        print(
            'email: ${_emailController.text} password: ${_passwordController.text}');
        print(
          'data: $data',
        );
        print(
          'URL: $urlLoginSignup',
        );
      }

      try {
        final response = await dio.post(
          urlLoginSignup,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: data,
          // data: {
          //   'email': '${_emailController.text}',
          //   'password': '${_passwordController.text}',
          // },
        );

        if (response.statusCode == 200) {
          // Asumimos que el token viene en la respuesta como 'token'
          final token = response.data['token'];
          // Handle successful login/signup
          if (kDebugMode) {
            print('Success: ${response.data}');
          }
          saveToken(token); // Save token to secure storage

          // Navigate to home page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => MainPage(
                      title: 'Todo Listo',
                    )),
          );
        } else if (response.statusCode == 201) {
          //Registro correcto.
          if (kDebugMode) {
            print('Success: ${response.data}');
          }

          _isLogin = !_isLogin;

          _showRegistrationOk(context);
        } else if (response.statusCode == 403){
          //Registro deshabilitado.
          if (kDebugMode) {
            print('Está el registro deshabilitado en el backend.');
          }

          _showErrorDialog('Por el momento tenemos el registro deshabilitado.');
          
        } else {
          // Handle error
          if (kDebugMode) {
            print('Error: ${response.data}');
          }
          // Show error message to user
          // _showErrorDialog('Login failed. Please try again.');
          _showErrorDialog('Ingreso fallido. Volvé a intentar.');
        }
      } catch (e) {
        // Handle network errors
        if (e is DioException) {
          if (kDebugMode) {
            print('Dio Error: ${e.message}');
          }
          // You can access more error details if needed:
          // print('Error Response: ${e.response?.data}');
        } else {
          if (kDebugMode) {
            print('Error: $e');
          }
        }
        // Show error message to user
        // _showErrorDialog('An error occurred. Please try again later.');
        _showErrorDialog('Ocurrió un error. Volvé a intentar en un rato.');
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        // title: const Text('An Error Occurred'),
        title: const Text('Occurrió un Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            // child: const Text('Okay'),
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  void _showRegistrationOk(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx2) {
        return AlertDialog(
          title: Text('¡Registro exitoso!'),
          content: Text(
              'Te has registrado correctamente. Por favor, inicia sesión para continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx2).pop();
              },
              // child: const Text('Okay'),
              child: const Text('Aceptar'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 60, 18, 230),
              const Color.fromARGB(255, 22, 194, 96)
            ],
            // colors: [Colors.blue.shade300, Colors.purple.shade300],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Agregar un espacio entre el logo y la parte superior
                    const SizedBox(height: 16),
                    // Agregar la imagen del logo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(1.0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode:
                            BlendMode.dstIn, // Difumina hacia transparente
                        child: Image.asset(
                          'assets/icon/icon-todo-listo.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Espaciado entre logo y texto
                    Text(
                      _isLogin
                          ? 'Bienvenido'
                          : 'Crear Cuenta', //'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresá tu email'; //'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña', //'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresá tu contraseña'; //'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(_isLogin
                                        ? 'Ingresá'
                                        : 'Registrate'), //'Login' : 'Sign Up'),
                              ),
                              // const SizedBox(height: 16),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                        ? 'No tenés cuenta? Registrate' //'Need an account? Sign Up'
                                        : 'Ya tenés cuenta? Ingresá' //'Already have an account? Login',
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
