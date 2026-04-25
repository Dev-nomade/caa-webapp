# CognitIA - Augmentative and Alternative Communication

Accessible Web App focused on Augmentative and Alternative Communication (AAC) for people on the autism spectrum. Minimalist design with high contrast and low cognitive load.

## Features

### Dynamic Home
- **PECS Cards**: Cards with emoji + text categorized by color
  - Green: Biological needs (Eat, Drink, Bathe, Sleep, Bathroom)
  - Yellow: Feelings (Happy, Sad, Tired, Anxious, Calm, etc.)
  - Blue: Actions (Get Dressed, Go for a Walk, Play, Study, Listen to Music, Hug)
- **Text-to-Speech**: Clicking a card triggers voice output in English (Web Speech API)
- **Confirmation animation**: Visual feedback when selecting a card

### Fixed Buttons
Six quick-access buttons: Eat, Drink, Bathe, Get Dressed, Sleep, Go for a Walk

### AI Module (Simulated Logic)
- Tracks clicks and times using localStorage
- Displays suggestive banners based on usage patterns:
  - Meal suggestions at recurring times
  - Sleep suggestions at night
  - Bath suggestions in the afternoon

### SOS Emergency Button
- Pulsating red button fixed in the header
- Sub-options: Pain, Loud Noise, Fear
- Soft alert sound via Web Audio API
- Simulated notification to caregiver (Notification API)

### Resources Page
- Playlist with relaxing music (YouTube embeds)
- Caregiver tips based on behavior
- Keyboard shortcuts / physical buttons guide

### Physical Buttons Integration
- Keyboard key mapping to app functions:
  - `1-6`: Fixed buttons (Eat, Drink, Bathe, Get Dressed, Sleep, Go for a Walk)
  - `0`: SOS
  - `F1-F3`: Emergency options (Pain, Loud Noise, Fear)
- Keyboard event API for integration with external devices

## Technologies

- React 18 + TypeScript
- Styled Components
- React Router
- Web Speech API (Text-to-Speech)
- Web Audio API (sound alerts)
- Notification API (caregiver alerts)

## How to run

```bash
npm install
npm start
```

## Accessibility

- Atkinson Hyperlegible font (high legibility)
- High contrast with soft colors
- Large buttons with rounded borders
- Full keyboard navigation support
- ARIA attributes for screen readers
- Pastel background to reduce sensory overload
- `aria-live` regions for dynamic updates
