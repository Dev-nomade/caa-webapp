import React from 'react';
import styled, { keyframes } from 'styled-components';
import { Suggestion } from '../types';

const slideDown = keyframes`
  from { transform: translateY(-20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
`;

const BannerContainer = styled.div`
  background: linear-gradient(135deg, #E8F5E9, #C8E6C9);
  border: 2px solid #66BB6A;
  border-radius: 16px;
  padding: 16px 24px;
  margin: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  animation: ${slideDown} 0.4s ease;
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.2);
`;

const BannerContent = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const BannerIcon = styled.span`
  font-size: 2rem;
`;

const BannerText = styled.p`
  font-size: 1.1rem;
  font-weight: 600;
  color: #2E7D32;
`;

const DismissButton = styled.button`
  background: #66BB6A;
  color: white;
  border-radius: 12px;
  padding: 10px 20px;
  font-weight: 600;
  font-size: 0.95rem;
  transition: all 0.2s ease;
  white-space: nowrap;

  &:hover {
    background: #4CAF50;
  }

  &:focus-visible {
    outline: 3px solid #2E7D32;
    outline-offset: 2px;
  }
`;

interface SuggestionBannerProps {
  suggestions: Suggestion[];
  onDismiss: (id: string) => void;
}

const SuggestionBanner: React.FC<SuggestionBannerProps> = ({ suggestions, onDismiss }) => {
  const visibleSuggestions = suggestions.filter((s) => s.visible);

  if (visibleSuggestions.length === 0) return null;

  return (
    <>
      {visibleSuggestions.map((suggestion) => (
        <BannerContainer key={suggestion.id} role="alert" aria-live="polite">
          <BannerContent>
            <BannerIcon role="img" aria-hidden="true">💡</BannerIcon>
            <BannerText>{suggestion.message}</BannerText>
          </BannerContent>
          <DismissButton
            onClick={() => onDismiss(suggestion.id)}
            aria-label={`Dismiss suggestion: ${suggestion.message}`}
          >
            Got it
          </DismissButton>
        </BannerContainer>
      ))}
    </>
  );
};

export default SuggestionBanner;
