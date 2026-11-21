# CognitIA

App gratuito e offline de **Comunicação Aumentativa e Alternativa (CAA)** para crianças autistas não verbais e suas famílias.

- `app/` — **CognitIA v2** em Flutter/Dart (Android). Sem conta, sem internet, dados só no aparelho.
- `legacy-web/` — versão antiga em React, mantida como referência.

## Recursos (v2)
- **Modo Criança**: cartões PECS grandes por cor (verde necessidades, amarelo sentimentos, azul ações), voz em português do Brasil.
- **Barra de frase**: toque em vários cartões e ouça a frase.
- **SOS**: Dor, Barulho alto e Medo, com vibração e fala.
- **Área do cuidador** (PIN, padrão 1234): ocultar cartões, alto contraste, tamanho da grade, relatório de uso de 7 dias.
- **Rotina visual**: passos do dia em sequência, passo atual em destaque, marcar como feito (recomeça todo dia); o cuidador monta e reordena.
- **Sugestões locais** por horário e hábito (sem IA remota).

## Como rodar
```bash
cd app
flutter pub get
flutter test
flutter run
```

## Gerar APK para distribuir
```bash
cd app
flutter build apk --release
# arquivo: build/app/outputs/flutter-apk/app-release.apk
```

## Próximos passos
Cartões com foto e voz do familiar, pictogramas ARASAAC (verificar licença), assinatura do APK e página de download.
