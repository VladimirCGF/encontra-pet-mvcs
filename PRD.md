# PRD 

Documento de Requisitos de Produto (PRD)

Versão: 5.2 (Sessão Híbrida Blindada, Correção de Edição/Autoria e Diagnóstico Avançado)

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
- **Funcionalidade Offline-First Total (Latência Zero)**: O cache local via SQLite é o ponto de entrada prioritário para criação, leitura, atualização e exclusão (CRUD completo).
- **Autenticação Segura & Híbrida**: Cadastro e login exigem conexão ativa, mas o perfil e a sessão do usuário ficam disponíveis offline.
- **Sincronização Silenciosa e Robusta (Job Sync)**: Tarefas (Insert, Update, Delete) acumuladas em modo offline são enviadas automaticamente em segundo plano por meio do `SyncService`.
- **UX Premium & Reativa**: O app conta com Pull-to-Refresh, carregamento reativo e animações suaves (Hero).
- **Isolamento de Dados do Usuário**: A aba "Meus Pets" filtra localmente e de forma reativa os dados específicos do tutor com base no UUID da sessão.

# 6. Justificativa Tecnológica
- **Flutter & Provider**: Desenvolvimento multiplataforma rápido com gerenciamento de estado reativo e previsível.
- **SQLite (sqflite)**: Banco relacional veloz para armazenamento local de tabelas.
- **Supabase (supabase_flutter)**: Backend poderoso (PostgreSQL) com RLS (Row Level Security), Storage configurado para mídias (`pet-images`) e painel em tempo real.
- **Connectivity Plus**: Monitoramento de rede para controle das operações offline.
- **Geolocator & Geocoding**: Integração nativa para captura automática do endereço.

# 7. Benchmark de Modelos no 

Abaixo está o benchmark do padrão de arquitetura MVCS, mapeando as responsabilidades de cada componente e seu estado de desenvolvimento atual:

| Componente / Camada | Responsabilidade Principal | Restrições & Fluxo de Acesso | Estado Atual dos Arquivos |
| :--- | :--- | :--- | :--- |
| **View** (`lib/view/`) | Exibição de UI e captura de ações do usuário | **Nunca** acessa API ou DB. | 100% funcional. `LocationSection` refatorado para geolocalização automática. Animações `Hero` adicionadas para fotos e `Empty State` rico desenvolvido para "Meus Pets". Corrigido bug de fechamento da data (`$finalDate}`) no `EditPetScreen`. |
| **Controller** (`lib/controller/`) | Validação de formulários, gestão de estado e Provider | Comunica-se com os Services. | `PetController` modificado para reativamente filtrar os dados do usuário autenticado no getter `myPets` através do `userId`. |
| **Service** (`lib/service/`) | Orquestração híbrida de persistência e sync | Decide entre SQLite e Supabase. | `LocationService` extrai Bairro, Cidade e Estado. `PetService` injeta `userId` tanto na inserção (`createPet`) quanto na atualização (`updatePet`) para manter a autoria dos pets editados. `SyncService` possui diagnóstico robusto com `debugPrint` identificando gargalos na rede e erros de Storage (ex: `StorageException`). |
| **Database/DAO** (`lib/database/`) | Persistência física local no SQLite | Isolamento total em arquivos de DAO. | `DatabaseHelper` atualizado para schema versão 4, aplicando `user_id` em tempo real. |
| **API** (`lib/api/`) | Comunicação direta com a nuvem do Supabase | Consumida apenas pelas classes Service. | Totalmente integrada com tracing de requisições implementado nas APIs de Pet e Auth. |

# 8. Funcionalidades Principais
- [x] **Tratamento de Exceções Customizadas**: Feedback em português para erros de rede e autenticação.
- [x] **Feed de Pets Dinâmico**: Visualização imediata e offline de pets cadastrados com carregamento automático.
- [x] **Área Pessoal de Pets ("Meus Pets")**: Gerenciamento isolado com cartões interativos para Edição e Exclusão.
- [x] **Edição Cadastral de Perfil**: Alteração de nome e contato offline-first.
- [x] **Geolocalização Ativa (Auto-Preenchimento)**: Captura em um clique do Bairro, Cidade e Estado via API nativa.
- [x] **Animações de Transição Premium (Hero)**: Efeito de expansão contínua em fotos ao navegar nas telas.
- [x] **Diagnóstico Nativo na Sincronização**: Monitoramento completo em console do ciclo de Push, Pull e Storage com o `Supabase`.
- [x] **Garantia de Autoria Reativa**: Blindagem nas edições de pets para assegurar que a propriedade (`userId`) nunca seja perdida.

# 9. Requisitos Funcionais
- [x] RF01 - O usuário deve conseguir se cadastrar utilizando um e-mail válido.
- [x] RF02 - O sistema deve rejeitar logins se o dispositivo estiver offline.
- [x] RF03 - O usuário deve conseguir cadastrar novos animais e imagens mesmo sem internet.
- [x] RF04 - O usuário deve conseguir editar os dados de um pet previamente criado.
- [x] RF05 - O usuário deve conseguir excluir o pet cadastrado (ação com janela de confirmação), refletindo imediatamente na UI.
- [x] RF06 - O feed de pets deve ser carregado a partir do SQLite no `initState` da Home para latência zero.
- [x] RF07 - O sistema de sincronização deve processar não apenas inserções, mas também exclusões e atualizações pendentes para o Supabase.
- [x] RF08 - O sistema deve permitir ao usuário preencher automaticamente sua localização usando GPS.
- [x] RF09 - O aplicativo deve exibir somente os pets publicados pelo usuário logado na tela de "Meus Pets".

# 10. Requisitos Não Funcionais
- **Responsividade (UI Thread)**: A thread de UI não trava por causa de uploads de mídia ou requisições de rede.
- **Portabilidade**: Execução em smartphones Android (Medium Phone).
- **Consistência de Nuvem (Supabase)**: A tabela `pets` no servidor deve ter a segurança (RLS) alinhada. O bucket de Storage `pet-images` deve ser público para visualização e possuir a política (Policy) de `INSERT` habilitada para uploads públicos/autenticados.

# 11. Arquitetura Proposta
A arquitetura segue o modelo modular MVCS estruturado desta forma:
```text
lib/
├─ api/          # Comunicação HTTP (AuthApi, PetApi) com tráfego mapeado
├─ controller/   # Gerenciamento de Estado Reativo (AuthController, PetController)
├─ database/     # SQLite Local Versão 4 (DatabaseHelper, UserDao, PetDao)
├─ model/        # Entidades puras serializáveis (UserModel, PetModel c/ userId)
├─ service/      # Regra Híbrida / Sincronizadores (SyncService, LocationService)
└─ view/         # Interface Gráfica / Telas / Widgets c/ animações
```

# 12. Hardware Alvo
Smartphones Android (API Level 36 - Medium Phone) com resoluções de tela padrão a partir de 1080×2220 e com suporte a conexões instáveis.

# 13. Métricas de Sucesso
- **Tempo de Inicialização de Telas**: < 200ms para exibição completa do feed.
- **Consistência de Dados**: 100% de precisão no Sync de Uploads (Imagens) e Registros Textuais.
- **Transparência de Troubleshooting**: Identificação instantânea de bloqueios do Supabase (ex: erro 403 de Storage).

# 14. Roadmap

### Concluído
- [x] **Fase 1 - 12**: Criação de base UI, implementação de MVCS, edição Offline-first, Pull-to-Refresh e gerenciamento de deleção.
- [x] **Fase 13**: Filtragem de Sessão Verdadeira e isolamento de banco de dados vinculando cada pet gerado ao seu UUID logado (`userId`).
- [x] **Fase 14**: Refinamentos finais de design, adição de geolocalização nativa (Fase extra) e transições visuais com widget `Hero` e reestruturação da tela com *Empty State*.
- [x] **Fase 14.1 (Diagnóstico)**: Integração massiva de logs (`debugPrint`) em todas as camadas da API e de Sincronização. Diagnóstico finalizado da trava do banco remoto causada pelo bloqueio de RLS do Storage do Supabase (Erro `403 Unauthorized` ao inserir foto) e ajuste correspondente no painel do Supabase.
- [x] **Fase 14.2 (Correção de Edição)**: Correção do bug de autoria nula ao salvar edições e ajuste do erro ortográfico no formulário de edição de datas.

### Em Andamento / Próximos Passos
- [ ] **Fase 15**: Validação final e encerramento de testes de integração ponta a ponta.

# 15. Riscos
- **Perda de Autoria**: Mitigado ativamente na camada de negócios (`PetService`) onde o `userId` é injetado compulsoriamente no banco SQLite e Supabase em atualizações.
- **Limpeza de Cache Físico**: Se o usuário tirar foto e limpar o cache do celular antes da internet voltar, a URL local vai falhar na hora de subir a mídia. Tratamento por `try-catch` já blindado na API.

# 16. Entrega Esperada
Aplicativo robusto que rastreia visualmente através de logs internos onde a comunicação falha, lidando ativamente com exceções na nuvem e garantindo estabilidade irretocável na perspectiva da UI do usuário.

# 17. Critério de Avaliação
1. **Padrão MVCS estrito**: Respeitado integralmente.
2. **Offline-First real**: CRUD completo isolado e 100% autônomo perante quedas na nuvem.
3. **Resiliência do SyncService**: Loga e identifica precisamente qual etapa (upload de foto vs upload JSON) falhou devido à ausência de Policies.
4. **Comunicação Ativa UI/Controller**: Interface reagindo em menos de meio segundo.
