import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cubicador Pro';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get enter => 'Ingresar';

  @override
  String get register => 'Registrarse';

  @override
  String get noAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get myProjects => 'Mis Proyectos';

  @override
  String get addProject => 'Añadir Proyecto';

  @override
  String get projectName => 'Nombre del Proyecto';

  @override
  String get location => 'Ubicación';

  @override
  String get technicalManager => 'Responsable Técnico';

  @override
  String get saveProject => 'Guardar Proyecto';

  @override
  String get fieldRequired => 'Campo requerido';

  @override
  String get loginError => 'Error: Usuario o contraseña incorrectos.';

  @override
  String get signupError => 'Error: No se pudo crear el usuario.';

  @override
  String get emailInUse => 'El correo electrónico ya está en uso por otra cuenta.';

  @override
  String get weakPassword => 'La contraseña es demasiado débil.';

  @override
  String get wrongPassword => 'La contraseña es incorrecta.';
}
