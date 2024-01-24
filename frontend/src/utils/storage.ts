import { useStorage } from '@vueuse/core';

interface UserInfo {
  admin: boolean;
  roles: string[];
  permissions: string[];
}

export const userInfo = useStorage('user-info', {
  admin: false,
  roles: [],
  permissions: [],
} as UserInfo);
