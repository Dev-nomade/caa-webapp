import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { GlobalStyles } from './styles/GlobalStyles';
import Header from './components/Header';
import SOSModal from './components/SOSModal';
import HomePage from './pages/HomePage';
import ResourcesPage from './pages/ResourcesPage';
import LoginPage from './pages/LoginPage';
import CadastroPage from './pages/CadastroPage';
import EsqueceuSenhaPage from './pages/EsqueceuSenhaPage';
import { getLoggedUser, logout } from './services/authService';

const App: React.FC = () => {
  const [sosOpen, setSOSOpen] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const user = getLoggedUser();
    setIsAuthenticated(!!user);
  }, []);

  const handleLogin = () => {
    setIsAuthenticated(true);
  };

  const handleLogout = () => {
    logout();
    setIsAuthenticated(false);
  };

  return (
    <Router>
      <GlobalStyles />
      <div aria-label="CognitIA - Comunicação Alternativa e Aumentativa">
        {isAuthenticated ? (
          <>
            <Header onSOSClick={() => setSOSOpen(true)} onLogout={handleLogout} />
            <SOSModal isOpen={sosOpen} onClose={() => setSOSOpen(false)} />
            <Routes>
              <Route path="/" element={<HomePage onSOSOpen={() => setSOSOpen(true)} />} />
              <Route path="/resources" element={<ResourcesPage />} />
              <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
          </>
        ) : (
          <Routes>
            <Route path="/login" element={<LoginPage onLogin={handleLogin} />} />
            <Route path="/register" element={<CadastroPage />} />
            <Route path="/forgot-password" element={<EsqueceuSenhaPage />} />
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        )}
      </div>
    </Router>
  );
};

export default App;
