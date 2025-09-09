import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  final String email; // Recibe el correo electrónico

  const TaskScreen({Key? key, required this.email})
    : super(key: key); // <-- MODIFICA EL CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body: Center(
        child: Text(
          'Bienvenido $email', // <-- MUESTRA EL MENSAJE AQUÍ
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
