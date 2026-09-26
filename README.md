# The Fellows Run

App multiplataforma para organizar corridas de um grupo de corrida: criação de eventos, inscrições,
metas pessoais e distância percorrida por participante.

> **Projeto de estudo.** Feito para estudar Flutter numa avaliação da faculdade, sem desenvolvimento
> ativo. A demo e o APK ficam disponíveis só para demonstração. Para testar, o cadastro aceita dados
> fictícios (com um e-mail fictício não dá para recuperar a senha). Se você usar dados reais, eles
> ficam protegidos pelas regras de acesso do Firebase ([`firestore.rules`](firestore.rules)): e-mail e
> telefone só podem ser lidos pelo próprio usuário; nome e foto aparecem para quem está logado, nas
> corridas em que você se inscrever.

**Demo web:** https://the-fellows-run.web.app

**Android:** baixe o APK na [última release](https://github.com/markinkkkkj/the-fellows-run/releases/latest).

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

## Instalar no Android

1. Abra a [última release](https://github.com/markinkkkkj/the-fellows-run/releases/latest) no celular
   e baixe o arquivo `.apk`.
2. Permita a instalação de apps desta fonte quando o Android pedir.
3. Abra o arquivo baixado e instale.

O APK é compilado e assinado pelo GitHub Actions a cada tag `v*`; atualizações instalam por cima da
versão anterior.

## Como rodar

Pré-requisitos: Flutter SDK 3.x e um projeto Firebase configurado (`lib/firebase_options.dart`,
gerado pelo `flutterfire configure`).

```bash
flutter pub get
flutter run            # dispositivo ou emulador conectado
flutter run -d chrome  # versão web
```
