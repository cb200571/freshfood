

import { createApp } from 'vue'
import { createPinia } from 'pinia'
// 引入 Bootstrap
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.bundle.min.js'
// 让 bootstrap.Modal 在全局可用（商户端弹窗需要）
import { Modal } from 'bootstrap'
window.bootstrap = { Modal }

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
