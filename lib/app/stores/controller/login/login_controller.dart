import 'package:email_validator/email_validator.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  @observable
  String name = "";

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  String confirmPassword = "";

  @computed
  bool get isSignUpButtonEnabled =>
      getErrorEmail(email) == null &&
      getErrorName(name) == null &&
      getErrorPassword(password) == null &&
      getErrorConfirmPassword(password, confirmPassword) == null &&
      email.length > 0 &&
      password.length > 0 &&
      confirmPassword.length > 0 &&
      name.length > 0;

  String? getErrorPassword(String text) {
    if (text.length == 0) {
      return null;
    }
    if (!validateStructure(text)) {
      return 'A senha é muito fraca.';
    }
    return null;
  }

  @action
  String? getErrorName(String text) {
    if (text.length == 0) {
      return null;
    }
    if (text.replaceAll(' ', '').length < 6 && text.length > 0) {
      return 'Nome inválido.';
    }
    return null;
  }

  @action
  String? getErrorEmail(String text) {
    if (text.length == 0) {
      return null;
    }
    if (!EmailValidator.validate(text)) {
      return 'E-mail inválido.';
    }
    return null;
  }

  @action
  String? getErrorConfirmPassword(
      String textPassword, String textConfirmPassword) {
    if (textConfirmPassword.length == 0) {
      return null;
    }

    if (textPassword.length == 0 && textConfirmPassword.length == 0) {
      return null;
    }
    if (textPassword != textConfirmPassword) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  bool validateStructure(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
