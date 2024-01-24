import type { TableColumnData } from '@arco-design/web-vue/es/table/interface';
import i18n from '@/locale';

export const TABLE_COLUMNS: TableColumnData[] = [
  {
    title: i18n.global.t('model.id'),
    dataIndex: 'id',
  },
  {
    title: i18n.global.t('model.name'),
    dataIndex: 'name',
  },
  {
    title: i18n.global.t('model.permission_count'),
    dataIndex: 'permission_count',
    slotName: 'permission_count',
  },
  {
    title: i18n.global.t('model.created_at'),
    dataIndex: 'created_at',
    slotName: 'created_at',
  },
  {
    title: i18n.global.t('model.updated_at'),
    dataIndex: 'updated_at',
    slotName: 'updated_at',
  },
  {
    title: i18n.global.t('text.operations'),
    dataIndex: 'operations',
    slotName: 'operations',
  },
];
