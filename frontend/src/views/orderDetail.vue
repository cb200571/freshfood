<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { orderApi } from '@/api'

const route = useRoute()
const router = useRouter()
const order = ref(null)
const items = ref([])

const statusMap = {
  0: { text: '待付款', color: '#ff9800' },
  1: { text: '已付款', color: '#4caf50' },
  2: { text: '已发货', color: '#2196f3' },
  3: { text: '已完成', color: '#9c27b0' },
  4: { text: '已取消', color: '#999' }
}

async function loadDetail() {
  const orderNo = route.query.orderNo
  if (!orderNo) return
  try {
    const res = await orderApi.getDetail(orderNo)
    if (res.code === 200) order.value = res.data
    const itemRes = await orderApi.getItems(orderNo)
    if (itemRes.code === 200) items.value = itemRes.data || []
  } catch (e) {
    console.error(e)
  }
}

// 去支付
function handlePay() {
  router.push(`/pay?orderNo=${order.value.orderNo}`)
}

// 取消订单
async function handleCancel() {
  if (!confirm('确定要取消订单吗？')) return
  try {
    const result = await orderApi.cancel(order.value.orderNo)
    if (result.code === 200) {
      alert('订单已取消')
      loadDetail() // 刷新
    } else {
      alert('取消失败：' + result.message)
    }
  } catch (e) {
    alert('取消失败，请重试')
  }
}

onMounted(() => loadDetail())
</script>

<template>
  <div class="detail-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.back()">←</button>
      <span class="title">订单详情</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 加载中 -->
    <div v-if="!order" class="loading-state">
      <p>加载中...</p>
    </div>

    <template v-else>
      <!-- 订单状态 -->
      <div class="status-section">
        <span class="status-text" :style="{ color: statusMap[order.status]?.color }">
          {{ statusMap[order.status]?.text }}
        </span>
      </div>

      <!-- 收货信息 -->
      <div class="info-card">
        <div class="card-title">收货信息</div>
        <div class="info-row">
          <span class="label">收货人</span>
          <span class="value">{{ order.receiverName }}</span>
        </div>
        <div class="info-row">
          <span class="label">手机号</span>
          <span class="value">{{ order.receiverPhone }}</span>
        </div>
        <div class="info-row">
          <span class="label">收货地址</span>
          <span class="value">{{ order.receiverAddress }}</span>
        </div>
      </div>

      <!-- 商品列表 -->
      <div class="info-card">
        <div class="card-title">商品信息</div>
        <div v-for="item in items" :key="item.id" class="product-item">
          <img :src="item.productImage" class="product-img" />
          <div class="product-info">
            <div class="product-name">{{ item.productName }}</div>
            <div class="product-sku">{{ item.skuName }}</div>
            <div class="product-bottom">
              <span class="product-price">¥{{ item.price }}</span>
              <span class="product-qty">×{{ item.quantity }}</span>
            </div>
          </div>
        </div>
        <div v-if="items.length === 0" class="no-items">暂无商品</div>
      </div>

      <!-- 订单信息 -->
      <div class="info-card">
        <div class="card-title">订单信息</div>
        <div class="info-row">
          <span class="label">订单号</span>
          <span class="value">{{ order.orderNo }}</span>
        </div>
        <div class="info-row">
          <span class="label">下单时间</span>
          <span class="value">{{ order.createTime }}</span>
        </div>
        <div v-if="order.payTime" class="info-row">
          <span class="label">支付时间</span>
          <span class="value">{{ order.payTime }}</span>
        </div>
      </div>

      <!-- 金额汇总 -->
      <div class="info-card">
        <div class="info-row">
          <span class="label">商品总额</span>
          <span class="value">¥{{ order.totalAmount }}</span>
        </div>
        <div class="info-row">
          <span class="label">运费</span>
          <span class="value">¥{{ order.freightAmount }}</span>
        </div>
        <div class="info-row total-row">
          <span class="label">实付金额</span>
          <span class="value total-amount">¥{{ order.payAmount }}</span>
        </div>
      </div>

      <!-- 操作按钮 -->
      <div class="action-bar" v-if="order.status === 0">
        <button class="btn-cancel" @click="handleCancel">取消订单</button>
        <button class="btn-pay" @click="handlePay">去支付</button>
      </div>
    </template>
  </div>
</template>

<style scoped>
.detail-page {
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

.status-section {
  background: white;
  padding: 20px 16px;
  text-align: center;
}

.status-text {
  font-size: 20px;
  font-weight: bold;
}

.info-card {
  background: white;
  margin: 12px 16px;
  border-radius: 12px;
  padding: 16px;
}

.card-title {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  font-size: 14px;
}

.label {
  color: #999;
}

.value {
  color: #333;
}

.total-row {
  border-top: 1px solid #f0f0f0;
  padding-top: 12px;
  margin-top: 4px;
}

.total-amount {
  font-size: 16px;
  font-weight: bold;
  color: #e74c3c;
}

.product-item {
  display: flex;
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}

.product-item:last-child {
  border-bottom: none;
}

.product-img {
  width: 70px;
  height: 70px;
  border-radius: 8px;
  object-fit: cover;
  margin-right: 12px;
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.product-name {
  font-size: 14px;
  color: #333;
}

.product-sku {
  font-size: 12px;
  color: #999;
}

.product-bottom {
  display: flex;
  justify-content: space-between;
}

.product-price {
  font-size: 14px;
  font-weight: 600;
  color: #e74c3c;
}

.product-qty {
  font-size: 13px;
  color: #999;
}

.no-items {
  text-align: center;
  color: #999;
  padding: 20px;
}

.action-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  gap: 12px;
  padding: 12px 16px;
  background: white;
  border-top: 1px solid #eee;
}

.btn-cancel {
  flex: 1;
  padding: 12px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 25px;
  font-size: 15px;
  cursor: pointer;
}

.btn-pay {
  flex: 2;
  padding: 12px;
  border: none;
  background: #e74c3c;
  color: white;
  border-radius: 25px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
}
</style>
