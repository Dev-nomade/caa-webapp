import React, { useState } from 'react';
import styled, { keyframes } from 'styled-components';
import { useNavigate, Link } from 'react-router-dom';
import { login } from '../services/authService';

const fadeIn = keyframes`
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
`;

const PageContainer = styled.div`
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #E3F2FD 0%, #F0F4F8 50%, #E8F5E9 100%);
  padding: 24px;
`;

const Card = styled.div`
  background: white;
  border-radius: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  padding: 40px;
  width: 100%;
  max-width: 440px;
  animation: ${fadeIn} 0.5s ease-out;
`;

const LogoSection = styled.div`
  text-align: center;
  margin-bottom: 36px;
`;

const LogoEmoji = styled.span`
  font-size: 3.5rem;
  display: block;
  margin-bottom: 8px;
`;

const LogoText = styled.h1`
  font-size: 2.2rem;
  color: #1565C0;
  font-weight: 700;
`;

const Subtitle = styled.p`
  color: #546E7A;
  font-size: 0.95rem;
  margin-top: 4px;
`;

const Form = styled.form`
  display: flex;
  flex-direction: column;
  gap: 18px;
`;

const Label = styled.label`
  font-weight: 600;
  font-size: 0.9rem;
  color: #37474F;
  display: flex;
  flex-direction: column;
  gap: 6px;
`;

const Input = styled.input`
  padding: 14px 16px;
  border: 2px solid #CFD8DC;
  border-radius: 12px;
  font-size: 1rem;
  font-family: inherit;
  transition: border-color 0.2s;

  &:focus {
    outline: none;
    border-color: #1565C0;
    box-shadow: 0 0 0 3px rgba(21, 101, 192, 0.15);
  }

  &::placeholder {
    color: #90A4AE;
  }
`;

const SubmitButton = styled.button`
  background: linear-gradient(135deg, #1565C0, #1976D2);
  color: white;
  border: none;
  border-radius: 12px;
  padding: 16px;
  font-size: 1.1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 4px;

  &:hover {
    background: linear-gradient(135deg, #0D47A1, #1565C0);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(21, 101, 192, 0.3);
  }

  &:active {
    transform: translateY(0);
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
  }
`;

const Message = styled.p<{ $error?: boolean }>`
  text-align: center;
  padding: 12px;
  border-radius: 10px;
  font-weight: 600;
  font-size: 0.9rem;
  background: ${(props) => (props.$error ? '#FFEBEE' : '#E8F5E9')};
  color: ${(props) => (props.$error ? '#C62828' : '#2E7D32')};
`;

const ForgotLink = styled(Link)`
  color: #1565C0;
  font-size: 0.9rem;
  text-align: right;
  text-decoration: none;
  font-weight: 500;

  &:hover {
    text-decoration: underline;
  }
`;

const FooterLinks = styled.div`
  text-align: center;
  margin-top: 24px;
  font-size: 0.9rem;
  color: #546E7A;
`;

const StyledLink = styled(Link)`
  color: #1565C0;
  font-weight: 600;
  text-decoration: none;

  &:hover {
    text-decoration: underline;
  }
`;

interface LoginPageProps {
  onLogin: () => void;
}

const LoginPage: React.FC<LoginPageProps> = ({ onLogin }) => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState<{ text: string; error: boolean } | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null);
    setLoading(true);

    setTimeout(() => {
      const result = login(email, password);
      setLoading(false);

      if (result.success) {
        setMessage({ text: result.message, error: false });
        setTimeout(() => {
          onLogin();
          navigate('/');
        }, 800);
      } else {
        setMessage({ text: result.message, error: true });
      }
    }, 500);
  };

  return (
    <PageContainer>
      <Card>
        <LogoSection>
          <LogoEmoji role="img" aria-label="Brain">🧠</LogoEmoji>
          <LogoText>CognitIA</LogoText>
          <Subtitle>Augmentative and Alternative Communication</Subtitle>
        </LogoSection>

        {message && <Message $error={message.error}>{message.text}</Message>}

        <Form onSubmit={handleSubmit}>
          <Label>
            Email
            <Input
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
            />
          </Label>

          <Label>
            Password
            <Input
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              autoComplete="current-password"
            />
          </Label>

          <ForgotLink to="/forgot-password">Forgot password?</ForgotLink>

          <SubmitButton type="submit" disabled={loading}>
            {loading ? 'Signing in...' : 'Sign in'}
          </SubmitButton>
        </Form>

        <FooterLinks>
          Don't have an account? <StyledLink to="/register">Sign up</StyledLink>
        </FooterLinks>
      </Card>
    </PageContainer>
  );
};

export default LoginPage;
