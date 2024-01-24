<template>
  <a-layout style="padding: 0 20px">
    <Breadcrumb
      :items="['menu.system-management', 'menu.system-management.user']"
    />
    <a-card
      :bordered="false"
      :header-style="{ border: 'none' }"
      :title="$t('menu.system-management.user')"
      :style="{ minHeight: '100vh' }"
    >
      <a-row style="margin-bottom: 16px">
        <a-col :span="12">
          <a-space>
            <a-button
              v-permission="['users#create']"
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
        <template #roles="{ record }">
          <a-space>
            <a-tag v-for="role in record.roles" :key="role.id">
              {{ role.name }}
            </a-tag>
          </a-space>
        </template>
        <template #created_at="{ record }">
          {{ formatTime(record.created_at) }}
        </template>
        <template #updated_at="{ record }">
          {{ formatTime(record.updated_at) }}
        </template>
        <template #user_type="{ record }">
          {{ userTypeLabel(record.user_type) }}
        </template>
        <template #operations="{ record }">
          <a-space>
            <a-button
              v-permission="['users#update']"
              type="primary"
              size="mini"
              :disabled="isAdmin(record)"
              @click="onEdit(record)"
            >
              {{ $t('text.edit') }}
            </a-button>
            <a-popconfirm
              :content="$t('text.confirm?')"
              @ok="onDestroy(record)"
            >
              <a-button
                v-permission="['users#destroy']"
                type="secondary"
                size="mini"
                :disabled="isAdmin(record)"
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
      :title="isInEdit ? $t('text.edit_user') : $t('text.new_user')"
      @before-ok="onModalBeforeOk"
    >
      <a-form :model="modalForm">
        <a-form-item
          field="name"
          :label="$t('model.name')"
          :rules="[{ required: !isInEdit }]"
        >
          <a-input v-model="modalForm.name" />
        </a-form-item>
        <a-form-item
          field="username"
          :label="$t('model.username')"
          :rules="[{ required: !isInEdit }]"
        >
          <a-input v-model="modalForm.username" />
        </a-form-item>
        <a-form-item
          :rules="[{ required: !isInEdit }]"
          field="password"
          :label="$t('model.password')"
        >
          <a-input-password v-model="modalForm.password" />
        </a-form-item>
        <a-form-item field="post" :label="$t('model.roles')">
          <a-select v-model="modalForm.role_ids" multiple>
            <a-option
              v-for="role in roleSelections"
              :key="role.id"
              :value="role.id"
            >
              {{ role.name }}
            </a-option>
          </a-select>
        </a-form-item>
      </a-form>
    </a-modal>
  </a-layout>
</template>

<script lang="ts" setup>
  import { ref, reactive, computed, onMounted, Ref } from 'vue';
  import useLoading from '@/hooks/loading';
  import usePagination from '@/hooks/pagination';
  import {
    usersIndex,
    usersCreate,
    usersUpdate,
    usersDestroy,
  } from '@/api/users';
  import { rolesIndex } from '@/api/roles';
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
      const { data, meta } = await usersIndex(params);
      tableData.value = data;
      setPagination(meta.pagination);
    } catch (err) {
      // you can report use errorHandler or other
    } finally {
      setLoading(false);
    }
  };

  const userTypes = [
    { label: '普通用户', value: 'normal_user' },
    { label: '管理员', value: 'admin' },
  ];

  const userTypeLabel = (value: string) => {
    const userType = userTypes.find((item) => item.value === value);
    return userType?.label;
  };

  interface RoleSelection {
    id: number;
    name: string;
  }

  const roleSelections: Ref<RoleSelection[]> = ref([]);

  const fetchRoleSelections = async () => {
    const res = await rolesIndex({});
    roleSelections.value = res.data;
  };

  const onRefresh = () => {
    currentPage.value = 1;
    fetchData();
  };

  const onPageChange = (page: number) => {
    currentPage.value = page;
    fetchData();
  };

  const generateModalForm = () => {
    return {
      id: undefined,
      username: '',
      password: '',
      admin: false,
      name: '',
      user_type: '',
      role_ids: [],
      avatar_attachment_attributes: {},
    };
  };

  const modalVisible = ref(false);
  const modalForm = reactive(generateModalForm());
  const isInEdit = computed(() => !!modalForm.id);

  const onEdit = async (record: any) => {
    Object.assign(modalForm, generateModalForm());
    const { id, username, name, user_type } = record;
    const roleIds = record.roles.map((role: any) => role.id);
    Object.assign(modalForm, {
      id,
      username,
      name,
      user_type,
      role_ids: roleIds,
    });
    await fetchRoleSelections();
    modalVisible.value = true;
  };

  const onDestroy = async (record: any) => {
    await usersDestroy(record.id);
    fetchData();
  };

  const onNew = async () => {
    Object.assign(modalForm, generateModalForm());
    await fetchRoleSelections();
    modalVisible.value = true;
  };

  const onModalBeforeOk = async (done: any) => {
    if (isInEdit.value) {
      await usersUpdate(modalForm.id, modalForm);
    } else {
      await usersCreate(modalForm);
    }
    done();
    fetchData();
  };

  const isAdmin = (user: any) => {
    return user.user_type === 'admin';
  };

  onMounted(() => {
    fetchData();
  });
</script>
