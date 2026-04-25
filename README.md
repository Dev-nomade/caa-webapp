# CognitIA - Comunicação Alternativa e Aumentativa

Web App acessível focado em Comunicação Alternativa e Aumentativa (CAA) para pessoas no espectro autista. Design minimalista, de alto contraste e com baixa carga cognitiva.

## Funcionalidades

### Home Dinâmica
- **Cards PECS**: Cards com emoji + texto categorizados por cores
  - Verde: Necessidades biológicas (Comer, Beber, Banhar, Dormir, Banheiro)
  - Amarelo: Sentimentos (Feliz, Triste, Cansado, Ansioso, Calmo, etc.)
  - Azul: Ações (Vestir, Passear, Brincar, Estudar, Ouvir Música, Abraçar)
- **Text-to-Speech**: Ao clicar em um card, o sistema emite voz em português (Web Speech API)
- **Animação de confirmação**: Feedback visual ao selecionar um card

### Botões Fixos
Seis botões de acesso rápido: Comer, Beber, Banhar, Vestir, Dormir, Passear

### Módulo de IA (Lógica Simulada)
- Rastreia cliques e horários usando localStorage
- Exibe banners sugestivos baseados em padrões de uso:
  - Sugestões de refeições em horários recorrentes
  - Sugestões de sono à noite
  - Sugestões de banho à tarde

### Botão de Emergência SOS
- Botão vermelho pulsante fixo no cabeçalho
- Sub-opções: Dor, Barulho Alto, Medo
- Alerta sonoro suave via Web Audio API
- Notificação simulada para o cuidador (Notification API)

### Página de Recursos
- Lista de reprodução com músicas relaxantes (YouTube embeds)
- Dicas para o cuidador baseadas em comportamento
- Guia de atalhos de teclado / botões físicos

### Integração com Botões Físicos
- Mapeamento de teclas do teclado para funções do app:
  - `1-6`: Botões fixos (Comer, Beber, Banhar, Vestir, Dormir, Passear)
  - `0`: SOS
  - `F1-F3`: Opções de emergência (Dor, Barulho Alto, Medo)
- API de eventos do teclado para integração com dispositivos externos

## Tecnologias

- React 18 + TypeScript
- Styled Components
- React Router
- Web Speech API (Text-to-Speech)
- Web Audio API (alertas sonoros)
- Notification API (alertas ao cuidador)

## Como executar

```bash
npm install
npm start
```

## Acessibilidade

- Fonte Atkinson Hyperlegible (alta legibilidade)
- Alto contraste com cores suaves
- Botões grandes com bordas arredondadas
- Suporte completo a navegação por teclado
- Atributos ARIA para leitores de tela
- Fundo pastel para reduzir sobrecarga sensorial
- `aria-live` regions para atualizações dinâmicas
