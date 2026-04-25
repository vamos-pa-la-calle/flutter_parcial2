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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
        ),
      ),
      home: const FormularioPage(),
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
        builder: (_) => ListaUsuariosPage(
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
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.tealAccent),
            onPressed: verUsuarios,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.tealAccent),
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
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/219/219986.png",
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nombreController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Nombre",
                  labelStyle: TextStyle(color: Colors.tealAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Correo",
                  labelStyle: TextStyle(color: Colors.tealAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: guardarDatos,
                child: Text(
                  indexEditando == null ? "Guardar" : "Actualizar",
                ),
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
      appBar: AppBar(
        title: const Text("Usuarios guardados"),
        backgroundColor: Colors.black,
      ),
      body: usuarios.isEmpty
          ? const Center(
              child: Text(
                "No hay datos",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final user = usuarios[index];

                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.tealAccent,
                    ),
                    title: Text(
                      user.nombre,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      user.correo,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.tealAccent),
                          onPressed: () => onEdit(index),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => onDelete(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}