type KeyHandler = (cardId: string) => void;

const KEY_MAP: Record<string, string> = {
  '1': 'eat',
  '2': 'drink',
  '3': 'bathe',
  '4': 'dress',
  '5': 'sleep',
  '6': 'walk',
  '0': 'sos',
  F1: 'pain',
  F2: 'loud-noise',
  F3: 'fear',
};

class KeyboardService {
  private handler: KeyHandler | null = null;
  private boundListener: ((e: KeyboardEvent) => void) | null = null;

  register(handler: KeyHandler): void {
    this.handler = handler;

    this.boundListener = (e: KeyboardEvent) => {
      const cardId = KEY_MAP[e.key];
      if (cardId && this.handler) {
        e.preventDefault();
        this.handler(cardId);
      }
    };

    window.addEventListener('keydown', this.boundListener);
  }

  unregister(): void {
    if (this.boundListener) {
      window.removeEventListener('keydown', this.boundListener);
      this.boundListener = null;
    }
    this.handler = null;
  }

  getKeyMap(): Record<string, string> {
    return { ...KEY_MAP };
  }
}

export const keyboardService = new KeyboardService();
