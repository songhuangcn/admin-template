import axios from 'axios';

export function permissionsIndex(params: any) {
  return axios.get('/api/permissions', { params });
}
