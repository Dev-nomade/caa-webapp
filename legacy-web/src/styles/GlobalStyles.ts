import { createGlobalStyle } from 'styled-components';

export const GlobalStyles = createGlobalStyle`
  @import url('https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:wght@400;700&display=swap');

  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  html {
    font-size: 18px;
  }

  body {
    font-family: 'Atkinson Hyperlegible', Arial, Helvetica, sans-serif;
    background-color: #F0F4F8;
    color: #1A1A2E;
    line-height: 1.6;
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  button {
    font-family: inherit;
    cursor: pointer;
    border: none;
    outline: none;
    font-size: inherit;
  }

  button:focus-visible {
    outline: 4px solid #1565C0;
    outline-offset: 2px;
  }

  a {
    color: inherit;
    text-decoration: none;
  }

  a:focus-visible {
    outline: 4px solid #1565C0;
    outline-offset: 2px;
  }

  ::-webkit-scrollbar {
    width: 10px;
  }

  ::-webkit-scrollbar-track {
    background: #E8EDF2;
    border-radius: 5px;
  }

  ::-webkit-scrollbar-thumb {
    background: #90A4AE;
    border-radius: 5px;
  }

  ::-webkit-scrollbar-thumb:hover {
    background: #607D8B;
  }
`;
