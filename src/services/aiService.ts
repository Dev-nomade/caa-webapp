import { ClickRecord, Suggestion } from '../types';

const STORAGE_KEY = 'caa-click-history';

class AIService {
  private clickHistory: ClickRecord[] = [];

  constructor() {
    this.loadHistory();
  }

  private loadHistory(): void {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        this.clickHistory = JSON.parse(stored);
      }
    } catch {
      this.clickHistory = [];
    }
  }

  private saveHistory(): void {
    try {
      // Keep only last 7 days
      const sevenDaysAgo = Date.now() - 7 * 24 * 60 * 60 * 1000;
      this.clickHistory = this.clickHistory.filter((r) => r.timestamp > sevenDaysAgo);
      localStorage.setItem(STORAGE_KEY, JSON.stringify(this.clickHistory));
    } catch {
      // localStorage not available
    }
  }

  recordClick(cardId: string): void {
    const now = new Date();
    this.clickHistory.push({
      cardId,
      timestamp: now.getTime(),
      hour: now.getHours(),
    });
    this.saveHistory();
  }

  getSuggestions(): Suggestion[] {
    const suggestions: Suggestion[] = [];
    const currentHour = new Date().getHours();

    const mealSuggestions = this.checkMealPattern(currentHour);
    suggestions.push(...mealSuggestions);

    const sleepSuggestion = this.checkSleepPattern(currentHour);
    if (sleepSuggestion) suggestions.push(sleepSuggestion);

    const bathSuggestion = this.checkBathPattern(currentHour);
    if (bathSuggestion) suggestions.push(bathSuggestion);

    return suggestions;
  }

  private checkMealPattern(currentHour: number): Suggestion[] {
    const suggestions: Suggestion[] = [];

    const mealTimes = [
      { start: 6, end: 9, meal: 'café da manhã' },
      { start: 11, end: 13, meal: 'almoço' },
      { start: 14, end: 16, meal: 'lanche' },
      { start: 18, end: 20, meal: 'jantar' },
    ];

    for (const { start, end, meal } of mealTimes) {
      if (currentHour >= start && currentHour <= end) {
        const clicksInWindow = this.clickHistory.filter(
          (r) => r.cardId === 'comer' && r.hour >= start && r.hour <= end
        );

        if (clicksInWindow.length >= 2) {
          suggestions.push({
            id: `meal-${meal}`,
            message: `Está quase na hora de comer. Você quer ${meal}?`,
            cardId: 'comer',
            visible: true,
          });
        }
      }
    }

    return suggestions;
  }

  private checkSleepPattern(currentHour: number): Suggestion | null {
    if (currentHour >= 20 || currentHour <= 6) {
      const sleepClicks = this.clickHistory.filter(
        (r) => r.cardId === 'dormir' && (r.hour >= 20 || r.hour <= 6)
      );

      if (sleepClicks.length >= 2) {
        return {
          id: 'sleep-suggestion',
          message: 'Está ficando tarde. Você quer ir dormir?',
          cardId: 'dormir',
          visible: true,
        };
      }
    }
    return null;
  }

  private checkBathPattern(currentHour: number): Suggestion | null {
    if (currentHour >= 17 && currentHour <= 20) {
      const bathClicks = this.clickHistory.filter(
        (r) => r.cardId === 'banhar' && r.hour >= 17 && r.hour <= 20
      );

      if (bathClicks.length >= 2) {
        return {
          id: 'bath-suggestion',
          message: 'Está na hora do banho. Você quer tomar banho?',
          cardId: 'banhar',
          visible: true,
        };
      }
    }
    return null;
  }
}

export const aiService = new AIService();
