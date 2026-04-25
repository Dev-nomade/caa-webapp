import React, { useState } from 'react';
import styled, { keyframes } from 'styled-components';
import { useNavigate, Link } from 'react-router-dom';
import { cadastrar } from '../services/authService';

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

const CadastroPage: React.FC = () => {
  const navigate = useNavigate();
  const [nomeResponsavel, setNomeResponsavel] = useState('');
  const [email, setEmail] = useState('');
  const [telefone, setTelefone] = useState('');
  const [nomeDependente, setNomeDependente] = useState('');
  const [senha, setSenha] = useState('');
  const [confirmarSenha, setConfirmarSenha] = useState('');
  const [message, setMessage] = useState<{ text: string; error: boolean } | null>(null);
  const [loading, setLoading] = useState(false);

  const formatTelefone = (value: string): string => {
    const digits = value.replace(/\D/g, '').slice(0, 11);
    if (digits.length <= 2) return digits;
    if (digits.length <= 7) return `(${digits.slice(0, 2)}) ${digits.slice(2)}`;
    return `(${digits.slice(0, 2)}) ${digits.slice(2, 7)}-${digits.slice(7)}`;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setMessage(null);

    if (senha.length < 6) {
      setMessage({ text: 'A senha deve ter pelo menos 6 caracteres.', error: true });
      return;
    }

    if (senha !== confirmarSenha) {
      setMessage({ text: 'As senhas não coincidem.', error: true });
      return;
    }

    setLoading(true);

    setTimeout(() => {
      const result = cadastrar(nomeResponsavel, email, telefone, nomeDependente, senha);
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
          <LogoEmoji role="img" aria-label="Cérebro">🧠</LogoEmoji>
          <LogoText>CognitIA</LogoText>
          <Subtitle>Crie sua conta</Subtitle>
        </LogoSection>

        {message && <Message $error={message.error}>{message.text}</Message>}

        <Form onSubmit={handleSubmit}>
          <Label>
            Nome completo do responsável
            <Input
              type="text"
              placeholder="Ex: Maria da Silva"
              value={nomeResponsavel}
              onChange={(e) => setNomeResponsavel(e.target.value)}
              required
              autoComplete="name"
            />
          </Label>

          <Label>
            E-mail do responsável
            <Input
              type="email"
              placeholder="Ex: maria@email.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              autoComplete="email"
            />
          </Label>

          <Label>
            Telefone do responsável
            <Input
              type="tel"
              placeholder="(00) 00000-0000"
              value={telefone}
              onChange={(e) => setTelefone(formatTelefone(e.target.value))}
              required
              autoComplete="tel"
            />
          </Label>

          <Label>
            Nome completo da criança / adulto
            <Input
              type="text"
              placeholder="Ex: João da Silva"
              value={nomeDependente}
              onChange={(e) => setNomeDependente(e.target.value)}
              required
            />
          </Label>

          <Label>
            Senha
            <Input
              type="password"
              placeholder="Mínimo 6 caracteres"
              value={senha}
              onChange={(e) => setSenha(e.target.value)}
              required
              minLength={6}
              autoComplete="new-password"
            />
          </Label>

          <Label>
            Confirmar senha
            <Input
              type="password"
              placeholder="Repita a senha"
              value={confirmarSenha}
              onChange={(e) => setConfirmarSenha(e.target.value)}
              required
              autoComplete="new-password"
            />
          </Label>

          <SubmitButton type="submit" disabled={loading}>
            {loading ? 'Cadastrando...' : 'Cadastrar'}
          </SubmitButton>
        </Form>

        <FooterLinks>
          Já tem uma conta? <StyledLink to="/login">Fazer login</StyledLink>
        </FooterLinks>
      </Card>
    </PageContainer>
  );
};

export default CadastroPage;
