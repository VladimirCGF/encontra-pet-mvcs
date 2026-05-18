# PRD 

Documento de Requisitos de Produto (PRD)

Versão: 6.0 (Busca & Filtro Reativos, Auditoria de Performance e Correções de Arquitetura)

# 1. Visão Geral do Produto

## Nome do Produto
EncontraPet

## Resumo Executivo
EncontraPet é um aplicativo móvel híbrido construído em Flutter que conecta donos de pets desaparecidos a salvadores e voluntários. Arquitetura **Offline-First** com padrão **MVCS (Model-View-Controller-Service)**, latência zero via **SQLite** local e sincronização bidirecional (Push/Pull) com **Supabase**. UI premium aderindo ao Material Design 3. A partir da v6.0, o app conta com busca textual e filtro por categoria no feed, além de uma camada de persistência otimizada com Singletons e cache de filtragem.

# 2. Problema de Negócio
Donos de animais sofrem com a falta de canais eficientes e imediatos para divulgar pets perdidos. Buscas e resgates costumam ocorrer em locais de baixíssima conectividade (parques, matas, áreas rurais). Aplicativos puramente online tornam-se inúteis nesses cenários críticos.

# 3. Objetivo do Produto
Oferecer uma plataforma de busca e gerenciamento de pets desaparecidos extremamente rápida e confiável. CRUD 100% offline com resposta instantânea, sincronização automática com a nuvem ao detectar conexão estável.

# 4. Público-Alvo

## Primário
Tutores e donos de cães e gatos que perderam seus animais ou encontraram um animal abandonado e precisam reportar imediatamente.

## Secundário
Protetores independentes, ONGs e grupos de busca que operam em áreas de sinal celular instável.

# 5. Proposta de Valor

## Benefícios principais
- **Offline-First Total (Latência Zero)**: CRUD completo via SQLite como ponto de entrada prioritário.
- **Busca e Filtro Reativos**: Pesquisa por nome, raça ou localização e filtro por categoria (Cachorros, Gatos, Outros) com resposta instantânea em memória.
- **Sincronização Silenciosa e Robusta**: Tarefas pendentes (Insert, Update, Delete) enviadas automaticamente via `SyncService` Singleton.
- **Proteção contra sobrescrita**: Pull da nuvem respeita edições locais pendentes (nunca sobrescreve dados não sincronizados).
- **Isolamento de Dados**: "Meus Pets" filtra reativamente pelo UUID do usuário autenticado.

# 6. Justificativa Tecnológica
- **Flutter & Provider**: Gerenciamento de estado reativo e previsível.
- **SQLite (sqflite)**: Banco local veloz com schema versionado (v4).
- **Supabase (supabase_flutter)**: Backend PostgreSQL com RLS, Storage (`pet-images`) público e Auth.
- **Connectivity Plus**: Monitoramento de rede para operações offline.
- **Geolocator & Geocoding**: Captura automática de endereço via GPS nativo.

# 7. Benchmark de Modelos no 

| Componente / Camada | Responsabilidade | Padrão Singleton | Estado Atual |
| :--- | :--- | :---: | :--- |
| **View** (`lib/view/`) | UI e captura de ações | N/A | Busca textual com botão limpar, chips de categoria conectados ao Controller, Hero animations, Empty States contextuais. |
| **Controller** (`lib/controller/`) | Estado reativo + Provider | Não | `PetController` com filtro cacheado (`_cachedFeedPets`), invalidação reativa por busca/categoria/CRUD. |
| **Service** (`lib/service/`) | Orquestração híbrida | ✅ `SyncService` | `SyncService` Singleton, Pull com proteção anti-sobrescrita, `PetService` com `deletePet` O(1), `LocationService` para GPS. |
| **Database/DAO** (`lib/database/`) | Persistência SQLite | ✅ Ambos DAOs | `PetDao` e `UserDao` Singleton com `getPetById()`. `DatabaseHelper` Singleton (schema v4, `user_id`). |
| **API** (`lib/api/`) | Comunicação Supabase | Não | `PetApi` e `AuthApi` com tracing completo (`debugPrint`). |

# 8. Funcionalidades Principais
- [x] Feed dinâmico com Pull-to-Refresh
- [x] Busca textual reativa (nome, raça, localização)
- [x] Filtro por categoria (Todos, Cachorros, Gatos, Outros)
- [x] Área "Meus Pets" com edição e exclusão isoladas por sessão
- [x] Geolocalização ativa (auto-preenchimento de Bairro, Cidade, Estado)
- [x] Hero animations nas transições de imagem
- [x] Empty States contextuais (busca sem resultado vs feed vazio)
- [x] Diagnóstico nativo com tracing em todas as APIs e no SyncService
- [x] Proteção de autoria em edições (injeção de `userId`)
- [x] Proteção anti-sobrescrita no Pull (respeita pendências locais)

# 9. Requisitos Funcionais
- [x] RF01 - Cadastro com e-mail válido.
- [x] RF02 - Login rejeitado offline com alerta amigável.
- [x] RF03 - Cadastrar pets e imagens sem internet.
- [x] RF04 - Editar dados de um pet sem perder autoria.
- [x] RF05 - Excluir pet com confirmação, reflexo imediato na UI.
- [x] RF06 - Feed carregado do SQLite no `initState` para latência zero.
- [x] RF07 - SyncService processa inserções, edições e exclusões pendentes.
- [x] RF08 - Preenchimento automático de localização via GPS.
- [x] RF09 - "Meus Pets" exibe apenas pets do usuário logado.
- [x] RF10 - Busca textual filtra o feed por nome, raça ou localização.
- [x] RF11 - Chips de categoria filtram o feed por tipo de animal.

# 10. Requisitos Não Funcionais
- **Responsividade**: UI thread nunca trava por uploads ou requisições de rede.
- **Portabilidade**: Android (Medium Phone, API Level 36).
- **Supabase**: Tabela `pets` com coluna `user_id`. Bucket `pet-images` público com Policy de `INSERT` habilitada.
- **Performance**: Singletons em DAOs e SyncService. Cache de filtragem no Controller. Imagens de rede com `cacheWidth: 600`.

# 11. Arquitetura Proposta
```text
lib/
├─ api/          # AuthApi, PetApi — com tracing de requisições
├─ controller/   # AuthController, PetController — cache reativo de filtros
├─ database/     # DatabaseHelper (Singleton, schema v4)
│                # PetDao (Singleton, getPetById)
│                # UserDao (Singleton)
├─ model/        # UserModel, PetModel (c/ userId)
├─ service/      # SyncService (Singleton, anti-sobrescrita no Pull)
│                # PetService (deletePet O(1), injeção de userId)
│                # UserService, LocationService
└─ view/         # HomeScreen (busca + filtro conectados)
                 # MyPetsScreen, EditPetScreen, NewPetScreen
                 # PetDetailsScreen, ProfileScreen
                 # Widgets: PetCard, MyPetCard (cacheWidth), HomeSearchBar, HomeCategories
```

# 12. Hardware Alvo
Smartphones Android (API Level 36 - Medium Phone), resolução 1080×2220+, suporte a conexões instáveis.

# 13. Métricas de Sucesso
- **Tempo de Inicialização**: < 200ms para exibição do feed.
- **Consistência**: 100% de precisão no Sync (texto + imagens).
- **Filtragem**: Resposta < 16ms (um frame) para qualquer combinação de busca + categoria.
- **Memória**: Imagens decodificadas limitadas a 600px de largura no cache.

# 14. Roadmap

### Concluído
- [x] **Fase 1 - 12**: Base UI, MVCS, edição Offline-First, Pull-to-Refresh, gerenciamento de deleção.
- [x] **Fase 13**: Filtragem de Sessão (`userId` em cada `PetModel`).
- [x] **Fase 14**: Geolocalização nativa, Hero animations, Empty States.
- [x] **Fase 14.1**: Tracing (`debugPrint`) em todas as APIs e SyncService.
- [x] **Fase 14.2**: Correção de perda de autoria em edições.
- [x] **Fase 15**: Busca textual reativa + Filtro por categoria na Home.
- [x] **Fase 16 (Auditoria de Performance)**: 7 correções aplicadas de 16 findings identificados:

| Finding | Severidade | Correção Aplicada |
|:---|:---:|:---|
| SyncService sem Singleton | 🔴 | Transformado em Singleton |
| Pull sobrescreve edições locais | 🔴 | Verificação de `syncStatus` antes de sobrescrever |
| `deletePet` carrega todos os pets | 🟡 | Criado `getPetById()` — O(1) |
| `feedPets` sem cache | 🟡 | `_cachedFeedPets` com invalidação reativa |
| DAOs sem Singleton | 🔵 | `PetDao` e `UserDao` → Singleton |
| Imagens sem `cacheWidth` | 🟡 | `cacheWidth: 600` em `Image.network` |
| `Connectivity()` instanciado repetidamente | 🟠 | Identificado (baixa prioridade) |

- [x] **Fase 17**: Migrar navegação de `pushReplacement` para `IndexedStack` (Finding 5.1 da Auditoria — preserva scroll e estado entre abas de forma instantânea).
- [x] **Fase 18**: Usar `Selector<PetController>` na HomeScreen para isolar rebuilds (Finding 2.1 da Auditoria — ganho drástico de performance na busca).

# 15. Riscos
- **Limpeza de Cache Físico**: Foto local deletada pelo OS antes do upload. Tratado via `try-catch` no SyncService.

# 16. Entrega Esperada
Aplicativo com CRUD offline-first completo, busca e filtro reativos, sincronização resiliente com proteção anti-sobrescrita, e camada de persistência otimizada com Singletons e cache de filtragem.

# 17. Critério de Avaliação
1. **Padrão MVCS estrito**: Respeitado integralmente — View nunca acessa API ou DB.
2. **Offline-First real**: CRUD completo e autônomo no SQLite.
3. **Resiliência do SyncService**: Singleton, anti-sobrescrita, tracing completo.
4. **Performance**: Cache de filtros, `getPetById` O(1), `cacheWidth` em imagens, DAOs Singleton.
5. **Busca & Filtro**: Combinação instantânea de texto + categoria com invalidação reativa.
