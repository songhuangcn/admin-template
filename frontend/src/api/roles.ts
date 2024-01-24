import axios from 'axios';

export function rolesIndex(params: any) {
  return axios.get('/api/roles', { params });
}

export function rolesCreate(data: any) {
  return axios.post('/api/roles', data);
}

export function rolesUpdate(id: any, data: any) {
  return axios.patch(`/api/roles/${id}`, data);
}

export function rolesDestroy(id: any) {
  return axios.delete(`/api/roles/${id}`);
}
