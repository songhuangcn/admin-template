import axios from 'axios';

export interface LoginData {
  username: string;
  password: string;
}

export function sessionsLogin(data: any) {
  return axios.post('/api/login', data);
}

export function sessionsUser() {
  return axios.get('/api/user');
}
