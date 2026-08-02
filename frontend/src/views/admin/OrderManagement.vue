<!-- frontend/src/views/admin/OrderManagement.vue -->
<!-- 商户端：订单管理页面 -->
<template>
  <div>
    <h3 class="mb-3">📋 订单管理</h3>

    <!-- 状态筛选 -->
    <div class="card mb-3">
      <div class="card-body py-2">
        <div class="d-flex gap-2 align-items-center">
          <button v-for="tab in statusTabs" :key="tab.value"
                  :class="filterStatus === tab.value ? 'btn btn-primary btn-sm' : 'btn btn-outline-secondary btn-sm'"
                  @click="filterStatus = tab.value; loadOrders()">
            {{ tab.label }}
          </button>
          <button class="btn btn-sm btn-outline-secondary ms-auto" @click="loadOrders()">🔄 刷新</button>
        </div>
      </div>
    </div>

    <!-- 订单表格 -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th>订单号</th>
              <th>用户ID</th>
              <th>收货人</th>
              <th>总金额</th>
              <th>状态</th>
              <th>创建时间</th>
              <th width="200">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in orderList" :key="order.id">
              <td><code>{{ order.orderNo }}</code></td>
              <td>{{ order.userId }}</td>
              <td>{{ order.receiverName }}</td>
              <td>¥{{ order.payAmount }}</td>
              <td>
                <span :class="getStatusClass(order.status)">
                  {{ getStatusText(order.status) }}
                </span>
              </td>
              <td>{{ formatTime(order.createTime) }}</td>
              <td>
                <button class="btn btn-sm btn-outline-info me-1" @click="viewDetail(order)">
                  详情
                </button>
                <button v-if="order.status === 1" class="btn btn-sm btn-outline-success me-1" @click="shipOrder(order)">
                  🚚 发货
                </button>
                <button v-if="order.status === 2" class="btn btn-sm btn-outline-primary" @click="completeOrder(order)">
                  ✅ 完成
                </button>
              </td>
            </tr>
            <tr v-if="orderList.length === 0">
              <td colspan="7" class="text-center text-muted py-4">暂无订单数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 订单详情弹窗 -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">📋 订单详情 - {{ detailOrder?.orderNo }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body" v-if="detailOrder">
            <div class="row mb-3">
              <div class="col-6">
                <p><strong>收货人：</strong>{{ detailOrder.receiverName }}</p>
                <p><strong>手机号：</strong>{{ detailOrder.receiverPhone }}</p>
                <p><strong>地址：</strong>{{ detailOrder.receiverAddress }}</p>
              </div>
              <div class="col-6 text-end">
                <p><strong>总金额：</strong>¥{{ detailOrder.totalAmount }}</p>
                <p><strong>实付：</strong>¥{{ detailOrder.payAmount }}</p>
                <p><strong>状态：</strong>{{ getStatusText(detailOrder.status) }}</p>
              </div>
            </div>
            <h6>商品明细</h6>
            <table class="table table-sm">
              <thead>
                <tr>
                  <th>商品</th>
                  <th>规格</th>
                  <th>单价</th>
                  <th>数量</th>
                  <th>小计</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="item in orderItems" :key="item.id">
                  <td>{{ item.productName }}</td>
                  <td>{{ item.skuName }}</td>
                  <td>¥{{ item.price }}</td>
                  <td>{{ item.quantity }}</td>
                  <td>¥{{ item.totalAmount }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { orderApi } from '@/api'

const orderList = ref([])
const filterStatus = ref('')
const detailOrder = ref(null)
const orderItems = ref([])

const statusTabs = [
  { value: '', label: '全部' },
  { value: '0', label: '待付款' },
  { value: '1', label: '待发货' },
  { value: '2', label: '已发货' },
  { value: '3', label: '已完成' },
  { value: '4', label: '已取消' }
]

const getStatusText = (status) => {
  const map = { 0: '待付款', 1: '待发货', 2: '已发货', 3: '已完成', 4: '已取消' }
  return map[status] || '未知'
}

const getStatusClass = (status) => {
  const map = { 0: 'badge bg-warning', 1: 'badge bg-primary', 2: 'badge bg-info', 3: 'badge bg-success', 4: 'badge bg-secondary' }
  return map[status] || 'badge bg-secondary'
}

const formatTime = (t) => {
  if (!t) return '-'
  return t.replace('T', ' ').substring(0, 16)
}

// 加载订单列表
const loadOrders = async () => {
  const statusParam = filterStatus.value !== '' ? `?status=${filterStatus.value}` : ''
  const res = await fetch(`/api/order/admin/list${statusParam}`).then(r => r.json())
  if (res.code === 200) {
    orderList.value = res.data
  }
}

// 查看详情
const viewDetail = async (order) => {
  detailOrder.value = order
  const res = await orderApi.getItems(order.orderNo)
  orderItems.value = res.code === 200 ? res.data : []
  new bootstrap.Modal(document.getElementById('orderDetailModal')).show()
}

// 发货
const shipOrder = async (order) => {
  if (!confirm(`确定要发货订单 ${order.orderNo} 吗？`)) return
  const res = await fetch(`/api/order/admin/ship?orderNo=${order.orderNo}`, { method: 'POST' }).then(r => r.json())
  if (res.code === 200) {
    order.status = 2
  } else {
    alert(res.message || '发货失败')
  }
}

// 完成订单
const completeOrder = async (order) => {
  if (!confirm(`确定要完成订单 ${order.orderNo} 吗？`)) return
  const res = await fetch(`/api/order/admin/complete?orderNo=${order.orderNo}`, { method: 'POST' }).then(r => r.json())
  if (res.code === 200) {
    order.status = 3
  } else {
    alert(res.message || '操作失败')
  }
}

onMounted(loadOrders)
</script>
