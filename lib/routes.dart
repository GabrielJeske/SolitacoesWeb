import 'package:get/get.dart';
import 'package:solicitacoes/pages/solicitacao/alte_solic.dart';
import 'package:solicitacoes/pages/solicitacao/cons_solic.dart';
import 'package:solicitacoes/pages/solicitacao/excl_solic.dart';
import 'package:solicitacoes/pages/home_page.dart';
import 'package:solicitacoes/pages/solicitacao/incl_solic.dart';
import 'package:solicitacoes/pages/login_page.dart';
import 'package:solicitacoes/pages/solicitacao/speed_solic.dart';
import 'package:solicitacoes/pages/usuarios/alteracao.dart';
import 'package:solicitacoes/pages/usuarios/alterar_senha.dart';
import 'package:solicitacoes/pages/usuarios/consulta.dart';
import 'package:solicitacoes/pages/usuarios/inclusao.dart';

class Routes {
  static final routes = [
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/usuarios/inclusao', page: () => Inclusao()),
    GetPage(name: '/usuarios/consulta', page: () => Consulta()),
    GetPage(name: '/usuarios/alteracao', page: () => Alteracao()),
    GetPage(name: '/usuarios/senha', page: () => AlterarSenha()),
    GetPage(name: '/solicitacoes/inclusao', page: () => Inclusaosolicitacao()),
    GetPage(name: '/solicitacoes/alteracao', page: () => Alteracaosolic()),
    GetPage(name: '/solicitacoes/consulta', page: () => ConsultaSolic()),
    GetPage(name: '/solicitacoes/exclusao', page: () => Exclusaosolic()),
    GetPage(name: '/solicitacoes/speed', page: () => Speedsolic()),
  ];
}