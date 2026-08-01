import { defineConfig } from 'vite';

/**
 * base './' обязателен: на Яндекс Играх сборка живёт под вложенным путём,
 * иначе ассеты не загрузятся.
 */
export default defineConfig({
  base: './',
  build: {
    target: 'es2020',
    minify: 'esbuild',
    outDir: 'dist',
    /**
     * JSON-данные (src/data) не инлайним в бандл:
     * на Яндекс Играх они должны лежать реальными файлами
     * и грузиться по относительным URL.
     */
    assetsInlineLimit: 0,
  },
});
