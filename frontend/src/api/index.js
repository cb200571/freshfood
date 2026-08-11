// 统一管理接口请求




const API_BASE = '/api'  // 通过 Vite 代理转发到 localhost:8080

// 用户相关 API
export const userApi = {
  // 发送验证码
  sendCode(phone) {
    return fetch(`${API_BASE}/user/sendCode`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ phone })
    }).then(r => r.json())
  },

  // 登录（账号密码）
  loginByPassword(username, password) {
    return fetch(`${API_BASE}/user/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    }).then(r => r.json())
  },

  // 登录（手机验证码）
  loginByPhone(phone, code) {
    return fetch(`${API_BASE}/user/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ phone, code })
    }).then(r => r.json())
  },

  // 注册
  register(data) {
    return fetch(`${API_BASE}/user/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(r => r.json())
  }
}

// 分类相关 API
export const categoryApi = {
  // 获取一级分类
  getTopCategories() {
    return fetch(`${API_BASE}/category/top`).then(r => r.json())
  },

  // 获取二级分类
  getSubCategories(parentId) {
    return fetch(`${API_BASE}/category/sub/${parentId}`).then(r => r.json())
  }
}

// 导出一个对象，统一存放所有商品相关请求方法
export const productApi = {
  // 按一级分类查商品
  getByParentCategory(parentId) {
    return fetch(`${API_BASE}/product/parent-category/${parentId}`).then(r => r.json())
  },

  // 按二级分类查商品
  getByCategory(catId) {
    return fetch(`${API_BASE}/product/category/${catId}`).then(r => r.json())
  },

  // 搜索商品
  search(keyword) {
    return fetch(`${API_BASE}/product/search?keyword=${encodeURIComponent(keyword)}`).then(r => r.json())
  },

  // 获取商品详情
  getDetail(spuId) {
    return fetch(`${API_BASE}/product/detail/${spuId}`).then(r => r.json())
  },

  // 扣减库存
  decreaseStock(skuId, quantity) {
    return fetch(`${API_BASE}/product/stock/decrease`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ skuId, quantity })
    }).then(r => r.json())
  },

  // 商户端：获取所有商品（不过滤状态）
  getAll() {
    return fetch(`${API_BASE}/product/list`).then(r => r.json())
  },

  // 检查商品名称是否已存在
  checkName(name) {
    return fetch(`${API_BASE}/product/check-name?name=${encodeURIComponent(name)}`).then(r => r.json())
  },

  // 商户端：新增商品（含 SKU）
  save(productData) {
    return fetch(`${API_BASE}/product/save`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(productData)
    }).then(r => r.json())
  },

  // 商户端：更新商品（含 SKU）
  update(productData) {
    return fetch(`${API_BASE}/product/update`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(productData)
    }).then(r => r.json())
  },

  // 商户端：上下架商品
  updateStatus(spuId, status) {
    return fetch(`${API_BASE}/product/status/${spuId}?status=${status}`, {
      method: 'PUT'
    }).then(r => r.json())
  },

  // 商户端：获取商品的 SKU 列表
  getSkus(spuId) {
    return fetch(`${API_BASE}/product/skus/${spuId}`).then(r => r.json())
  },


  // 更新SKU
 updateSku(sku) {
    return fetch(`${API_BASE}/product/update/sku`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(sku)
    }).then(r => r.json())
  }
}
// 地址相关 API
export const addressApi = {
  // 获取用户的所有地址
  getList(userId) {
    return fetch(`${API_BASE}/address/list?userId=${userId}`).then(r => r.json())
  },

  // 获取用户的默认地址
  getDefault(userId) {
    return fetch(`${API_BASE}/address/default?userId=${userId}`).then(r => r.json())
  },

  // 添加地址
  add(address) {
    return fetch(`${API_BASE}/address/add`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(address)
    }).then(r => r.json())
  },

  // 更新地址
  update(address) {
    return fetch(`${API_BASE}/address/update`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(address)
    }).then(r => r.json())
  },

  // 删除地址
  delete(addressId, userId) {
    return fetch(`${API_BASE}/address/delete?addressId=${addressId}&userId=${userId}`, {
      method: 'DELETE'
    }).then(r => r.json())
  },

  // 设置默认地址
  setDefault(addressId, userId) {
    return fetch(`${API_BASE}/address/setDefault?addressId=${addressId}&userId=${userId}`, {
      method: 'PUT'
    }).then(r => r.json())
  }
}
export const orderApi = {
  // 创建订单
  create(orderData) {
    return fetch(`${API_BASE}/order/create`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(orderData)
    }).then(r => r.json())
  },

  // 获取用户订单列表
  getList(userId) {
    return fetch(`${API_BASE}/order/list?userId=${userId}`).then(r => r.json())
  },

  // 获取订单详情
  getDetail(orderNo) {
    return fetch(`${API_BASE}/order/detail?orderNo=${orderNo}`).then(r => r.json())
  },

  // 获取订单商品列表
  getItems(orderNo) {
    return fetch(`${API_BASE}/order/items?orderNo=${orderNo}`).then(r => r.json())
  },

  // 支付订单
  pay(orderNo) {
    return fetch(`${API_BASE}/order/pay?orderNo=${orderNo}`, {
      method: 'POST'
    }).then(r => r.json())
  },

  // 取消订单
  cancel(orderNo) {
    return fetch(`${API_BASE}/order/cancel?orderNo=${orderNo}`, {
      method: 'POST'
    }).then(r => r.json())
  }
}
// 仪表盘相关 API
// 秒杀相关 API
export const seckillApi = {
  // 获取进行中的秒杀活动
  getActive() {
    return fetch(`${API_BASE}/seckill/active`).then(r => r.json())
  },
  // 秒杀购买
  buy(activityId, userId) {
    return fetch(`${API_BASE}/seckill/buy?activityId=${activityId}&userId=${userId}`, {
      method: 'POST'
    }).then(r => r.json())
  }
}

export const dashboardApi = {
  // 获取统计数据
  getStats() {
    return fetch(`${API_BASE}/dashboard/stats`).then(r => r.json())
  },

  // 获取库存预警
  getLowStock() {
    return fetch(`${API_BASE}/dashboard/low-stock`).then(r => r.json())
  }
}
export const couponApi  = {
  // 获取我的优惠券（含详情）
  getMyCoupons(userId) {
    return fetch(`${API_BASE}/coupon/my/detail?userId=${userId}`).then(r => r.json())
  },
  // 使用优惠券
  useCoupon(couponUserId, orderNo) {
    return fetch(`${API_BASE}/coupon/use?couponUserId=${couponUserId}&orderNo=${orderNo}`, {
      method: 'POST'
    }).then(r => r.json())
  }
}
// 购物车 API（后端存储）
export const cartApi = {
  // 查询用户购物车
  list(userId) {
    return fetch(`${API_BASE}/cart/list?userId=${userId}`).then(r => r.json())
  },

  // 加购：body 传 {userId, skuId, spuId, quantity}
  add(data) {
    return fetch(`${API_BASE}/cart/add`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(r => r.json())
  },

  // 修改数量：body 传 {id, quantity}
  update(data) {
    return fetch(`${API_BASE}/cart/update`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    }).then(r => r.json())
  },

  // 删除购物车项
  remove(id) {
    return fetch(`${API_BASE}/cart/delete?id=${id}`, {
      method: 'DELETE'
    }).then(r => r.json())
  }
}
