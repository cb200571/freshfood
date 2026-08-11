// ===== 测试数据准备（通过后端接口）=====
// 仅用于在用例内部稳定构造前置数据，不修改任何页面代码
import { testUser } from '../fixtures/test-data.js'

// 获取测试用户的 userId（走后端登录接口，不依赖硬编码 id）
export async function getUserId(page) {
  const res = await page.request.post('/api/user/login', {
    data: { username: testUser.username, password: testUser.password },
  })
  const body = await res.json()
  return body.data.userId
}

// 封装一个异步工具函数 getAvailableSkus，通过接口请求，自动筛选出上架、价格大于 0、库存大于 0、排除指定关键词的可用 SKU 商品；收集到指定条数之后立刻返回结果，专供你秒杀自动化脚本挑选合格商品使用。
// excludeKeyword：跳过名称含该关键词的商品（避免秒杀等活动污染首页某个商品的展示）
export async function getAvailableSkus(page, count = 2, excludeKeyword = '') {
  const listRes = await page.request.get('/api/product/list')
  const products = (await listRes.json()).data || []
  const skus = []
  for (const spu of products) {
    if (spu.status !== 1) continue //continue 结束本轮循环，直接跳到下一轮循环开头，后面代码不会执行
    if (excludeKeyword && (spu.name || '').includes(excludeKeyword)) continue
    const skuRes = await page.request.get(`/api/product/skus/${spu.id}`)
    const skuList = (await skuRes.json()).data || []
    for (const sku of skuList) {
      if (sku.status !== 1) continue
      const price = Number(sku.price)
      if (!(price > 0) || Number(sku.stock) <= 0) continue // 需要有效价格和库存
      skus.push({ spuId: spu.id, skuId: sku.id, price })
      if (skus.length >= count) return skus
    }
  }
  return skus
}

// 清空用户购物车
export async function clearCart(page, userId) {
  const res = await page.request.get(`/api/cart/list?userId=${userId}`)
  const body = await res.json()
  for (const item of body.data || []) {
    await page.request.delete(`/api/cart/delete?id=${item.id}`)
  }
}

// 添加购物车（同一 SKU 会累加数量）
export async function addToCart(page, userId, sku, quantity = 1) {
  await page.request.post('/api/cart/add', {
    data: { userId, skuId: sku.skuId, spuId: sku.spuId, quantity },
  })
}

// 创建一个待付款订单（用于订单取消等用例）
export async function createPendingOrder(page, userId) {
  const [sku] = await getAvailableSkus(page, 1)
  const res = await page.request.post('/api/order/create', {
    data: {
      userId,
      receiverName: '自动化测试',
      receiverPhone: '13800001111',
      receiverAddress: '广东省深圳市南山区科技园1号',
      items: [{
        spuId: sku.spuId,
        skuId: sku.skuId,
        productName: '自动化测试商品',
        skuName: '默认规格',
        productImage: '',
        price: sku.price,
        quantity: 1,
      }],
    },
  })
  const body = await res.json()
  return body.data
}

// 查询用户地址列表
export async function listAddresses(page, userId) {
  const res = await page.request.get(`/api/address/list?userId=${userId}`)
  return (await res.json()).data || []
}

// 新增收货地址，返回新创建的地址对象（通过查询列表取最新一条）
export async function addAddress(page, userId, overrides = {}) {
  const data = {
    userId,
    receiverName: `自动化地址${Date.now()}`,
    receiverPhone: '13800001111',
    province: '广东省',
    city: '深圳市',
    district: '南山区',
    detailAddress: '科技园1号',
    isDefault: 0,
    ...overrides,
  }
  await page.request.post('/api/address/add', { data })
  const list = await listAddresses(page, userId)
  return list[list.length - 1]
}

// ===== 商户端 / 订单 =====

// 支付订单（把待付款订单变成已付款）
export async function payOrder(page, orderNo) {
  const res = await page.request.post(`/api/order/pay?orderNo=${orderNo}`)
  return (await res.json()).code === 200
}

// 发货（已付款 -> 已发货）
export async function shipOrder(page, orderNo) {
  const res = await page.request.post(`/api/order/admin/ship?orderNo=${orderNo}`)
  return (await res.json()).code === 200
}

// 完成订单（已发货 -> 已完成）
export async function completeOrder(page, orderNo) {
  const res = await page.request.post(`/api/order/admin/complete?orderNo=${orderNo}`)
  return (await res.json()).code === 200
}

// ===== 商户端 / 商品 =====

// 取一个可用的二级分类 id
export async function getSubCategoryId(page) {
  const topRes = await page.request.get('/api/category/top')
  const tops = (await topRes.json()).data || []
  for (const top of tops) {
    const subRes = await page.request.get(`/api/category/sub/${top.id}`)
    const subs = (await subRes.json()).data || []
    if (subs.length) return subs[0].id
  }
  return null
}

// 通过接口新增商品（可带 SKU），返回 { id, ...提交数据 }
export async function createProduct(page, overrides = {}) {
  const categoryId = overrides.categoryId || (await getSubCategoryId(page))
  const data = {
    name: `自动商品${Date.now()}`,
    categoryId,
    brand: '自动化测试',
    description: '',
    mainImage: '',
    isColdChain: 0,
    shelfLife: 0,
    status: 1,
    skuList: [
      { skuName: `默认规格${Date.now()}`, price: 5, originalPrice: 8, stock: 100, warningStock: 10 },
    ],
    ...overrides,
  }
  const res = await page.request.post('/api/product/save', { data })
  return { id: (await res.json()).data, ...data }
}

// ===== 商户端 / 优惠券 =====

// 通过接口新增优惠券，返回 { id, ...提交数据 }
export async function createCoupon(page, overrides = {}) {
  const data = {
    name: `自动券${Date.now()}`,
    type: 1,
    amount: 10,
    minSpend: 30,
    total: 100,
    startTime: '2026-08-01T00:00',
    endTime: '2026-12-31T23:59',
    ...overrides,
  }
  const res = await page.request.post('/api/coupon/create', { data })
  return { id: (await res.json()).data, ...data }
}

// 切换优惠券状态（1 启用 / 0 禁用）
export async function setCouponStatus(page, id, status) {
  const res = await page.request.put(`/api/coupon/status/${id}?status=${status}`)
  return (await res.json()).code === 200
}

// 给用户发放优惠券
export async function issueCoupon(page, couponId, userId) {
  const res = await page.request.post(`/api/coupon/issue?couponId=${couponId}&userId=${userId}`)
  return (await res.json()).code === 200
}

// 查询用户优惠券（含券名）
export async function getUserCoupons(page, userId) {
  const res = await page.request.get(`/api/coupon/my/detail?userId=${userId}`)
  return (await res.json()).data || []
}

// ===== 商户端 / 秒杀 =====

// 通过接口新增秒杀活动（时间范围覆盖当前时间，后端会自动算为进行中 status=1）
// 刻意避开"菠菜"商品，避免活动展示到首页秒杀区时干扰其他用例对菠菜的断言
export async function createSeckillActivity(page, overrides = {}) {
  const [sku] = await getAvailableSkus(page, 1, '菠菜')
  const data = {
    activityName: `自动秒杀${Date.now()}`,
    spuId: sku.spuId,
    skuId: sku.skuId,
    seckillPrice: 1,
    originalPrice: sku.price,
    stock: 50,
    startTime: '2026-08-01T00:00',
    endTime: '2026-12-31T23:59',
    ...overrides,
  }
  const res = await page.request.post('/api/seckill/create', { data })
  return { id: (await res.json()).data, ...data }
}

// 切换秒杀活动状态（0 未开始 / 1 进行中 / 2 已结束）
export async function setSeckillStatus(page, id, status) {
  const res = await page.request.put(`/api/seckill/status/${id}?status=${status}`)
  return (await res.json()).code === 200
}
