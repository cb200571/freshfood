<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const router = useRouter()
const user = useUserStore()

// 购物车数据
const cartItems = ref([])
const loading = ref(true)

// 全选状态
const isAllSelected = ref(false)

// 计算选中的商品
const selectedItems = computed(() => {
  return cartItems.value.filter(item => item.selected)
})

// 计算总价
const totalPrice = computed(() => {
  return selectedItems.value.reduce((sum, item) => {
    return sum + (item.price * item.quantity)
  }, 0)
})

// 计算选中商品数量
const selectedCount = computed(() => {
  return selectedItems.value.reduce((sum, item) => sum + item.quantity, 0)
})

// 加载购物车数据
function loadCart() {
  loading.value = true
  try {
    const savedCart = localStorage.getItem('cart')
    if (savedCart) {
      const parsed = JSON.parse(savedCart)
      // 给每个商品添加 selected 状态，默认选中
      cartItems.value = parsed.map(item => ({
        ...item,
        selected: true
      }))
    } else {
      cartItems.value = []
    }
    updateAllSelected()
  } catch (e) {
    console.error('加载购物车失败', e)
    cartItems.value = []
  } finally {
    loading.value = false
  }
}

// 保存购物车到 localStorage
function saveCart() {
  // 保存时不包含 selected 状态
  const toSave = cartItems.value.map(({ selected, ...rest }) => rest)
  localStorage.setItem('cart', JSON.stringify(toSave))
}

// 切换单个商品选中状态
function toggleItem(item) {
  item.selected = !item.selected
  updateAllSelected()
}

// 切换全选
function toggleAll() {
  isAllSelected.value = !isAllSelected.value
  cartItems.value.forEach(item => {
    item.selected = isAllSelected.value
  })
}

// 更新全选状态
function updateAllSelected() {
  isAllSelected.value = cartItems.value.length > 0 && cartItems.value.every(item => item.selected)
}

// 增加数量
function increaseQuantity(item) {
  if (item.quantity < 99) {
    item.quantity++
    saveCart()
  }
}

// 减少数量
function decreaseQuantity(item) {
  if (item.quantity > 1) {
    item.quantity--
    saveCart()
  }
}

// 删除商品
function removeItem(index) {
  if (confirm('确定要删除这个商品吗？')) {
    cartItems.value.splice(index, 1)
    saveCart()
    updateAllSelected()
  }
}

// 清空购物车
function clearCart() {
  if (confirm('确定要清空购物车吗？')) {
    cartItems.value = []
    saveCart()
  }
}

// 结算
function checkout() {
  if (selectedItems.value.length === 0) {
    alert('请先选择要结算的商品')
    return
  }

  if (!user.isLogin) {
    const goToLogin = confirm('请先登录，是否前往登录页面？')
    if (goToLogin) {
      router.push('/login')
    }
    return
  }

  // 准备订单商品数据
  const orderItems = selectedItems.value.map(item => ({
    spuId: item.spuId,
    skuId: item.skuId,
    name: item.name,
    skuName: item.skuName,
    image: item.image,
    price: item.price,
    quantity: item.quantity
  }))

  // 检查是否包含秒杀商品
  const seckillItem = selectedItems.value.find(item => item.seckillActivityId)
  const query = { items: JSON.stringify(orderItems) }
  if (seckillItem) {
    query.seckillActivityId = seckillItem.seckillActivityId
  }

  // 跳转到订单确认页面
  router.push({ path: '/orderConfirm', query })
}

// 跳转到商品详情
function goDetail(item) {
  router.push(`/product/${item.spuId}`)
}

onMounted(() => {
  loadCart()
})
</script>

<template>
  <div class="cart-page">
    <!-- 顶部导航 -->
    <div class="top-bar">
      <span class="title">购物车</span>
      <button v-if="cartItems.length > 0" class="clear-btn" @click="clearCart">清空</button>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">
      <p>加载中...</p>
    </div>

    <!-- 购物车为空 -->
    <div v-else-if="cartItems.length === 0" class="empty-cart">
      <div class="empty-icon">🛒</div>
      <p class="empty-text">购物车是空的</p>
      <p class="empty-sub">快去挑选心仪的商品吧~</p>
      <button class="go-shop-btn" @click="router.push('/shop')">去逛逛</button>
    </div>

    <!-- 购物车列表 -->
    <div v-else class="cart-list">
      <div
        v-for="(item, index) in cartItems"
        :key="item.skuId"
        class="cart-item"
      >
        <!-- 选择框 -->
        <div class="item-checkbox" @click="toggleItem(item)">
          <div class="checkbox" :class="{ checked: item.selected }">
            <span v-if="item.selected">✓</span>
          </div>
        </div>

        <!-- 商品图片 -->
        <div class="item-image" @click="goDetail(item)">
          <img v-if="item.image" :src="item.image" :alt="item.name">
          <span v-else style="font-size: 40px;">📦</span>
        </div>

        <!-- 商品信息 -->
        <div class="item-info">
          <div class="item-name" @click="goDetail(item)">{{ item.name }}</div>
          <div class="item-sku">{{ item.skuName }}</div>
          <div class="item-price">¥{{ item.price }}</div>

          <!-- 数量控制 -->
          <div class="quantity-control">
            <button @click="decreaseQuantity(item)" :disabled="item.quantity <= 1">−</button>
            <span>{{ item.quantity }}</span>
            <button @click="increaseQuantity(item)" :disabled="item.quantity >= 99">+</button>
          </div>
        </div>

        <!-- 删除按钮 -->
        <button class="item-delete" @click="removeItem(index)">✕</button>
      </div>
    </div>

    <!-- 底部结算栏 -->
    <div v-if="cartItems.length > 0" class="bottom-bar">
      <div class="select-all" @click="toggleAll">
        <div class="checkbox" :class="{ checked: isAllSelected }">
          <span v-if="isAllSelected">✓</span>
        </div>
        <span>全选</span>
      </div>

      <div class="total-info">
        <div class="total-price">
          合计：<span class="price-value">¥{{ totalPrice.toFixed(2) }}</span>
        </div>
        <div class="total-count">已选 {{ selectedCount }} 件</div>
      </div>

      <button
        class="checkout-btn"
        :disabled="selectedItems.length === 0"
        @click="checkout"
      >
        结算
      </button>
    </div>

    <!-- 底部 TabBar -->
    <TabBar />
  </div>
</template>

<style scoped>
.cart-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 130px;
}

/* 顶部导航 */
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

.title {
  font-size: 17px;
  font-weight: 600;
}

.clear-btn {
  background: none;
  border: none;
  font-size: 14px;
  color: #e74c3c;
  cursor: pointer;
}

/* 加载中 */
.loading-state {
  display: flex;
  justify-content: center;
  padding: 60px;
  color: #999;
}

/* 空购物车 */
.empty-cart {
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

/* 购物车列表 */
.cart-list {
  padding: 10px 16px;
}

.cart-item {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 12px;
  padding: 14px;
  margin-bottom: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.item-checkbox {
  margin-right: 12px;
  cursor: pointer;
}

.checkbox {
  width: 22px;
  height: 22px;
  border: 2px solid #ddd;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: white;
  transition: all 0.2s;
}

.checkbox.checked {
  background: #e74c3c;
  border-color: #e74c3c;
}

.item-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  margin-right: 12px;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.item-info {
  flex: 1;
  min-width: 0;
}

.item-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
}

.item-sku {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}

.item-price {
  font-size: 16px;
  font-weight: bold;
  color: #e74c3c;
  margin-bottom: 8px;
}

.quantity-control {
  display: flex;
  align-items: center;
  gap: 12px;
}

.quantity-control button {
  width: 28px;
  height: 28px;
  border: 1px solid #ddd;
  border-radius: 6px;
  background: #f9f9f9;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quantity-control button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.quantity-control span {
  font-size: 15px;
  min-width: 24px;
  text-align: center;
}

.item-delete {
  background: none;
  border: none;
  font-size: 18px;
  color: #999;
  cursor: pointer;
  padding: 8px;
  margin-left: 8px;
}

/* 底部结算栏 */
.bottom-bar {
  position: fixed;
  bottom: 60px;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background: white;
  border-top: 1px solid #eee;
  z-index: 100;
}

.select-all {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  font-size: 14px;
  color: #333;
}

.total-info {
  flex: 1;
  text-align: right;
  margin-right: 12px;
}

.total-price {
  font-size: 14px;
  color: #333;
}

.price-value {
  font-size: 18px;
  font-weight: bold;
  color: #e74c3c;
}

.total-count {
  font-size: 12px;
  color: #999;
  margin-top: 2px;
}

.checkout-btn {
  padding: 12px 30px;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.checkout-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}
</style>

---
📝 第二步：添加路由配置

修改文件：frontend\src\router\index.js

在路由配置中添加购物车路由：

import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
history: createWebHistory(import.meta.env.BASE_URL),
routes: [
{
path: '/',
name: 'home',
component: () => import('../views/HomeView.vue'),
},
{
path: '/login',
name: 'login',
component: () => import('../views/Login.vue'),
},
{
path: '/register',
name: 'register',
component: () => import('../views/Register.vue'),
},
{
path: '/shop',
name: 'shop',
component: () => import('../views/Shop.vue'),
},
{
path: '/my',
name: 'my',
component: () => import('../views/My.vue'),
},
{
path: '/product/:id',
name: 'product',
component: () => import('../views/ProductDetail.vue')
},
{
path: '/cart',
name: 'cart',
component: () => import('../views/Cart.vue')  // 添加这行
}
],
})

export default router
