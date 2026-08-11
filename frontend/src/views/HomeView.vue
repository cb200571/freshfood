<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { categoryApi, productApi, seckillApi, cartApi } from '@/api'
import { useUserStore } from '@/stores/user'
import TabBar from '@/components/TabBar.vue'

const router = useRouter()
const user = useUserStore()

// 状态
const location = ref('北京市 · 朝阳区')
const keyword = ref('')
const cartCount = ref(0)
const loading = ref(true)
const toastShow = ref(false)
const toastMsg = ref('')
const currentProducts = ref([])
// 大类颜色数组
const catColors = [
  'linear-gradient(135deg,#a8edea,#fed6e3)',
  'linear-gradient(135deg,#ffecd2,#fcb69f)',
  'linear-gradient(135deg,#d4fc79,#96e6a1)',
  'linear-gradient(135deg,#a1c4fd,#c2e9fb)',
  'linear-gradient(135deg,#fbc2eb,#a18cd1)',
  'linear-gradient(135deg,#fddb92,#d1fdff)',
  'linear-gradient(135deg,#f093fb,#f5576c22)',
  'linear-gradient(135deg,#4facfe,#00f2fe)',
  'linear-gradient(135deg,#43e97b,#38f9d7)',
  'linear-gradient(135deg,#fa709a,#fee140)',
]

// 大类数据
const categories = ref([])

// 轮播 Banner 数据
const banners = ref([
  {
    tag: '限时折扣',
    title: '5折起！今日特惠',
    sub: '精选商品，每天更新',
    btn: '立即抢购 →',
    bg: 'linear-gradient(135deg,#ff6b6b,#ffa500)',
  },
  {
    tag: '新人专享',
    title: '新人领券 立减20元',
    sub: '首单满39元即可使用',
    btn: '领取优惠券 →',
    bg: 'linear-gradient(135deg,#667eea,#764ba2)',
  },
  {
    tag: '当日鲜采',
    title: '今日凌晨直采直发',
    sub: '产地直供 · 新鲜到家',
    btn: '查看鲜采商品 →',
    bg: 'linear-gradient(135deg,#43e97b,#38f9d7)',
  },
  {
    tag: '满减活动',
    title: '满99减15 满199减40',
    sub: '全场商品均可参与，不限品类',
    btn: '马上去凑单 →',
    bg: 'linear-gradient(135deg,#f093fb,#f5576c)',
  },
])

// 推荐商品
const products = ref([])

// 秒杀活动
const seckillActivities = ref([])

const showToast = (msg) => {
  toastMsg.value = msg
  toastShow.value = true
  setTimeout(() => { toastShow.value = false }, 1600)
}

// 加载购物车数量（角标显示）
async function loadCartCount() {
  if (!user.userId) {
    cartCount.value = 0
    return
  }
  try {
    const res = await cartApi.list(user.userId)
    if (res.code === 200) {
      cartCount.value = (res.data || []).reduce((sum, item) => sum + item.quantity, 0)
    }
  } catch (e) {
    console.error('加载购物车数量失败', e)
  }
}

const addCart = async (p) => {
  // 未登录用户提示先登录
  if (!user.userId) {
    alert('请先登录')
    router.push('/login')
    return
  }
  try {
    // 首页商品只有 spu 信息，需先查它的 SKU 列表，取第一个 SKU
    const skuRes = await productApi.getSkus(p.id)
    if (skuRes.code !== 200 || !skuRes.data || skuRes.data.length === 0) {
      alert('该商品暂无库存')
      return
    }
    const firstSku = skuRes.data[0]
    // 调后端加购
    const res = await cartApi.add({
      userId: user.userId,
      skuId: firstSku.id,
      spuId: p.id,
      quantity: 1
    })
    if (res.code === 200) {
      // 更新购物车角标
      loadCartCount()
      showToast(`✅ 已加入购物车：${p.name.substring(0, 8)}...`)
    } else {
      alert('加入购物车失败：' + (res.message || '未知错误'))
    }
  } catch (e) {
    console.error('加购失败', e)
    alert('加入购物车失败')
  }
}

const doSearch = () => {
  const searchKeyword = keyword.value.trim()
  if (!searchKeyword) return
  // 跳转到商品列表页，并携带搜索关键词
  // Shop 页 onMounted 时会读取 URL 里的 keyword 参数并自动搜索
  router.push({ path: '/shop', query: { keyword: searchKeyword } })
}
const goDetail = (p) => {
  router.push(`/product/${p.id}`)  // ✅ 跳转到商品详情页
}

const goProfile = () => {
  router.push(user.isLogin ? '/my' : '/login')
}

onMounted(() => {
  // 从后端加载购物车数量（角标）
  loadCartCount()

  // 加载数据
  loadData()
})

const goSeckillDetail = (activity) => {
  router.push(`/product/${activity.spuId}?seckillActivityId=${activity.id}`)
}

async function loadData() {
  try {
    // 0. 加载秒杀活动
    const seckillRes = await seckillApi.getActive()
    if (seckillRes.code === 200) seckillActivities.value = seckillRes.data

    // 1. 加载一级分类
    const catData = await categoryApi.getTopCategories()
    if (catData.code === 200 && catData.data) {
      categories.value = catData.data

      // 2. 用第一个大类加载推荐商品
      if (catData.data.length > 0) {
        const prodData = await productApi.getByParentCategory(catData.data[0].id)
        if (prodData.code === 200 && prodData.data) {
          // 初始化商品列表
          products.value = prodData.data.map(spu => ({
            ...spu, minPrice: null, minOriginalPrice: null, priceLoaded: false
          }))

          // 3. 逐个查详情取最低价
          prodData.data.forEach((spu, idx) => {
            productApi.getDetail(spu.id).then(r => {
              const updated = { ...products.value[idx] }
              if (r.code === 200 && r.data) {
                updated.minPrice = r.data.minPrice || null
                updated.minOriginalPrice = r.data.minOriginalPrice || null
              }
              updated.priceLoaded = true
              products.value[idx] = updated
            }).catch(() => {
              const updated = { ...products.value[idx] }
              updated.priceLoaded = true
              products.value[idx] = updated
            })
          })
        }
      }
    }
  } catch (e) {
    console.error('首页数据加载失败:', e)
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="home-page">
    <!-- 顶部导航 -->
    <div class="top-nav">
      <!-- 位置行 -->
      <div class="location">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
          <circle cx="12" cy="9" r="2.5"/>
        </svg>
        <span>{{ location }}</span>
      </div>
      <!-- 搜索行 -->
      <div class="nav-row">
        <span class="logo-txt">🥬 鲜果生鲜</span>
        <div class="search-wrap">
          <input v-model="keyword" type="text" placeholder="搜索新鲜蔬果、肉禽..." @keyup.enter="doSearch">
          <button @click="doSearch">🔍</button>
        </div>
        <!-- 登录态 -->
        <div class="user-area">
          <template v-if="!user.isLogin">
            <router-link to="/login">登录</router-link>
            <span class="divider">|</span>
            <router-link to="/register">注册</router-link>
          </template>
          <template v-else>
            <div class="user-avatar" @click="goProfile">{{ user.userName[0] }}</div>
          </template>
        </div>
      </div>
    </div>

    <!-- 大类入口 -->
    <div style="background: white; margin-top: 8px;">
      <div class="section-title">商品分类</div>
      <div class="cat-grid">
        <router-link :to="'/shop?cat=' + cat.id" class="cat-item" v-for="(cat, i) in categories" :key="cat.id">
          <div class="cat-avatar" :style="{ background: catColors[i % catColors.length] }">{{ cat.icon || '📦' }}</div>
          <span class="cat-label">{{ cat.name }}</span>
        </router-link>
      </div>
    </div>

    <!-- 轮播 Banner -->
    <div class="banner-section">
      <div id="bannerCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
        <div class="carousel-indicators">
          <button v-for="(b, i) in banners" :key="i"
            type="button" data-bs-target="#bannerCarousel"
            :data-bs-slide-to="i"
            :class="{ active: i === 0 }"
            :aria-current="i === 0 ? 'true' : 'false'">
          </button>
        </div>
        <div class="carousel-inner">
          <div class="carousel-item" :class="{ active: i === 0 }" v-for="(b, i) in banners" :key="i">
            <div class="banner-card" :style="{ background: b.bg }">
              <div class="banner-content">
                <span class="banner-tag">{{ b.tag }}</span>
                <div class="banner-title">{{ b.title }}</div>
                <div class="banner-sub">{{ b.sub }}</div>
                <span class="banner-btn">{{ b.btn }}</span>
              </div>
            </div>
          </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
          <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
          <span class="carousel-control-next-icon"></span>
        </button>
      </div>
    </div>

    <!-- 秒杀专区 -->
    <div v-if="seckillActivities.length > 0" class="seckill-section">
      <div class="section-title">⚡ 限时秒杀</div>
      <div class="seckill-list">
        <div v-for="act in seckillActivities" :key="act.id" class="seckill-card">
          <div class="seckill-left">
            <div class="seckill-price">¥{{ act.seckillPrice }}</div>
            <div class="seckill-original">¥{{ act.originalPrice }}</div>
          </div>
          <div class="seckill-right">
            <div class="seckill-name">{{ act.activityName }}</div>
            <div class="seckill-spu">{{ act.spuName }} · {{ act.skuName }}</div>
            <div class="seckill-progress">
              <div class="seckill-bar">
                <div class="seckill-fill" :style="{ width: Math.min(100, act.soldCount/act.stock*100) + '%' }"></div>
              </div>
              <span class="seckill-stock">已抢{{ act.soldCount }}/{{ act.stock }}</span>
            </div>
            <button class="seckill-btn" @click="goSeckillDetail(act)"
                    :disabled="act.soldCount >= act.stock">
              {{ act.soldCount >= act.stock ? '已抢完' : '去看看' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 推荐商品区 -->
    <div class="section-title">🔥 爆款推荐</div>
    <div class="products-section">
      <div class="row g-2" v-if="!loading">
        <div class="col-6 col-sm-4 col-md-3" v-for="p in products" :key="p.id">
          <div class="product-card-wrap">
            <div class="product-card" @click="goDetail(p)">
              <div class="p-img">
                <img v-if="p.mainImage" :src="p.mainImage" style="width: 100%; height: 100%; object-fit: contain;" alt="">
                <span v-else style="font-size: 48px;">🥬</span>
              </div>
              <div class="p-body">
                <div class="p-name">{{ p.name }}</div>
                <div class="p-sub">{{ p.brand || '精选好货' }}</div>
                <div class="p-bottom">
                  <div class="p-price">
                    <template v-if="p.priceLoaded">
                      <span v-if="p.minPrice">¥{{ p.minPrice }}</span>
                      <span v-else>--</span>
                      <span class="p-original" v-if="p.minOriginalPrice">¥{{ p.minOriginalPrice }}</span>
                    </template>
                    <span v-else class="price-skeleton"></span>
                  </div>
                  <button class="btn-cart" @click.stop="addCart(p)">+</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- 加载骨架 -->
      <div class="row g-2" v-else>
        <div class="col-6 col-sm-4 col-md-3" v-for="i in 8" :key="i">
          <div style="padding: 6px;">
            <div style="border-radius: 12px; overflow: hidden;">
              <div class="skeleton" style="height: 150px;"></div>
              <div style="padding: 10px; background: white;">
                <div class="skeleton" style="height: 14px; margin-bottom: 8px;"></div>
                <div class="skeleton" style="height: 14px; width: 70%;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 底部 TabBar -->
    <TabBar />

    <!-- Toast 消息 -->
    <div class="toast-msg" :class="{ show: toastShow }">{{ toastMsg }}</div>
  </div>
</template>

<style scoped>
.home-page {
  background: #f6f7f8;
  padding-bottom: 70px;
}

/* 顶部导航 */
.top-nav {
  position: sticky;
  top: 0;
  z-index: 999;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  padding: 10px 16px 8px;
  box-shadow: 0 2px 12px rgba(67, 233, 123, 0.25);
}

.top-nav .location {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.85);
  display: flex;
  align-items: center;
  gap: 4px;
  margin-bottom: 8px;
}

.top-nav .location svg {
  width: 13px;
  height: 13px;
}

.nav-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.logo-txt {
  font-size: 18px;
  font-weight: 700;
  color: white;
  white-space: nowrap;
}

.search-wrap {
  flex: 1;
  display: flex;
  background: white;
  border-radius: 22px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.search-wrap input {
  flex: 1;
  border: none;
  padding: 8px 14px;
  font-size: 13px;
  outline: none;
  background: transparent;
}

.search-wrap button {
  border: none;
  background: #2dbe60;
  color: white;
  padding: 8px 14px;
  font-size: 13px;
  cursor: pointer;
  border-radius: 0 22px 22px 0;
}

.user-area {
  display: flex;
  align-items: center;
  gap: 6px;
}

.user-area a {
  color: white;
  font-size: 13px;
  text-decoration: none;
  white-space: nowrap;
}

.user-area .divider {
  margin: 0 4px;
  opacity: 0.6;
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

/* 大类入口 */
.section-title {
  font-size: 15px;
  font-weight: 700;
  color: #222;
  padding: 14px 16px 6px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.section-title::before {
  content: '';
  width: 4px;
  height: 16px;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  border-radius: 2px;
}

.cat-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 0;
  background: white;
  padding: 10px 0 14px;
}

.cat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 8px 4px;
  cursor: pointer;
  text-decoration: none;
}

.cat-item:active {
  opacity: 0.7;
}

.cat-avatar {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
  transition: transform 0.2s;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
}

.cat-item:hover .cat-avatar {
  transform: scale(1.08);
}

.cat-label {
  font-size: 12px;
  color: #444;
}

/* 轮播 Banner */
.banner-section {
  padding: 12px 16px;
}

.banner-card {
  border-radius: 12px;
  overflow: hidden;
  position: relative;
  height: 150px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.banner-card .banner-content {
  position: relative;
  z-index: 1;
  color: white;
  text-align: center;
}

.banner-card .banner-tag {
  display: inline-block;
  background: #ff4d4f;
  color: white;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 10px;
  margin-bottom: 6px;
}

.banner-card .banner-title {
  font-size: 22px;
  font-weight: 800;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
}

.banner-card .banner-sub {
  font-size: 13px;
  opacity: 0.9;
  margin-top: 4px;
}

.banner-card .banner-btn {
  display: inline-block;
  margin-top: 8px;
  padding: 4px 16px;
  background: white;
  color: #e74c3c;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 700;
}

.carousel-indicators [data-bs-target] {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.6);
}

.carousel-indicators .active {
  background: white;
}

/* 商品推荐区 */
.products-section {
  padding: 0 12px 12px;
}

.product-card-wrap {
  padding: 6px;
}

.product-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.07);
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.product-card .p-img {
  height: 220px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f0fdf4, #ecfdf5);
  font-size: 56px;
}

.product-card .p-body {
  padding: 10px 12px 12px;
}

.product-card .p-name {
  font-size: 14px;
  font-weight: 600;
  color: #222;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  min-height: 40px;
}

.product-card .p-sub {
  font-size: 11px;
  color: #aaa;
  margin: 4px 0;
}

.product-card .p-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 8px;
}

.product-card .p-price {
  font-size: 18px;
  font-weight: 700;
  color: #e74c3c;
}

.product-card .p-price .p-unit {
  font-size: 11px;
  color: #aaa;
  font-weight: 400;
  margin-left: 2px;
}

.product-card .p-price .p-original {
  font-size: 11px;
  color: #ccc;
  text-decoration: line-through;
  margin-left: 4px;
}

.btn-cart {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: transform 0.15s;
  box-shadow: 0 3px 8px rgba(67, 233, 123, 0.4);
}

.btn-cart:active {
  transform: scale(0.9);
}

/* 加载骨架 */
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite;
  border-radius: 8px;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
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

/* 秒杀专区 */
.seckill-section {
  padding: 0 12px;
}
.seckill-list {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  padding: 0 4px 12px;
  scrollbar-width: none;
}
.seckill-card {
  flex-shrink: 0;
  width: 280px;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  box-shadow: 0 2px 10px rgba(0,0,0,0.07);
}
.seckill-left {
  width: 100px;
  background: linear-gradient(135deg,#ff6b6b,#ee5a24);
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 12px;
}
.seckill-price {
  font-size: 24px;
  font-weight: bold;
}
.seckill-original {
  font-size: 12px;
  text-decoration: line-through;
  opacity: 0.7;
}
.seckill-right {
  flex: 1;
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.seckill-name {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}
.seckill-spu {
  font-size: 12px;
  color: #999;
}
.seckill-progress {
  display: flex;
  align-items: center;
  gap: 8px;
}
.seckill-bar {
  flex: 1;
  height: 6px;
  background: #f0f0f0;
  border-radius: 3px;
  overflow: hidden;
}
.seckill-fill {
  height: 100%;
  background: linear-gradient(90deg,#ff6b6b,#ee5a24);
  border-radius: 3px;
  transition: width 0.3s;
}
.seckill-stock {
  font-size: 11px;
  color: #999;
  white-space: nowrap;
}
.seckill-btn {
  padding: 6px 0;
  border: none;
  border-radius: 20px;
  background: linear-gradient(135deg,#ff6b6b,#ee5a24);
  color: white;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s;
}
.seckill-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}
.seckill-btn:hover:not(:disabled) {
  opacity: 0.9;
}

/* Toast 消息 */
.toast-msg {
  position: fixed;
  bottom: 80px;
  left: 50%;
  transform: translateX(-50%);
  background: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 8px 18px;
  border-radius: 20px;
  font-size: 13px;
  opacity: 0;
  transition: opacity 0.3s;
  z-index: 9999;
  pointer-events: none;
}

.toast-msg.show {
  opacity: 1;
}
</style>
