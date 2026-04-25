import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { GlobalStyles } from './styles/GlobalStyles';
import Header from './components/Header';
import SOSModal from './components/SOSModal';
import HomePage from './pages/HomePage';
import ResourcesPage from './pages/ResourcesPage';

const App: React.FC = () => {
  const [sosOpen, setSOSOpen] = useState(false);

  return (
    <Router>
      <GlobalStyles />
      <div aria-label="CognitIA - Comunicação Alternativa e Aumentativa">
        <Header onSOSClick={() => setSOSOpen(true)} />
        <SOSModal isOpen={sosOpen} onClose={() => setSOSOpen(false)} />
        <Routes>
          <Route path="/" element={<HomePage onSOSOpen={() => setSOSOpen(true)} />} />
          <Route path="/recursos" element={<ResourcesPage />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
