import 'package:app/task_screen.dart';
import 'package:flutter/material.dart'; // Importa el paquete de widgets de Flutter

// Widget con estado para los campos de login
class LoginFields extends StatefulWidget {
  const LoginFields({super.key}); // Constructor con clave opcional

  @override
  State<LoginFields> createState() => _LoginFieldsState(); // Crea el estado asociado
}

// Estado del widget LoginFields
class _LoginFieldsState extends State<LoginFields> {
  final _formKey = GlobalKey<FormState>(); // Llave para el formulario
  final _emailCtrl =
      TextEditingController(); // Controlador para el campo de email
  final _passCtrl =
      TextEditingController(); // Controlador para el campo de contraseña

  bool _obscure = true; // Controla si la contraseña está oculta
  bool _loading =
      false; // Indica si está cargando (por ejemplo, al hacer login)
  String? _error; // Mensaje de error opcional

  @override
  void dispose() {
    _emailCtrl.dispose(); // Libera recursos del controlador de email
    _passCtrl.dispose(); // Libera recursos del controlador de contraseña
    super.dispose(); // Llama al método dispose del padre
  }

  // Método para manejar el envío del formulario
  Future<void> _submit() async {
    FocusScope.of(context).unfocus(); // Quita el foco de los campos
    final ok =
        _formKey.currentState?.validate() ?? false; // Valida el formulario
    if (!ok) return; // Si no es válido, no hace nada

    setState(() {
      _loading = true; // Indica que está cargando
      _error = null; // Resetea el mensaje de error
    });

    try {
      await Future.delayed(
        const Duration(milliseconds: 3000),
      ); // Simula una espera
      if (!mounted) return; // Verifica si el widget sigue montado
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TaskScreen(
            email: _emailCtrl.text.trim(),
          ), // <-- PASA EL CORREO AQUÍ
        ),
      );
    } catch (e) {
      if (!mounted) return; // Verifica si el widget sigue montado
      setState(
        () => _error = "Credenciales inválidas o error de red",
      ); // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No pudimos iniciar sesión"),
        ), // Muestra un SnackBar con el error
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false); // Termina la carga
      }
    }
  }

  @override
  // Construye la interfaz del widget
  Widget build(BuildContext context) {
    return AutofillGroup(
      // Agrupa los campos para autocompletar
      child: Form(
        key: _formKey, // Asigna la llave al formulario
        autovalidateMode:
            AutovalidateMode.onUserInteraction, // Valida al interactuar
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estira los hijos horizontalmente
          mainAxisSize: MainAxisSize.min, // Toma el tamaño mínimo vertical
          children: [
            Center(
              child: Image.network(
                "https://i.ibb.co/vvz9FzwG/logo.jpg", // Logo de la app
                height: 150, // Altura de la imagen
                fit: BoxFit.contain, // Ajuste de la imagen
              ),
            ),
            const SizedBox(height: 16), // Espacio vertical

            const Text(
              "Bienvenido a la Comunidad Toritana", // Texto de bienvenida
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ), // Estilo del texto
              textAlign: TextAlign.center, // Centra el texto
            ),

            // Campo de texto para el correo electrónico
            TextFormField(
              enabled:
                  !_loading, // Deshabilita si está cargando (debería ser !loading)
              controller: _emailCtrl, // Controlador del campo
              keyboardType: TextInputType.emailAddress, // Tipo de teclado
              textCapitalization:
                  TextCapitalization.none, // Sin capitalización automática
              autocorrect: false, // Sin autocorrección
              enableSuggestions: true, // Sugerencias activadas
              autofillHints: const [
                AutofillHints.email,
              ], // Sugerencia de autocompletar
              decoration: const InputDecoration(
                labelText: "Correo electrónico", // Etiqueta
                hintText: "Ejemplo: usuario@ejemplo.com", // Texto de ayuda
                prefixIcon: Icon(Icons.email_outlined), // Icono al inicio
                border: OutlineInputBorder(), // Borde del campo
              ),
              validator: (v) {
                final value = v?.trim() ?? ""; // Elimina espacios
                if (value.isEmpty)
                  return "Ingresa un correo electrónico"; // Valida vacío
                final emailOk = RegExp(
                  r'^\S+@\S+\.\S+$',
                ).hasMatch(value); // Valida formato email
                return emailOk
                    ? null
                    : "correo electrónico no válido"; // Mensaje de error
              },
              textInputAction: TextInputAction.next, // Acción del teclado
              onFieldSubmitted: (_) => FocusScope.of(
                context,
              ).requestFocus(), // Pasa al siguiente campo
            ),
            const SizedBox(height: 12), // Espacio vertical
            // Campo de texto para la contraseña
            TextFormField(
              enabled:
                  !_loading, // Deshabilita si está cargando (debería ser !loading)
              controller: _passCtrl, // Controlador del campo
              obscureText: _obscure, // Oculta el texto si es true
              enableSuggestions: false, // Sin sugerencias
              autocorrect: false, // Sin autocorrección
              autofillHints: const [
                AutofillHints.password,
              ], // Sugerencia de autocompletar
              decoration: InputDecoration(
                labelText: "Contraseña", // Etiqueta
                border: const OutlineInputBorder(), // Borde del campo
                prefixIcon: const Icon(Icons.lock_outline), // Icono al inicio
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _obscure = !_obscure,
                  ), // Cambia visibilidad
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ), // Icono según estado
                  tooltip: _obscure ? "Mostrar" : "Ocultar", // Texto de ayuda
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty)
                  return "Ingresa una contraseña"; // Valida vacío
                if (v.length < 6)
                  return "Mínimo 6 caracteres"; // Valida longitud
                return null; // Contraseña válida
              },
              textInputAction: TextInputAction.done, // Acción del teclado
              onFieldSubmitted: (_) => _submit(), // Envía el formulario
            ),
            const SizedBox(height: 8), // Espacio vertical

            if (_error != null)
              Text(
                _error!, // Muestra el mensaje de error
                style: const TextStyle(color: Colors.red), // Estilo en rojo
                textAlign: TextAlign.center, // Centrado
              ),
            const SizedBox(height: 16), // Espacio vertical
            // Botón de ingresar
            SizedBox(
              height: 48, // Altura del botón
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    232,
                    208,
                    48,
                  ), // Color de fondo
                  foregroundColor: const Color.fromARGB(
                    255,
                    0,
                    0,
                    0,
                  ), // Color del texto
                ),
                onPressed: _loading
                    ? null
                    : _submit, // Deshabilita si está cargando
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text("Ingresar"), // Texto del botón
              ),
            ),
            const SizedBox(height: 8), // Espacio vertical
            // Botón de "¿Olvidaste tu contraseña?"
            TextButton(
              onPressed: _loading
                  ? null
                  : () {}, // Deshabilita si está cargando
              child: const Text("¿Olvidaste tu contraseña?"), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}
