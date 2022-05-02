// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NotificationsStore on _NotificationsStoreBase, Store {
  late final _$modelAtom =
      Atom(name: '_NotificationsStoreBase.model', context: context);

  @override
  List<NotificationResponseModel>? get model {
    _$modelAtom.reportRead();
    return super.model;
  }

  @override
  set model(List<NotificationResponseModel>? value) {
    _$modelAtom.reportWrite(value, super.model, () {
      super.model = value;
    });
  }

  late final _$getNotificationsAsyncAction =
      AsyncAction('_NotificationsStoreBase.getNotifications', context: context);

  @override
  Future getNotifications() {
    return _$getNotificationsAsyncAction.run(() => super.getNotifications());
  }

  @override
  String toString() {
    return '''
model: ${model}
    ''';
  }
}
