import React, { useState } from 'react';
import styled, { keyframes } from 'styled-components';
import { useNavigate, Link } from 'react-router-dom';
import { register } from '../services/authService';

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
  max-width: 480px;
  animation: ${fadeIn} 0.5s ease-out;
`;

const LogoSection = styled.div`
  text-align: center;
  margin-bottom: 32px;
`;

const LogoEmoji = styled.span`
  font-size: 3rem;
  display: block;
  margin-bottom: 8px;
`;

const LogoText = styled.h1`
  font-size: 2rem;
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
  gap: 16px;
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
  margin-top: 8px;

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

const FooterLinks = styled.div`
  text-align: center;
  margin-top: 20px;
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

const RegisterPage: React.FC = () => {
  const navigate = useNavigate();
  const [guardianName, setGuardianName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [dependentName, setDependentName] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [message, setMessage] = useState<{ text: string; error: boolean } | null>(null);
  const [loading, setLoading] = useState(false);

  const formatPhone = (value: string): string => {
    const digits = value.replace(/\D/g, '').slice(0, 11);
    if (digits.length <= 2) return digits;
    if (digits.length <= 7) return `(${digits.slice(0, 2)}) ${digits.slice(2)}`;
    return `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null);

    if (password.length < 6) {
      setMessage({ text: 'Password must be at least 6 characters.', error: true });
      return;
    }

    if (password !== confirmPassword) {
      setMessage({ text: 'Passwords do not match.', error: true });
      return;
    }

    setLoading(true);

    setTimeout(() => {
      const result = register(guardianName, email, phone, dependentName, password);
      setMessage({ text: result.message, error: !result.success });
      setLoading(false);

      if (result.success) {
        setTimeout(() => navigate('/login'), 1500);
      }
    }, 500);
  };

  return (
    <PageContainer>
      <Card>
        <LogoSection>
          <LogoEmoji role="img" aria-label="Brain">🧠</LogoEmoji>
          <LogoText>CognitIA</LogoText>
          <Subtitle>Create your account</Subtitle>
        </LogoSection>

        {message && <Message $error={message.error}>{message.text}</Message>}

        <Form onSubmit={handleSubmit}>
          <Label>
            Guardian's full name
            <Input
              type="text"
              placeholder="e.g. Jane Smith"
              value={guardianName}
              onChange={(e) => setGuardianName(e.target.value)}
              required
              autoComplete="name"
            />
          </Label>

          <Label>
            Guardian's email
            <Input
              type="email"
              placeholder="e.g. jane@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
            />
          </Label>

          <Label>
            Guardian's phone
            <Input
              type="tel"
              placeholder="(00) 00000-0000"
              value={phone}
              onChange={(e) => setPhone(formatPhone(e.target.value))}
              required
              autoComplete="tel"
            />
          </Label>

          <Label>
            Full name of child / adult
            <Input
              type="text"
              placeholder="e.g. John Smith"
              value={dependentName}
              onChange={(e) => setDependentName(e.target.value)}
              required
            />
          </Label>

          <Label>
            Password
            <Input
              type="password"
              placeholder="Minimum 6 characters"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              minLength={6}
              autoComplete="new-password"
            />
          </Label>

          <Label>
            Confirm password
            <Input
              type="password"
              placeholder="Repeat your password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              required
              autoComplete="new-password"
            />
          </Label>

          <SubmitButton type="submit" disabled={loading}>
            {loading ? 'Registering...' : 'Register'}
          </SubmitButton>
        </Form>

        <FooterLinks>
          Already have an account? <StyledLink to="/login">Sign in</StyledLink>
        </FooterLinks>
      </Card>
    </PageContainer>
  );
};

export default RegisterPage;
