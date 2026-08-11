<!-- frontend/src/views/admin/SeckillManagement.vue -->
<!-- 商户端：限时秒杀管理页面 -->
<template>
  <div>
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3>⚡ 限时秒杀</h3>
      <button class="btn btn-primary" @click="openAddModal">➕ 创建秒杀活动</button>
    </div>

    <!-- 秒杀活动列表 -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th>ID</th>
              <th>活动名称</th>
              <th>商品</th>
              <th>规格</th>
              <th>秒杀价</th>
              <th>原价</th>
              <th>已售/库存</th>
              <th>活动时间</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="activity in activityList" :key="activity.id">
              <td>{{ activity.id }}</td>
              <td>{{ activity.activityName }}</td>
              <td>{{ activity.spuName || 'ID:'+activity.spuId }}</td>
              <td>{{ activity.skuName || 'ID:'+activity.skuId }}</td>
              <td class="text-danger fw-bold">¥{{ activity.seckillPrice }}</td>
              <td class="text-decoration-line-through text-muted">¥{{ activity.originalPrice }}</td>
              <td>{{ activity.soldCount }}/{{ activity.stock }}</td>
              <td>{{ formatTime(activity.startTime) }}<br>~ {{ formatTime(activity.endTime) }}</td>
              <td>
                <span :class="getStatusClass(activity.status)">
                  {{ getStatusText(activity.status) }}
                </span>
              </td>
              <td>
                <button v-if="activity.status === 0" class="btn btn-sm btn-outline-success me-1"
                        @click="updateStatus(activity, 1)">
                  ▶️ 开始
                </button>
                <button v-if="activity.status === 1" class="btn btn-sm btn-outline-danger"
                        @click="updateStatus(activity, 2)">
                  ⏹️ 结束
                </button>
              </td>
            </tr>
            <tr v-if="activityList.length === 0">
              <td colspan="10" class="text-center text-muted py-4">暂无秒杀活动</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 创建秒杀活动弹窗 -->
    <div class="modal fade" id="seckillModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">创建秒杀活动</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">活动名称 <span class="text-danger">*</span></label>
              <input v-model="form.activityName" class="form-control" placeholder="如：限时特惠-有机蔬菜">
            </div>
            <div class="row mb-3">
              <div class="col-6">
                <label class="form-label">选择商品 <span class="text-danger">*</span></label>
                <input v-model="spuKeyword" class="form-control form-control-sm mb-1" placeholder="搜索商品名称...">
                <select v-model="form.spuId" class="form-select" @change="onSpuChange" size="4">
                  <option v-for="spu in filteredSpuList" :key="spu.id" :value="spu.id">
                    {{ spu.name }}
                  </option>
                </select>
              </div>
              <div class="col-6">
                <label class="form-label">选择规格 <span class="text-danger">*</span></label>
                <select v-model="form.skuId" class="form-select" :disabled="!form.spuId || skuList.length === 0">
                  <option :value="null">-- 请选择规格 --</option>
                  <option v-for="sku in skuList" :key="sku.id" :value="sku.id">
                    {{ sku.skuName }}（¥{{ sku.price }}，库存{{ sku.stock }}）
                  </option>
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-6">
                <label class="form-label">秒杀价 <span class="text-danger">*</span></label>
                <input v-model.number="form.seckillPrice" class="form-control" type="number" step="0.01">
              </div>
              <div class="col-6">
                <label class="form-label">原价 <span class="text-danger">*</span></label>
                <input v-model.number="form.originalPrice" class="form-control" type="number" step="0.01">
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label">秒杀库存</label>
              <input v-model.number="form.stock" class="form-control" type="number">
            </div>
            <div class="row mb-3">
              <div class="col-6">
                <label class="form-label">开始时间</label>
                <DateTimeInput v-model="form.startTime" />
              </div>
              <div class="col-6">
                <label class="form-label">结束时间</label>
                <DateTimeInput v-model="form.endTime" />
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitActivity">创建</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import DateTimeInput from '@/components/DateTimeInput.vue'
import { toISO } from '@/utils/datetime.js'

const activityList = ref([])
const spuList = ref([])     // 所有商品（SPU）
const skuList = ref([])     // 当前选中SPU的SKU列表
const spuKeyword = ref('')

// 搜索过滤后的商品列表
const filteredSpuList = computed(() => {
  if (!spuKeyword.value) return spuList.value
  const kw = spuKeyword.value.toLowerCase()
  return spuList.value.filter(s => s.name.toLowerCase().includes(kw))
})
const form = ref({
  activityName: '', spuId: null, skuId: null,
  seckillPrice: 0, originalPrice: 0, stock: 100,
  startTime: '', endTime: ''
})

const getStatusText = (status) => {
  const map = { 0: '未开始', 1: '进行中', 2: '已结束' }
  return map[status] || '未知'
}

const getStatusClass = (status) => {
  const map = { 0: 'badge bg-secondary', 1: 'badge bg-success', 2: 'badge bg-danger' }
  return map[status] || 'badge bg-secondary'
}

const formatTime = (t) => {
  if (!t) return '-'
  return t.replace('T', ' ').substring(0, 16)
}

const loadActivities = async () => {
  const res = await fetch('/api/seckill/list').then(r => r.json())
  if (res.code === 200) activityList.value = res.data
}

const loadSpuList = async () => {
  const res = await fetch('/api/product/list').then(r => r.json())
  if (res.code === 200) spuList.value = res.data
}

// 选中商品时加载SKU
const onSpuChange = async () => {
  skuList.value = []
  form.value.skuId = null
  if (!form.value.spuId) return
  const res = await fetch(`/api/product/skus/${form.value.spuId}`).then(r => r.json())
  if (res.code === 200) skuList.value = res.data
  // 自动填入原价（取第一个SKU的售价）
  if (skuList.value.length > 0) {
    form.value.originalPrice = skuList.value[0].price
    form.value.skuId = skuList.value[0].id
  }
}

const openAddModal = () => {
  form.value = {
    activityName: '', spuId: null, skuId: null,
    seckillPrice: 0, originalPrice: 0, stock: 100,
    startTime: '', endTime: ''
  }
  skuList.value = []
  spuKeyword.value = ''
  new bootstrap.Modal(document.getElementById('seckillModal')).show()
}

const submitActivity = async () => {
  if (!form.value.activityName || !form.value.spuId || !form.value.skuId) {
    alert('请填写完整信息')
    return
  }
  if (!form.value.seckillPrice || form.value.seckillPrice <= 0) {
    alert('请输入秒杀价')
    return
  }
  const res = await fetch('/api/seckill/create', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    // 日期时间支持手填，提交前统一转成后端格式
    body: JSON.stringify({
      ...form.value,
      startTime: toISO(form.value.startTime),
      endTime: toISO(form.value.endTime),
    })
  }).then(r => r.json())
  if (res.code === 200) {
    alert('创建成功')
    bootstrap.Modal.getInstance(document.getElementById('seckillModal')).hide()
    loadActivities()
  } else {
    alert(res.message || '创建失败')
  }
}

const updateStatus = async (activity, status) => {
  const action = status === 1 ? '开始' : '结束'
  if (!confirm(`确定要${action}活动「${activity.activityName}」吗？`)) return
  const res = await fetch(`/api/seckill/status/${activity.id}?status=${status}`, { method: 'PUT' }).then(r => r.json())
  if (res.code === 200) {
    activity.status = status
  }
}

onMounted(() => {
  loadActivities()
  loadSpuList()
})
</script>
