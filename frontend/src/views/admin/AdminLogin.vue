<!-- frontend/src/views/admin/AdminLogin.vue -->
<template>
  <div class="admin-login-container">
    <div class="login-card">
      <h2>🏪 商户管理后台</h2>
      <p class="subtitle">鲜食汇商户管理系统</p>

      <form @submit.prevent="handleLogin">
        <div class="mb-3">
          <label class="form-label">账号</label>
          <input v-model="form.username" type="text" class="form-control"
                 placeholder="请输入商户账号" required>
        </div>
        <div class="mb-3">
          <label class="form-label">密码</label>
          <input v-model="form.password" type="password" class="form-control"
                 placeholder="请输入密码" required>
        </div>
        <button type="submit" class="btn btn-primary w-100" :disabled="loading">
          {{ loading ? '登录中...' : '登录' }}
        </button>
      </form>

      <p v-if="error" class="text-danger mt-2 text-center">{{ error }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { userApi } from '@/api'
import { useAdminStore } from '@/stores/admin'

const router = useRouter()
const adminStore = useAdminStore()
const form = ref({ username: '', password: '' })//响应式表单对象
const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
  loading.value = true
  error.value = ''
  try {
    // 注意：你的 api/index.js 中 loginByPassword 需要两个参数
    const res = await userApi.loginByPassword(form.value.username, form.value.password)

    if (res.code === 200 && res.data?.role === 1) {
      // 是商户，保存登录状态
      adminStore.setLogin(res.data)
      router.push('/admin/dashboard')
    } else if (res.code === 200 && res.data?.role !== 1) {
      error.value = '该账号不是商户账号，请用普通用户登录'
    } else {
      error.value = res.message || '登录失败'
    }
  } catch (e) {
    error.value = '网络错误，请检查后端是否启动'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.admin-login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a5276 0%, #2e86c1 100%);
}
.login-card {
  background: white;
  padding: 40px;
  border-radius: 12px;
  width: 400px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}
.login-card h2 { text-align: center; margin-bottom: 5px; }
.subtitle { text-align: center; color: #666; margin-bottom: 30px; }
</style>
