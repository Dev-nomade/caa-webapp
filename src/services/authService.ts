export interface User {
  guardianName: string;
  email: string;
  phone: string;
  dependentName: string;
}

interface StoredUser extends User {
  password: string;
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

export function register(
  guardianName: string,
  email: string,
  phone: string,
  dependentName: string,
  password: string
): { success: boolean; message: string } {
  const users = getStoredUsers();
  const exists = users.some((u) => u.email.toLowerCase() === email.toLowerCase());

  if (exists) {
    return { success: false, message: 'Email already registered.' };
  }

  users.push({ guardianName, email, phone, dependentName, password });
  saveUsers(users);

  return { success: true, message: 'Registration successful!' };
}

export function login(
  email: string,
  password: string
): { success: boolean; message: string; user?: User } {
  const users = getStoredUsers();
  const found = users.find(
    (u) => u.email.toLowerCase() === email.toLowerCase() && u.password === password
  );

  if (!found) {
    return { success: false, message: 'Incorrect email or password.' };
  }

  const user: User = {
    guardianName: found.guardianName,
    email: found.email,
    phone: found.phone,
    dependentName: found.dependentName,
  };

  localStorage.setItem(AUTH_KEY, JSON.stringify(user));
  return { success: true, message: 'Login successful!', user };
}

export function logout(): void {
  localStorage.removeItem(AUTH_KEY);
}

export function getLoggedUser(): User | null {
  const data = localStorage.getItem(AUTH_KEY);
  return data ? JSON.parse(data) : null;
}

export function recoverPassword(email: string): { success: boolean; message: string } {
  const users = getStoredUsers();
  const found = users.some((u) => u.email.toLowerCase() === email.toLowerCase());

  if (!found) {
    return { success: false, message: 'Email not found.' };
  }

  return {
    success: true,
    message: 'A recovery link has been sent to your email.',
  };
}
