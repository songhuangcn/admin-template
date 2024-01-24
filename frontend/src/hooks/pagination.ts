import { Pagination } from '@/types/axios';
import { ref, Ref, computed } from 'vue';
import { PaginationProps } from '@arco-design/web-vue';

export default function usePagination(pageRef: Ref<number>) {
  const paginationData: Ref<Pagination | undefined> = ref(undefined);
  const currentPage: Ref<number> = pageRef;
  const setPagination = (value: Pagination | undefined) => {
    paginationData.value = value;
  };
  const pagination = computed(() => {
    if (paginationData.value) {
      return {
        total: paginationData.value.total,
        pageSize: paginationData.value.per_page,
        current: currentPage.value,
      } as PaginationProps;
    }
    return false;
  });
  return {
    pagination,
    setPagination,
  };
}
