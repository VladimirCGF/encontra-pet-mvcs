# PRD

Documento de Requisitos de Produto (PRD)

Versão: 3.0 (Sincronização Offline-First, Perfis Dinâmicos e Sessão)

# 1. Visão Geral do Produto

## Nome do Produto
EncontraPet

## Resumo Executivo
EncontraPet é um aplicativo móvel híbrido e robusto construído em Flutter que tem como missão conectar donos de pets desaparecidos a salvadores e voluntários. O aplicativo destaca-se pela sua arquitetura **Offline-First**, utilizando o padrão **MVCS (Model-View-Controller-Service)**. Ele opera com latência zero gravando e lendo informações diretamente do banco local **SQLite**, ao mesmo tempo em que sincroniza dados em segundo plano de forma bidirecional (Push/Pull) com o backend em nuvem **Supabase**. O app é visualmente premium, aderindo estritamente ao Material Design 3 e com zero issues no linter de produção.

# 2. Problema de Negócio
Donos de animais sofrem com a falta de canais eficientes e imediatos para divulgar pets perdidos. Além disso, as buscas e resgates costumam ocorrer em locais de baixíssima ou nenhuma conectividade móvel (parques, matas, subsolos, áreas rurais). Aplicativos puramente online tornam-se inúteis nesses cenários críticos, causando perda de tempo precioso e frustração para os donos e voluntários.

# 3. Objetivo do Produto
Oferecer uma plataforma de busca e gerenciamento de pets desaparecidos extremamente rápida e confiável. O produto deve permitir cadastros, listagens e edições de dados de forma 100% offline com resposta instantânea e transparente para o usuário, empurrando as modificações e mídias para a nuvem de forma automática no exato instante em que uma conexão estável à internet for detectada.

# 4. Público-Alvo

## Primário
Tutores e donos de cães e gatos que perderam seus animais ou encontraram um animal abandonado na rua e precisam reportar imediatamente.

## Secundário
Protetores independentes, ONGs e grupos de busca de animais perdidos que operam frequentemente em áreas externas e de sinal celular instável.

# 5. Proposta de Valor

## Benefícios principais
- **Funcionalidade Offline-First (Latência Zero)**: O cache local via SQLite é o ponto de entrada prioritário para leitura e escrita, proporcionando carregamentos imediatos.
- **Autenticação Segura & Híbrida**: O cadastro e login exigem conexão ativa para garantir integridade, mas o perfil do usuário fica disponível offline imediatamente após a autenticação.
- **Sincronização Silenciosa (Job Sync)**: Tarefas pendentes acumuladas em modo offline são enviadas automaticamente em segundo plano por meio de serviços inteligentes de sincronização.
- **Arquitetura MVCS Robusta**: Desacoplamento total entre lógica de apresentação (View), regra de negócio/estado (Controller) e persistência de dados (Service/DAO/API).

# 6. Justificativa Tecnológica
- **Flutter & Provider**: Desenvolvimento multiplataforma rápido com gerenciamento de estado reativo e previsível.
- **SQLite (sqflite)**: Banco relacional veloz para armazenamento local estruturado sem necessidade de persistência binária pesada (imagens são salvas como caminhos de arquivos locais).
- **Supabase (supabase_flutter)**: Backend instantâneo com autenticação integrada, banco relacional estruturado em nuvem e Storage para imagens.
- **Connectivity Plus**: Monitoramento de rede em tempo real para controle fino das operações online/offline no aplicativo.

# 7. Benchmark de Modelos no 
| Componente / Camada | Responsabilidade Principal | Restrições & Fluxo de Acesso | Estado Atual dos Arquivos |
| :--- | :--- | :--- | :--- |
| **View** (`lib/view/`) | Exibição de UI e captura de ações do usuário | **Nunca** acessa API ou DB. Apenas consome Controllers. | 100% funcional. Conectado ao `AuthController` e `PetController`. |
| **Controller** (`lib/controller/`) | Validação de formulários, gestão de estado e Provider | Comunica-se com os Services. **Nunca** executa queries de banco ou chamadas HTTP diretas. | Reativo. Métodos de login, cadastro, alteração cadastral e gerenciamento de pets ativos. |
| **Service** (`lib/service/`) | Orquestração híbrida de persistência e sync | Decide entre SQLite e Supabase. Executa tarefas em background. | Habilitado para push/pull bidirecional de pets e dados de perfil do usuário. |
| **Database/DAO** (`lib/database/`) | Persistência física local no SQLite | Isolamento total em arquivos de DAO (`UserDao`, `PetDao`). Armazena apenas caminhos textuais de fotos. | Versão 3 estável. Adicionada a coluna `sync_status` para a tabela de usuários. |
| **API** (`lib/api/`) | Comunicação direta com a nuvem do Supabase | Consumida apenas pelas classes da camada Service. | Totalmente integrada para autenticação, perfis e pets. |

# 8. Funcionalidades Principais
- [x] **Autenticação Robusta**: Login e Signup com validações locais integradas (Regex de e-mail e senha mínima de 8 caracteres).
- [x] **Tratamento de Exceções Customizadas**: Feedback traduzido para o usuário em português para casos de duplicidade de conta, taxa de requisições excedida (*Rate Limit*) e e-mail pendente de confirmação.
- [x] **Feed de Pets Dinâmico**: Visualização imediata e offline de pets cadastrados.
- [x] **Área Pessoal de Pets ("Meus Pets")**: Gerenciamento de animais cadastrados pelo usuário.
- [x] **Edição Cadastral de Perfil**: Alteração de nome e contato (telefone) no formato offline-first (salvamento local imediato e sincronização em lote).
- [x] **Indicador de Sincronização Visual**: Notificação em tempo real de status pendente de sincronização para alteração de dados do usuário e pets (ícone de nuvem offline reativo).
- [ ] **Persistência de Sessão ("Manter Conectado")**: Botão reativo de persistência e restauração automática de sessão (Lógica implementada no Controller; tela e Wrapper em andamento).

# 9. Requisitos Funcionais
- [x] RF01 - O usuário deve conseguir se cadastrar utilizando um e-mail válido e uma senha forte (mínimo de 8 caracteres).
- [x] RF02 - O sistema deve rejeitar cadastros e logins se o dispositivo estiver offline, emitindo alertas amigáveis.
- [x] RF03 - O sistema deve traduzir para o português todos os erros de autenticação do Supabase.
- [x] RF04 - O usuário deve conseguir editar seu nome e telefone de contato a qualquer momento, mesmo offline.
- [x] RF05 - O feed de pets deve ser carregado prioritariamente a partir do banco local SQLite para resposta instantânea.
- [x] RF06 - O sistema de sincronização automática deve disparar o upload dos pets criados e perfis editados offline assim que a conexão de rede for restabelecida.
- [ ] RF07 - O usuário deve ter a opção "Manter conectado" no login para salvar a sessão e pular a autenticação ao reabrir o app.

# 10. Requisitos Não Funcionais
- **Responsividade (UI Thread)**: A thread de interface gráfica nunca deve travar por operações bloqueantes de rede ou disco.
- **Portabilidade**: Execução garantida em smartphones Android modernos.
- **Robustez de Dados**: Uso de transações SQLite e ConflictAlgorithm nos DAOs para evitar duplicidade ou corrupção de tabelas.
- **Privacidade de Mídias**: Caminhos de imagens armazenadas localmente no cache do sistema antes de subir para o Supabase Storage.

# 11. Arquitetura Proposta
A arquitetura do projeto segue o modelo modular e desacoplado do MVCS estruturado desta forma:
```text
lib/
├─ api/          # Comunicação HTTP / Supabase (AuthApi, PetApi)
├─ controller/   # Gerenciamento de Estado Reativo (AuthController, PetController)
├─ database/     # SQLite Local (DatabaseHelper, UserDao, PetDao)
├─ model/        # Entidades puras serializáveis (UserModel, PetModel)
├─ service/      # Regra Híbrida / Sincronizadores (UserService, PetService, SyncService)
└─ view/         # Interface Gráfica / Telas / Widgets (LoginPage, SignupPage, HomeScreen, ProfileScreen, MyPetsScreen, etc.)
```

# 12. Hardware Alvo
Smartphones Android (API Level 36 - Medium Phone) com resoluções de tela padrão a partir de 1080×2220 e com suporte a conexões instáveis ou ausência intermitente de dados móveis.

# 13. Métricas de Sucesso
- **Tempo de Inicialização de Telas**: < 200ms para exibição completa do feed (graças ao SQLite).
- **Consistência de Dados**: 100% das inserções offline devem ser eventualmente sincronizadas para o Supabase sem duplicações.
- **Qualidade de Código**: Manter o projeto com **0 warnings** no Flutter Analyze.

# 14. Roadmap

### Concluído
- [x] **Fase 1**: Criação do layout inicial e navegação (View).
- [x] **Fase 2**: Padronização do visual seguindo Material Design 3.
- [x] **Fase 3**: Migração das pastas do projeto para a arquitetura estruturada MVCS.
- [x] **Fase 4**: Criação das tabelas `users` e `pets` no SQLite local.
- [x] **Fase 5**: Integração nativa com cliente de autenticação do Supabase.
- [x] **Fase 6**: Sincronização automatizada bidirecional (Push/Pull) de pets desaparecidos.
- [x] **Fase 7**: Validações de e-mail/senha na tela de cadastro e tradução de erros de API.
- [x] **Fase 8**: Edição de Perfil Offline-First com migração do banco SQLite local para Versão 3 e suporte a indicador de sincronização reativo na UI.
- [x] **Fase 9**: Implementação do recurso "Manter Conectado" e Auto-Login (SharedPreferences + AuthWrapper + reescrita reativa do controlador).

### Em Andamento
- [ ] **Fase 10**: Validação extensiva de fluxos híbridos e tratamento de expiração de token.

# 15. Riscos
- **Estouro de Cota de E-mail (SMTP Rate Limit)**: O SMTP gratuito do Supabase limita o envio de e-mails de confirmação. *Mitigação*: Implementamos tratamento amigável no app para avisar sobre excesso de tentativas e recomendamos a criação de contas de teste com auto-confirmação diretamente no console administrativo do Supabase para desenvolvimento fluido.
- **Conflito de Versões de Dados**: Edições simultâneas do perfil do usuário em múltiplos dispositivos. *Mitigação*: Estratégia de última gravação local prevalece (*Last-Write-Wins*).

# 16. Entrega Esperada
Um aplicativo Flutter de alta fidelidade visual, com linter impecável, que permite a busca ativa de pets de forma 100% offline, garantindo que o cadastro de novos animais e atualizações cadastrais do tutor persistam localmente no SQLite e sejam sincronizados com segurança nos servidores remotos do Supabase.

# 17. Critério de Avaliação
1. **Padrão MVCS estrito**: Nenhuma chamada ao banco de dados ou API é permitida nas telas ou controladores.
2. **Offline-First real**: O aplicativo deve carregar e funcionar com todas as telas populadas de dados mesmo se o celular estiver em modo avião.
3. **Persistência de Sessão funcional**: O usuário não deve precisar logar novamente se fechar e abrir o aplicativo tendo marcado "Manter conectado".
4. **Análise estática limpa**: Execução do `flutter analyze` sem erros ou avisos na estrutura do código.
