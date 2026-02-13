// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_mob.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginMob on LoginMobBase, Store {
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(
            () => super.isFormValid,
            name: 'LoginMobBase.isFormValid',
          ))
          .value;

  late final _$formErrorsAtom = Atom(
    name: 'LoginMobBase.formErrors',
    context: context,
  );

  @override
  ObservableMap<String, String?> get formErrors {
    _$formErrorsAtom.reportRead();
    return super.formErrors;
  }

  @override
  set formErrors(ObservableMap<String, String?> value) {
    _$formErrorsAtom.reportWrite(value, super.formErrors, () {
      super.formErrors = value;
    });
  }

  @override
  String toString() {
    return '''
formErrors: ${formErrors},
isFormValid: ${isFormValid}
    ''';
  }
}
