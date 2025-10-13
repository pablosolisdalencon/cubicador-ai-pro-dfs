import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cubicador Pro';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get enter => 'Enter';

  @override
  String get register => 'Sign Up';

  @override
  String get noAccount => 'Don\'t have an account? Sign Up';

  @override
  String get myProjects => 'My Projects';

  @override
  String get addProject => 'Add Project';

  @override
  String get projectName => 'Project Name';

  @override
  String get location => 'Location';

  @override
  String get technicalManager => 'Technical Manager';

  @override
  String get saveProject => 'Save Project';

  @override
  String get fieldRequired => 'Field required';

  @override
  String get loginError => 'Error: Incorrect username or password.';

  @override
  String get signupError => 'Error: Could not create user.';

  @override
  String get emailInUse => 'The email address is already in use by another account.';

  @override
  String get weakPassword => 'The password provided is too weak.';

  @override
  String get wrongPassword => 'The password is not correct.';
}
