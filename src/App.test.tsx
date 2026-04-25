import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders CognitIA header', () => {
  render(<App />);
  const headerElement = screen.getByText(/CognitIA/i);
  expect(headerElement).toBeInTheDocument();
});

test('renders SOS button', () => {
  render(<App />);
  const sosButton = screen.getByLabelText(/Botão de emergência SOS/i);
  expect(sosButton).toBeInTheDocument();
});

test('renders quick action cards', () => {
  render(<App />);
  const comerCard = screen.getByLabelText(/Comer/i);
  expect(comerCard).toBeInTheDocument();
});
