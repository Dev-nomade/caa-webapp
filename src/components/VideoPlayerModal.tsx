import React, { useEffect, useRef } from 'react';
import styled, { keyframes } from 'styled-components';
import { PECSCard } from '../types';
import { categoryColors } from '../data/cards';

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
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: ${fadeIn} 0.2s ease;
  padding: 16px;
`;

const Modal = styled.div<{ $category: string }>`
  background: white;
  border-radius: 24px;
  max-width: 700px;
  width: 100%;
  animation: ${slideUp} 0.3s ease;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  border: 4px solid ${(props) => categoryColors[props.$category]?.border || '#1565C0'};
`;

const ModalHeader = styled.div<{ $category: string }>`
  background: ${(props) => categoryColors[props.$category]?.bg || '#E3F2FD'};
  padding: 16px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const CardInfo = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const CardEmoji = styled.span`
  font-size: 2.5rem;
`;

const CardLabel = styled.span<{ $category: string }>`
  font-size: 1.4rem;
  font-weight: 700;
  color: ${(props) => categoryColors[props.$category]?.text || '#333'};
`;

const CloseButton = styled.button`
  background: rgba(0, 0, 0, 0.1);
  border-radius: 50%;
  width: 44px;
  height: 44px;
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  color: #333;

  &:hover {
    background: rgba(0, 0, 0, 0.2);
  }

  &:focus-visible {
    outline: 3px solid #1565C0;
    outline-offset: 2px;
  }
`;

const VideoContainer = styled.div`
  position: relative;
  width: 100%;
  padding-bottom: 56.25%;
  background: #000;
`;

const VideoIframe = styled.iframe`
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: none;
`;

const Description = styled.div<{ $category: string }>`
  padding: 16px 24px;
  font-size: 1.2rem;
  font-weight: 600;
  color: ${(props) => categoryColors[props.$category]?.text || '#333'};
  text-align: center;
  background: ${(props) => categoryColors[props.$category]?.bg || '#E3F2FD'};
`;

interface VideoPlayerModalProps {
  card: PECSCard | null;
  onClose: () => void;
}

const VideoPlayerModal: React.FC<VideoPlayerModalProps> = ({ card, onClose }) => {
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (card && modalRef.current) {
      modalRef.current.focus();
    }
  }, [card]);

  useEffect(() => {
    if (!card) return;

    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
      }
    };
    window.addEventListener('keydown', handleEscape);
    return () => window.removeEventListener('keydown', handleEscape);
  }, [card, onClose]);

  if (!card || !card.videoUrl) return null;

  const videoSrc = `${card.videoUrl}?autoplay=1&rel=0&modestbranding=1`;

  return (
    <Overlay
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
      role="dialog"
      aria-modal="true"
      aria-label={`Video: ${card.label}`}
    >
      <Modal ref={modalRef} tabIndex={-1} $category={card.category}>
        <ModalHeader $category={card.category}>
          <CardInfo>
            <CardEmoji role="img" aria-hidden="true">{card.emoji}</CardEmoji>
            <CardLabel $category={card.category}>{card.label}</CardLabel>
          </CardInfo>
          <CloseButton
            onClick={onClose}
            aria-label="Close video"
          >
            X
          </CloseButton>
        </ModalHeader>
        <VideoContainer>
          <VideoIframe
            src={videoSrc}
            title={`Video about ${card.label}`}
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
          />
        </VideoContainer>
        <Description $category={card.category}>
          {card.description}
        </Description>
      </Modal>
    </Overlay>
  );
};

export default VideoPlayerModal;
