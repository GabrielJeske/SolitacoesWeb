import 'package:mobx/mobx.dart';

part 'login_mob.g.dart';

class LoginMob = LoginMobBase with _$LoginMob;

abstract class LoginMobBase with Store { 

  @observable
  ObservableMap<String, String?> formErrors = ObservableMap.of({});

  @computed
  bool get isFormValid => formErrors.values.every((error) => error == null);
  
}