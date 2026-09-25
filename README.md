# The Fellows Run

App multiplataforma para organizar corridas de um grupo de corrida: criação de eventos, inscrições,
metas pessoais e distância percorrida por participante.

**Demo web:** https://the-fellows-run.web.app

## Funcionalidades

- **Conta:** cadastro e login com e-mail e senha (Firebase Auth), edição de perfil e troca de senha.
- **Foto de perfil:** tirada na hora com a câmera ou escolhida da galeria, salva no Firebase Storage
  e mantida em cache no dispositivo.
- **Corridas:** lista das próximas corridas com status e detalhes de local, data e prazo de inscrição.
- **Inscrição com meta:** o participante se inscreve e define a própria meta em km.
- **Administração:** usuários com papel de admin criam, editam e excluem corridas e registram a
  distância que cada participante percorreu.
- **Histórico:** corridas passadas com a distância percorrida por participante.

## Stack

| Camada | Tecnologia |
|---|---|
| App | Flutter (Dart), Android, iOS e web |
| Autenticação | Firebase Auth |
| Dados | Cloud Firestore |
| Arquivos | Firebase Storage |
| Hospedagem web | Firebase Hosting |

## Estrutura

```
lib/
  models/     # AppUser, Run, Registration
  services/   # repositórios do Firestore e cache de usuários
  screens/    # uma pasta por tela (home, run_details, add_run, manage_run, edit_profile, settings)
  widgets/    # componentes compartilhados (cards, campos, badges)
  theme/      # cores e tema do app
```

## Como rodar

Pré-requisitos: Flutter SDK 3.x e um projeto Firebase configurado (`lib/firebase_options.dart`,
gerado pelo `flutterfire configure`).

```bash
flutter pub get
flutter run            # dispositivo ou emulador conectado
flutter run -d chrome  # versão web
```
