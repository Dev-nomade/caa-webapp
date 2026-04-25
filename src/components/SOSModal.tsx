import React, { useEffect, useRef } from 'react';
import styled, { keyframes } from 'styled-components';
import { sosOptions } from '../data/cards';
import { speechService } from '../services/speechService';

const fadeIn = keyframes`
  from { opacity: 0; }
  to { opacity: 1; }
`;

const slideUp = keyframes`
  from { transform: translateY(30px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
`;

const Overlay = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: ${fadeIn} 0.2s ease;
`;

const Modal = styled.div`
  background: white;
  border-radius: 24px;
  padding: 32px;
  max-width: 500px;
  width: 90%;
  animation: ${slideUp} 0.3s ease;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
`;

const Title = styled.h2`
  text-align: center;
  color: #C62828;
  font-size: 1.8rem;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
`;

const Subtitle = styled.p`
  text-align: center;
  color: #666;
  margin-bottom: 24px;
  font-size: 1rem;
`;

const OptionsGrid = styled.div`
  display: flex;
  flex-direction: column;
  gap: 12px;
`;

const OptionButton = styled.button`
  background: #FFEBEE;
  border: 3px solid #EF9A9A;
  border-radius: 16px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  font-size: 1.3rem;
  font-weight: 600;
  color: #C62828;
  transition: all 0.2s ease;
  width: 100%;

  &:hover {
    background: #FFCDD2;
    transform: scale(1.02);
  }

  &:focus-visible {
    outline: 4px solid #C62828;
    outline-offset: 3px;
  }
`;

const OptionEmoji = styled.span`
  font-size: 2.5rem;
`;

const OptionContent = styled.div`
  text-align: left;
`;

const OptionLabel = styled.div`
  font-weight: 700;
`;

const OptionDesc = styled.div`
  font-size: 0.9rem;
  color: #666;
  font-weight: 400;
`;

const CloseButton = styled.button`
  margin-top: 20px;
  width: 100%;
  padding: 16px;
  background: #E0E0E0;
  border-radius: 16px;
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  transition: all 0.2s ease;

  &:hover {
    background: #BDBDBD;
  }

  &:focus-visible {
    outline: 4px solid #1565C0;
    outline-offset: 3px;
  }
`;

const NotificationBanner = styled.div`
  margin-top: 16px;
  padding: 12px 16px;
  background: #FFF3E0;
  border: 2px solid #FFB74D;
  border-radius: 12px;
  text-align: center;
  font-weight: 600;
  color: #E65100;
  font-size: 0.95rem;
`;

interface SOSModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const SOSModal: React.FC<SOSModalProps> = ({ isOpen, onClose }) => {
  const [notification, setNotification] = React.useState<string | null>(null);
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen && modalRef.current) {
      modalRef.current.focus();
    }
  }, [isOpen]);

  useEffect(() => {
    if (!isOpen) return;

    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };
    window.addEventListener('keydown', handleEscape);
    return () => window.removeEventListener('keydown', handleEscape);
  }, [isOpen, onClose]);

  const handleOptionClick = (optionId: string, label: string, description: string) => {
    speechService.speak(description);
    speechService.playAlertSound();

    setNotification(
      `Alerta enviado ao cuidador: "${label}". Aguarde, a ajuda está a caminho.`
    );

    if ('Notification' in window && Notification.permission === 'granted') {
      new Notification('CognitIA Alerta - SOS', {
        body: `${label}: ${description}`,
        icon: '🚨',
      });
    } else if ('Notification' in window && Notification.permission !== 'denied') {
      Notification.requestPermission().then((permission) => {
        if (permission === 'granted') {
          new Notification('CognitIA Alerta - SOS', {
            body: `${label}: ${description}`,
          });
        }
      });
    }

    console.log(`[ALERTA SOS] ${optionId}: ${description} - ${new Date().toISOString()}`);
  };

  if (!isOpen) return null;

  return (
    <Overlay
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
      role="dialog"
      aria-modal="true"
      aria-label="SOS Emergência"
    >
      <Modal ref={modalRef} tabIndex={-1}>
        <Title>
          <span role="img" aria-hidden="true">🚨</span>
          SOS Emergência
        </Title>
        <Subtitle>O que está acontecendo? Toque para pedir ajuda.</Subtitle>

        <OptionsGrid>
          {sosOptions.map((option, index) => (
            <OptionButton
              key={option.id}
              onClick={() => handleOptionClick(option.id, option.label, option.description)}
              aria-label={`${option.label}: ${option.description}. Tecla F${index + 1}`}
            >
              <OptionEmoji role="img" aria-hidden="true">{option.emoji}</OptionEmoji>
              <OptionContent>
                <OptionLabel>{option.label}</OptionLabel>
                <OptionDesc>{option.description}</OptionDesc>
              </OptionContent>
            </OptionButton>
          ))}
        </OptionsGrid>

        {notification && <NotificationBanner role="alert">{notification}</NotificationBanner>}

        <CloseButton onClick={onClose} aria-label="Fechar menu de emergência">
          Fechar
        </CloseButton>
      </Modal>
    </Overlay>
  );
};

export default SOSModal;
