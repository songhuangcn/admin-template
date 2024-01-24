<template>
  <a-layout style="padding: 0 20px; min-width: 1200px">
    <Breadcrumb :items="['menu.dashboard', 'menu.dashboard.workplace']" />
    <a-card
      :bordered="false"
      :header-style="{ border: 'none' }"
      :title="$t('menu.dashboard.workplace')"
      :style="{ minHeight: '100vh' }"
    >
      {{ $t('text.demo_tips') }}
    </a-card>
  </a-layout>
</template>
