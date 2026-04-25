import React from 'react';
import styled, { keyframes } from 'styled-components';
import { Link, useLocation } from 'react-router-dom';

const pulse = keyframes`
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
`;

const HeaderContainer = styled.header`
  background: linear-gradient(135deg, #1565C0, #1976D2);
  color: white;
  padding: 12px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  position: sticky;
  top: 0;
  z-index: 100;
`;

const Logo = styled(Link)`
  font-size: 1.5rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10px;
  color: white;
  text-decoration: none;

  &:focus-visible {
    outline: 3px solid white;
    outline-offset: 4px;
    border-radius: 4px;
  }
`;

const LogoEmoji = styled.span`
  font-size: 2rem;
`;

const Nav = styled.nav`
  display: flex;
  align-items: center;
  gap: 8px;
`;

const NavLink = styled(Link)<{ $active: boolean }>`
  padding: 10px 20px;
  border-radius: 25px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.2s ease;
  background: ${(props) => (props.$active ? 'rgba(255,255,255,0.25)' : 'transparent')};
  color: white;
  text-decoration: none;

  &:hover {
    background: rgba(255, 255, 255, 0.2);
  }

  &:focus-visible {
    outline: 3px solid white;
    outline-offset: 2px;
  }
`;

const SOSButton = styled.button`
  background: #D32F2F;
  color: white;
  border: 3px solid #B71C1C;
  border-radius: 50%;
  width: 60px;
  height: 60px;
  font-size: 1rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: ${pulse} 2s ease-in-out infinite;
  box-shadow: 0 4px 12px rgba(211, 47, 47, 0.4);
  transition: all 0.2s ease;

  &:hover {
    background: #B71C1C;
    transform: scale(1.1);
  }

  &:focus-visible {
    outline: 4px solid white;
    outline-offset: 4px;
  }
`;

interface HeaderProps {
  onSOSClick: () => void;
}

const Header: React.FC<HeaderProps> = ({ onSOSClick }) => {
  const location = useLocation();

  return (
    <HeaderContainer role="banner">
      <Logo to="/" aria-label="CAA Comunicar - Página inicial">
        <LogoEmoji role="img" aria-hidden="true">💬</LogoEmoji>
        CAA Comunicar
      </Logo>
      <Nav role="navigation" aria-label="Navegação principal">
        <NavLink to="/" $active={location.pathname === '/'}>
          Início
        </NavLink>
        <NavLink to="/recursos" $active={location.pathname === '/recursos'}>
          Recursos
        </NavLink>
        <SOSButton
          onClick={onSOSClick}
          aria-label="Botão de emergência SOS"
          title="Emergência SOS (Tecla 0)"
        >
          SOS
        </SOSButton>
      </Nav>
    </HeaderContainer>
  );
};

export default Header;
