<!-- frontend/src/views/admin/Dashboard.vue -->
<template>
  <div class="dashboard">
    <h3 class="mb-4">📊 数据概览</h3>

    <!-- 统计卡片 -->
    <div class="row g-3 mb-4">
      <div class="col-md-3">
        <div class="stat-card bg-primary text-white">
          <div class="stat-icon">📋</div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.todayOrderCount }}</div>
            <div class="stat-label">今日订单</div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card bg-success text-white">
          <div class="stat-icon">💰</div>
          <div class="stat-info">
            <div class="stat-number">¥{{ stats.todaySales }}</div>
            <div class="stat-label">今日销售额</div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card bg-warning text-white">
          <div class="stat-icon">📦</div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.pendingShipCount }}</div>
            <div class="stat-label">待发货</div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="stat-card bg-info text-white">
          <div class="stat-icon">👥</div>
          <div class="stat-info">
            <div class="stat-number">{{ stats.totalUsers }}</div>
            <div class="stat-label">用户总数</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 库存预警 -->
    <div class="card">
      <div class="card-header d-flex justify-content-between align-items-center">
        <span>⚠️ 库存预警</span>
        <span class="badge bg-danger">{{ lowStockList.length }} 项</span>
      </div>
      <div class="card-body">
        <div v-if="lowStockList.length === 0" class="text-muted text-center py-3">
          暂无库存不足的商品 👍
        </div>
        <table v-else class="table table-hover mb-0">
          <thead>
          <tr>
            <th>SKU名称</th>
            <th>SKU编码</th>
            <th>当前库存</th>
            <th>预警库存</th>
            <th>状态</th>
          </tr>
          </thead>
          <tbody>
          <tr v-for="sku in lowStockList" :key="sku.id">
            <td>{{ sku.skuName }}</td>
            <td><code>{{ sku.skuCode }}</code></td>
            <td>
              <span class="text-danger fw-bold">{{ sku.stock }}</span>
            </td>
            <td>{{ sku.warningStock }}</td>
            <td><span class="badge bg-danger">库存不足</span></td>
          </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { dashboardApi } from '@/api'

// 统计数据
const stats = ref({
  todayOrderCount: 0,
  todaySales: 0,
  pendingShipCount: 0,
  totalUsers: 0
})

// 库存预警列表
const lowStockList = ref([])

// 页面加载时获取数据
onMounted(async () => {
  // 并行请求，提高加载速度
  const [statsRes, stockRes] = await Promise.all([
    dashboardApi.getStats(),
    dashboardApi.getLowStock()
  ])

  if (statsRes.code === 200) {
    stats.value = statsRes.data
  }
  if (stockRes.code === 200) {
    lowStockList.value = stockRes.data
  }
})
</script>

<style scoped>
.stat-card {
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.1);
  transition: transform 0.2s;
}
.stat-card:hover {
  transform: translateY(-3px);
}
.stat-icon {
  font-size: 36px;
}
.stat-number {
  font-size: 28px;
  font-weight: bold;
}
.stat-label {
  font-size: 14px;
  opacity: 0.9;
}
</style>
