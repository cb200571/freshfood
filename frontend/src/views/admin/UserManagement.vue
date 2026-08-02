<!-- frontend/src/views/admin/UserManagement.vue -->
<!-- 商户端：用户管理页面 -->
<template>
  <div>
    <h3 class="mb-3">👥 用户管理</h3>

    <!-- 搜索栏 -->
    <div class="card mb-3">
      <div class="card-body py-2">
        <div class="row g-2 align-items-center">
          <div class="col-md-4">
            <input v-model="searchKeyword" class="form-control form-control-sm"
                   placeholder="搜索用户名或手机号...">
          </div>
          <div class="col-md-2">
            <button class="btn btn-sm btn-outline-secondary" @click="loadUsers">🔄 刷新</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 用户表格 -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th width="60">ID</th>
              <th>用户名</th>
              <th>手机号</th>
              <th>邮箱</th>
              <th>角色</th>
              <th>注册时间</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in filteredList" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.username }}</td>
              <td>{{ user.phone }}</td>
              <td>{{ user.email || '-' }}</td>
              <td>
                <span :class="user.role === 1 ? 'badge bg-danger' : 'badge bg-primary'">
                  {{ user.role === 1 ? '商户' : '普通用户' }}
                </span>
              </td>
              <td>{{ formatTime(user.createTime) }}</td>
            </tr>
            <tr v-if="filteredList.length === 0">
              <td colspan="6" class="text-center text-muted py-4">暂无用户数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const userList = ref([])
const searchKeyword = ref('')

const filteredList = computed(() => {
  if (!searchKeyword.value) return userList.value
  const kw = searchKeyword.value.toLowerCase()
  return userList.value.filter(u =>
    (u.username && u.username.toLowerCase().includes(kw)) ||
    (u.phone && u.phone.includes(kw))
  )
})

const formatTime = (t) => {
  if (!t) return '-'
  return t.replace('T', ' ').substring(0, 16)
}

const loadUsers = async () => {
  const res = await fetch('/api/user/admin/list').then(r => r.json())
  if (res.code === 200) {
    userList.value = res.data
  }
}

onMounted(loadUsers)
</script>
