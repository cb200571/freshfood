<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { addressApi } from '@/api'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const addresses = ref([])
const loading = ref(true)
const showForm = ref(false)
const editing = ref(null) // null=新增，有值=编辑

// 表单数据
const form = ref({
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detailAddress: '',
  isDefault: 0
})

// 加载地址列表
async function loadAddresses() {
  try {
    const res = await addressApi.getList(userStore.userId)
    if (res.code === 200) {
      addresses.value = res.data || []
    }
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

// 打开新增表单
function openAdd() {
  editing.value = null
  form.value = { receiverName: '', receiverPhone: '', province: '', city: '', district: '', detailAddress: '',
    isDefault: 0 }
  showForm.value = true
}

// 打开编辑表单
function openEdit(addr) {
  editing.value = addr.id
  form.value = { ...addr }
  showForm.value = true
}

// 关闭表单
function closeForm() {
  showForm.value = false
}

// 提交表单（新增或编辑）
async function submitForm() {
  if (!form.value.receiverName || !form.value.receiverPhone || !form.value.province || !form.value.detailAddress) {
    alert('请填写完整信息')
    return
  }
  try {
    let res
    if (editing.value) {
      res = await addressApi.update({ ...form.value, userId: userStore.userId })
    } else {
      res = await addressApi.add({ ...form.value, userId: userStore.userId })
    }
    if (res.code === 200) {
      alert(editing.value ? '修改成功' : '添加成功')
      showForm.value = false
      loadAddresses()
    } else {
      alert(res.message || '操作失败')
    }
  } catch (e) {
    alert('操作失败，请重试')
  }
}

// 删除地址
async function deleteAddr(addr) {
  if (!confirm('确定删除该地址吗？')) return
  try {
    const res = await addressApi.delete(addr.id, userStore.userId)
    if (res.code === 200) {
      alert('删除成功')
      loadAddresses()
    } else {
      alert(res.message || '删除失败')
    }
  } catch (e) {
    alert('删除失败，请重试')
  }
}

// 设为默认
async function setDefault(addr) {
  try {
    const res = await addressApi.setDefault(addr.id, userStore.userId)
    if (res.code === 200) {
      loadAddresses()
    }
  } catch (e) {
    console.error(e)
  }
}

onMounted(() => loadAddresses())
</script>

<template>
  <div class="address-page">
    <!-- 顶部 -->
    <div class="top-bar">
      <button class="back-btn" @click="router.back()">←</button>
      <span class="title">收货地址</span>
      <span style="width: 50px;"></span>
    </div>

    <!-- 加载中 -->
    <div v-if="loading" class="loading-state">加载中...</div>

    <!-- 地址列表 -->
    <div v-else-if="addresses.length > 0" class="address-list">
      <div v-for="addr in addresses" :key="addr.id" class="address-card">
        <div class="addr-info">
          <div class="addr-top">
            <span class="addr-name">{{ addr.receiverName }}</span>
            <span class="addr-phone">{{ addr.receiverPhone }}</span>
            <span v-if="addr.isDefault === 1" class="default-tag">默认</span>
          </div>
          <div class="addr-detail">
            {{ addr.province }}{{ addr.city }}{{ addr.district }} {{ addr.detailAddress }}
          </div>
        </div>
        <div class="addr-actions">
          <button v-if="addr.isDefault !== 1" @click="setDefault(addr)">设为默认</button>
          <button @click="openEdit(addr)">编辑</button>
          <button @click="deleteAddr(addr)" class="delete-btn">删除</button>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <div class="empty-icon">📍</div>
      <p>暂无收货地址</p>
    </div>

    <!-- 新增按钮 -->
    <button class="add-btn" @click="openAdd">+ 新增收货地址</button>

    <!-- 新增/编辑弹窗 -->
    <div v-if="showForm" class="modal-mask">
      <div class="modal-content">
        <div class="modal-header">
          <span>{{ editing ? '编辑地址' : '新增地址' }}</span>
          <button @click="closeForm">✕</button>
        </div>
        <div class="form-group">
          <label>收货人</label>
          <input v-model="form.receiverName" placeholder="请输入收货人姓名" />
        </div>
        <div class="form-group">
          <label>手机号</label>
          <input v-model="form.receiverPhone" placeholder="请输入手机号" />
        </div>
        <div class="form-group">
          <label>省份</label>
          <input v-model="form.province" placeholder="如：北京市" />
        </div>
        <div class="form-group">
          <label>城市</label>
          <input v-model="form.city" placeholder="如：北京市" />
        </div>
        <div class="form-group">
          <label>区/县</label>
          <input v-model="form.district" placeholder="如：朝阳区" />
        </div>
        <div class="form-group">
          <label>详细地址</label>
          <input v-model="form.detailAddress" placeholder="街道、门牌号等" />
        </div>
        <div class="form-group checkbox-group">
          <input type="checkbox" v-model="form.isDefault" :true-value="1" :false-value="0" id="isDefault" />
          <label for="isDefault">设为默认地址</label>
        </div>
        <button class="submit-btn" @click="submitForm">保存</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.address-page {
  min-height: 100vh;
  background: #f5f5f5;
  padding-bottom: 80px;
}

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

.back-btn { background: none; border: none; font-size: 20px; cursor: pointer; width: 50px; text-align: left; }
.title { font-size: 17px; font-weight: 600; }

.loading-state { text-align: center; padding: 60px; color: #999; }

.empty-state { text-align: center; padding: 80px 20px; color: #999; }
.empty-icon { font-size: 60px; margin-bottom: 12px; }

.address-list { padding: 12px 16px; }

.address-card {
  background: white;
  border-radius: 12px;
  padding: 14px 16px;
  margin-bottom: 12px;
}

.addr-top { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
.addr-name { font-weight: 600; font-size: 15px; }
.addr-phone { color: #666; font-size: 14px; }
.default-tag { background: #2dbe60; color: white; font-size: 11px; padding: 2px 6px; border-radius: 4px; }
.addr-detail { font-size: 13px; color: #666; }

.addr-actions {
  display: flex;
  gap: 10px;
  margin-top: 10px;
  padding-top: 10px;
  border-top: 1px solid #f5f5f5;
}

.addr-actions button {
  padding: 4px 12px;
  border: 1px solid #ddd;
  background: white;
  border-radius: 15px;
  font-size: 12px;
  cursor: pointer;
}

.delete-btn { color: #e74c3c; border-color: #f5c6cb; }

.add-btn {
  position: fixed;
  bottom: 20px;
  left: 16px;
  right: 16px;
  padding: 14px;
  background: #2dbe60;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

/* 弹窗 */
.modal-mask {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.modal-content {
  background: white;
  width: 100%;
  border-radius: 16px 16px 0 0;
  padding: 20px 16px 30px;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 600;
}

.modal-header button { background: none; border: none; font-size: 18px; cursor: pointer; }

.form-group { margin-bottom: 14px; }
.form-group label { display: block; font-size: 13px; color: #666; margin-bottom: 6px; }
.form-group input[type="text"],
.form-group input:not([type="checkbox"]) {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  box-sizing: border-box;
}

.checkbox-group { display: flex; align-items: center; gap: 8px; }
.checkbox-group label { margin-bottom: 0; }
.checkbox-group input { width: auto; }

.submit-btn {
  width: 100%;
  padding: 12px;
  background: #2dbe60;
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  margin-top: 10px;
}
</style>
