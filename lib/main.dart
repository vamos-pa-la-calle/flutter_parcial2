import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Usuario {
  String nombre;
  String correo;

  Usuario({required this.nombre, required this.correo});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormularioPage(),
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  List<Usuario> usuarios = [];

  int? indexEditando;

  void guardarDatos() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (indexEditando == null) {
          usuarios.add(
            Usuario(
              nombre: nombreController.text,
              correo: correoController.text,
            ),
          );
        } else {
          usuarios[indexEditando!] = Usuario(
            nombre: nombreController.text,
            correo: correoController.text,
          );
          indexEditando = null;
        }
      });

      nombreController.clear();
      correoController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Datos guardados")),
      );
    }
  }

  void editarUsuario(int index) {
    setState(() {
      nombreController.text = usuarios[index].nombre;
      correoController.text = usuarios[index].correo;
      indexEditando = index;
    });

    Navigator.pop(context);
  }

  void eliminarUsuario(int index) {
    setState(() {
      usuarios.removeAt(index);
    });
  }

  void verUsuarios() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ListaUsuariosPage(
              usuarios: usuarios,
              onEdit: editarUsuario,
              onDelete: eliminarUsuario,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulario Flutter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: verUsuarios,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: guardarDatos,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese su nombre";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese su correo";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: guardarDatos,
                child: Text(indexEditando == null ? "Guardar" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaUsuariosPage extends StatelessWidget {
  final List<Usuario> usuarios;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const ListaUsuariosPage({
    super.key,
    required this.usuarios,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios guardados")),
      body:
          usuarios.isEmpty
              ? const Center(child: Text("No hay datos"))
              : ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final user = usuarios[index];

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.nombre),
                    subtitle: Text(user.correo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => onEdit(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => onDelete(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}