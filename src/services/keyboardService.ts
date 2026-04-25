type KeyHandler = (cardId: string) => void;

const KEY_MAP: Record<string, string> = {
  '1': 'comer',
  '2': 'beber',
  '3': 'banhar',
  '4': 'vestir',
  '5': 'dormir',
  '6': 'passear',
  '0': 'sos',
  F1: 'dor',
  F2: 'barulho',
  F3: 'medo',
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
