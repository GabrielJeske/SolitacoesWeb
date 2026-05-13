# SolicitacoesWeb

Sistema web para gerenciamento de solicitações (tickets), com frontend em Flutter e backend em Go.

## Funcionalidades

- Autenticação de usuários com controle de acesso
- Abertura, consulta e acompanhamento de solicitações
- Alteração de status das solicitações
- Upload e download de anexos
- Gerenciamento de usuários (inclusão, consulta, alteração e troca de senha)

## Tecnologias

### Frontend (Flutter Web)
- **Flutter** com gerenciamento de estado via **MobX** e **GetX**
- Navegação com rotas nomeadas
- Armazenamento local com **GetStorage**
- Comunicação com o servidor via **HTTP**

### Backend (`server_http/`)
- **Go** com servidor HTTP nativo (`net/http`)
- API REST com endpoints para solicitações, usuários e autenticação
- Middleware CORS para comunicação com o frontend

## Estrutura do Projeto

```
lib/                  # Código-fonte Flutter
├── controller/       # Controllers da aplicação
├── funcoes/          # Funções utilitárias
├── objetos/          # Modelos de dados
├── pages/            # Telas da aplicação
│   ├── login_page    # Tela de login
│   ├── home_page     # Tela principal
│   ├── solicitacao/  # Telas de solicitações
│   └── usuarios/     # Telas de gestão de usuários
├── store/            # Stores MobX
└── widgets/          # Componentes reutilizáveis

server_http/          # Servidor backend em Go
```

## Como Executar

### Frontend
```bash
flutter pub get
flutter run -d chrome
```

### Backend
```bash
cd server_http
go run .
```
