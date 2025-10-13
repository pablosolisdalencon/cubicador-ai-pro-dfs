import 'package:cubicador_pro/src/cubication/cubication_results_screen.dart';
import 'package:flutter/material.dart';

class CubicationFormScreen extends StatefulWidget {
  const CubicationFormScreen({super.key});

  @override
  State<CubicationFormScreen> createState() => _CubicationFormScreenState();
}

class _CubicationFormScreenState extends State<CubicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedWorkType;
  final _workTypes = ['Muro', 'Losa', 'Columna', 'Cimentación'];

  final _largoController = TextEditingController();
  final _anchoController = TextEditingController();
  final _altoController = TextEditingController();
  final _unidadesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cubicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedWorkType,
                hint: const Text('Tipo de Obra'),
                items: _workTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWorkType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _largoController,
                decoration: const InputDecoration(labelText: 'Largo (m)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _anchoController,
                decoration: const InputDecoration(labelText: 'Ancho (m)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _altoController,
                decoration: const InputDecoration(labelText: 'Alto (m)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _unidadesController,
                decoration: const InputDecoration(labelText: 'Número de Unidades'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String workType = _selectedWorkType!;
                    final double largo = double.parse(_largoController.text);
                    final double ancho = double.parse(_anchoController.text);
                    final double alto = double.parse(_altoController.text);
                    final int unidades = int.parse(_unidadesController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CubicationResultsScreen(
                          workType: workType,
                          largo: largo,
                          ancho: ancho,
                          alto: alto,
                          unidades: unidades,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Calcular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
