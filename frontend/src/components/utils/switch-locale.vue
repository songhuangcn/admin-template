<template>
  <a-tooltip :content="$t('settings.language')">
    <a-button
      class="nav-btn"
      type="outline"
      :shape="'circle'"
      @click="setDropDownVisible"
    >
      <template #icon>
        <icon-language />
      </template>
    </a-button>
  </a-tooltip>
  <a-dropdown trigger="click" @select="switchLocale as any">
    <div ref="triggerBtn" class="trigger-btn"></div>
    <template #content>
      <a-doption v-for="item in locales" :key="item.value" :value="item.value">
        <template #icon>
          <icon-check v-show="item.value === currentLocale" />
        </template>
        {{ item.label }}
      </a-doption>
    </template>
  </a-dropdown>
</template>

<script lang="ts" setup>
  import { ref } from 'vue';
  import { LOCALE_OPTIONS } from '@/locale';
  import useLocale from '@/hooks/locale';

  const locales = [...LOCALE_OPTIONS];
  const triggerBtn = ref();
  const { changeLocale, currentLocale } = useLocale();
  const switchLocale = (locale: string) => {
    changeLocale(locale);
    window.location.reload();
  };

  const setDropDownVisible = () => {
    const event = new MouseEvent('click', {
      view: window,
      bubbles: true,
      cancelable: true,
    });
    triggerBtn.value.dispatchEvent(event);
  };
</script>
