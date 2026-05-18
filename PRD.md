# PRD 

Documento de Requisitos de Produto (PRD)

Versão: 2.0 (Atualização de Arquitetura e Contexto)

# 1. Visão Geral do Produto

## Nome do Produto
EncontraPet

## Resumo Executivo
EncontraPet é um aplicativo móvel Flutter que ajuda donos de pets a reencontrarem animais perdidos. O frontend (telas, navegação, componentes) foi concluído utilizando Material Design 3 e tipografia Roboto. Atualmente, o projeto passa por uma mudança arquitetural para adotar o padrão **MVCS (Model-View-Controller-Service)** focado em uma estratégia **Offline-First**. O app utilizará **SQLite** como banco de dados local (cache) e **Supabase** como backend em nuvem (sincronização). A interface já está 100% pronta e documentada, aguardando a refatoração para conectar o fluxo de dados real.

# 2. Problema de Negócio
Donos de pets perdem tempo procurando animais desaparecidos; falta uma plataforma centralizada, visualmente agradável, confiável e que, fundamentalmente, **funcione em áreas com baixa ou nenhuma conectividade** no momento do resgate ou busca.

# 3. Objetivo do Produto
Facilitar o cadastro, gerenciamento e localização de pets perdidos através de um app premium, que permita ao usuário salvar informações instantaneamente (cache local) e sincronize com a rede global de forma transparente assim que houver internet (Supabase).

# 4. Público-Alvo

## Primário
Donos de animais domésticos (cães, gatos) que utilizam smartphones Android.

## Secundário
Voluntários, ONGs e protetores de animais atuando muitas vezes em áreas remotas.

# 5. Proposta de Valor

## Benefícios principais
- **Funcionalidade Offline-First:** Interação sem atrasos na rede, salvando e lendo primeiro do SQLite.
- **Arquitetura Desacoplada:** Código altamente mantível baseado em MVCS (Model, View, Controller, Service).
- **Interface Premium:** Consistência com Material Design 3, navegação fluida e sem warnings no lint.

# 6. Justificativa Tecnológica
- **Flutter:** UI rica e multiplataforma.
- **MVCS:** Separação rígida de responsabilidades; a View nunca acessa o banco e o Controller não faz queries SQL.
- **SQLite:** Permite leitura imediata e cache confiável no aparelho.
- **Supabase:** Backend robusto e moderno para sincronização em nuvem e storage de imagens.

# 7. Benchmark de Modelos no 
| Componente / Ferramenta | Responsabilidade (No Projeto) | Restrições e Observações |
|-------------------------|--------------------------------|--------------------------|
| **View** (`lib/view/`) | UI e captura de eventos | **NUNCA** acessa Service, API ou DB. Apenas Controller. |
| **Controller** (`lib/controller/`) | Regra de negócio e estado | Usa ChangeNotifier/Provider. **NUNCA** faz queries diretas. |
| **Service** (`lib/service/`) | Orquestração de dados | Decide entre SQLite e Supabase. Sincroniza em background. |
| **SQLite** (`lib/database/`) | Persistência local (Cache) | **PROIBIDO** arquivos binários. Salva apenas strings/URLs. |
| **Supabase** (`lib/api/`) | Banco em Nuvem e Storage | Sincronizado pelo Service quando houver rede. |

# 8. Funcionalidades Principais
- Autenticação (Login/Signup)
- Feed principal de pets desaparecidos/encontrados
- Perfil do usuário e configurações
- Biblioteca pessoal "Meus Pets"
- Formulários de Cadastro e Edição de pets (com upload de fotos local/remoto)
- Diálogo de confirmação para remoção
- Tela rica de detalhes do pet
- Navegação integrada (BottomBar + FAB)

# 9. Requisitos Funcionais
- [x] Telas de UI (Login, Signup, Feed, Perfil, Meus Pets, Cadastro, Edição, Detalhes)
- [x] Fluxo de navegação (Navigator/Rotas)
- [x] Linter configurado e código sem warnings (0 issues)
- [ ] Definição e Mapeamento de Entidades (`lib/model/`)
- [ ] Configuração do SQLite Local (`lib/database/`)
- [ ] Configuração do Cliente Supabase (`lib/api/`)
- [ ] Implementação da Lógica de Persistência Híbrida (`lib/service/`)
- [ ] Vinculação das Views com Controllers Reais (`lib/controller/`)

# 10. Requisitos Não Funcionais
- **Performance:** UI fluida (60fps); a leitura inicial de dados sempre deve vir do SQLite para carregar imediatamente.
- **Segurança da Arquitetura:** O fluxo de dados é estrito: `Usuário -> View -> Controller -> Service -> DB/API`.
- **Armazenamento:** Mídias não vão pro SQLite; imagens capturadas offline ficam nos arquivos do SO e o caminho é guardado no DB até o upload para o Supabase Storage.

# 11. Arquitetura Proposta
A estrutura do projeto está migrando para:
```text
lib/
├─ model/       # Entidades puras e serializadores (fromJson/toJson).
├─ view/        # Widgets, telas, formulários e listagens (UI limpa).
├─ controller/  # Gerenciamento de estado, validações de negócio e Provider.
├─ service/     # Centralização de dados e sincronização (SQLite <-> Supabase).
├─ database/    # Helpers e inicialização do SQLite.
└─ api/         # Clientes HTTP / Supabase.
```

# 12. Hardware Alvo
Android smartphones (API 36 – Medium Phone) com resolução mínima 1080×2220. Suporte total a uso offline intermitente.

# 13. Métricas de Sucesso
| Métrica | Meta |
|---------|------|
| Tempos de Load em telas de Feed | Imediato (via cache local) |
| Engajamento (pets cadastrados/mês) | ≥ 50 |
| Taxa de Sucesso em Sincronização | ≥ 98% dos dados locais sobem para nuvem |
| Crashes e Lint Warnings | 0 |

# 14. Roadmap
- [x] Fase 1 – Telas Base e Navegação Frontend (Concluído)
- [x] Fase 2 – Material Design 3 e padronização (Concluído)
- [x] Fase 3 – Arquitetura Definida: MVCS com Offline-First (Concluído, Contexto atual)
- [x] Fase 4 – Reestruturação de pastas (`model`, `view`, `controller`, etc.)
- [x] Fase 5 – Implementação do SQLite (Tabelas e Database Helper)
- [x] Fase 6 – Configuração do Supabase (Autenticação e API)
- [ ] Fase 7 – Serviços de Sincronização (Service Layer)
- [ ] Fase 8 – Refatoração do estado (Controller + View)

# 15. Riscos
- Sincronização e conflito de dados entre instâncias concorrentes.
- Gerenciamento adequado do armazenamento de imagens no cache do aparelho.
- Transição da atual estrutura de pastas (`views/`, `core/`, `widgets/`) para o padrão estrito MVCS.

# 16. Entrega Esperada
Aplicativo robusto com layout finalizado, conectado a uma malha de dados offline-first eficiente que não trava a interface e mantém o estado sincronizado em segundo plano, respeitando 100% as diretrizes da arquitetura MVCS.

# 17. Critério de Avaliação
1. Conformidade com a restrição: `View -> Controller -> Service -> Bancos`.
2. Zero consultas diretas ao banco na View ou no Controller.
3. As pastas e estrutura espelham rigorosamente os domínios `model/`, `view/`, `controller/`, `service/`, `database/`, e `api/`.
4. Sem arquivos blob salvos no banco SQLite.
5. `flutter analyze` sem erros.
