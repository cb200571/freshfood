<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { orderApi } from '@/api'
import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const router = useRouter()
const userStore = useUserStore()
const route = useRoute()

const orders = ref([])
const loading = ref(true)
const activeTab = ref(-1)  // 当前选中的标签，-1表示全部

// 订单状态映射
const statusMap = {
  0: { text: '待付款', color: '#ff9800' },
  1: { text: '已付款', color: '#4caf50' },
  2: { text: '已发货', color: '#2196f3' },
  3: { text: '已完成', color: '#9c27b0' },
  4: { text: '已取消', color: '#999' }
}
const tabs = [
  { name: '全部', status: -1 },
  { name: '待付款', status: 0 },
  { name: '待收货', status: 1 },
  { name: '待评价', status: 2 }
]
// 根据标签筛选订单
const filteredOrders = computed(() => {
  if (activeTab.value === -1) {
    return orders.value  // 全部
  }
  return orders.value.filter(order => order.status === activeTab.value)
})

// 切换标签
function switchTab(status) {
  activeTab.value = status
}
// 加载订单列表
async function loadOrders() {
  const userId = userStore.userId
  if (!userId) {
    alert('请先登录')
    router.push('/login')
    return
  }

  try {
    const result = await orderApi.getList(userId)
    if (result.code === 200) {
      orders.value = result.data || []
    }
  } catch (e) {
    console.error('加载订单失败', e)
  } finally {
    loading.value = false
  }
}

// 跳转到订单详情
function goDetail(order) {
  router.push(`/orderDetail?orderNo=${order.orderNo}`)
}

// 去支付
function goPay(order) {
  router.push(`/pay?orderNo=${order.orderNo}`)
}

// 取消订单
async function cancelOrder(order) {
  if (!confirm('确定要取消订单吗？')) return

  try {
    const result = await orderApi.cancel(order.orderNo)
    if (result.code === 200) {
      alert('订单已取消')
      loadOrders()  // 刷新列表
    } else {
      alert('取消失败：' + result.message)
    }
  } catch (e) {
    alert('取消失败，请重试')
  }
}

onMounted(() => {
  // 从URL获取状态参数
  const statusParam = route.query.status
  if (statusParam !== undefined) {
    activeTab.value = parseInt(statusParam)
  }
  loadOrders()
})
</script>

<template>
  <div class="order-list-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.back()">←</button>
      <span class="title">我的订单</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 标签页 -->
    <div class="order-tabs">
      <div
        v-for="tab in tabs"
        :key="tab.status"
        class="order-tab-item"
        :class="{ active: activeTab === tab.status }"
        @click="switchTab(tab.status)"
      >
        {{ tab.name }}
      </div>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">
      <p>加载中...</p>
    </div>

    <!-- 订单列表为空 -->
    <div v-else-if="filteredOrders.length === 0" class="empty-state">
      <div class="empty-icon">📋</div>
      <p class="empty-text">
        {{ activeTab === -1 ? '暂无订单' : `暂无${tabs.find(t => t.status === activeTab)?.name}订单` }}
      </p>
      <p class="empty-sub">快去挑选心仪的商品吧~</p>
      <button class="go-shop-btn" @click="router.push('/shop')">去逛逛</button>
    </div>

    <!-- 订单列表 -->
    <div v-else class="order-list">
      <div v-for="order in filteredOrders" :key="order.id" class="order-card">
        <div class="order-header" @click="goDetail(order)">
          <span class="order-no">订单号：{{ order.orderNo }}</span>
          <span class="order-status" :style="{ color: statusMap[order.status]?.color }">
              {{ statusMap[order.status]?.text }}
            </span>
        </div>

        <div class="order-info" @click="goDetail(order)">
          <div class="order-row">
            <span class="info-label">下单时间</span>
            <span class="info-value">{{ order.createTime }}</span>
          </div>
          <div class="order-row">
            <span class="info-label">收货人</span>
            <span class="info-value">{{ order.receiverName }}</span>
          </div>
          <div class="order-row">
            <span class="info-label">订单金额</span>
            <span class="info-value amount">¥{{ order.payAmount }}</span>
          </div>
        </div>

        <div class="order-actions">
          <button
            v-if="order.status === 0"
            class="action-btn cancel"
            @click="cancelOrder(order)"
          >
            取消订单
          </button>
          <button
            v-if="order.status === 0"
            class="action-btn pay"
            @click="goPay(order)"
          >
            去支付
          </button>
          <button
            class="action-btn detail"
            @click="goDetail(order)"
          >
            查看详情
          </button>
        </div>
      </div>
    </div>

    <!-- 底部 TabBar -->
    <TabBar />
  </div>
</template>

<style scoped>
.order-tabs {
  display: flex;
  background: white;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 48px;
  z-index: 99;
}

.order-tab-item {
  flex: 1;
  text-align: center;
  padding: 12px 0;
  font-size: 14px;
  color: #666;
  cursor: pointer;
  position: relative;
}

.order-tab-item.active {
  color: #e74c3c;
  font-weight: 600;
}

.order-tab-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 30px;
  height: 3px;
  background: #e74c3c;
  border-radius: 2px;
}
.order-list-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 80px;
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
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  width: 50px;
  text-align: left;
}

.title {
  font-size: 17px;
  font-weight: 600;
}

.loading-state {
  display: flex;
  justify-content: center;
  padding: 60px;
  color: #999;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80px 20px;
}

.empty-icon {
  font-size: 80px;
  margin-bottom: 20px;
}

.empty-text {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.empty-sub {
  font-size: 14px;
  color: #999;
  margin-bottom: 30px;
}

.go-shop-btn {
  padding: 12px 40px;
  background: #2dbe60;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.order-list {
  padding: 16px;
}

.order-card {
  background: white;
  border-radius: 12px;
  margin-bottom: 16px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
}

.order-no {
  font-size: 13px;
  color: #666;
}

.order-status {
  font-size: 14px;
  font-weight: 600;
}

.order-info {
  padding: 14px 16px;
  cursor: pointer;
}

.order-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
  font-size: 14px;
}

.info-label {
  color: #999;
}

.info-value {
  color: #333;
}

.info-value.amount {
  font-weight: bold;
  color: #e74c3c;
}

.order-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 14px 16px;
  border-top: 1px solid #f5f5f5;
}

.action-btn {
  padding: 8px 16px;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
}

.action-btn.cancel {
  border: 1px solid #ddd;
  background: white;
  color: #666;
}

.action-btn.pay {
  border: none;
  background: #e74c3c;
  color: white;
}

.action-btn.detail {
  border: 1px solid #ddd;
  background: white;
  color: #666;
}
</style>
