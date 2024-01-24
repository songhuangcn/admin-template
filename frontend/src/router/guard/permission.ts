import type { Router, RouteRecordNormalized } from 'vue-router';
import NProgress from 'nprogress'; // progress bar

import usePermission from '@/hooks/permission';
import { DEFAULT_ROUTE } from '@/router/constants';

export default function setupPermissionGuard(router: Router) {
  router.beforeEach(async (to, _from, next) => {
    const Permission = usePermission();
    const permissionsAllow = Permission.accessRouter(to);

    // eslint-disable-next-line no-lonely-if
    if (permissionsAllow) next();
    else next(DEFAULT_ROUTE);

    NProgress.done();
  });
}
