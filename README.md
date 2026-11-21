# CognitIA

App gratuito e offline de **Comunicação Aumentativa e Alternativa (CAA)** para crianças autistas não verbais e suas famílias.

- `app/` — **CognitIA v2** em Flutter/Dart (Android). Sem conta, sem internet, dados só no aparelho.
- `legacy-web/` — versão antiga em React, mantida como referência.

## Recursos (v2)
- **Modo Criança**: cartões PECS grandes por cor (verde necessidades, amarelo sentimentos, azul ações), voz em português do Brasil.
- **SOS**: Dor, Barulho alto e Medo, com vibração e fala.
- **Área do cuidador** (PIN, padrão 1234): ocultar cartões, alto contraste, tamanho da grade, relatório de uso de 7 dias.
- **Rotina visual**: passos do dia em sequência, passo atual em destaque, marcar como feito (recomeça todo dia); o cuidador monta e reordena.
- **Cartões da família**: o cuidador cria cartões com foto (câmera ou galeria) e voz gravada de alguém conhecido; tudo fica só no aparelho (foto e voz funcionam no Android).


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

## Ver o app online e baixar o APK (GitHub Actions)
- **Versão web (GitHub Pages):** ative em *Settings → Pages → Source: GitHub Actions*. O workflow `web-pages.yml` publica em `https://<usuario>.github.io/caa-webapp/` a cada push na `main`, ou manualmente em *Actions → Publicar versão web → Run workflow*.
- **APK Android:** o workflow `android-apk.yml` roda a cada push (na `main` e em `claude/**`). Baixe em *Actions → execução → Artifacts → cognitia-apk*. Para uma página de download pública, crie uma tag: `git tag v0.1.0 && git push origin v0.1.0` e o APK aparece em *Releases*.
- O APK é assinado com chave de depuração (serve para testar e instalar). Para Play Store seria preciso uma chave própria.

## Próximos passos
Pictogramas ARASAAC (verificar licença), assinatura do APK e página de download.
