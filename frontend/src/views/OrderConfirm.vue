<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { orderApi, addressApi, couponApi } from '@/api'// 后端请求接口
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

// 订单数据
const orderItems = ref([])
const totalPrice = ref(0)
const loading = ref(true)

// 收货地址
const currentAddress = ref(null)
const addressList = ref([])
const showAddressModal = ref(false)

// 新增地址表单
const showAddAddress = ref(false)
const newAddress = ref({
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detailAddress: '',
  isDefault: 0
})
const savingAddress = ref(false)

// 秒杀相关
const seckillActivityId = ref(null)

// 优惠券相关
const couponList = ref([])
const selectedCoupon = ref(null)
const showCouponModal = ref(false)
const discountAmount = ref(0)
const actualPay = computed(() => {
  const pay = totalPrice.value - discountAmount.value
  return pay > 0 ? pay : 0
})

// 加载订单商品
function loadOrderItems() {
  // 从路由参数或购物车获取商品信息
  const itemsJson = route.query.items
  if (itemsJson) {
    try {
      orderItems.value = JSON.parse(itemsJson)
      calculateTotal()
    } catch (e) {
      console.error('解析商品信息失败', e)
    }
  }
  // 读取秒杀活动ID
  if (route.query.seckillActivityId) {
    seckillActivityId.value = Number(route.query.seckillActivityId)
  }
  loading.value = false
}

// 计算总价
function calculateTotal() {
  totalPrice.value = orderItems.value.reduce((sum, item) => {
    return sum + (item.price * item.quantity)
  }, 0)
}

// 加载用户地址
async function loadUserAddress() {
  const userId = userStore.userId
  if (!userId) return

  try {
    const defaultResult = await addressApi.getDefault(userId)
    if (defaultResult.code === 200 && defaultResult.data) {
      currentAddress.value = defaultResult.data
    } else {
      const listResult = await addressApi.getList(userId)
      if (listResult.code === 200 && listResult.data && listResult.data.length > 0) {
        currentAddress.value = listResult.data[0]
      }
    }
  } catch (e) {
    console.error('加载地址失败', e)
  }
}

// 打开地址选择弹窗
async function openAddressModal() {
  const userId = userStore.userId
  if (!userId) return

  try {
    const result = await addressApi.getList(userId)
    if (result.code === 200) {
      addressList.value = result.data || []
    }
  } catch (e) {
    console.error('加载地址列表失败', e)
  }
  showAddressModal.value = true
}

// 选择地址
function selectAddress(address) {
  currentAddress.value = address
  showAddressModal.value = false
}

// 打开新增地址弹窗
function openAddAddress() {
  newAddress.value = {
    receiverName: '',
    receiverPhone: '',
    province: '',
    city: '',
    district: '',
    detailAddress: '',
    isDefault: 0
  }
  showAddAddress.value = true//显示新增地址弹窗
}

// 保存新地址
async function saveNewAddress() {
  if (!newAddress.value.receiverName.trim()) {
    alert('请输入收件人姓名')
    return
  }
  if (!/^1[3-9]\d{9}$/.test(newAddress.value.receiverPhone)) {
    alert('请输入正确的手机号')
    return
  }
  if (!newAddress.value.province.trim() || !newAddress.value.city.trim()) {
    alert('请输入省市区')
    return
  }
  if (!newAddress.value.detailAddress.trim()) {
    alert('请输入详细地址')
    return
  }

  savingAddress.value = true
  try {
    const result = await addressApi.add({
      ...newAddress.value,
      userId: userStore.userId
    })
    if (result.code === 200) {
      alert('✅ 地址添加成功')
      showAddAddress.value = false
      // 刷新地址列表
      await loadUserAddress()
      await openAddressModal()
    } else {
      alert('添加失败：' + (result.message || '请重试'))
    }
  } catch (e) {
    alert('网络错误，请重试')
  } finally {
    savingAddress.value = false
  }
}

// 格式化地址
function formatAddress(address) {
  if (!address) return ''
  return `${address.province}${address.city}${address.district}${address.detailAddress}`
}

// 加载可用优惠券
async function loadCoupons() {
  const userId = userStore.userId
  if (!userId) return
  try {
    const res = await couponApi.getMyCoupons(userId)
    if (res.code === 200) {
      // 只显示未使用且满足最低消费的优惠券
      const list = (res.data || []).filter(c => c.status === 0 && totalPrice.value >= c.minSpend)
      couponList.value = list
    }
  } catch (e) {
    console.error('加载优惠券失败', e)
  }
}

// 打开优惠券选择弹窗
function openCouponModal() {
  showCouponModal.value = true
}

// 选择优惠券
function selectCoupon(coupon) {
  selectedCoupon.value = coupon
  showCouponModal.value = false
  if (coupon.type === 1) {
    discountAmount.value = coupon.amount
  } else if (coupon.type === 2) {
    discountAmount.value = totalPrice.value * (1 - coupon.amount)
  }
}

// 移除优惠券
function removeCoupon() {
  selectedCoupon.value = null
  discountAmount.value = 0
}

// 提交订单
async function submitOrder() {
  if (!currentAddress.value) {
    alert('请选择收货地址')
    return
  }
  const userId = userStore.userId
  if (!userId) {
    alert('请登录')
    router.push('/login')
    return // 必须return，阻止后续代码执行

  }

  if (orderItems.value.length === 0) {
    alert('请选择商品')
    return
  }

  const orderData = {
    userId: userStore.userId,
    receiverName: currentAddress.value.receiverName,
    receiverPhone: currentAddress.value.receiverPhone,
    receiverAddress: formatAddress(currentAddress.value),
    couponUserId: selectedCoupon.value ? selectedCoupon.value.id : null,
    seckillActivityId: seckillActivityId.value,
    items: orderItems.value.map(item => ({
      spuId: item.spuId,
      skuId: item.skuId,
      productName: item.name,
      skuName: item.skuName,
      productImage: item.image,
      price: item.price,
      quantity: item.quantity
    }))
  }

  try {
    const result = await orderApi.create(orderData)
    if (result.code === 200) {
      alert('✅ 下单成功！')
      // 跳转到支付页面
      router.push(`/pay?orderNo=${result.data.orderNo}`)
    } else {
      alert('下单失败：' + result.message)
    }
  } catch (e) {
    alert('下单失败，请重试')
  }
}

onMounted(() => {
  loadOrderItems()
  loadUserAddress()
  loadCoupons()
})
</script>

<template>
  <div class="order-confirm-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.back()">←</button>
      <span class="title">确认订单</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">
      <p>加载中...</p>
    </div>

    <!-- 订单内容 -->
    <div v-else class="content">
      <!-- 收货地址 -->
      <div class="address-bar" @click="openAddressModal">
        <div class="address-icon">📍</div>
        <div class="address-info">
          <div class="address-label">配送至：</div>
          <div class="address-text" v-if="currentAddress">
            {{ currentAddress.receiverName }} {{ currentAddress.receiverPhone }}
            <br>
            <span class="address-detail">{{ formatAddress(currentAddress) }}</span>
          </div>
          <div class="address-text" v-else>
            点击选择收货地址
          </div>
        </div>
        <div class="address-arrow">›</div>
      </div>

      <!-- 商品列表 -->
      <div class="items-section">
        <div class="section-title">商品清单</div>
        <div class="item-list">
          <div v-for="item in orderItems" :key="item.skuId" class="item-card">
            <div class="item-image">
              <img v-if="item.image" :src="item.image" :alt="item.name">
              <span v-else style="font-size: 40px;">📦</span>
            </div>
            <div class="item-info">
              <div class="item-name">{{ item.name }}</div>
              <div class="item-sku">{{ item.skuName }}</div>
              <div class="item-price-qty">
                <span class="item-price">¥{{ item.price }}</span>
                <span class="item-qty">x{{ item.quantity }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 优惠券 -->
      <div class="coupon-section" @click="openCouponModal">
        <div class="coupon-bar">
          <span class="coupon-icon">🎫</span>
          <span class="coupon-placeholder" v-if="!selectedCoupon">选择优惠券</span>
          <span class="coupon-selected" v-else>
            -¥{{ discountAmount.toFixed(2) }} · {{ selectedCoupon.name }}
          </span>
          <span class="coupon-arrow">›</span>
        </div>
        <div class="coupon-tip" v-if="selectedCoupon">
          <button class="remove-coupon" @click.stop="removeCoupon">移除</button>
        </div>
      </div>

      <!-- 订单金额 -->
      <div class="amount-section">
        <div class="amount-row">
          <span>商品金额</span>
          <span>¥{{ totalPrice.toFixed(2) }}</span>
        </div>
        <div class="amount-row">
          <span>运费</span>
          <span>¥0.00</span>
        </div>
        <div class="amount-row" v-if="discountAmount > 0">
          <span>优惠券</span>
          <span style="color:#e74c3c;">-¥{{ discountAmount.toFixed(2) }}</span>
        </div>
        <div class="amount-row total">
          <span>合计</span>
          <span class="total-price">¥{{ actualPay.toFixed(2) }}</span>
        </div>
      </div>
    </div>

    <!-- 底部提交栏 -->
    <div class="bottom-bar">
      <div class="total-info">
        <span class="total-label">合计：</span>
        <span class="total-value">¥{{ actualPay.toFixed(2) }}</span>
      </div>
      <button class="submit-btn" @click="submitOrder" :disabled="orderItems.length === 0">
        提交订单
      </button>
    </div>

    <!-- 地址选择弹窗 -->
    <div class="modal-overlay" v-if="showAddressModal" @click.self="showAddressModal = false">
      <div class="address-modal">
        <div class="modal-header">
          <div class="modal-title">选择收货地址</div>
          <button class="add-address-btn" @click="openAddAddress">+ 新增地址</button>
          <button class="modal-close" @click="showAddressModal = false">✕</button>
        </div>

        <div class="modal-body">
          <div v-if="addressList.length === 0" class="no-address">
            <p>暂无收货地址</p>
            <p>请先去"我的"页面添加地址</p>
          </div>

          <div v-else class="address-list">
            <div
              v-for="addr in addressList"
              :key="addr.id"
              class="address-item"
              :class="{ active: currentAddress?.id === addr.id }"
              @click="selectAddress(addr)"
            >
              <div class="address-info">
                <div class="address-name-phone">
                  <span class="address-name">{{ addr.receiverName }}</span>
                  <span class="address-phone">{{ addr.receiverPhone }}</span>
                  <span v-if="addr.isDefault === 1" class="default-tag">默认</span>
                </div>
                <div class="address-detail">
                  {{ addr.province }}{{ addr.city }}{{ addr.district }}{{ addr.detailAddress }}
                </div>
              </div>
              <div class="address-check" v-if="currentAddress?.id === addr.id">✓</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 优惠券选择弹窗 -->
    <div class="modal-overlay" v-if="showCouponModal" @click.self="showCouponModal = false">
      <div class="address-modal">
        <div class="modal-header">
          <div class="modal-title">选择优惠券</div>
          <button class="modal-close" @click="showCouponModal = false">✕</button>
        </div>
        <div class="modal-body">
          <div v-if="couponList.length === 0" class="no-address">
            <p>暂无可用优惠券</p>
          </div>
          <div v-else class="address-list">
            <div
              v-for="c in couponList"
              :key="c.id"
              class="address-item"
              :class="{ active: selectedCoupon?.id === c.id }"
              @click="selectCoupon(c)"
            >
              <div class="address-info">
                <div class="address-name-phone">
                  <span class="address-name" style="color:#e74c3c;">
                    {{ c.type === 2 ? `${c.amount*10}折` : `¥${c.amount}` }}
                  </span>
                  <span v-if="c.minSpend > 0" class="default-tag">满¥{{ c.minSpend }}可用</span>
                </div>
                <div style="font-size:14px;margin-top:4px;">{{ c.name }}</div>
              </div>
              <div class="address-check" v-if="selectedCoupon?.id === c.id">✓</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 新增地址弹窗 -->
    <div class="modal-overlay" v-if="showAddAddress" @click.self="showAddAddress = false">
      <div class="address-modal">
        <div class="modal-header">
          <div class="modal-title">新增收货地址</div>
          <button class="modal-close" @click="showAddAddress = false">✕</button>
        </div>

        <div class="modal-body">
          <div class="address-form">
            <div class="form-row">
              <label>收件人</label>
              <input type="text" v-model="newAddress.receiverName" placeholder="请输入收件人姓名">
            </div>
            <div class="form-row">
              <label>手机号</label>
              <input type="tel" v-model="newAddress.receiverPhone" placeholder="请输入手机号">
            </div>
            <div class="form-row">
              <label>省份</label>
              <input type="text" v-model="newAddress.province" placeholder="如：广东省">
            </div>
            <div class="form-row">
              <label>城市</label>
              <input type="text" v-model="newAddress.city" placeholder="如：深圳市">
            </div>
            <div class="form-row">
              <label>区县</label>
              <input type="text" v-model="newAddress.district" placeholder="如：南山区">
            </div>
            <div class="form-row">
              <label>详细地址</label>
              <input type="text" v-model="newAddress.detailAddress" placeholder="街道、门牌号等">
            </div>
            <div class="form-row checkbox-row">
              <label>
                <input type="checkbox" v-model="newAddress.isDefault" :true-value="1" :false-value="0">
                设为默认地址
              </label>
            </div>
            <button class="save-btn" @click="saveNewAddress" :disabled="savingAddress">
              {{ savingAddress ? '保存中...' : '保存地址' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.order-confirm-page {
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
  padding: 10px 16px;
}

/* 收货地址 */
.address-bar {
  display: flex;
  align-items: center;
  padding: 14px 16px;
  background: white;
  border-radius: 12px;
  margin-bottom: 10px;
  cursor: pointer;
}

.address-icon {
  font-size: 20px;
  margin-right: 10px;
}

.address-info {
  flex: 1;
}

.address-label {
  font-size: 12px;
  color: #999;
}

.address-text {
  font-size: 14px;
  color: #333;
  margin-top: 2px;
}

.address-detail {
  font-size: 12px;
  color: #999;
}

.address-arrow {
  font-size: 20px;
  color: #ccc;
}

/* 商品列表 */
.items-section {
  background: white;
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 10px;
}

.section-title {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 12px;
}

.item-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.item-card {
  display: flex;
  align-items: center;
}

.item-image {
  width: 70px;
  height: 70px;
  border-radius: 8px;
  overflow: hidden;
  margin-right: 12px;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.item-info {
  flex: 1;
}

.item-name {
  font-size: 14px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
}

.item-sku {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}

.item-price-qty {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.item-price {
  font-size: 15px;
  font-weight: bold;
  color: #e74c3c;
}

.item-qty {
  font-size: 13px;
  color: #666;
}

/* 订单金额 */
.amount-section {
  background: white;
  border-radius: 12px;
  padding: 14px 16px;
}

.amount-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  font-size: 14px;
  color: #333;
}

.amount-row.total {
  border-top: 1px solid #eee;
  margin-top: 8px;
  padding-top: 12px;
}

.total-price {
  font-size: 18px;
  font-weight: bold;
  color: #e74c3c;
}

/* 底部提交栏 */
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background: white;
  border-top: 1px solid #eee;
  z-index: 100;
}

.total-info {
  flex: 1;
}

.total-label {
  font-size: 14px;
  color: #333;
}

.total-value {
  font-size: 20px;
  font-weight: bold;
  color: #e74c3c;
}

.submit-btn {
  padding: 12px 30px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.submit-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

/* 地址弹窗 */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.address-modal {
  width: 100%;
  max-height: 70vh;
  background: white;
  border-radius: 16px 16px 0 0;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  border-bottom: 1px solid #f0f0f0;
}

.add-address-btn {
  background: #e74c3c;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
  margin-right: 10px;
}

.modal-title {
  font-size: 17px;
  font-weight: 600;
}

.modal-close {
  background: none;
  border: none;
  font-size: 20px;
  color: #999;
  cursor: pointer;
}

.modal-body {
  padding: 16px;
}

.no-address {
  text-align: center;
  padding: 40px 0;
  color: #999;
}

.address-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.address-item {
  display: flex;
  align-items: center;
  padding: 14px;
  border: 1px solid #eee;
  border-radius: 10px;
  cursor: pointer;
}

.address-item.active {
  border-color: #e74c3c;
  background: #fff5f5;
}

.address-item .address-info {
  flex: 1;
}

.address-name-phone {
  margin-bottom: 6px;
}

.address-name {
  font-size: 15px;
  font-weight: 600;
  margin-right: 10px;
}

.address-phone {
  font-size: 14px;
  color: #666;
}

.default-tag {
  display: inline-block;
  background: #e74c3c;
  color: white;
  font-size: 11px;
  padding: 2px 6px;
  border-radius: 4px;
  margin-left: 8px;
}

.address-check {
  color: #e74c3c;
  font-size: 20px;
  font-weight: bold;
  margin-left: 10px;
}

/* 地址表单 */
.address-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.form-row {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-row label {
  font-size: 13px;
  color: #555;
  font-weight: 500;
}

.form-row input[type="text"],
.form-row input[type="tel"] {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}

.form-row input:focus {
  border-color: #e74c3c;
}

.checkbox-row {
  flex-direction: row;
  align-items: center;
}

.checkbox-row label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.checkbox-row input[type="checkbox"] {
  width: 16px;
  height: 16px;
  accent-color: #e74c3c;
}

.save-btn {
  width: 100%;
  padding: 12px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  margin-top: 8px;
}

.save-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

/* 优惠券 */
.coupon-section {
  background: white;
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 10px;
  cursor: pointer;
}
.coupon-bar {
  display: flex;
  align-items: center;
  gap: 8px;
}
.coupon-icon {
  font-size: 18px;
}
.coupon-placeholder {
  flex: 1;
  font-size: 14px;
  color: #999;
}
.coupon-selected {
  flex: 1;
  font-size: 14px;
  color: #e74c3c;
  font-weight: 600;
}
.coupon-arrow {
  color: #ccc;
  font-size: 20px;
}
.coupon-tip {
  margin-top: 6px;
  display: flex;
  justify-content: flex-end;
}
.remove-coupon {
  background: none;
  border: none;
  color: #999;
  font-size: 12px;
  cursor: pointer;
  text-decoration: underline;
}
.remove-coupon:hover {
  color: #e74c3c;
}
</style>
