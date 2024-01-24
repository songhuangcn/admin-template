<template>
  <a-layout style="padding: 0 20px">
    <Breadcrumb
      :items="['menu.system-management', 'menu.system-management.role']"
    />
    <a-card
      :bordered="false"
      :header-style="{ border: 'none' }"
      :title="$t('menu.system-management.role')"
      :style="{ minHeight: '100vh' }"
    >
      <a-row style="margin-bottom: 16px">
        <a-col :span="12">
          <a-space>
            <a-button
              v-permission="['roles#create']"
              type="primary"
              @click="onNew"
            >
              <template #icon>
                <icon-plus />
              </template>
              {{ $t('text.new') }}
            </a-button>
          </a-space>
        </a-col>
        <a-col
          :span="12"
          style="display: flex; align-items: center; justify-content: end"
        >
          <a-tooltip :content="$t('text.refresh')">
            <a-button @click="onRefresh">
              <template #icon>
                <icon-refresh />
              </template>
              {{ $t('text.refresh') }}
            </a-button>
          </a-tooltip>
        </a-col>
      </a-row>
      <a-table
        row-key="id"
        :loading="loading"
        :pagination="pagination"
        :columns="TABLE_COLUMNS"
        :data="tableData"
        :bordered="false"
        @page-change="onPageChange"
      >
        <template #permission_count="{ record }">
          <a-badge :count="record.permission_count" />
        </template>
        <template #created_at="{ record }">
          {{ formatTime(record.created_at) }}
        </template>
        <template #updated_at="{ record }">
          {{ formatTime(record.updated_at) }}
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button
              v-permission="['roles#update']"
              type="primary"
              size="mini"
              @click="onEdit(record)"
            >
              {{ $t('text.edit') }}
            </a-button>
            <a-popconfirm
              :content="$t('text.confirm?')"
              @ok="onDestroy(record)"
            >
              <a-button
                v-permission="['roles#destroy']"
                type="secondary"
                size="mini"
              >
                {{ $t('text.delete') }}
              </a-button>
            </a-popconfirm>
          </a-space>
        </template>
      </a-table>
    </a-card>
    <a-modal
      v-model:visible="modalVisible"
      :title="isInEdit ? $t('text.edit_role') : $t('text.new_role')"
      @before-ok="onModalBeforeOk"
    >
      <a-form :model="modalForm">
        <a-form-item field="name" :label="$t('model.name')">
          <a-input v-model="modalForm.name" />
        </a-form-item>
        <a-form-item field="permission_names" :label="$t('model.permissions')">
          <a-space direction="vertical">
            <div
              v-for="(
                permissionSelections, controller, index
              ) in groupedPermissionSelection"
              :key="index"
            >
              <div>
                <a-checkbox
                  v-model="selectAll"
                  :value="controller"
                  @change="
                    (_value, event) => onCheckController(event, controller)
                  "
                >
                  {{ $t('text.select_all') }}
                </a-checkbox>
              </div>
              <a-checkbox-group v-model="modalForm.permission_names">
                <a-checkbox
                  v-for="(permission, subindex) in permissionSelections"
                  :key="subindex"
                  :value="permission.name"
                >
                  {{ permission.name_i18n }}
                </a-checkbox>
              </a-checkbox-group>
            </div>
          </a-space>
        </a-form-item>
      </a-form>
    </a-modal>
  </a-layout>
</template>

<script lang="ts" setup>
  import { ref, reactive, computed, onMounted } from 'vue';
  import useLoading from '@/hooks/loading';
  import usePagination from '@/hooks/pagination';
  import {
    rolesIndex,
    rolesCreate,
    rolesUpdate,
    rolesDestroy,
  } from '@/api/roles';
  import { permissionsIndex } from '@/api/permissions';
  import { formatTime } from '@/utils/formatter';

  import { TABLE_COLUMNS } from './table-columns';

  const { loading, setLoading } = useLoading(true);
  const tableData = ref([]);

  const currentPage = ref(1);
  const { pagination, setPagination } = usePagination(currentPage);

  const fetchData = async () => {
    setLoading(true);
    try {
      const params = { page: currentPage.value, per_page: 20 };
      const { data, meta } = await rolesIndex(params);
      tableData.value = data;
      setPagination(meta.pagination);
    } catch (err) {
      // you can report use errorHandler or other
    } finally {
      setLoading(false);
    }
  };

  const onRefresh = () => {
    currentPage.value = 1;
    fetchData();
  };

  const onPageChange = (page: number) => {
    currentPage.value = page;
    fetchData();
  };

  const permissionsSelection = ref([]);

  const fetchPermissions = async () => {
    const { data } = await permissionsIndex({});
    permissionsSelection.value = data;
  };

  // const controllerI18n = reactive<any>({});

  const groupedPermissionSelection = computed(() => {
    return permissionsSelection.value.reduce((result: any, item: any) => {
      // controllerI18n[item.controller] ||= item.controller_i18n;
      result[item.controller] ||= [];
      result[item.controller].push(item);
      return result;
    }, {});
  });

  type ModalForm = {
    id: undefined | number;
    name: string;
    permission_names: string[];
  };

  const generateModalForm = (): ModalForm => {
    return {
      id: undefined,
      name: '',
      permission_names: [],
    };
  };

  const selectAll = ref([]);

  const modalVisible = ref(false);
  const modalForm = reactive(generateModalForm());
  const isInEdit = computed(() => !!modalForm.id);

  const onEdit = async (record: any) => {
    Object.assign(modalForm, {
      id: record.id,
      name: record.name,
      permission_names: record.permission_names,
    });
    selectAll.value = [];
    await fetchPermissions();
    modalVisible.value = true;
  };

  const onDestroy = async (record: any) => {
    await rolesDestroy(record.id);
    fetchData();
  };

  const onNew = async () => {
    Object.assign(modalForm, generateModalForm());
    selectAll.value = [];
    await fetchPermissions();
    modalVisible.value = true;
  };

  const onModalBeforeOk = async (done: any) => {
    if (isInEdit.value) {
      await rolesUpdate(modalForm.id, modalForm);
    } else {
      await rolesCreate(modalForm);
    }
    done();
    fetchData();
  };

  const onCheckController = (event: any, controller: any) => {
    const controllerPermissions = groupedPermissionSelection.value[
      controller
    ].map((item: any) => item.name);
    if (event.target.checked) {
      modalForm.permission_names = Array.from(
        new Set([...modalForm.permission_names, ...controllerPermissions])
      );
    } else {
      modalForm.permission_names = modalForm.permission_names.filter(
        (name: any) => !controllerPermissions.includes(name)
      );
    }
  };

  onMounted(() => {
    fetchData();
  });
</script>
