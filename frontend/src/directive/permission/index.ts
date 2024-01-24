import { DirectiveBinding } from 'vue';
import { useUserStore } from '@/store';

function checkPermission(el: HTMLElement, binding: DirectiveBinding) {
  const { value } = binding;
  const userStore = useUserStore();

  if (Array.isArray(value)) {
    if (userStore.admin) return;

    if (value.length > 0) {
      const permissionValues = value;

      if (!userStore.hasEveryPermission(permissionValues) && el.parentNode) {
        el.parentNode.removeChild(el);
      }
    }
  } else {
    throw new Error(
      `need roles! Like v-permission="['users#index','roles#index']"`
    );
  }
}

export default {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  },
  updated(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  },
};
