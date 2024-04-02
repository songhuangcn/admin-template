import { resolve } from 'path';
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx';
import svgLoader from 'vite-svg-loader';
import VueI18nPlugin from '@intlify/unplugin-vue-i18n/vite';
import configArcoStyleImportPlugin from './plugin/arcoStyleImport';
import autoImportPlugin from './plugin/autoImport';

export default defineConfig({
  plugins: [
    vue(),
    autoImportPlugin(),
    VueI18nPlugin({
      runtimeOnly: true,
      compositionOnly: true,
      include: [resolve('locales/**')],
    }),
    vueJsx(),
    svgLoader({ svgoConfig: {} }),
    configArcoStyleImportPlugin(),
  ],
  resolve: {
    alias: [
      {
        find: '@',
        replacement: resolve(__dirname, '../src'),
      },
      {
        find: 'assets',
        replacement: resolve(__dirname, '../src/assets'),
      },
      {
        find: 'vue',
        replacement: 'vue/dist/vue.esm-bundler.js', // compile template
      },
    ],
    extensions: ['.ts', '.js'],
  },
  define: {
    'process.env': {},
  },
  css: {
    preprocessorOptions: {
      less: {
        modifyVars: {
          hack: `true; @import (reference) "${resolve(
            'src/assets/style/breakpoint.less'
          )}";`,
        },
        javascriptEnabled: true,
      },
    },
  },
  optimizeDeps: {
    include: ['mitt', 'dayjs', 'axios', 'pinia', '@vueuse/core', 'vue-i18n'],
    exclude: ['@iconify-icons/lets-icons'],
  },
});
