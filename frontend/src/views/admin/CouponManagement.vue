<!-- frontend/src/views/admin/CouponManagement.vue -->
<!-- 商户端：优惠券管理页面 -->
<template>
  <div>
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3>🎫 优惠券管理</h3>
      <button class="btn btn-primary" @click="openAddModal">➕ 创建优惠券</button>
    </div>

    <!-- 优惠券列表 -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th>ID</th>
              <th>名称</th>
              <th>类型</th>
              <th>优惠</th>
              <th>最低消费</th>
              <th>已领/总量</th>
              <th>有效期</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="coupon in couponList" :key="coupon.id">
              <td>{{ coupon.id }}</td>
              <td>{{ coupon.name }}</td>
              <td>
                <span :class="coupon.type === 1 ? 'badge bg-primary' : 'badge bg-info'">
                  {{ coupon.type === 1 ? '满减' : '折扣' }}
                </span>
              </td>
              <td>{{ coupon.type === 1 ? `¥${coupon.amount}` : `${coupon.amount * 100}%off` }}</td>
              <td>¥{{ coupon.minSpend }}</td>
              <td>{{ coupon.used }}/{{ coupon.total }}</td>
              <td>{{ formatTime(coupon.startTime) }} ~ {{ formatTime(coupon.endTime) }}</td>
              <td>
                <span :class="coupon.status === 1 ? 'badge bg-success' : 'badge bg-secondary'">
                  {{ coupon.status === 1 ? '启用' : '禁用' }}
                </span>
              </td>
              <td>
                <button class="btn btn-sm btn-outline-warning me-1" @click="openIssueModal(coupon)">
                  📤 发放
                </button>
                <button
                  :class="coupon.status === 1 ? 'btn btn-sm btn-outline-danger' : 'btn btn-sm btn-outline-success'"
                  @click="toggleStatus(coupon)">
                  {{ coupon.status === 1 ? '禁用' : '启用' }}
                </button>
              </td>
            </tr>
            <tr v-if="couponList.length === 0">
              <td colspan="9" class="text-center text-muted py-4">暂无优惠券</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 创建优惠券弹窗 -->
    <div class="modal fade" id="couponModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">创建优惠券</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">优惠券名称 <span class="text-danger">*</span></label>
              <input v-model="form.name" class="form-control" placeholder="如：新人专享券">
            </div>
            <div class="mb-3">
              <label class="form-label">类型</label>
              <select v-model="form.type" class="form-select">
                <option :value="1">满减</option>
                <option :value="2">折扣</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">{{ form.type === 1 ? '优惠金额' : '折扣比例（如0.85=85折）' }}</label>
              <input v-model.number="form.amount" class="form-control" type="number" step="0.01">
            </div>
            <div class="mb-3">
              <label class="form-label">最低消费金额</label>
              <input v-model.number="form.minSpend" class="form-control" type="number" step="0.01">
            </div>
            <div class="mb-3">
              <label class="form-label">发放总量</label>
              <input v-model.number="form.total" class="form-control" type="number">
            </div>
            <div class="row mb-3">
              <div class="col-6">
                <label class="form-label">开始时间</label>
                <input v-model="form.startTime" class="form-control" type="datetime-local">
              </div>
              <div class="col-6">
                <label class="form-label">结束时间</label>
                <input v-model="form.endTime" class="form-control" type="datetime-local">
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitCoupon">创建</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 发放优惠券弹窗 -->
    <div class="modal fade" id="issueModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">发放优惠券 - {{ currentCoupon?.name }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">用户ID <span class="text-danger">*</span></label>
              <input v-model.number="issueUserId" class="form-control" type="number" placeholder="输入要发放的用户ID">
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" @click="issueCoupon">发放</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const couponList = ref([])
const form = ref({ name: '', type: 1, amount: 0, minSpend: 0, total: 100, startTime: '', endTime: '' })
const currentCoupon = ref(null)
const issueUserId = ref(null)

const formatTime = (t) => {
  if (!t) return '-'
  return t.replace('T', ' ').substring(0, 16)
}

const loadCoupons = async () => {
  const res = await fetch('/api/coupon/list').then(r => r.json())
  if (res.code === 200) couponList.value = res.data
}

const openAddModal = () => {
  form.value = { name: '', type: 1, amount: 0, minSpend: 0, total: 100, startTime: '', endTime: '' }
  new bootstrap.Modal(document.getElementById('couponModal')).show()
}

const submitCoupon = async () => {
  if (!form.value.name) { alert('请输入优惠券名称'); return }
  const res = await fetch('/api/coupon/create', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(form.value)
  }).then(r => r.json())
  if (res.code === 200) {
    alert('创建成功')
    bootstrap.Modal.getInstance(document.getElementById('couponModal')).hide()
    loadCoupons()
  } else {
    alert(res.message || '创建失败')
  }
}

const openIssueModal = (coupon) => {
  currentCoupon.value = coupon
  issueUserId.value = null
  new bootstrap.Modal(document.getElementById('issueModal')).show()
}

const issueCoupon = async () => {
  if (!issueUserId.value) { alert('请输入用户ID'); return }
  const res = await fetch(`/api/coupon/issue?couponId=${currentCoupon.value.id}&userId=${issueUserId.value}`, {
    method: 'POST'
  }).then(r => r.json())
  if (res.code === 200) {
    alert('发放成功')
    bootstrap.Modal.getInstance(document.getElementById('issueModal')).hide()
    loadCoupons()
  } else {
    alert(res.message || '发放失败')
  }
}

const toggleStatus = async (coupon) => {
  const newStatus = coupon.status === 1 ? 0 : 1
  const res = await fetch(`/api/coupon/status/${coupon.id}?status=${newStatus}`, { method: 'PUT' }).then(r => r.json())
  if (res.code === 200) {
    coupon.status = newStatus
  }
}

onMounted(loadCoupons)
</script>
