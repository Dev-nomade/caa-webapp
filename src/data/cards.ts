import { PECSCard, SOSOption, CaregiverTip, MusicTrack } from '../types';

export const pecsCards: PECSCard[] = [
  // Biological Needs (Green)
  {
    id: 'eat',
    label: 'Eat',
    category: 'biological',
    emoji: '🍽️',
    description: 'I want to eat',
    videoUrl: 'https://www.youtube.com/embed/KY-VXRqm2Pg',
  },
  {
    id: 'drink',
    label: 'Drink',
    category: 'biological',
    emoji: '🥤',
    description: 'I want to drink',
    videoUrl: 'https://www.youtube.com/embed/6upE2O4QINY',
  },
  {
    id: 'bathe',
    label: 'Bathe',
    category: 'biological',
    emoji: '🚿',
    description: 'I want to take a bath',
    videoUrl: 'https://www.youtube.com/embed/aueefWtXdpM',
  },
  {
    id: 'sleep',
    label: 'Sleep',
    category: 'biological',
    emoji: '😴',
    description: 'I want to sleep',
    videoUrl: 'https://www.youtube.com/embed/7xaCG3LbSCw',
  },
  {
    id: 'bathroom',
    label: 'Bathroom',
    category: 'biological',
    emoji: '🚽',
    description: 'I need to use the bathroom',
    videoUrl: 'https://www.youtube.com/embed/aueefWtXdpM',
  },
  // Feelings (Yellow)
  {
    id: 'happy',
    label: 'Happy',
    category: 'feelings',
    emoji: '😊',
    description: 'I am happy',
    videoUrl: 'https://www.youtube.com/embed/SLYx0Kv37Hs',
  },
  {
    id: 'sad',
    label: 'Sad',
    category: 'feelings',
    emoji: '😢',
    description: 'I am sad',
    videoUrl: 'https://www.youtube.com/embed/9l3jNTZ_qgU',
  },
  {
    id: 'tired',
    label: 'Tired',
    category: 'feelings',
    emoji: '😩',
    description: 'I am tired',
    videoUrl: 'https://www.youtube.com/embed/Z3MorRFqJWc',
  },
  {
    id: 'hungry',
    label: 'Hungry',
    category: 'feelings',
    emoji: '🤤',
    description: 'I am hungry',
    videoUrl: 'https://www.youtube.com/embed/G_p8uFBgxhM',
  },
  {
    id: 'thirsty',
    label: 'Thirsty',
    category: 'feelings',
    emoji: '💧',
    description: 'I am thirsty',
    videoUrl: 'https://www.youtube.com/embed/VWXu9H6WVk0',
  },
  {
    id: 'anxious',
    label: 'Anxious',
    category: 'feelings',
    emoji: '😰',
    description: 'I am anxious',
    videoUrl: 'https://www.youtube.com/embed/hlWiI4xVXKY',
  },
  {
    id: 'calm',
    label: 'Calm',
    category: 'feelings',
    emoji: '😌',
    description: 'I am calm',
    videoUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  // Actions (Blue)
  {
    id: 'dress',
    label: 'Get Dressed',
    category: 'actions',
    emoji: '👕',
    description: 'I want to get dressed',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
  {
    id: 'walk',
    label: 'Go for a Walk',
    category: 'actions',
    emoji: '🚶',
    description: 'I want to go for a walk',
    videoUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  {
    id: 'play',
    label: 'Play',
    category: 'actions',
    emoji: '🎮',
    description: 'I want to play',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
  {
    id: 'study',
    label: 'Study',
    category: 'actions',
    emoji: '📚',
    description: 'I want to study',
    videoUrl: 'https://www.youtube.com/embed/QkddAGUgASE',
  },
  {
    id: 'listen-music',
    label: 'Listen to Music',
    category: 'actions',
    emoji: '🎵',
    description: 'I want to listen to music',
    videoUrl: 'https://www.youtube.com/embed/77ZozI0rw7w',
  },
  {
    id: 'hug',
    label: 'Hug',
    category: 'actions',
    emoji: '🤗',
    description: 'I want a hug',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
];

export const sosOptions: SOSOption[] = [
  {
    id: 'pain',
    label: 'Pain',
    emoji: '🤕',
    description: 'I am in pain',
  },
  {
    id: 'loud-noise',
    label: 'Loud Noise',
    emoji: '🔊',
    description: 'The noise is bothering me',
  },
  {
    id: 'fear',
    label: 'Fear',
    emoji: '😨',
    description: 'I am scared',
  },
];

export const caregiverTips: CaregiverTip[] = [
  {
    id: '1',
    title: 'Consistent Routine',
    content:
      'Maintain a predictable daily routine. People on the autism spectrum benefit from knowing what to expect throughout the day. Use visual supports like calendars and schedules.',
    category: 'routine',
  },
  {
    id: '2',
    title: 'Sensory Environment',
    content:
      'Reduce excessive sensory stimuli. Keep lights soft, minimize noise, and provide calm spaces. Observe which stimuli bother the person the most.',
    category: 'sensory',
  },
  {
    id: '3',
    title: 'Visual Communication',
    content:
      'Use visual supports (PECS, images, symbols) to complement verbal communication. Give the person time to process information before repeating or rephrasing.',
    category: 'communication',
  },
  {
    id: '4',
    title: 'Smooth Transitions',
    content:
      'Give advance notice about activity changes. Use visual timers and countdowns to help transition between activities.',
    category: 'routine',
  },
  {
    id: '5',
    title: 'Positive Reinforcement',
    content:
      'Celebrate achievements and positive behaviors. Use specific and concrete praise. Avoid vague language like "good job" — prefer "You put your toys away, great job!".',
    category: 'behavior',
  },
  {
    id: '6',
    title: 'Signs of Overload',
    content:
      'Learn to identify signs of sensory overload: covering ears, rocking, avoiding eye contact. Offer a calm space when you notice these signs.',
    category: 'sensory',
  },
  {
    id: '7',
    title: 'Feeding',
    content:
      'Respect food preferences and introduce new foods gradually. Many autistic people have sensory sensitivities to textures and flavors.',
    category: 'feeding',
  },
  {
    id: '8',
    title: 'Bedtime',
    content:
      'Create a relaxing and consistent bedtime routine. Reduce visual and auditory stimuli before sleep. Consider using soft nightlights and weighted blankets.',
    category: 'routine',
  },
];

export const musicTracks: MusicTrack[] = [
  {
    id: '1',
    title: 'Relaxing Music for Children',
    artist: 'Nature Sounds',
    embedUrl: 'https://www.youtube.com/embed/hlWiI4xVXKY',
  },
  {
    id: '2',
    title: 'Calm Children\'s Songs',
    artist: 'Lullabies',
    embedUrl: 'https://www.youtube.com/embed/77ZozI0rw7w',
  },
  {
    id: '3',
    title: 'Nature Sounds - Birds',
    artist: 'Nature',
    embedUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  {
    id: '4',
    title: 'Classical Music to Relax',
    artist: 'Classics',
    embedUrl: 'https://www.youtube.com/embed/HMnrl0tmd3k',
  },
];

export const categoryColors: Record<string, { bg: string; border: string; text: string }> = {
  biological: { bg: '#C8E6C9', border: '#4CAF50', text: '#2E7D32' },
  feelings: { bg: '#FFF9C4', border: '#FFC107', text: '#F57F17' },
  actions: { bg: '#BBDEFB', border: '#2196F3', text: '#1565C0' },
  emergency: { bg: '#FFCDD2', border: '#F44336', text: '#C62828' },
};
