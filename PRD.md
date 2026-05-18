# PRD 

Documento de Requisitos de Produto (PRD)

Versão: 4.0 (Diagnóstico de Nuvem, Gerenciamento de Pets Offline-First e Refresh Reativo).

# 1. Visão Geral do Produto

## Nome do Produto
EncontraPet

## Resumo Executivo
EncontraPet é um aplicativo móvel híbrido e robusto construído em Flutter que tem como missão conectar donos de pets desaparecidos a salvadores e voluntários. O aplicativo destaca-se pela sua arquitetura **Offline-First**, utilizando o padrão **MVCS (Model-View-Controller-Service)**. Ele opera com latência zero gravando e lendo informações diretamente do banco local **SQLite**, ao mesmo tempo em que sincroniza dados em segundo plano de forma bidirecional (Push/Pull) com o backend em nuvem **Supabase**. O app é visualmente premium, aderindo estritamente ao Material Design 3.

# 2. Problema de Negócio
Donos de animais sofrem com a falta de canais eficientes e imediatos para divulgar pets perdidos. Além disso, as buscas e resgates costumam ocorrer em locais de baixíssima ou nenhuma conectividade móvel (parques, matas, subsolos, áreas rurais). Aplicativos puramente online tornam-se inúteis nesses cenários críticos, causando perda de tempo precioso e frustração para os donos e voluntários.

# 3. Objetivo do Produto
Oferecer uma plataforma de busca e gerenciamento de pets desaparecidos extremamente rápida e confiável. O produto deve permitir cadastros, listagens, edições e exclusões de dados de forma 100% offline com resposta instantânea e transparente para o usuário, empurrando as modificações e mídias para a nuvem de forma automática no exato instante em que uma conexão estável à internet for detectada.

# 4. Público-Alvo

## Primário
Tutores e donos de cães e gatos que perderam seus animais ou encontraram um animal abandonado na rua e precisam reportar imediatamente.

## Secundário
Protetores independentes, ONGs e grupos de busca de animais perdidos que operam frequentemente em áreas externas e de sinal celular instável.

# 5. Proposta de Valor

## Benefícios principais
- **Funcionalidade Offline-First Total (Latência Zero)**: O cache local via SQLite é o ponto de entrada prioritário para criação, leitura, atualização e exclusão (CRUD completo), proporcionando velocidade extrema na interface.
- **Autenticação Segura & Híbrida**: Cadastro e login exigem conexão ativa, mas o perfil e a sessão do usuário ficam disponíveis offline.
- **Sincronização Silenciosa e Robusta (Job Sync)**: Tarefas (Insert, Update, Delete) acumuladas em modo offline são enviadas automaticamente em segundo plano por meio do `SyncService`.
- **UX Premium & Reativa**: O app conta com Pull-to-Refresh e carregamento reativo de dados no primeiro instante de tela.

# 6. Justificativa Tecnológica
- **Flutter & Provider**: Desenvolvimento multiplataforma rápido com gerenciamento de estado reativo e previsível.
- **SQLite (sqflite)**: Banco relacional veloz para armazenamento local de tabelas.
- **Supabase (supabase_flutter)**: Backend poderoso (PostgreSQL) com RLS (Row Level Security), Storage configurado para mídias (`pet-images`) e painel em tempo real.
- **Connectivity Plus**: Monitoramento de rede para controle das operações offline.

# 7. Benchmark de Modelos no 

| Componente / Camada | Responsabilidade Principal | Restrições & Fluxo de Acesso | Estado Atual dos Arquivos |
| :--- | :--- | :--- | :--- |
| **View** (`lib/view/`) | Exibição de UI e captura de ações do usuário | **Nunca** acessa API ou DB. | 100% funcional. `HomeScreen` e `MyPetsScreen` totalmente reativas. |
| **Controller** (`lib/controller/`) | Validação de formulários, gestão de estado e Provider | Comunica-se com os Services. | Modificado para lidar com deleção, edição e carga de pets na inicialização. |
| **Service** (`lib/service/`) | Orquestração híbrida de persistência e sync | Decide entre SQLite e Supabase. | `PetService` e `SyncService` habilitados para `pending_update` e `pending_delete`. |
| **Database/DAO** (`lib/database/`) | Persistência física local no SQLite | Isolamento total em arquivos de DAO. | Estável. Manipula inserções e exclusões físicas. |
| **API** (`lib/api/`) | Comunicação direta com a nuvem do Supabase | Consumida apenas pelas classes Service. | Totalmente integrada (Auth, Pets, Storage). |

# 8. Funcionalidades Principais
- [x] **Tratamento de Exceções Customizadas**: Feedback em português para erros de rede e autenticação.
- [x] **Feed de Pets Dinâmico**: Visualização imediata e offline de pets cadastrados com carregamento automático (`StatefulWidget`).
- [x] **Área Pessoal de Pets ("Meus Pets")**: Gerenciamento de animais com cartões interativos para Edição e Exclusão.
- [x] **Edição Cadastral de Perfil**: Alteração de nome e contato offline-first.
- [x] **Pull-to-Refresh Reativo**: Funcionalidade "Deslizar para Atualizar" embutida nas telas Home e Meus Pets.
- [x] **CRUD Completo Offline-First**: Inserção, edição e remoção de pets guardadas no banco local e empurradas via PUSH para nuvem quando conectado.
- [x] **Persistência de Sessão ("Manter Conectado")**: Botão reativo de persistência e restauração automática de sessão.

# 9. Requisitos Funcionais
- [x] RF01 - O usuário deve conseguir se cadastrar utilizando um e-mail válido.
- [x] RF02 - O sistema deve rejeitar logins se o dispositivo estiver offline, emitindo alertas amigáveis.
- [x] RF03 - O usuário deve conseguir cadastrar novos animais e imagens mesmo sem internet.
- [x] RF04 - O usuário deve conseguir editar os dados de um pet previamente criado.
- [x] RF05 - O usuário deve conseguir excluir o pet cadastrado (ação com janela de confirmação), refletindo imediatamente na UI.
- [x] RF06 - O feed de pets deve ser carregado a partir do SQLite no `initState` da Home para latência zero.
- [x] RF07 - O sistema de sincronização deve processar não apenas inserções, mas também exclusões e atualizações pendentes para o Supabase.

# 10. Requisitos Não Funcionais
- **Responsividade (UI Thread)**: A thread de UI não trava por causa de uploads de mídia.
- **Portabilidade**: Execução em smartphones Android (Medium Phone).
- **Consistência de Nuvem (Supabase)**: A tabela `pets` no servidor deve ter a segurança (RLS) alinhada e desativada para a Fase de Testes ou configurada com Policies públicas. O bucket de Storage `pet-images` deve ser obrigatoriamente público.

# 11. Arquitetura Proposta
A arquitetura do projeto segue o modelo modular e desacoplado do MVCS estruturado desta forma:
```text
lib/
├─ api/          # Comunicação HTTP / Supabase (AuthApi, PetApi)
├─ controller/   # Gerenciamento de Estado Reativo (AuthController, PetController)
├─ database/     # SQLite Local (DatabaseHelper, UserDao, PetDao)
├─ model/        # Entidades puras serializáveis (UserModel, PetModel)
├─ service/      # Regra Híbrida / Sincronizadores (UserService, PetService, SyncService)
└─ view/         # Interface Gráfica / Telas / Widgets (HomeScreen, EditPetScreen, MyPetsScreen)
```

# 12. Hardware Alvo
Smartphones Android (API Level 36 - Medium Phone) com resoluções de tela padrão a partir de 1080×2220 e com suporte a conexões instáveis.

# 13. Métricas de Sucesso
- **Tempo de Inicialização de Telas**: < 200ms para exibição completa do feed.
- **Consistência de Dados**: 100% de precisão no Sync de Uploads (Imagens) e Registros Textuais.
- **Qualidade de Código**: O projeto deve compilar limpo sem travar o motor.

# 14. Roadmap

### Concluído
- [x] **Fase 1 - 7**: Criação da base UI, integração nativa SQLite e Supabase e autenticação robusta (Concluídas em sprints anteriores).
- [x] **Fase 8**: Edição de Perfil Offline-First com migração de SQLite.
- [x] **Fase 9**: Persistência de Sessão e Auto-Login.
- [x] **Fase 10**: Diagnóstico profundo e correção de erros de comunicação da API Supabase (Resolução do Erro PGRST205 - Schema/Table not found e Erro 42501 - Bloqueio de RLS). Criação guiada da tabela `pets` e bucket `pet-images`.
- [x] **Fase 11**: Refatoração da Home para carregamento `StatefulWidget` com `Pull-to-Refresh`.
- [x] **Fase 12**: Implementação completa da aba "Meus Pets" (Gerenciamento, Edição conectada, Exclusão com Confirmação e Update reativo no SyncService).

### Em Andamento / Próximos Passos
- [ ] **Fase 13**: Filtragem de Sessão Verdadeira (Buscar apenas os pets do usuário logado baseado no UUID da autenticação, enviando um `userId` em cada `PetModel`).
- [ ] **Fase 14**: Ajustes finais de design e micro-interações do fluxo de publicação e sucesso.

# 15. Riscos
- **Arquivos Temporários Perdidos**: Se o app fecha antes de fazer o upload, a imagem gerada pelo `image_picker` pode ser apagada do cache do OS, impedindo a sincronização da mídia (Tratamento já embutido no código ignorando o erro com graciosidade).
- **RLS Mal Configurado**: Se ativado erroneamente no Supabase, a inserção falha silenciosamente na UI enquanto o debug lança `42501`.

# 16. Entrega Esperada
Aplicativo de produção que domina o uso offline e online de dados com UI/UX focada na estabilidade da sessão e feedback visual.

# 17. Critério de Avaliação
1. **Padrão MVCS estrito**: Respeitado integralmente.
2. **Offline-First real**: CRUD (Criar, Ler, Atualizar e Deletar) completo local.
3. **Resiliência do SyncService**: Consegue processar inserções, edições e exclusões autônomas.
4. **Comunicação Ativa UI/Controller**: Interface deve reagir no instante em que `notifyListeners()` é disparado.
