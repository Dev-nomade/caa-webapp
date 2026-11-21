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
      { start: 6, end: 9, meal: 'breakfast' },
      { start: 11, end: 13, meal: 'lunch' },
      { start: 14, end: 16, meal: 'snack' },
      { start: 18, end: 20, meal: 'dinner' },
    ];

    for (const { start, end, meal } of mealTimes) {
      if (currentHour >= start && currentHour <= end) {
        const clicksInWindow = this.clickHistory.filter(
          (r) => r.cardId === 'eat' && r.hour >= start && r.hour <= end
        );

        if (clicksInWindow.length >= 2) {
          suggestions.push({
            id: `meal-${meal}`,
            message: `It's almost time to eat. Would you like ${meal}?`,
            cardId: 'eat',
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
        (r) => r.cardId === 'sleep' && (r.hour >= 20 || r.hour <= 6)
      );

      if (sleepClicks.length >= 2) {
        return {
          id: 'sleep-suggestion',
          message: 'It\'s getting late. Would you like to go to sleep?',
          cardId: 'sleep',
          visible: true,
        };
      }
    }
    return null;
  }

  private checkBathPattern(currentHour: number): Suggestion | null {
    if (currentHour >= 17 && currentHour <= 20) {
      const bathClicks = this.clickHistory.filter(
        (r) => r.cardId === 'bathe' && r.hour >= 17 && r.hour <= 20
      );

      if (bathClicks.length >= 2) {
        return {
          id: 'bath-suggestion',
          message: 'It\'s bath time. Would you like to take a bath?',
          cardId: 'bathe',
          visible: true,
        };
      }
    }
    return null;
  }
}

export const aiService = new AIService();
