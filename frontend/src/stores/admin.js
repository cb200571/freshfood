import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAdminStore = defineStore('admin', () => {
  // 状态
  const token = ref(localStorage.getItem('admin_token') || '')
  const adminInfo = ref(JSON.parse(localStorage.getItem('admin_user') || '{}'))

  // 计算属性
  const isLoggedIn = computed(() => !!token.value)
  const adminName = computed(() => adminInfo.value.username || '管理员')

  // 登录（保存状态 + localStorage）
  function setLogin(data) {
    token.value = data.token
    adminInfo.value = data
    localStorage.setItem('admin_token', data.token)
    localStorage.setItem('admin_user', JSON.stringify(data))
  }

  // 退出（清除状态 + localStorage）
  function logout() {
    token.value = ''
    adminInfo.value = {}
    localStorage.removeItem('admin_token')
    localStorage.removeItem('admin_user')
  }

  return { token, adminInfo, isLoggedIn, adminName, setLogin, logout }
})
