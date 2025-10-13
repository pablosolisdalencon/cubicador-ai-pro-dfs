import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubicador_pro/src/models/construction_material_model.dart';
import 'package:cubicador_pro/src/materials/add_material_screen.dart';
import 'package:cubicador_pro/src/materials/material_service.dart';
import 'package:flutter/material.dart';

class MaterialListScreen extends StatefulWidget {
  const MaterialListScreen({super.key});

  @override
  State<MaterialListScreen> createState() => _MaterialListScreenState();
}

class _MaterialListScreenState extends State<MaterialListScreen> {
  final MaterialService _materialService = MaterialService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Materiales'),
      ),
      body: StreamBuilder<QuerySnapshot<ConstructionMaterial>>(
        stream: _materialService.getMaterials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los materiales.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tienes materiales. ¡Añade uno!'));
          }

          final materials = snapshot.data!.docs;

          return ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index].data();
              return Dismissible(
                key: Key(material.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  _materialService.deleteMaterial(material.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${material.name} eliminado')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(material.name),
                  subtitle: Text('Precio: \$${material.price.toStringAsFixed(2)} por ${material.unit}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMaterialScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Añadir Material',
      ),
    );
  }
}
