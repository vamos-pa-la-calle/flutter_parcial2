import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tareas = [];
  TextEditingController controlador = TextEditingController();

  void agregarTarea() {
    if (controlador.text.isNotEmpty) {
      setState(() {
        tareas.add(controlador.text);
        controlador.clear();
      });
    }
  }

  void eliminarTarea(int index) {
    setState(() {
      tareas.removeAt(index);
    });
  }

  void editarTarea(int index) {
    TextEditingController editarController =
        TextEditingController(text: tareas[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar tarea'),
          content: TextField(
            controller: editarController,
            decoration: InputDecoration(hintText: 'Editar texto'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tareas[index] = editarController.text;
                });
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Lista de Tareas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controlador,
                    decoration: InputDecoration(
                      hintText: 'Escribe una tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: agregarTarea,
                  child: Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tareas[index]),
                  onTap: () => editarTarea(index), // 👈 tocar para editar
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminarTarea(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}