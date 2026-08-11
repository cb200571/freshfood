<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

import { productApi, cartApi } from '@/api'
import { useUserStore } from '@/stores/user'
const route = useRoute()
const router = useRouter()

// 商品数据
const product = ref(null)
const skuList = ref([])
const loading = ref(true)//加载状态

// 秒杀相关
const seckillActivityId = ref(null)
const seckillPriceMap = ref({})  // skuId -> 秒杀价

// 规格选择弹窗相关
const showSpecModal = ref(false)//弹窗显示
const selectedSku = ref(null)//选中规格
const quantity = ref(1)//购买数量
const actionType = ref('')  // 'cart' 或 'buy'
const userStore = useUserStore()
// 获取skuid对应秒杀价
function getSeckillPrice(sku) {
  if (!seckillActivityId.value) return null
  return seckillPriceMap.value[sku.id] || null
}

// sku显示的最终价格
function displayPrice(sku) {
  return getSeckillPrice(sku) || sku.price
}

// 加载商品详情
async function loadProduct() {
  const spuId = route.params.id
  if (!spuId) return
  loading.value = true

  // 读取秒杀活动ID（只接受进行中的活动）
  if (route.query.seckillActivityId) {
    const activityId = Number(route.query.seckillActivityId)
    try {
      const res = await fetch('/api/seckill/active').then(r => r.json())
      if (res.code === 200) {
        const act = res.data.find(a => a.id === activityId)
        if (act) {
          seckillActivityId.value = activityId
          seckillPriceMap.value[act.skuId] = act.seckillPrice
        }
      }
    } catch (e) { console.error('加载秒杀信息失败', e) }
  }

  try {
    const result = await productApi.getDetail(spuId)
    if (result.code === 200 && result.data) {
      product.value = result.data
      skuList.value = result.data.skuList || []
      // 默认选中第一个 SKU
      if (skuList.value.length > 0) {
        selectedSku.value = skuList.value[0]
      }
    }
  } catch (e) {
    console.error('加载商品详情失败', e)
  } finally {
    loading.value = false
  }
}

// 打开规格弹窗
function openSpecModal(type) {
  // 登录校验
  if (!userStore.isLogin) {
    const goToLogin = confirm('请先登录，是否前往登录页面？')
    if (goToLogin) {
      router.push('/login')
    }
    return
  }

  actionType.value = type
  showSpecModal.value = true
}

// 选择 SKU
function selectSku(sku) {
  selectedSku.value = sku
}

// 数量增减
function changeQuantity(delta) {
  const newVal = quantity.value + delta
  if (newVal >= 1 && newVal <= (selectedSku.value?.stock || 99)) {
    quantity.value = newVal
  }
}

// 获取实际价格（秒杀优先）
function getRealPrice(sku) {
  return getSeckillPrice(sku) || (sku ? sku.price : 0)
}

// 加入购物车（调后端接口存储）
async function addToCart() {
  if (!selectedSku.value) return
  // 未登录用户提示先登录
  if (!userStore.userId) {
    alert('请先登录')
    router.push('/login')
    return
  }
  // 调后端加购接口
  const res = await cartApi.add({
    userId: userStore.userId,
    skuId: selectedSku.value.id,
    spuId: product.value.id,
    quantity: quantity.value
  })
  if (res.code === 200) {
    showSpecModal.value = false
    const goToCart = confirm('✅ 已加入购物车，是否去购物车查看？')
    if (goToCart) {
      router.push('/cart')
    }
  } else {
    alert('加入购物车失败：' + (res.message || '未知错误'))
  }
}

// 立即购买
async function buyNow() {
  if (!selectedSku.value) return
  if (selectedSku.value.stock < quantity.value) {
    alert('库存不足')
    return
  }

  const realPrice = getRealPrice(selectedSku.value)
  // 准备订单商品数据
  const orderItems = [{
    spuId: product.value.id,
    skuId: selectedSku.value.id,
    name: product.value.name,
    skuName: selectedSku.value.skuName,
    image: selectedSku.value.image || product.value.mainImage,
    price: realPrice,
    quantity: quantity.value
  }]

  const query = { items: JSON.stringify(orderItems) }
  if (seckillActivityId.value) {
    query.seckillActivityId = seckillActivityId.value
  }
  // 跳转到订单确认页面
  router.push({ path: '/orderConfirm', query })
}

// 返回
function goBack() {
  router.back()
}

onMounted(() => {
  loadProduct()
})
</script>



<template>
    <div class="product-detail-page">
      <!-- 顶部导航栏 -->
      <div class="top-bar">
        <button class="back-btn" @click="goBack">← 返回</button>
      <span class="title">商品详情</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">
      <p>加载中...</p>
    </div>

    <!-- 商品内容 -->
    <div v-else-if="product" class="content">

      <!-- 商品图片 -->
      <div class="product-image">
        <img v-if="product.mainImage" :src="product.mainImage" :alt="product.name">
        <div v-else class="no-image">📦</div>
      </div>

      <!-- 价格区域 -->
      <div class="price-section">
        <template v-if="seckillActivityId && getSeckillPrice(selectedSku)">
          <span class="current-price seckill-price">⚡¥{{ getSeckillPrice(selectedSku) }}</span>
          <span class="original-price">¥{{ selectedSku?.price || product.minPrice }}</span>
          <span class="seckill-tag">限时秒杀</span>
        </template>
        <template v-else>
          <span class="current-price">¥{{ selectedSku?.price || product.minPrice }}</span>
          <span v-if="selectedSku?.originalPrice" class="original-price">¥{{ selectedSku.originalPrice }}</span>
        </template>
        <span class="price-unit" v-if="selectedSku?.priceUnit">/{{ selectedSku.priceUnit }}</span>
      </div>

      <!-- 商品名称 -->
      <div class="product-name">
        <span v-if="product.isColdChain" class="cold-tag">冷链</span>
        {{ product.name }}
      </div>

      <!-- 商品描述 -->
      <div class="product-desc" v-if="product.description">
        {{ product.description }}
      </div>

      <!-- 商品信息 -->
      <div class="product-info-card">
        <div class="info-row" v-if="product.brand">
          <span class="info-label">品牌</span>
          <span class="info-value">{{ product.brand }}</span>
        </div>
        <div class="info-row" v-if="product.categoryName">
          <span class="info-label">分类</span>
          <span class="info-value">{{ product.categoryName }}</span>
        </div>
        <div class="info-row" v-if="product.shelfLife">
          <span class="info-label">保质期</span>
          <span class="info-value">{{ product.shelfLife }}天</span>
        </div>
      </div>

      <!-- SKU 规格选择（在页面中也展示） -->
      <div class="sku-section">
        <div class="section-title">已选</div>
        <div class="sku-tags">
            <span
              v-for="sku in skuList"
          :key="sku.id"
          class="sku-tag"
          :class="{ active: selectedSku?.id === sku.id, disabled: sku.stock <= 0 }"
          @click="sku.stock > 0 && selectSku(sku)"
          >
          {{ sku.skuName || sku.weightDesc }}
          <span class="sku-price">
            <template v-if="seckillActivityId && getSeckillPrice(sku)">⚡¥{{ getSeckillPrice(sku) }}</template>
            <template v-else>¥{{ sku.price }}</template>
          </span>
        </span>
      </div>
    </div>

    <!-- 商品详情图（如果有） -->
    <div class="detail-images" v-if="product.detailImages">
      <div class="section-title">商品详情</div>
      <div class="detail-img-list">
        <img v-for="(img, i) in product.detailImages.split(',')" :key="i" :src="img.trim()" alt="">
      </div>
    </div>
  </div>

<!-- 底部操作栏 -->
<div class="bottom-bar" v-if="product">
  <div class="bar-left">
    <div class="bar-icon" @click="router.push('/')">
    <span>🏠</span>
    <span class="icon-text">首页</span>
  </div>
  <div class="bar-icon" @click="router.push('/cart')">
  <span>🛒</span>
  <span class="icon-text">购物车</span>
</div>
</div>
<div class="bar-right">
  <button class="btn-cart" @click="openSpecModal('cart')">加入购物车</button>
<button class="btn-buy" @click="openSpecModal('buy')">立即购买</button>
</div>
</div>

<!-- 规格选择弹窗（遮罩层） -->
<div class="modal-overlay" v-if="showSpecModal" @click.self="showSpecModal = false">
  <div class="spec-modal">
  <!-- 弹窗头部：商品缩略图 + 价格 -->
  <div class="modal-header">
    <div class="modal-thumb">
      <img v-if="selectedSku?.image || product?.mainImage" :src="selectedSku?.image || product?.mainImage"
      alt="">
      <span v-else style="font-size:40px;">📦</span>
    </div>
    <div class="modal-info">
      <div class="modal-price">
        <template v-if="seckillActivityId && getSeckillPrice(selectedSku)">⚡¥{{ getSeckillPrice(selectedSku) }}</template>
        <template v-else>¥{{ selectedSku?.price || '--' }}</template>
      </div>
      <div class="modal-stock">库存：{{ selectedSku?.stock ?? '--' }}</div>
      <div class="modal-selected">已选：{{ selectedSku?.skuName || '请选择规格' }}</div>
    </div>
    <button class="modal-close" @click="showSpecModal = false">✕</button>
</div>
<!-- 规格列表 -->
<div class="modal-body">
  <div class="spec-label">规格</div>
  <div class="spec-options">
    <div
      v-for="sku in skuList"
    :key="sku.id"
    class="spec-option"
    :class="{ active: selectedSku?.id === sku.id, disabled: sku.stock <= 0 }"
    @click="sku.stock > 0 && selectSku(sku)"
    >
    <span class="spec-name">{{ sku.skuName || sku.weightDesc }}</span>
    <span class="spec-price">¥{{ sku.price }}</span>
    <span v-if="sku.stock <= 0" class="spec-out">已售罄</span>
  </div>
</div>

<!-- 数量选择 -->
<div class="quantity-section">
  <span class="spec-label">数量</span>
  <div class="quantity-control">
    <button @click="changeQuantity(-1)" :disabled="quantity <= 1">−</button>
  <span>{{ quantity }}</span>
  <button @click="changeQuantity(1)" :disabled="quantity >= (selectedSku?.stock || 99)">+</button>
</div>
</div>
</div>

<!-- 弹窗底部按钮 -->
<div class="modal-footer">
  <button
    v-if="actionType === 'cart'"
    class="modal-btn cart-btn"
  @click="addToCart"
  :disabled="!selectedSku || selectedSku.stock <= 0"
  >
  加入购物车
</button>
<button
  v-if="actionType === 'buy'"
  class="modal-btn buy-btn"
              @click="buyNow"
:disabled="!selectedSku || selectedSku.stock <= 0"
  >
  立即购买
  </button>
</div>
</div>
</div>
</div>
</template>



  <style scoped>
    .product-detail-page {
    min-height: 100vh;
    background: #f5f5f5;
    padding-bottom: 70px;
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
    .back-btn {
    background: none;
    border: none;
    font-size: 16px;
    color: #333;
    cursor: pointer;
  }
    .title {
    font-size: 17px;
    font-weight: 600;
  }

    /* 商品图片 */
    .product-image {
    width: 100%;
    height: 300px;
    background: white;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
  }
    .product-image img {
    width: 100%;
    height: 100%;
    object-fit: contain;
  }
    .no-image { font-size: 80px; }

    /* 价格 */
    .price-section {
    padding: 14px 16px;
    background: white;
  }
    .current-price {
    font-size: 26px;
    font-weight: bold;
    color: #e74c3c;
  }
    .original-price {
    font-size: 14px;
    color: #999;
    text-decoration: line-through;
    margin-left: 8px;
  }
    .price-unit {
    font-size: 13px;
    color: #999;
  }

    /* 商品名称 */
    .product-name {
    padding: 10px 16px;
    background: white;
    font-size: 17px;
    font-weight: 600;
    line-height: 1.4;
    margin-bottom: 8px;
  }
    .cold-tag {
    display: inline-block;
    background: #e8f5e9;
    color: #2e7d32;
    font-size: 11px;
    padding: 2px 6px;
    border-radius: 4px;
    margin-right: 6px;
    font-weight: normal;
  }

    /* 商品描述 */
    .product-desc {
    padding: 12px 16px;
    background: white;
    font-size: 14px;
    color: #666;
    line-height: 1.6;
    margin-bottom: 8px;
  }

    /* 商品信息卡片 */
    .product-info-card {
    background: white;
    padding: 14px 16px;
    margin-bottom: 8px;
  }
    .info-row {
    display: flex;
    padding: 6px 0;
    font-size: 14px;
  }
    .info-label {
    width: 60px;
    color: #999;
  }
    .info-value { color: #333; }

    /* SKU 区域 */
    .sku-section {
    background: white;
    padding: 14px 16px;
    margin-bottom: 8px;
  }
    .section-title {
    font-size: 15px;
    font-weight: 600;
    margin-bottom: 10px;
  }
    .sku-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
    .sku-tag {
    padding: 8px 14px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 13px;
    cursor: pointer;
    background: #fafafa;
  }
    .sku-tag.active {
    border-color: #e74c3c;
    color: #e74c3c;
    background: #fff5f5;
  }
    .sku-tag.disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
    .sku-price {
    display: block;
    font-size: 12px;
    color: #e74c3c;
    margin-top: 2px;
  }

    /* 详情图 */
    .detail-images {
    background: white;
    padding: 14px 16px;
  }
    .detail-img-list img {
    width: 100%;
    display: block;
    margin-bottom: 8px;
  }

    /* 底部操作栏 */
    .bottom-bar {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    display: flex;
    align-items: center;
    padding: 8px 16px;
    background: white;
    border-top: 1px solid #eee;
    z-index: 100;
  }
    .bar-left {
    display: flex;
    gap: 20px;
    margin-right: 16px;
  }
    .bar-icon {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 20px;
    cursor: pointer;
  }
    .icon-text {
    font-size: 10px;
    color: #666;
  }
    .bar-right {
    flex: 1;
    display: flex;
    gap: 10px;
  }
    .btn-cart {
    flex: 1;
    padding: 12px;
    border: none;
    border-radius: 25px;
    background: #ff9800;
    color: white;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
  }
    .btn-buy {
    flex: 1;
    padding: 12px;
    border: none;
    border-radius: 25px;
    background: #e74c3c;
    color: white;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
  }

    /* 规格弹窗 */
    .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.5);
    z-index: 200;
    display: flex;
    align-items: flex-end;
  }
    .spec-modal {
    width: 100%;
    max-height: 70vh;
    background: white;
    border-radius: 16px 16px 0 0;
    overflow-y: auto;
  }
    .modal-header {
    display: flex;
    padding: 16px;
    border-bottom: 1px solid #f0f0f0;
    position: relative;
  }
    .modal-thumb {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    overflow: hidden;
    margin-right: 12px;
    background: #f5f5f5;
    display: flex;
    align-items: center;
    justify-content: center;
  }
    .modal-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
    .modal-info { flex: 1; }
    .modal-price {
    font-size: 22px;
    font-weight: bold;
    color: #e74c3c;
  }
    .modal-stock {
    font-size: 13px;
    color: #999;
    margin-top: 4px;
  }
    .modal-selected {
    font-size: 13px;
    color: #666;
    margin-top: 4px;
  }
    .modal-close {
    position: absolute;
    top: 12px;
    right: 16px;
    background: none;
    border: none;
    font-size: 20px;
    color: #999;
    cursor: pointer;
  }

    .modal-body {
    padding: 16px;
  }
    .spec-label {
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 10px;
  }
    .spec-options {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 20px;
  }
    .spec-option {
    display: flex;
    align-items: center;
    padding: 12px;
    border: 1px solid #eee;
    border-radius: 10px;
    cursor: pointer;
  }
    .spec-option.active {
    border-color: #e74c3c;
    background: #fff5f5;
  }
    .spec-option.disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
    .spec-name { flex: 1; font-size: 14px; }
    .spec-price { font-size: 14px; color: #e74c3c; margin-right: 8px; }
    .spec-out { font-size: 12px; color: #999; }

    .quantity-section {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
    .quantity-control {
    display: flex;
    align-items: center;
    gap: 16px;
  }
    .quantity-control button {
    width: 32px;
    height: 32px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background: #f9f9f9;
    font-size: 18px;
    cursor: pointer;
  }
    .quantity-control button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
  }
    .quantity-control span {
    font-size: 16px;
    min-width: 30px;
    text-align: center;
  }

    .modal-footer {
    padding: 12px 16px;
    border-top: 1px solid #f0f0f0;
  }
    .modal-btn {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 25px;
    font-size: 16px;
    font-weight: 600;
    color: white;
    cursor: pointer;
  }
    .modal-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
    .cart-btn { background: #ff9800; }
    .buy-btn { background: #e74c3c; }
    .seckill-price { color: #ff4d4f !important; animation: pulse 1s infinite; }
    .seckill-tag {
      display: inline-block;
      background: #ff4d4f;
      color: white;
      font-size: 11px;
      padding: 1px 8px;
      border-radius: 10px;
      margin-left: 8px;
      vertical-align: middle;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.7; }
    }

    .loading-state {
    display: flex;
    justify-content: center;
    padding: 60px;
    color: #999;
  }
  </style>
