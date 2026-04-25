import React, { useState, useEffect, useCallback } from 'react';
import styled from 'styled-components';
import PECSCardComponent from '../components/PECSCardComponent';
import SuggestionBanner from '../components/SuggestionBanner';
import VideoPlayerModal from '../components/VideoPlayerModal';
import { pecsCards } from '../data/cards';
import { PECSCard, Suggestion } from '../types';
import { aiService } from '../services/aiService';
import { keyboardService } from '../services/keyboardService';
import { speechService } from '../services/speechService';

const PageContainer = styled.main`
  padding: 16px 24px 40px;
  max-width: 1200px;
  margin: 0 auto;
`;

const SectionTitle = styled.h2<{ $color: string }>`
  font-size: 1.4rem;
  font-weight: 700;
  color: ${(props) => props.$color};
  margin: 24px 0 12px;
  padding-left: 4px;
  display: flex;
  align-items: center;
  gap: 8px;
`;

const SectionIcon = styled.span`
  font-size: 1.5rem;
`;

const FixedButtonsSection = styled.section`
  margin-bottom: 16px;
`;

const FixedButtonsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
`;

const CardsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
`;

const LastSelectedBanner = styled.div`
  background: linear-gradient(135deg, #E3F2FD, #BBDEFB);
  border: 2px solid #64B5F6;
  border-radius: 16px;
  padding: 16px 24px;
  margin-bottom: 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 1.1rem;
  color: #1565C0;
  font-weight: 600;
`;

const KeyboardHint = styled.div`
  background: #F5F5F5;
  border: 1px solid #E0E0E0;
  border-radius: 12px;
  padding: 12px 20px;
  margin-bottom: 16px;
  font-size: 0.85rem;
  color: #666;
  text-align: center;
`;

const fixedButtonIds = ['eat', 'drink', 'bathe', 'dress', 'sleep', 'walk'];
const keyHints: Record<string, string> = {
  eat: '1',
  drink: '2',
  bathe: '3',
  dress: '4',
  sleep: '5',
  walk: '6',
};

interface HomePageProps {
  onSOSOpen: () => void;
}

const HomePage: React.FC<HomePageProps> = ({ onSOSOpen }) => {
  const [lastSelected, setLastSelected] = useState<PECSCard | null>(null);
  const [suggestions, setSuggestions] = useState<Suggestion[]>([]);
  const [videoCard, setVideoCard] = useState<PECSCard | null>(null);

  const handleCardSelect = useCallback((card: PECSCard) => {
    setLastSelected(card);
    if (card.videoUrl) {
      setVideoCard(card);
    }
    const newSuggestions = aiService.getSuggestions();
    setSuggestions(newSuggestions);
  }, []);

  const handleDismiss = useCallback((id: string) => {
    setSuggestions((prev) =>
      prev.map((s) => (s.id === id ? { ...s, visible: false } : s))
    );
  }, []);

  useEffect(() => {
    const initialSuggestions = aiService.getSuggestions();
    setSuggestions(initialSuggestions);
  }, []);

  useEffect(() => {
    keyboardService.register((cardId: string) => {
      if (cardId === 'sos') {
        onSOSOpen();
        return;
      }

      const card = pecsCards.find((c) => c.id === cardId);
      if (card) {
        speechService.speak(card.description);
        aiService.recordClick(card.id);
        handleCardSelect(card);
      }
    });

    return () => keyboardService.unregister();
  }, [onSOSOpen, handleCardSelect]);

  const fixedCards = pecsCards.filter((c) => fixedButtonIds.includes(c.id));
  const feelingsCards = pecsCards.filter((c) => c.category === 'feelings');
  const actionsCards = pecsCards.filter(
    (c) => c.category === 'actions' && !fixedButtonIds.includes(c.id)
  );
  const biologicalCards = pecsCards.filter(
    (c) => c.category === 'biological' && !fixedButtonIds.includes(c.id)
  );

  return (
    <PageContainer>
      <SuggestionBanner suggestions={suggestions} onDismiss={handleDismiss} />

      {lastSelected && (
        <LastSelectedBanner role="status" aria-live="polite">
          <span role="img" aria-hidden="true" style={{ fontSize: '2rem' }}>
            {lastSelected.emoji}
          </span>
          {lastSelected.description}
        </LastSelectedBanner>
      )}

      <KeyboardHint>
        Use as teclas 1-6 para ações rápidas, 0 para SOS, F1-F3 para opções de emergência
      </KeyboardHint>

      <FixedButtonsSection aria-label="Botões Fixos - Ações Rápidas">
        <SectionTitle $color="#2E7D32">
          <SectionIcon role="img" aria-hidden="true">⭐</SectionIcon>
          Ações Rápidas
        </SectionTitle>
        <FixedButtonsGrid>
          {fixedCards.map((card) => (
            <PECSCardComponent
              key={card.id}
              card={card}
              keyHint={keyHints[card.id]}
              onSelect={handleCardSelect}
            />
          ))}
        </FixedButtonsGrid>
      </FixedButtonsSection>

      <section aria-label="Sentimentos">
        <SectionTitle $color="#F57F17">
          <SectionIcon role="img" aria-hidden="true">💛</SectionIcon>
          Sentimentos
        </SectionTitle>
        <CardsGrid>
          {feelingsCards.map((card) => (
            <PECSCardComponent
              key={card.id}
              card={card}
              onSelect={handleCardSelect}
            />
          ))}
        </CardsGrid>
      </section>

      {biologicalCards.length > 0 && (
        <section aria-label="Necessidades">
          <SectionTitle $color="#2E7D32">
            <SectionIcon role="img" aria-hidden="true">💚</SectionIcon>
            Necessidades
          </SectionTitle>
          <CardsGrid>
            {biologicalCards.map((card) => (
              <PECSCardComponent
                key={card.id}
                card={card}
                onSelect={handleCardSelect}
              />
            ))}
          </CardsGrid>
        </section>
      )}

      <section aria-label="Atividades">
        <SectionTitle $color="#1565C0">
          <SectionIcon role="img" aria-hidden="true">💙</SectionIcon>
          Atividades
        </SectionTitle>
        <CardsGrid>
          {actionsCards.map((card) => (
            <PECSCardComponent
              key={card.id}
              card={card}
              onSelect={handleCardSelect}
            />
          ))}
        </CardsGrid>
      </section>
      <VideoPlayerModal card={videoCard} onClose={() => setVideoCard(null)} />
    </PageContainer>
  );
};

export default HomePage;
