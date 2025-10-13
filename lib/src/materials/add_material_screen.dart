import 'package:cubicador_pro/src/models/construction_material_model.dart';
import 'package:cubicador_pro/src/materials/material_service.dart';
import 'package:flutter/material.dart';

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  final _performanceController = TextEditingController();
  final MaterialService _materialService = MaterialService();
  MaterialType _selectedType = MaterialType.volume;

  Future<void> _addMaterial() async {
    if (_formKey.currentState!.validate()) {
      final newMaterial = ConstructionMaterial(
        id: '',
        name: _nameController.text,
        unit: _unitController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        performance: double.tryParse(_performanceController.text) ?? 0.0,
        type: _selectedType,
      );
      await _materialService.addMaterial(newMaterial);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Material'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField<MaterialType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Tipo de Cálculo'),
                items: MaterialType.values.map((MaterialType type) {
                  return DropdownMenuItem<MaterialType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unidad (ej. m³, kg, pza)'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio por Unidad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              if (_selectedType == MaterialType.area)
                TextFormField(
                  controller: _performanceController,
                  decoration: InputDecoration(labelText: 'Rendimiento (ej. Unidades por m²)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMaterial,
                child: const Text('Guardar Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
