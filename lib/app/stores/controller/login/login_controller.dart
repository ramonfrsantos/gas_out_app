import 'dart:async';

import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase
    with _$LoginController;

abstract class _LoginControllerBase with Store {
  @observable
  bool isSignUpButtonDisabled = true;

  @action
  setValue(bool value) {
    isSignUpButtonDisabled = value;
  }
}
