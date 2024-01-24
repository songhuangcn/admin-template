import { defineStore } from 'pinia';
import { sessionsLogin, sessionsUser, LoginData } from '@/api/sessions';
import { setToken, clearToken } from '@/utils/auth';
import { removeRouteListener } from '@/utils/route-listener';
import { UserState } from './types';
import useAppStore from '../app';

const useUserStore = defineStore('user', {
  state: (): UserState => ({
    id: undefined,
    username: undefined,
    name: undefined,
    admin: undefined,
    role_names: undefined,
    permission_names: undefined,
    user_type: undefined,
    // name: undefined,
    // avatar: undefined,
    // job: undefined,
    // organization: undefined,
    // location: undefined,
    // email: undefined,
    // introduction: undefined,
    // personalWebsite: undefined,
    // jobName: undefined,
    // organizationName: undefined,
    // locationName: undefined,
    // phone: undefined,
    // registrationDate: undefined,
    // accountId: undefined,
    // certification: undefined,
    // role: '',
  }),

  getters: {
    userInfo(state: UserState): UserState {
      return { ...state };
    },
  },

  actions: {
    // switchRoles() {
    //   return new Promise((resolve) => {
    //     this.role = this.role === 'user' ? 'admin' : 'user';
    //     resolve(this.role);
    //   });
    // },
    // Set user's information
    setInfo(partial: Partial<UserState>) {
      this.$patch(partial);
    },

    hasEveryPermission(permissions: string[]) {
      if (this.admin) return true;

      return permissions.every((permission) =>
        this.permission_names?.includes(permission)
      );
    },

    hasSomePermission(permissions: string[]) {
      if (this.admin) return true;

      return permissions.some((permission) =>
        this.permission_names?.includes(permission)
      );
    },

    // Reset user's information
    resetInfo() {
      this.$reset();
    },

    // Get user's information
    async info() {
      try {
        const res = await sessionsUser();

        this.setInfo(res.data);
      } catch (err) {
        clearToken();
        throw err;
      }
    },

    // Login
    async login(loginForm: LoginData) {
      try {
        const res = await sessionsLogin(loginForm);
        setToken(res.data.token);
      } catch (err) {
        clearToken();
        throw err;
      }
    },
    logoutCallBack() {
      const appStore = useAppStore();
      this.resetInfo();
      clearToken();
      removeRouteListener();
      appStore.clearServerMenu();
    },
    // Logout
    async logout() {
      // try {
      //   await userLogout();
      // } finally {
      //   this.logoutCallBack();
      // }
      this.logoutCallBack();
    },
  },
});

export default useUserStore;
