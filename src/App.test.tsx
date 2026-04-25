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
  const emailInput = screen.getByPlaceholderText(/Enter your email/i);
  const passwordInput = screen.getByPlaceholderText(/Enter your password/i);
  expect(emailInput).toBeInTheDocument();
  expect(passwordInput).toBeInTheDocument();
});

test('renders sign up link on login page', () => {
  localStorage.removeItem('cognitia_auth');
  render(<App />);
  const signUpLink = screen.getByText(/Sign up/i);
  expect(signUpLink).toBeInTheDocument();
});
