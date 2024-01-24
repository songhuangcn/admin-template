import type { Router } from 'vue-router';
import { setRouteEmitter } from '@/utils/route-listener';
import setupUserLoginInfoGuard from './userLoginInfo';
import setupPermissionGuard from './permission';

function setupPageGuard(router: Router) {
  router.beforeEach(async (to) => {
    // emit route change
    setRouteEmitter(to);
  });
}

// 钩子, 阻止相同的path也刷新
function setupAnchorGuard(router: Router) {
  router.beforeEach((to, from, next) => {
    if (to.path !== from.path) {
      next();
    }
  });
}

export default function createRouteGuard(router: Router) {
  setupPageGuard(router);
  setupAnchorGuard(router);
  setupUserLoginInfoGuard(router);
  setupPermissionGuard(router);
}
