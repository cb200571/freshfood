<script setup>
import { useRouter } from 'vue-router'//useRouter() 是 vue-router4 提供的组合式钩子函数,门给 Vue3 <script setup> 使用。
// Vue3 setup 里没有 this，写不了 Vue2 的 this.$router，
// 只能通过 useRouter() 获取路由操作对象。
// 调用它会返回全局路由实例，这个实例身上有一堆控制页面跳转的方法：
// router.push()：跳转到新页面（可返回上一页）
// router.replace()：跳转并替换当前页面（不能回退）
// router.back()：返回上一页
// router.go(n)：前进 / 后退多页

import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const router = useRouter()
const user = useUserStore()

// 退出登录
function logout() {
  user.logout()
  router.push('/')
}
</script>

<template>
  <div class="my-page">
    <!-- 未登录 -->
    <div v-if="!user.isLogin" class="nologin-card">
      <div class="avatar-placeholder">👤</div>
      <div style="font-size: 15px; font-weight: 600;">您还未登录</div>
      <div style="font-size: 12px; opacity: 0.75; margin-top: 4px;">登录后享受更多优惠</div>
      <div class="login-btns">
        <router-link to="/login" class="btn-login">登录</router-link>
        <router-link to="/register" class="btn-reg">注册</router-link>
      </div>
    </div>

    <!-- 已登录 -->
    <template v-else>
      <!-- 用户卡片 -->
      <div class="user-card">
        <div class="top-row">
          <div class="avatar-wrap">
            <div class="avatar">{{ user.userName[0] }}</div>
            <div class="user-info">
              <h3>{{ user.userName }}</h3>
              <div class="phone">{{ user.userPhone || '未绑定手机号' }}</div>
            </div>
          </div>
          <button class="btn-settings" @click="alert('设置页面开发中')">⚙</button>
        </div>
      </div>

      <!-- 订单入口 -->
      <div class="section">
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 14px 16px 0;">
          <span style="font-size: 15px; font-weight: 700; color: #222;">我的订单</span>
        </div>
        <div class="order-grid">
          <div class="order-item" @click="router.push('/orderList?status=0')">
            <div class="icon-wrap icon-pay">💰</div>
            待支付
          </div>
          <div class="order-item" @click="router.push('/orderList?status=1')">
            <div class="icon-wrap icon-delivery">📦</div>
            待收货
          </div>
          <div class="order-item" @click="router.push('/orderList?status=2')">
            <div class="icon-wrap icon-review">✍️</div>
            待评价
          </div>
          <div class="order-item" @click="router.push('/orderList?status=3')">
            <div class="icon-wrap icon-after">🔧</div>
            售后
          </div>
          <div class="order-item" @click="router.push('/orderList')">
            <div class="icon-wrap icon-all">📋</div>
            我的订单
        </div>
          <div class="order-item" @click="router.push('/my/coupons')">
            <div class="icon-wrap icon-all">🎫</div>
            我的优惠券
          </div>
      </div>

      <!-- 功能列表 -->
      <div class="section" style="margin-top: 10px;">
        <div class="menu-list">
          <div class="menu-item" @click="router.push('/addressList')">
            <span class="menu-icon">📍</span> 收货地址
            <span class="menu-arrow">›</span>
          </div>
          <div class="menu-item" @click="alert('功能开发中')">
            <span class="menu-icon">💬</span> 客服中心
            <span class="menu-arrow">›</span>
          </div>
          <div class="menu-item" @click="alert('功能开发中')">
            <span class="menu-icon">❓</span> 帮助与反馈
            <span class="menu-arrow">›</span>
          </div>
        </div>
      </div>

      <!-- 退出按钮 -->
      <button class="logout-btn" @click="logout">退出登录</button>
      </div>
    </template>

    <!-- 底部 TabBar -->
    <TabBar />
  </div>
</template>

<style scoped>
.my-page {
  background: #f6f7f8;
  min-height: 100vh;
  padding-bottom: 70px;
}

/* 未登录状态 */
.nologin-card {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  padding: 30px 20px 24px;
  color: white;
  text-align: center;
}

.nologin-card .avatar-placeholder {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  margin: 0 auto 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 30px;
}

.nologin-card .login-btns {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 12px;
}

.nologin-card .login-btns a {
  padding: 8px 24px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s;
}

.btn-login {
  background: white;
  color: #2dbe60;
}

.btn-login:hover {
  background: #e8ffe8;
}

.btn-reg {
  background: rgba(255, 255, 255, 0.25);
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.5);
}

.btn-reg:hover {
  background: rgba(255, 255, 255, 0.4);
}

/* 已登录 - 用户卡片 */
.user-card {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  padding: 30px 20px 24px;
  color: white;
  position: relative;
}

.user-card .top-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.user-card .avatar-wrap {
  display: flex;
  align-items: center;
  gap: 14px;
}

.user-card .avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  font-weight: 700;
  border: 3px solid rgba(255, 255, 255, 0.5);
}

.user-card .user-info h3 {
  font-size: 18px;
  font-weight: 700;
  margin-bottom: 2px;
}

.user-card .user-info .phone {
  font-size: 12px;
  opacity: 0.8;
}

.user-card .btn-settings {
  width: 36px;
  height: 36px;
  border: none;
  background: rgba(255, 255, 255, 0.25);
  color: white;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  transition: background 0.2s;
}

.user-card .btn-settings:hover {
  background: rgba(255, 255, 255, 0.4);
}

/* 内容区 */
.section {
  background: white;
  margin: 10px 12px 0;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 订单入口 */
.order-grid {
  display: flex;
  padding: 16px 0;
}

.order-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  text-decoration: none;
  color: #333 !important;
  font-size: 12px;
  position: relative;
  transition: color 0.2s;
}

.order-item:hover {
  color: #2dbe60 !important;
}

.order-item .icon-wrap {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
}

.icon-pay { background: #fff3e0; }
.icon-delivery { background: #e8f5e9; }
.icon-review { background: #fce4ec; }
.icon-after { background: #e3f2fd; }
.icon-all { background: #f3e5f5; }

.item-order {
  color: #333;
  text-decoration: none;
}
.item-order:hover {
  color: #2dbe60;
}
/* 功能列表 */
.menu-list {
  padding: 0;
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 15px 16px;
  cursor: pointer;
  text-decoration: none;
  color: #333;
  font-size: 14px;
  border-bottom: 1px solid #f5f5f5;
  transition: background 0.15s;
}

.menu-item:last-child {
  border-bottom: none;
}

.menu-item:hover {
  background: #f9fdf9;
}

.menu-item .menu-icon {
  font-size: 20px;
  margin-right: 12px;
  width: 24px;
  text-align: center;
}

.menu-item .menu-arrow {
  margin-left: auto;
  color: #ccc;
  font-size: 14px;
}

/* 退出按钮 */
.logout-btn {
  display: block;
  width: calc(100% - 24px);
  margin: 16px 12px;
  padding: 12px 0;
  background: white;
  border: 1px solid #eee;
  border-radius: 12px;
  text-align: center;
  color: #999;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.logout-btn:hover {
  color: #e74c3c;
  border-color: #ffcccc;
}
</style>
