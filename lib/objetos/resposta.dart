class ApiResponse {
  final bool sucesso;
  final String mensagem;
  final dynamic data;

  ApiResponse({
    required this.sucesso,
    required this.mensagem,
    this.data,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      sucesso: map['sucesso'] ?? false, 
      mensagem: map['mensagem'] ?? 'Erro desconhecido',
      data: map['data'],
    );
  }
}