import React, { useState, useCallback } from 'react';
import styled, { keyframes, css } from 'styled-components';
import { PECSCard } from '../types';
import { categoryColors } from '../data/cards';
import { speechService } from '../services/speechService';
import { aiService } from '../services/aiService';

const popIn = keyframes`
  0% { transform: scale(1); }
  30% { transform: scale(0.92); }
  60% { transform: scale(1.08); }
  100% { transform: scale(1); }
`;

const ripple = keyframes`
  0% {
    transform: scale(0);
    opacity: 0.6;
  }
  100% {
    transform: scale(4);
    opacity: 0;
  }
`;

const checkmark = keyframes`
  0% { opacity: 0; transform: scale(0) rotate(-45deg); }
  50% { opacity: 1; transform: scale(1.2) rotate(0deg); }
  100% { opacity: 0; transform: scale(1) rotate(0deg); }
`;

const CardWrapper = styled.button<{ $category: string; $isActive: boolean }>`
  position: relative;
  overflow: hidden;
  background: ${(props) => categoryColors[props.$category]?.bg || '#E0E0E0'};
  border: 3px solid ${(props) => categoryColors[props.$category]?.border || '#9E9E9E'};
  border-radius: 20px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 160px;
  transition: all 0.2s ease;
  cursor: pointer;
  width: 100%;

  ${(props) =>
    props.$isActive &&
    css`
      animation: ${popIn} 0.5s ease;
    `}

  &:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
  }

  &:active {
    transform: translateY(0);
  }

  &:focus-visible {
    outline: 4px solid ${(props) => categoryColors[props.$category]?.border || '#1565C0'};
    outline-offset: 3px;
  }
`;

const RippleEffect = styled.span`
  position: absolute;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  background: rgba(255, 255, 255, 0.6);
  animation: ${ripple} 0.6s ease-out;
  pointer-events: none;
`;

const CheckOverlay = styled.div`
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: none;
  animation: ${checkmark} 1s ease;
`;

const CheckIcon = styled.span`
  font-size: 3rem;
`;

const Emoji = styled.span`
  font-size: 3.5rem;
  line-height: 1;
`;

const Label = styled.span<{ $category: string }>`
  font-size: 1.2rem;
  font-weight: 700;
  color: ${(props) => categoryColors[props.$category]?.text || '#333'};
  text-align: center;
`;

const KeyHint = styled.span`
  position: absolute;
  top: 8px;
  right: 12px;
  font-size: 0.7rem;
  color: #666;
  background: rgba(255, 255, 255, 0.7);
  padding: 2px 8px;
  border-radius: 10px;
`;

interface PECSCardComponentProps {
  card: PECSCard;
  keyHint?: string;
  onSelect?: (card: PECSCard) => void;
}

const PECSCardComponent: React.FC<PECSCardComponentProps> = ({ card, keyHint, onSelect }) => {
  const [isActive, setIsActive] = useState(false);
  const [showCheck, setShowCheck] = useState(false);
  const [ripplePos, setRipplePos] = useState<{ x: number; y: number } | null>(null);

  const handleClick = useCallback(
    (e: React.MouseEvent<HTMLButtonElement>) => {
      const rect = e.currentTarget.getBoundingClientRect();
      setRipplePos({
        x: e.clientX - rect.left - 20,
        y: e.clientY - rect.top - 20,
      });

      setIsActive(true);
      setShowCheck(true);

      speechService.speak(card.description);
      aiService.recordClick(card.id);

      if (onSelect) {
        onSelect(card);
      }

      setTimeout(() => setIsActive(false), 500);
      setTimeout(() => {
        setShowCheck(false);
        setRipplePos(null);
      }, 1000);
    },
    [card, onSelect]
  );

  return (
    <CardWrapper
      $category={card.category}
      $isActive={isActive}
      onClick={handleClick}
      aria-label={`${card.label}: ${card.description}`}
      role="button"
      tabIndex={0}
    >
      {keyHint && <KeyHint aria-hidden="true">Key {keyHint}</KeyHint>}
      {ripplePos && (
        <RippleEffect style={{ left: ripplePos.x, top: ripplePos.y }} />
      )}
      {showCheck && (
        <CheckOverlay>
          <CheckIcon role="img" aria-label="Selected">✓</CheckIcon>
        </CheckOverlay>
      )}
      <Emoji role="img" aria-hidden="true">
        {card.emoji}
      </Emoji>
      <Label $category={card.category}>{card.label}</Label>
    </CardWrapper>
  );
};

export default PECSCardComponent;
