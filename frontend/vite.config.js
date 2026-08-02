import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueJsx(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  // 跨域代理，解决前端开发时 浏览器跨域请求后端接口 的问题。
  server: {
    port: 5173,  // 前端项目启动端口，默认就是5173
    proxy: {     // 代理配置开始
      '/api': {  // 只要请求路径以 /api 开头，就走代理。
        target: 'http://localhost:8081',  // 后端服务地址+端口
        changeOrigin: true  // 开启跨域伪装，修改请求源，解决跨域报错
      }
    }
  }
})
