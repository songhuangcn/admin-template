import { RouteRecordRaw } from 'vue-router';

import DefaultRouterView from '@/components/default-router-view/index.vue';

export const appRoutes: RouteRecordRaw[] = [
  {
    path: 'dashboard',
    name: 'Dashboard',
    component: DefaultRouterView,
    meta: {
      locale: 'menu.dashboard',
      requiresAuth: true,
      icon: 'icon-dashboard',
      order: 0,
    },
    children: [
      {
        path: 'workplace',
        name: 'Workplace',
        component: () => import('@/views/dashboard/workplace/index.vue'),
        meta: {
          locale: 'menu.dashboard.workplace',
          requiresAuth: true,
        },
      },
    ],
  },
  {
    path: 'system-management',
    name: 'System Management',
    component: DefaultRouterView,
    meta: {
      locale: 'menu.system-management',
      requiresAuth: true,
      icon: 'icon-settings',
      order: 4,
    },
    children: [
      {
        path: 'user',
        name: 'User',
        component: () => import('@/views/system-management/user/index.vue'),
        meta: {
          locale: 'menu.system-management.user',
          requiresAuth: true,
          roles: ['users#index'],
        },
      },
      {
        path: 'role',
        name: 'Role',
        component: () => import('@/views/system-management/role/index.vue'),
        meta: {
          locale: 'menu.system-management.role',
          requiresAuth: true,
          roles: ['roles#index'],
        },
      },
    ],
  },
];
