<!--创建底部导航栏组件-->
<!--把底部 TabBar 抽成组件，多个页面复用。-->

<script setup>
 // 获取当前路由信息，用来判断当前所在页面
import { useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const user = useUserStore()
</script>

<template>
  <div class="tab-bar">
    <router-link class="tab-item" :class="{ active: route.path === '/' }" to="/">
      <svg viewBox="0 0 24 24" fill="currentColor">
        <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
      </svg>
      首页
    </router-link>
    <router-link class="tab-item" :class="{ active: route.path === '/shop' }" to="/shop">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <rect x="3" y="3" width="7" height="7" rx="1"/>
        <rect x="14" y="3" width="7" height="7" rx="1"/>
        <rect x="3" y="14" width="7" height="7" rx="1"/>
        <rect x="14" y="14" width="7" height="7" rx="1"/>
      </svg>
      分类
    </router-link>
    <router-link class="tab-item" :class="{ active: route.path === '/cart' }" to="/cart">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/>
        <line x1="3" y1="6" x2="21" y2="6"/>
        <path d="M16 10a4 4 0 01-8 0"/>
      </svg>
      购物车
    </router-link>
    <router-link class="tab-item" :class="{ active: route.path === '/my' }" :to="user.isLogin ? '/my' : '/login'">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
        <circle cx="12" cy="7" r="4"/>
      </svg>
      我的
    </router-link>
  </div>
</template>

<style scoped>
.tab-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 60px;
  background: white;
  border-top: 1px solid #eee;
  display: flex;
  z-index: 998;
  box-shadow: 0 -4px 16px rgba(0, 0, 0, 0.06);
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 2px;
  text-decoration: none;
  color: #999;
  font-size: 11px;
  transition: color 0.2s;
}

.tab-item.active {
  color: #2dbe60;
}

.tab-item svg {
  width: 22px;
  height: 22px;
}
</style>
