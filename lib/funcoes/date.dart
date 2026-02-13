// date.dart - CÓDIGO CORRIGIDO

class Data {
  //dd
  static var dia = DateTime.now().day.toString().length == 1
      ? "0${DateTime.now().day}"
      : DateTime.now().day.toString(); // <-- Correção para garantir "03" ao invés de "3"
  //mm
  static var mes = DateTime.now().month.toString().length == 1
      ? "0${DateTime.now().month}"
      : DateTime.now().month.toString();
  //aa
  static var ano = DateTime.now().year.toString().substring(2);

  //hh
  static var hora = DateTime.now().hour.toString().length == 1
      ? "0${DateTime.now().hour}"
      : DateTime.now().hour.toString();
  //mm
  static var minutos = DateTime.now().minute.toString().length == 1
      ? "0${DateTime.now().minute}"
      : DateTime.now().minute.toString();
  //ss
  static var segundos = DateTime.now().second.toString().length == 1
      ? "0${DateTime.now().second}"
      : DateTime.now().second.toString();

  static String get getData {
    //dd/mm/aa
    return "$dia/$mes/$ano";
  }

  static String get getHora {
    //hh:mm:ss
    return "$hora:$minutos:$segundos";
  }
}