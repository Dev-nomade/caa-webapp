import { PECSCard, SOSOption, CaregiverTip, MusicTrack } from '../types';

export const pecsCards: PECSCard[] = [
  // Necessidades Biológicas (Verde)
  {
    id: 'eat',
    label: 'Comer',
    category: 'biological',
    emoji: '🍽️',
    description: 'Eu quero comer',
    videoUrl: 'https://www.youtube.com/embed/KY-VXRqm2Pg',
  },
  {
    id: 'drink',
    label: 'Beber',
    category: 'biological',
    emoji: '🥤',
    description: 'Eu quero beber',
    videoUrl: 'https://www.youtube.com/embed/6upE2O4QINY',
  },
  {
    id: 'bathe',
    label: 'Banhar',
    category: 'biological',
    emoji: '🚿',
    description: 'Eu quero tomar banho',
    videoUrl: 'https://www.youtube.com/embed/aueefWtXdpM',
  },
  {
    id: 'sleep',
    label: 'Dormir',
    category: 'biological',
    emoji: '😴',
    description: 'Eu quero dormir',
    videoUrl: 'https://www.youtube.com/embed/7xaCG3LbSCw',
  },
  {
    id: 'bathroom',
    label: 'Banheiro',
    category: 'biological',
    emoji: '🚽',
    description: 'Eu preciso ir ao banheiro',
    videoUrl: 'https://www.youtube.com/embed/aueefWtXdpM',
  },
  // Sentimentos (Amarelo)
  {
    id: 'happy',
    label: 'Feliz',
    category: 'feelings',
    emoji: '😊',
    description: 'Eu estou feliz',
    videoUrl: 'https://www.youtube.com/embed/SLYx0Kv37Hs',
  },
  {
    id: 'sad',
    label: 'Triste',
    category: 'feelings',
    emoji: '😢',
    description: 'Eu estou triste',
    videoUrl: 'https://www.youtube.com/embed/9l3jNTZ_qgU',
  },
  {
    id: 'tired',
    label: 'Cansado',
    category: 'feelings',
    emoji: '😩',
    description: 'Eu estou cansado',
    videoUrl: 'https://www.youtube.com/embed/Z3MorRFqJWc',
  },
  {
    id: 'hungry',
    label: 'Com Fome',
    category: 'feelings',
    emoji: '🤤',
    description: 'Eu estou com fome',
    videoUrl: 'https://www.youtube.com/embed/G_p8uFBgxhM',
  },
  {
    id: 'thirsty',
    label: 'Com Sede',
    category: 'feelings',
    emoji: '💧',
    description: 'Eu estou com sede',
    videoUrl: 'https://www.youtube.com/embed/VWXu9H6WVk0',
  },
  {
    id: 'anxious',
    label: 'Ansioso',
    category: 'feelings',
    emoji: '😰',
    description: 'Eu estou ansioso',
    videoUrl: 'https://www.youtube.com/embed/hlWiI4xVXKY',
  },
  {
    id: 'calm',
    label: 'Calmo',
    category: 'feelings',
    emoji: '😌',
    description: 'Eu estou calmo',
    videoUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  // Ações (Azul)
  {
    id: 'dress',
    label: 'Vestir',
    category: 'actions',
    emoji: '👕',
    description: 'Eu quero me vestir',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
  {
    id: 'walk',
    label: 'Passear',
    category: 'actions',
    emoji: '🚶',
    description: 'Eu quero passear',
    videoUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  {
    id: 'play',
    label: 'Brincar',
    category: 'actions',
    emoji: '🎮',
    description: 'Eu quero brincar',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
  {
    id: 'study',
    label: 'Estudar',
    category: 'actions',
    emoji: '📚',
    description: 'Eu quero estudar',
    videoUrl: 'https://www.youtube.com/embed/QkddAGUgASE',
  },
  {
    id: 'listen-music',
    label: 'Ouvir Música',
    category: 'actions',
    emoji: '🎵',
    description: 'Eu quero ouvir música',
    videoUrl: 'https://www.youtube.com/embed/77ZozI0rw7w',
  },
  {
    id: 'hug',
    label: 'Abraçar',
    category: 'actions',
    emoji: '🤗',
    description: 'Eu quero um abraço',
    videoUrl: 'https://www.youtube.com/embed/gSEu2od18PQ',
  },
];

export const sosOptions: SOSOption[] = [
  {
    id: 'pain',
    label: 'Dor',
    emoji: '🤕',
    description: 'Eu estou com dor',
  },
  {
    id: 'loud-noise',
    label: 'Barulho Alto',
    emoji: '🔊',
    description: 'O barulho está me incomodando',
  },
  {
    id: 'fear',
    label: 'Medo',
    emoji: '😨',
    description: 'Eu estou com medo',
  },
];

export const caregiverTips: CaregiverTip[] = [
  {
    id: '1',
    title: 'Rotina Consistente',
    content:
      'Mantenha uma rotina diária previsível. Pessoas no espectro autista se beneficiam de saber o que esperar ao longo do dia. Use suportes visuais como calendários e agendas.',
    category: 'rotina',
  },
  {
    id: '2',
    title: 'Ambiente Sensorial',
    content:
      'Reduza estímulos sensoriais excessivos. Mantenha luzes suaves, minimize ruídos e ofereça espaços calmos. Observe quais estímulos mais incomodam a pessoa.',
    category: 'sensorial',
  },
  {
    id: '3',
    title: 'Comunicação Visual',
    content:
      'Use suportes visuais (PECS, imagens, símbolos) para complementar a comunicação verbal. Dê tempo para a pessoa processar a informação antes de repetir ou reformular.',
    category: 'comunicação',
  },
  {
    id: '4',
    title: 'Transições Suaves',
    content:
      'Avise com antecedência sobre mudanças de atividade. Use temporizadores visuais e contagens regressivas para ajudar na transição entre atividades.',
    category: 'rotina',
  },
  {
    id: '5',
    title: 'Reforço Positivo',
    content:
      'Celebre conquistas e comportamentos positivos. Use elogios específicos e concretos. Evite linguagem vaga como "bom trabalho" — prefira "Você guardou seus brinquedos, muito bem!".',
    category: 'comportamento',
  },
  {
    id: '6',
    title: 'Sinais de Sobrecarga',
    content:
      'Aprenda a identificar sinais de sobrecarga sensorial: cobrir os ouvidos, balançar-se, evitar contato visual. Ofereça um espaço calmo quando notar esses sinais.',
    category: 'sensorial',
  },
  {
    id: '7',
    title: 'Alimentação',
    content:
      'Respeite as preferências alimentares e introduza novos alimentos gradualmente. Muitas pessoas autistas têm sensibilidades sensoriais a texturas e sabores.',
    category: 'alimentação',
  },
  {
    id: '8',
    title: 'Hora de Dormir',
    content:
      'Crie uma rotina relaxante e consistente para a hora de dormir. Reduza estímulos visuais e sonoros antes do sono. Considere usar luzes noturnas suaves e cobertores de peso.',
    category: 'rotina',
  },
];

export const musicTracks: MusicTrack[] = [
  {
    id: '1',
    title: 'Música Relaxante para Crianças',
    artist: 'Sons da Natureza',
    embedUrl: 'https://www.youtube.com/embed/hlWiI4xVXKY',
  },
  {
    id: '2',
    title: 'Canções Infantis Calmas',
    artist: 'Canções de Ninar',
    embedUrl: 'https://www.youtube.com/embed/77ZozI0rw7w',
  },
  {
    id: '3',
    title: 'Sons da Natureza - Pássaros',
    artist: 'Natureza',
    embedUrl: 'https://www.youtube.com/embed/rYoZgpAEkFs',
  },
  {
    id: '4',
    title: 'Música Clássica para Relaxar',
    artist: 'Clássicos',
    embedUrl: 'https://www.youtube.com/embed/HMnrl0tmd3k',
  },
];

export const categoryColors: Record<string, { bg: string; border: string; text: string }> = {
  biological: { bg: '#C8E6C9', border: '#4CAF50', text: '#2E7D32' },
  feelings: { bg: '#FFF9C4', border: '#FFC107', text: '#F57F17' },
  actions: { bg: '#BBDEFB', border: '#2196F3', text: '#1565C0' },
  emergency: { bg: '#FFCDD2', border: '#F44336', text: '#C62828' },
};
