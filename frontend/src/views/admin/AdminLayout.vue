<!-- frontend/src/views/admin/AdminLayout.vue -->
<template>
  <div class="admin-layout">
    <!-- 左侧菜单 -->
    <aside class="sidebar" :class="{ collapsed: isCollapsed }">
      <div class="sidebar-header">
        <span v-if="!isCollapsed">🏪 鲜食汇管理后台</span>
        <span v-else>🏪</span>
      </div>
      <nav class="sidebar-menu">
        <router-link
          v-for="item in menuItems"
          :key="item.path"
          :to="item.path"
          class="menu-item"
          :class="{ active: $route.path === item.path }"
        >
          <span class="icon">{{ item.icon }}</span>
          <span v-if="!isCollapsed" class="label">{{ item.label }}</span>
        </router-link>
      </nav>
    </aside>

    <!-- 右侧主区域 -->
    <div class="main-area">
      <!-- 顶部栏 -->
      <header class="topbar">
        <button class="btn btn-sm btn-outline-secondary" @click="isCollapsed = !isCollapsed">
          ☰
        </button>
        <div class="topbar-right">
          <span class="me-3">👤 {{ adminName }}</span>
          <button class="btn btn-sm btn-outline-danger" @click="handleLogout">退出登录</button>
        </div>
      </header>

      <!-- 内容区：子路由在这里渲染 -->
      <main class="content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const isCollapsed = ref(false)

// 从 localStorage 读取商户信息
const adminName = computed(() => {
  try {
    const admin = JSON.parse(localStorage.getItem('admin_user'))
    return admin?.username || '管理员'
  } catch {
    return '管理员'
  }
})

// 菜单配置
const menuItems = [
  { path: '/admin/dashboard', icon: '📊', label: '数据概览' },
  { path: '/admin/products',  icon: '📦', label: '商品管理' },
  { path: '/admin/orders',    icon: '📋', label: '订单管理' },
  { path: '/admin/users',     icon: '👥', label: '用户管理' },
  { path: '/admin/coupons',   icon: '🎫', label: '优惠券' },
  { path: '/admin/seckill',   icon: '⚡', label: '限时秒杀' },
]

// 退出登录
const handleLogout = () => {
  localStorage.removeItem('admin_token')
  localStorage.removeItem('admin_user')
  router.push('/admin/login')
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

/* ===== 左侧菜单 ===== */
.sidebar {
  width: 220px;
  background: #1a1a2e;
  color: #fff;
  transition: width 0.3s;
  flex-shrink: 0;
}
.sidebar.collapsed {
  width: 64px;
}
.sidebar-header {
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: bold;
  border-bottom: 1px solid rgba(255,255,255,0.1);
}
.sidebar-menu {
  padding: 10px 0;
}
.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  color: rgba(255,255,255,0.7);
  text-decoration: none;
  transition: all 0.2s;
}
.menu-item:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
}
.menu-item.active {
  background: #0d6efd;
  color: #fff;
}
.menu-item .icon {
  font-size: 18px;
  width: 24px;
  text-align: center;
}
.menu-item .label {
  margin-left: 12px;
  white-space: nowrap;
}

/* ===== 右侧主区域 ===== */
.main-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: #f5f5f5;
}

/* ===== 顶部栏 ===== */
.topbar {
  height: 56px;
  background: #fff;
  border-bottom: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  flex-shrink: 0;
}
.topbar-right {
  display: flex;
  align-items: center;
}

/* ===== 内容区 ===== */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
}
</style>
