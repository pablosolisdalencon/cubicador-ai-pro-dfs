import 'package:cubicador_pro/src/location/location_service.dart';
import 'package:cubicador_pro/src/models/project_model.dart';
import 'package:cubicador_pro/src/projects/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _managerController = TextEditingController();
  final ProjectService _projectService = ProjectService();
  final LocationService _locationService = LocationService();
  bool _isSaving = false;
  bool _isGettingLocation = false;

  Future<void> _addProject() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      try {
        final newProject = Project(
          id: '',
          name: _nameController.text,
          location: _locationController.text,
          technicalManager: _managerController.text,
        );
        await _projectService.addProject(newProject);
        if (mounted) Navigator.pop(context);
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      final position = await _locationService.getCurrentPosition();
      _locationController.text = 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addProject)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.projectName),
                validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
                enabled: !_isSaving,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  suffixIcon: _isGettingLocation
                      ? const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
                      : IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _isSaving ? null : _getCurrentLocation,
                          tooltip: 'Usar mi ubicación actual',
                        ),
                ),
                validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
                enabled: !_isSaving && !_isGettingLocation,
              ),
              TextFormField(
                controller: _managerController,
                decoration: InputDecoration(labelText: l10n.technicalManager),
                validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
                enabled: !_isSaving,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving || _isGettingLocation ? null : _addProject,
                child: _isSaving
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text(l10n.saveProject),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
