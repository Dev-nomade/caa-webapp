import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders CognitIA login page when not authenticated', () => {
  localStorage.removeItem('cognitia_auth');
  render(<App />);
  const logoElements = screen.getAllByText(/CognitIA/i);
  expect(logoElements.length).toBeGreaterThan(0);
});

test('renders login form with email and password fields', () => {
  localStorage.removeItem('cognitia_auth');
  render(<App />);
  const emailInput = screen.getByPlaceholderText(/Digite seu e-mail/i);
  const senhaInput = screen.getByPlaceholderText(/Digite sua senha/i);
  expect(emailInput).toBeInTheDocument();
  expect(senhaInput).toBeInTheDocument();
});

test('renders cadastro link on login page', () => {
  localStorage.removeItem('cognitia_auth');
  render(<App />);
  const cadastroLink = screen.getByText(/Cadastre-se/i);
  expect(cadastroLink).toBeInTheDocument();
});
