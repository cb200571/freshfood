
<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { couponApi } from '@/api'
import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const router = useRouter()
const user = useUserStore()
const coupons = ref([])
const loading = ref(true)

async function loadCoupons() {
  if (!user.isLogin || !user.userId) return
  try {
    const res = await couponApi.getMyCoupons(user.userId)
    if (res.code === 200) {
      coupons.value = res.data || []
    }
  } catch (e) {
    console.error('加载优惠券失败:', e)
  } finally {
    loading.value = false
  }
}

// 优惠券状态文本
function statusText(status) {
  if (status === 0) return '未使用'
  if (status === 1) return '已使用'
  if (status === 2) return '已过期'
  return '未知'
}

// 优惠券状态样式
function statusClass(status) {
  if (status === 0) return 'status-unused'
  if (status === 1) return 'status-used'
  if (status === 2) return 'status-expired'
  return ''
}

// 优惠券金额显示
function formatAmount(coupon) {
  if (coupon.type === 2) {  // 折扣券
    return `${coupon.amount * 10}折`
  }
  return `¥${coupon.amount}`
}

// 有效期文本
function validDate(coupon) {
  if (!coupon.startTime || !coupon.endTime) return ''
  const start = coupon.startTime.replace('T', ' ').substring(0, 10)
  const end = coupon.endTime.replace('T', ' ').substring(0, 10)
  return `${start} ~ ${end}`
}

onMounted(loadCoupons)
</script>

<template>
  <div class="coupon-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.back()">←</button>
      <span class="title">我的优惠券</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 未登录 -->
    <div v-if="!user.isLogin" class="empty-state">
      <p>请先登录</p>
    </div>

    <!-- 加载中 -->
    <div v-else-if="loading" class="empty-state">
      <p>加载中...</p>
    </div>

    <!-- 无优惠券 -->
    <div v-else-if="coupons.length === 0" class="empty-state">
      <div class="empty-icon">🎫</div>
      <p>暂无优惠券</p>
    </div>

    <!-- 优惠券列表 -->
    <div v-else class="coupon-list">
      <div
        v-for="coupon in coupons"
        :key="coupon.id"
        class="coupon-card"
        :class="statusClass(coupon.status)"
      >
        <div class="coupon-left">
          <div class="coupon-amount">{{ formatAmount(coupon) }}</div>
          <div class="coupon-min-spend" v-if="coupon.minSpend > 0">
            满¥{{ coupon.minSpend }}可用
          </div>
        </div>
        <div class="coupon-right">
          <div class="coupon-name">{{ coupon.name }}</div>
          <div class="coupon-date">{{ validDate(coupon) }}</div>
          <div class="coupon-status" :class="statusClass(coupon.status)">
            {{ statusText(coupon.status) }}
          </div>
        </div>
        <button v-if="coupon.status === 0" class="use-btn" @click="router.push('/shop')">去使用</button>
      </div>
    </div>

    <TabBar />
  </div>
</template>

<style scoped>
.coupon-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 70px;
}
.top-bar {
  position: sticky;
  top: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: white;
  border-bottom: 1px solid #eee;
}
.back-btn {
  background: none; border: none; font-size: 20px; cursor: pointer; width: 50px; text-align: left;
}
.title {
  font-size: 17px; font-weight: 600;
}
.empty-state {
  text-align: center; padding: 80px 20px; color: #999;
}
.empty-icon {
  font-size: 60px; margin-bottom: 16px;
}
.coupon-list {
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.coupon-card {
  display: flex;
  align-items: stretch;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
  position: relative;
}
.coupon-card::before {
  content: '';
  position: absolute;
  left: 35%;
  top: 0;
  bottom: 0;
  width: 2px;
  border-left: 2px dashed #eee;
}
.coupon-left {
  width: 35%;
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
}
.coupon-card.status-used .coupon-left {
  background: #bbb;
}
.coupon-card.status-expired .coupon-left {
  background: #ccc;
}
.coupon-amount {
  font-size: 28px;
  font-weight: bold;
}
.coupon-min-spend {
  font-size: 12px;
  margin-top: 4px;
  opacity: 0.9;
}
.coupon-right {
  flex: 1;
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 6px;
}
.coupon-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
}
.coupon-date {
  font-size: 12px;
  color: #999;
}
.coupon-status {
  font-size: 12px;
  font-weight: 600;
}
.status-unused { color: #2dbe60; }
.status-used { color: #999; }
.status-expired { color: #ccc; }
.go-shop-btn {
  margin-top: 20px;
  padding: 12px 40px;
  background: #2dbe60;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}
.go-shop-btn:hover {
  background: #22a34e;
}
.use-btn {
  align-self: center;
  margin-right: 14px;
  padding: 8px 16px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.2s;
  flex-shrink: 0;
}
.use-btn:hover {
  background: #c0392b;
}
</style>
