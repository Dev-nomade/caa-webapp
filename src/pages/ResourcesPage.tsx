import React, { useState } from 'react';
import styled from 'styled-components';
import { caregiverTips, musicTracks } from '../data/cards';

const PageContainer = styled.main`
  padding: 16px 24px 40px;
  max-width: 1200px;
  margin: 0 auto;
`;

const PageTitle = styled.h1`
  font-size: 1.8rem;
  font-weight: 700;
  color: #1565C0;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
`;

const PageSubtitle = styled.p`
  color: #666;
  font-size: 1rem;
  margin-bottom: 24px;
`;

const TabContainer = styled.div`
  display: flex;
  gap: 8px;
  margin-bottom: 24px;
`;

const Tab = styled.button<{ $active: boolean }>`
  padding: 12px 24px;
  border-radius: 25px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.2s ease;
  background: ${(props) => (props.$active ? '#1565C0' : '#E3F2FD')};
  color: ${(props) => (props.$active ? 'white' : '#1565C0')};

  &:hover {
    background: ${(props) => (props.$active ? '#1565C0' : '#BBDEFB')};
  }

  &:focus-visible {
    outline: 4px solid #1565C0;
    outline-offset: 2px;
  }
`;

const SectionTitle = styled.h2`
  font-size: 1.4rem;
  font-weight: 700;
  color: #333;
  margin: 20px 0 16px;
  display: flex;
  align-items: center;
  gap: 8px;
`;

const SectionIcon = styled.span`
  font-size: 1.5rem;
`;

/* Music Section */
const MusicGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
`;

const MusicCard = styled.div`
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border: 2px solid #E3F2FD;
`;

const MusicEmbed = styled.div`
  position: relative;
  width: 100%;
  padding-top: 56.25%;

  iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: none;
  }
`;

const MusicInfo = styled.div`
  padding: 16px;
`;

const MusicTitle = styled.h3`
  font-size: 1.1rem;
  font-weight: 700;
  color: #333;
  margin-bottom: 4px;
`;

const MusicArtist = styled.p`
  font-size: 0.9rem;
  color: #666;
`;

/* Tips Section */
const TipsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 20px;
`;

const TipCard = styled.article`
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  border-left: 5px solid #66BB6A;
  transition: all 0.2s ease;

  &:hover {
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
    transform: translateY(-2px);
  }
`;

const TipTitle = styled.h3`
  font-size: 1.15rem;
  font-weight: 700;
  color: #2E7D32;
  margin-bottom: 8px;
`;

const TipContent = styled.p`
  font-size: 1rem;
  color: #444;
  line-height: 1.7;
`;

const TipCategory = styled.span`
  display: inline-block;
  background: #E8F5E9;
  color: #2E7D32;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 600;
  margin-top: 12px;
`;

const KeyboardSection = styled.section`
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  margin-top: 24px;
  border: 2px solid #E3F2FD;
`;

const KeyTable = styled.table`
  width: 100%;
  border-collapse: separate;
  border-spacing: 0 8px;
`;

const KeyRow = styled.tr`
  &:hover td {
    background: #F5F5F5;
  }
`;

const KeyCell = styled.td`
  padding: 10px 16px;
  font-size: 1rem;
  border-radius: 8px;
`;

const KeyBadge = styled.kbd`
  background: #E3F2FD;
  border: 2px solid #90CAF9;
  border-radius: 8px;
  padding: 4px 12px;
  font-family: inherit;
  font-weight: 700;
  font-size: 0.95rem;
  color: #1565C0;
`;

const ResourcesPage: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'music' | 'tips' | 'keyboard'>('music');

  return (
    <PageContainer>
      <PageTitle>
        <span role="img" aria-hidden="true">📚</span>
        Recursos
      </PageTitle>
      <PageSubtitle>Músicas relaxantes, dicas para cuidadores e atalhos do teclado.</PageSubtitle>

      <TabContainer role="tablist" aria-label="Seções de recursos">
        <Tab
          role="tab"
          aria-selected={activeTab === 'music'}
          $active={activeTab === 'music'}
          onClick={() => setActiveTab('music')}
        >
          🎵 Músicas
        </Tab>
        <Tab
          role="tab"
          aria-selected={activeTab === 'tips'}
          $active={activeTab === 'tips'}
          onClick={() => setActiveTab('tips')}
        >
          💡 Dicas
        </Tab>
        <Tab
          role="tab"
          aria-selected={activeTab === 'keyboard'}
          $active={activeTab === 'keyboard'}
          onClick={() => setActiveTab('keyboard')}
        >
          ⌨️ Atalhos
        </Tab>
      </TabContainer>

      {activeTab === 'music' && (
        <section aria-label="Lista de reprodução">
          <SectionTitle>
            <SectionIcon role="img" aria-hidden="true">🎵</SectionIcon>
            Lista de Reprodução Relaxante
          </SectionTitle>
          <MusicGrid>
            {musicTracks.map((track) => (
              <MusicCard key={track.id}>
                <MusicEmbed>
                  <iframe
                    src={track.embedUrl}
                    title={track.title}
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowFullScreen
                  />
                </MusicEmbed>
                <MusicInfo>
                  <MusicTitle>{track.title}</MusicTitle>
                  <MusicArtist>{track.artist}</MusicArtist>
                </MusicInfo>
              </MusicCard>
            ))}
          </MusicGrid>
        </section>
      )}

      {activeTab === 'tips' && (
        <section aria-label="Dicas para o cuidador">
          <SectionTitle>
            <SectionIcon role="img" aria-hidden="true">💡</SectionIcon>
            Dicas para o Cuidador
          </SectionTitle>
          <TipsGrid>
            {caregiverTips.map((tip) => (
              <TipCard key={tip.id}>
                <TipTitle>{tip.title}</TipTitle>
                <TipContent>{tip.content}</TipContent>
                <TipCategory>{tip.category}</TipCategory>
              </TipCard>
            ))}
          </TipsGrid>
        </section>
      )}

      {activeTab === 'keyboard' && (
        <KeyboardSection aria-label="Atalhos de teclado e botões físicos">
          <SectionTitle>
            <SectionIcon role="img" aria-hidden="true">⌨️</SectionIcon>
            Atalhos de Teclado / Botões Físicos
          </SectionTitle>
          <p style={{ marginBottom: 16, color: '#666' }}>
            Use estas teclas do teclado ou conecte botões físicos via API de entrada
            para acionar as mesmas funções do app.
          </p>
          <KeyTable>
            <thead>
              <tr>
                <KeyCell as="th" style={{ fontWeight: 700, color: '#333' }}>
                  Tecla
                </KeyCell>
                <KeyCell as="th" style={{ fontWeight: 700, color: '#333' }}>
                  Ação
                </KeyCell>
              </tr>
            </thead>
            <tbody>
              <KeyRow>
                <KeyCell><KeyBadge>1</KeyBadge></KeyCell>
                <KeyCell>🍽️ Comer</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>2</KeyBadge></KeyCell>
                <KeyCell>🥤 Beber</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>3</KeyBadge></KeyCell>
                <KeyCell>🚿 Banhar</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>4</KeyBadge></KeyCell>
                <KeyCell>👕 Vestir</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>5</KeyBadge></KeyCell>
                <KeyCell>😴 Dormir</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>6</KeyBadge></KeyCell>
                <KeyCell>🚶 Passear</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>0</KeyBadge></KeyCell>
                <KeyCell>🚨 SOS (Emergência)</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>F1</KeyBadge></KeyCell>
                <KeyCell>🤕 Dor</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>F2</KeyBadge></KeyCell>
                <KeyCell>🔊 Barulho Alto</KeyCell>
              </KeyRow>
              <KeyRow>
                <KeyCell><KeyBadge>F3</KeyBadge></KeyCell>
                <KeyCell>😨 Medo</KeyCell>
              </KeyRow>
            </tbody>
          </KeyTable>

          <div style={{ marginTop: 24, padding: 16, background: '#FFF3E0', borderRadius: 12, border: '2px solid #FFB74D' }}>
            <h3 style={{ color: '#E65100', marginBottom: 8, fontSize: '1.1rem' }}>
              🔌 API de Botões Físicos
            </h3>
            <p style={{ color: '#666', fontSize: '0.95rem', lineHeight: 1.7 }}>
              Para integrar botões físicos, envie eventos de teclado simulados via a API
              <code style={{ background: '#FFECB3', padding: '2px 6px', borderRadius: 4, margin: '0 4px' }}>
                KeyboardEvent
              </code>
              do navegador. Exemplo:
            </p>
            <pre style={{ background: '#263238', color: '#ECEFF1', padding: 16, borderRadius: 8, marginTop: 12, fontSize: '0.85rem', overflowX: 'auto' }}>
{`// Simular pressionamento da tecla "1" (Comer)
window.dispatchEvent(
  new KeyboardEvent('keydown', { key: '1' })
);

// Simular SOS
window.dispatchEvent(
  new KeyboardEvent('keydown', { key: '0' })
);`}
            </pre>
          </div>
        </KeyboardSection>
      )}
    </PageContainer>
  );
};

export default ResourcesPage;
