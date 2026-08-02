<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { orderApi } from '@/api'

const route = useRoute()
const router = useRouter()

const orderNo = ref('')
const orderInfo = ref(null)
const loading = ref(true)
const paying = ref(false)

// 加载订单信息
async function loadOrderInfo() {
  orderNo.value = route.query.orderNo
  if (!orderNo.value) {
    alert('订单号不存在')
    router.back()
    return
  }

  try {
    const result = await orderApi.getDetail(orderNo.value)
    if (result.code === 200) {
      orderInfo.value = result.data
    } else {
      alert('订单不存在')
      router.back()
    }
  } catch (e) {
    console.error('加载订单失败', e)
  } finally {
    loading.value = false
  }
}

// 模拟支付
async function handlePay() {
  if (paying.value) return

  paying.value = true
  try {
    const result = await orderApi.pay(orderNo.value)
    if (result.code === 200) {
      alert('✅ 支付成功！')
      router.push('/orderList')
    } else {
      alert('支付失败：' + result.message)
    }
  } catch (e) {
    alert('支付失败，请重试')
  } finally {
    paying.value = false
  }
}

// 取消订单
async function handleCancel() {
  if (!confirm('确定要取消订单吗？')) return

  try {
    const result = await orderApi.cancel(orderNo.value)
    if (result.code === 200) {
      alert('订单已取消')
      router.push('/orderList')
    } else {
      alert('取消失败：' + result.message)
    }
  } catch (e) {
    alert('取消失败，请重试')
  }
}

onMounted(() => {
  loadOrderInfo()
})
</script>

<template>
  <div class="pay-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.push('/orderList')">←</button>
      <span class="title">订单支付</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">
      <p>加载中...</p>
    </div>

    <!-- 支付内容 -->
    <div v-else-if="orderInfo" class="content">
      <!-- 支付金额 -->
      <div class="pay-amount">
        <div class="amount-label">支付金额</div>
        <div class="amount-value">¥{{ orderInfo.payAmount }}</div>
      </div>

      <!-- 订单信息 -->
      <div class="order-info">
        <div class="info-row">
          <span class="info-label">订单号</span>
          <span class="info-value">{{ orderInfo.orderNo }}</span>
        </div>
        <div class="info-row">
          <span class="info-label">下单时间</span>
          <span class="info-value">{{ orderInfo.createTime }}</span>
        </div>
        <div class="info-row">
          <span class="info-label">收货人</span>
          <span class="info-value">{{ orderInfo.receiverName }}</span>
        </div>
        <div class="info-row">
          <span class="info-label">收货地址</span>
          <span class="info-value">{{ orderInfo.receiverAddress }}</span>
        </div>
      </div>

      <!-- 支付方式 -->
      <div class="pay-method">
        <div class="method-title">支付方式</div>
        <div class="method-item active">
          <span class="method-icon">💳</span>
          <span class="method-name">模拟支付</span>
          <span class="method-check">✓</span>
        </div>
      </div>
    </div>

    <!-- 底部支付按钮 -->
    <div class="bottom-bar" v-if="orderInfo">
      <button class="cancel-btn" @click="handleCancel">取消订单</button>
      <button class="pay-btn" @click="handlePay" :disabled="paying">
        {{ paying ? '支付中...' : '立即支付' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.pay-page {
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

.content {
  padding: 16px;
}

/* 支付金额 */
.pay-amount {
  background: linear-gradient(135deg, #e74c3c, #ff6b6b);
  border-radius: 16px;
  padding: 30px;
  text-align: center;
  color: white;
  margin-bottom: 16px;
}

.amount-label {
  font-size: 14px;
  opacity: 0.9;
  margin-bottom: 10px;
}

.amount-value {
  font-size: 36px;
  font-weight: bold;
}

/* 订单信息 */
.order-info {
  background: white;
  border-radius: 12px;
  padding: 16px;
  margin-bottom: 16px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  font-size: 14px;
  border-bottom: 1px solid #f5f5f5;
}

.info-row:last-child {
  border-bottom: none;
}

.info-label {
  color: #999;
}

.info-value {
  color: #333;
  text-align: right;
  flex: 1;
  margin-left: 20px;
}

/* 支付方式 */
.pay-method {
  background: white;
  border-radius: 12px;
  padding: 16px;
}

.method-title {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 12px;
}

.method-item {
  display: flex;
  align-items: center;
  padding: 14px;
  border: 1px solid #eee;
  border-radius: 10px;
  cursor: pointer;
}

.method-item.active {
  border-color: #e74c3c;
  background: #fff5f5;
}

.method-icon {
  font-size: 24px;
  margin-right: 12px;
}

.method-name {
  flex: 1;
  font-size: 15px;
}

.method-check {
  color: #e74c3c;
  font-size: 18px;
  font-weight: bold;
}

/* 底部支付按钮 */
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  gap: 12px;
  padding: 12px 16px;
  background: white;
  border-top: 1px solid #eee;
  z-index: 100;
}

.cancel-btn {
  flex: 1;
  padding: 14px;
  border: 1px solid #ddd;
  border-radius: 25px;
  background: white;
  color: #666;
  font-size: 16px;
  cursor: pointer;
}

.pay-btn {
  flex: 2;
  padding: 14px;
  border: none;
  border-radius: 25px;
  background: #e74c3c;
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.pay-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}
</style>
