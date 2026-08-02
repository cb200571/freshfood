<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { categoryApi, productApi } from '@/api'
import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const route = useRoute()//读取当前路由信息
const router = useRouter()//操作路由
const user = useUserStore()

// 分类图标映射
const CAT_ICONS = {
  '新鲜蔬菜': '🥬', '时令水果': '🍎', '肉禽蛋': '🥩', '水产海鲜': '🦐',
  '粮油调味': '🧂', '休闲零食': '🍪', '酒水饮料': '🥤', '个护清洁': '🧴'
}

// 状态
const searchKeyword = ref('')
const currentParentId = ref(null)
const currentCatId = ref(null)
const categories = ref([])
const subCategories = ref([])
const products = ref([])
const currentProducts = ref([])

// 详情弹窗
const showModal = ref(false)
const detailData = ref(null)
const selectedSkuId = ref(null)

// 加载一级分类
async function loadTopCategories() {
  try {
    const result = await categoryApi.getTopCategories()
    if (result.code !== 200) return
    categories.value = result.data

    // 默认选第一个或从 URL 参数获取
    const urlCatId = route.query.cat
    const target = urlCatId ? result.data.find(c => c.id == urlCatId) : null
    if (target) {
      selectTopCat(target.id)
    } else if (result.data.length > 0) {
      selectTopCat(result.data[0].id)
    }
  } catch (e) {
    console.error('加载分类失败:', e)
  }
}

// 点击一级分类
async function selectTopCat(parentId) {
  currentParentId.value = parentId
  currentCatId.value = null

  // 加载二级分类
  try {
    const result = await categoryApi.getSubCategories(parentId)
    if (result.code === 200) {
      subCategories.value = result.data
    }

    // 加载该一级分类下所有商品
    loadProductsByParent(parentId)
  } catch (e) {
    console.error('加载二级分类失败:', e)
  }
}

// 点击二级分类
function selectSubCat(catId) {
  currentCatId.value = catId
  if (catId === null) {
    loadProductsByParent(currentParentId.value)
  } else {
    loadProductsByCategory(catId)
  }
}

// 按一级分类加载商品
async function loadProductsByParent(parentId) {
  try {
    const result = await productApi.getByParentCategory(parentId)
    if (result.code === 200) {
      currentProducts.value = result.data
      renderProducts(result.data)
    }
  } catch (e) {
    console.error('加载商品失败:', e)
  }
}

// 按二级分类加载商品
async function loadProductsByCategory(catId) {
  try {
    const result = await productApi.getByCategory(catId)
    if (result.code === 200) {
      currentProducts.value = result.data
      renderProducts(result.data)
    }
  } catch (e) {
    console.error('加载商品失败:', e)
  }
}

// 搜索
async function doSearch() {
  const keyword = searchKeyword.value.trim()
  if (!keyword) return
  try {
    const result = await productApi.search(keyword)
    if (result.code === 200) {
      currentProducts.value = result.data
      renderProducts(result.data)
    }
  } catch (e) {
    console.error('搜索失败:', e)
  }
}

// 渲染商品列表（异步加载价格）
function renderProducts(list) {
  products.value = list.map(p => ({
    ...p,
    minPrice: null,
    minOriginalPrice: null,
    priceLoaded: false  // 新增：标记价格是否已加载
  }))

  // 异步加载价格
  list.forEach((p, idx) => {
    productApi.getDetail(p.id).then(r => {
      if (r.code === 200 && r.data) {
        const updated = { ...products.value[idx] }
        updated.minPrice = r.data.minPrice || null
        updated.minOriginalPrice = r.data.minOriginalPrice || null
        updated.priceLoaded = true
        products.value[idx] = updated
      } else {
        // 加载失败也标记为已加载，显示"--"
        const updated = { ...products.value[idx] }
        updated.priceLoaded = true
        products.value[idx] = updated
      }
    }).catch(() => {
      // 请求失败也标记为已加载
      const updated = { ...products.value[idx] }
      updated.priceLoaded = true
      products.value[idx] = updated
    })
  })
}

// 打开详情弹窗
async function openDetail(spuId) {
  showModal.value = true
  detailData.value = null
  selectedSkuId.value = null

  try {
    const result = await productApi.getDetail(spuId)
    if (result.code === 200) {
      detailData.value = result.data
    }
  } catch (e) {
    console.error('加载详情失败:', e)
  }
}

// 选择 SKU
function selectSku(skuId) {
  selectedSkuId.value = skuId
}

// 模拟下单扣库存
async function testBuy() {
  if (!selectedSkuId.value) {
    alert('请先选择一个规格')
    return
  }
  try {
    const result = await productApi.decreaseStock(selectedSkuId.value, 1)
    if (result.code === 200) {
      alert('✅ 下单成功！库存已减少1件')
      closeDetail()
    } else {
      alert('❌ ' + result.message)
    }
  } catch (e) {
    alert('网络错误')
  }
}

// 关闭详情弹窗
function closeDetail() {
  showModal.value = false
  selectedSkuId.value = null
  // 重新加载商品列表
  if (currentCatId.value) loadProductsByCategory(currentCatId.value)
  else if (currentParentId.value) loadProductsByParent(currentParentId.value)
}

// 退出登录
function logout() {
  user.logout()
  router.push('/')
}

onMounted(() => {
  loadTopCategories()
})
</script>

<template>
  <div class="shop-page">
    <!-- 顶部导航 -->
    <div class="header">
      <div class="logo">🥬 鲜果生鲜</div>
      <div class="search-box">
        <input v-model="searchKeyword" type="text" placeholder="搜索水果、蔬菜、肉禽蛋…" @keyup.enter="doSearch">
        <button @click="doSearch">搜索</button>
      </div>
      <!-- 右上角：登录状态 -->
      <div class="user-area">
        <template v-if="!user.isLogin">
          <router-link to="/login">登录</router-link>
          <router-link to="/register">注册</router-link>
        </template>
        <template v-else>
          <div class="user-avatar" title="user.userName">{{ user.userName[0] }}</div>
          <a href="#" @click.prevent="logout" style="font-size: 12px;">退出</a>
        </template>
      </div>
    </div>

    <!-- 主布局 -->
    <div class="main-layout">
      <!-- 左侧分类 -->
      <div class="sidebar">
        <div
          v-for="cat in categories"
          :key="cat.id"
          class="cat-item"
          :class="{ active: currentParentId === cat.id }"
          @click="selectTopCat(cat.id)"
        >
          <span class="cat-icon">{{ CAT_ICONS[cat.name] || '📦' }}</span>
          {{ cat.name }}
        </div>
      </div>

      <!-- 右侧内容 -->
      <div class="content">
        <!-- 二级分类标签 -->
        <div class="sub-cats">
          <span
            class="sub-cat-tag"
            :class="{ active: currentCatId === null }"
            @click="selectSubCat(null)"
          >全部</span>
          <span
            v-for="cat in subCategories"
            :key="cat.id"
            class="sub-cat-tag"
            :class="{ active: currentCatId === cat.id }"
            @click="selectSubCat(cat.id)"
          >{{ cat.name }}</span>
        </div>

        <!-- 商品网格 -->
        <div class="product-grid" v-if="products.length > 0">
          <div
            v-for="p in products"
            :key="p.id"
            class="product-card"
            @click="$router.push(`/product/${p.id}`)"
          >
            <div class="img-wrap">
              <img v-if="p.mainImage" :src="p.mainImage" :alt="p.name">
              <span v-else style="font-size: 60px;">📦</span>
            </div>
            <div class="info">
              <div class="name">{{ p.name }}</div>
              <div class="brand">{{ p.brand || '' }}</div>
              <div class="price">
                <template v-if="p.priceLoaded">
                  <span v-if="p.minPrice">¥{{ p.minPrice }}</span>
                  <span v-else>--</span>
                  <span class="unit">起</span>
                </template>
                <span v-else class="price-skeleton"></span>
              </div>
              <div class="tags">
                <span v-if="p.isColdChain" class="tag cold">❄ 冷链</span>
                <span v-if="p.shelfLife > 0" class="tag">保质{{ p.shelfLife }}天</span>
              </div>
            </div>
          </div>
        </div>

        <!-- 空状态 -->
        <div class="empty" v-else>
          <div class="icon">👈</div>
          <div>请选择左侧分类浏览商品</div>
        </div>
      </div>
    </div>

    <!-- 详情弹窗 -->
    <div class="modal-overlay" v-if="showModal" @click.self="closeDetail">
      <div class="modal" v-if="detailData">
        <button class="close-btn" @click="closeDetail">✕</button>
        <h2>{{ detailData.name }}</h2>
        <div class="detail-brand">{{ detailData.brand || '' }} · {{ detailData.categoryName || '' }}</div>
        <div class="detail-price-range">
          <template v-if="detailData.minPrice && detailData.maxPrice">
            ¥{{ detailData.minPrice }}{{ detailData.minPrice !== detailData.maxPrice ? ' ~ ¥' + detailData.maxPrice : '' }}
          </template>
          <template v-else>暂无价格</template>
        </div>
        <div class="detail-desc" v-if="detailData.description">{{ detailData.description }}</div>
        <div class="detail-tags">
          <span v-if="detailData.isColdChain" class="tag cold">❄ 冷链运输</span>
          <span v-if="detailData.shelfLife > 0" class="tag">保质期{{ detailData.shelfLife }}天</span>
          <span class="tag">{{ detailData.status === 1 ? '在售' : '下架' }}</span>
        </div>

        <!-- SKU 列表 -->
        <template v-if="detailData.skuList && detailData.skuList.length > 0">
          <h3>选择规格</h3>
          <div class="sku-list">
            <div
              v-for="sku in detailData.skuList"
              :key="sku.id"
              class="sku-item"
              :class="{ selected: selectedSkuId === sku.id }"
              @click="selectSku(sku.id)"
            >
              <div>
                <div class="sku-name">{{ sku.weightDesc || sku.skuName }}</div>
                <div class="sku-stock" :class="{ 'low-stock': sku.stock <= sku.warningStock }">
                  {{ sku.stock <= sku.warningStock ? '⚠ 库存紧张: ' + sku.stock + '件' : '库存: ' + sku.stock + '件' }}
                </div>
              </div>
              <div>
                <div class="sku-price">¥{{ sku.price }}</div>
                <div v-if="sku.originalPrice > sku.price" style="text-decoration: line-through; color: #999; font-size: 12px;">
                  ¥{{ sku.originalPrice }}
                </div>
              </div>
            </div>
          </div>
        </template>

        <!-- 库存操作区 -->
        <div class="stock-section">
          <h3>🧪 库存测试</h3>
          <div class="row">
            <button class="btn-buy" @click="testBuy">模拟下单(扣库存)</button>
            <span style="font-size: 13px; color: #666;">选择上方规格后点击</span>
          </div>
        </div>
      </div>
      <div class="modal" v-else>
        <div style="text-align: center; padding: 40px;">加载中…</div>
      </div>
    </div>

    <!-- 底部 TabBar -->
    <TabBar />
  </div>
</template>

<style scoped>
.shop-page {
  background: #f5f5f5;
  min-height: 100vh;
  padding-bottom: 70px;
}

/* 顶部导航 */
.header {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  padding: 12px 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header .logo {
  font-size: 22px;
  font-weight: bold;
  color: white;
  white-space: nowrap;
}

.header .search-box {
  flex: 1;
  display: flex;
  gap: 0;
}

.header .search-box input {
  flex: 1;
  padding: 10px 14px;
  border: none;
  border-radius: 20px 0 0 20px;
  font-size: 14px;
  outline: none;
}

.header .search-box button {
  padding: 10px 20px;
  border: none;
  background: white;
  color: #43e97b;
  font-weight: bold;
  border-radius: 0 20px 20px 0;
  cursor: pointer;
  font-size: 14px;
}

.header .search-box button:hover {
  background: #f0f0f0;
}

.user-area {
  display: flex;
  align-items: center;
  gap: 8px;
}

.user-area a {
  color: white;
  font-size: 13px;
  text-decoration: none;
  white-space: nowrap;
  padding: 6px 14px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 18px;
}

.user-area a:hover {
  background: rgba(255, 255, 255, 0.35);
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  cursor: pointer;
  color: white;
  font-weight: 700;
}

/* 主布局 */
.main-layout {
  display: flex;
  max-width: 1200px;
  margin: 15px auto;
  gap: 15px;
  padding: 0 15px;
}

/* 左侧分类菜单 */
.sidebar {
  width: 180px;
  flex-shrink: 0;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.sidebar .cat-item {
  padding: 14px 20px;
  cursor: pointer;
  font-size: 14px;
  color: #333;
  border-bottom: 1px solid #f0f0f0;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.sidebar .cat-item:hover {
  background: #e8f8e8;
  color: #2e7d32;
}

.sidebar .cat-item.active {
  background: rgba(67, 233, 123, 0.2);
  color: #2e7d32;
  font-weight: bold;
}

.sidebar .cat-icon {
  font-size: 18px;
  width: 24px;
  text-align: center;
}

/* 右侧内容区 */
.content {
  flex: 1;
}

/* 二级分类标签 */
.sub-cats {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 15px;
  padding: 12px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

.sub-cat-tag {
  padding: 6px 16px;
  border-radius: 20px;
  cursor: pointer;
  font-size: 13px;
  border: 1px solid #e0e0e0;
  background: white;
  transition: all 0.2s;
  color: #666;
}

.sub-cat-tag:hover {
  border-color: #43e97b;
  color: #2e7d32;
}

.sub-cat-tag.active {
  background: #43e97b;
  color: white;
  border-color: #43e97b;
}

/* 商品网格 */
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 15px;
}

.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  transition: transform 0.2s, box-shadow 0.2s;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

.product-card .img-wrap {
  height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #e8f8e8 0%, #f5f5f5 100%);
  font-size: 60px;
  overflow: hidden;
}

.product-card .img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-card .info {
  padding: 12px 15px;
}

.product-card .name {
  font-size: 15px;
  font-weight: bold;
  color: #333;
  margin-bottom: 6px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-card .brand {
  font-size: 12px;
  color: #999;
  margin-bottom: 8px;
}

.product-card .price {
  font-size: 18px;
  color: #e74c3c;
  font-weight: bold;
}

.product-card .price .unit {
  font-size: 12px;
  color: #999;
  font-weight: normal;
  margin-left: 4px;
}

/* 价格骨架屏 */
.price-skeleton {
  display: inline-block;
  width: 60px;
  height: 20px;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

.product-card .tags {
  display: flex;
  gap: 4px;
  margin-top: 6px;
}

.tag {
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
  background: #e8f8e8;
  color: #2e7d32;
}

.tag.cold {
  background: #dbeafe;
  color: #1d4ed8;
}

/* 详情弹窗 */
.modal-overlay {
  display: flex;
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  justify-content: center;
  align-items: center;
}

.modal {
  background: white;
  border-radius: 16px;
  max-width: 700px;
  width: 90%;
  max-height: 85vh;
  overflow-y: auto;
  padding: 30px;
  position: relative;
}

.modal .close-btn {
  position: absolute;
  top: 15px;
  right: 20px;
  background: none;
  border: none;
  font-size: 28px;
  cursor: pointer;
  color: #999;
}

.modal .close-btn:hover {
  color: #333;
}

.modal h2 {
  font-size: 22px;
  margin-bottom: 10px;
  color: #333;
}

.modal .detail-brand {
  color: #999;
  margin-bottom: 15px;
}

.modal .detail-price-range {
  font-size: 24px;
  color: #e74c3c;
  font-weight: bold;
  margin-bottom: 20px;
}

.modal .detail-desc {
  background: #f9f9f9;
  padding: 12px;
  border-radius: 8px;
  margin-bottom: 20px;
  color: #666;
  font-size: 14px;
  line-height: 1.6;
}

.modal .detail-tags {
  margin-bottom: 15px;
  display: flex;
  gap: 8px;
}

.modal h3 {
  font-size: 16px;
  margin-bottom: 10px;
  color: #333;
}

.modal .sku-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.modal .sku-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 15px;
  border: 2px solid #f0f0f0;
  border-radius: 10px;
  transition: all 0.2s;
  cursor: pointer;
}

.modal .sku-item:hover {
  border-color: #43e97b;
}

.modal .sku-item.selected {
  border-color: #43e97b;
  background: #e8f8e8;
}

.modal .sku-name {
  font-size: 14px;
  color: #333;
}

.modal .sku-price {
  font-size: 16px;
  color: #e74c3c;
  font-weight: bold;
}

.modal .sku-stock {
  font-size: 12px;
  color: #999;
}

.modal .low-stock {
  color: #e74c3c !important;
}

/* 库存操作区 */
.stock-section {
  margin-top: 20px;
  padding: 15px;
  background: #f0fdf4;
  border-radius: 10px;
  border: 1px solid #bbf7d0;
}

.stock-section h3 {
  margin-bottom: 10px;
}

.stock-section .row {
  display: flex;
  gap: 10px;
  align-items: center;
}

.stock-section button {
  padding: 8px 20px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 13px;
  font-weight: bold;
  color: white;
}

.btn-buy {
  background: #43e97b;
}

.btn-buy:hover {
  background: #2ecc71;
}

/* 空状态 */
.empty {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
  background: white;
  border-radius: 12px;
}

.empty .icon {
  font-size: 60px;
  margin-bottom: 15px;
}

/* 响应式 */
@media (max-width: 768px) {
  .main-layout {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
    display: flex;
    overflow-x: auto;
  }

  .sidebar .cat-item {
    white-space: nowrap;
    border-bottom: none;
    border-right: 1px solid #f0f0f0;
  }

  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  }
}
</style>
