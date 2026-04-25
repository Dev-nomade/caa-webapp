export interface User {
  nomeResponsavel: string;
  email: string;
  telefone: string;
  nomeDependente: string;
}

interface StoredUser extends User {
  senha: string;
}

const USERS_KEY = 'cognitia_users';
const AUTH_KEY = 'cognitia_auth';

function getStoredUsers(): StoredUser[] {
  const data = localStorage.getItem(USERS_KEY);
  return data ? JSON.parse(data) : [];
}

function saveUsers(users: StoredUser[]): void {
  localStorage.setItem(USERS_KEY, JSON.stringify(users));
}

export function cadastrar(
  nomeResponsavel: string,
  email: string,
  telefone: string,
  nomeDependente: string,
  senha: string
): { success: boolean; message: string } {
  const users = getStoredUsers();
  const exists = users.some((u) => u.email.toLowerCase() === email.toLowerCase());

  if (exists) {
    return { success: false, message: 'E-mail já cadastrado.' };
  }

  users.push({ nomeResponsavel, email, telefone, nomeDependente, senha });
  saveUsers(users);

  return { success: true, message: 'Cadastro realizado com sucesso!' };
}

export function login(
  email: string,
  senha: string
): { success: boolean; message: string; user?: User } {
  const users = getStoredUsers();
  const found = users.find(
    (u) => u.email.toLowerCase() === email.toLowerCase() && u.senha === senha
  );

  if (!found) {
    return { success: false, message: 'E-mail ou senha incorretos.' };
  }

  const user: User = {
    nomeResponsavel: found.nomeResponsavel,
    email: found.email,
    telefone: found.telefone,
    nomeDependente: found.nomeDependente,
  };

  localStorage.setItem(AUTH_KEY, JSON.stringify(user));
  return { success: true, message: 'Login realizado com sucesso!', user };
}

export function logout(): void {
  localStorage.removeItem(AUTH_KEY);
}

export function getLoggedUser(): User | null {
  const data = localStorage.getItem(AUTH_KEY);
  return data ? JSON.parse(data) : null;
}

export function recuperarSenha(email: string): { success: boolean; message: string } {
  const users = getStoredUsers();
  const found = users.some((u) => u.email.toLowerCase() === email.toLowerCase());

  if (!found) {
    return { success: false, message: 'E-mail não encontrado.' };
  }

  return {
    success: true,
    message: 'Um link de recuperação foi enviado para o seu e-mail.',
  };
}
