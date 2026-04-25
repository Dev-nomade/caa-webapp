export interface PECSCard {
  id: string;
  label: string;
  category: CardCategory;
  emoji: string;
  description: string;
  videoUrl?: string;
}

export type CardCategory = 'biological' | 'feelings' | 'actions' | 'emergency';

export interface ClickRecord {
  cardId: string;
  timestamp: number;
  hour: number;
}

export interface SOSOption {
  id: string;
  label: string;
  emoji: string;
  description: string;
}

export interface Suggestion {
  id: string;
  message: string;
  cardId: string;
  visible: boolean;
}

export interface CaregiverTip {
  id: string;
  title: string;
  content: string;
  category: string;
}

export interface MusicTrack {
  id: string;
  title: string;
  artist: string;
  embedUrl: string;
}
