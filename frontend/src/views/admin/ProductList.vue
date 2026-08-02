<!-- frontend/src/views/admin/ProductList.vue -->
<!-- 商户端：商品管理页面 -->
<template>
  <div>
    <!-- 顶部操作栏 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3>📦 商品管理</h3>
      <button class="btn btn-primary" @click="openAddModal">
        ➕ 新增商品
      </button>
    </div>

    <!-- 搜索栏 -->
    <div class="card mb-3">
      <div class="card-body py-2">
        <div class="row g-2 align-items-center">
          <div class="col-md-4">
            <input v-model="searchKeyword" class="form-control form-control-sm"
                   placeholder="搜索商品名称...">
          </div>
          <div class="col-md-3">
            <select v-model="filterStatus" class="form-select form-select-sm">
              <option value="">全部状态</option>
              <option value="1">已上架</option>
              <option value="0">已下架</option>
            </select>
          </div>
          <div class="col-md-2">
            <button class="btn btn-sm btn-outline-secondary" @click="loadProducts">🔄 刷新</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 商品表格 -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-hover mb-0">
          <thead class="table-light">
            <tr>
              <th width="60">ID</th>
              <th>商品名称</th>
              <th>分类</th>
              <th>品牌</th>
              <th width="80">状态</th>
              <th width="160">创建时间</th>
              <th width="220">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="spu in filteredList" :key="spu.id">
              <td>{{ spu.id }}</td>
              <td>{{ spu.name }}</td>
              <td><span class="badge bg-info bg-opacity-10 text-info">{{ getCategoryPath(spu.categoryId) }}</span></td>
              <td>{{ spu.brand || '-' }}</td>
              <td>
                <span :class="spu.status === 1 ? 'badge bg-success' : 'badge bg-secondary'">
                  {{ spu.status === 1 ? '上架' : '下架' }}
                </span>
              </td>
              <td>{{ formatTime(spu.createTime) }}</td>
              <td>
                <button class="btn btn-sm btn-outline-info me-1" @click="openEditModal(spu)">
                  ✏️ 编辑
                </button>
                <button class="btn btn-sm btn-outline-warning me-1" @click="openSkuModal(spu)">
                  📋 SKU
                </button>
                <button
                  :class="spu.status === 1 ? 'btn btn-sm btn-outline-danger' : 'btn btn-sm btn-outline-success'"
                  @click="toggleStatus(spu)">
                  {{ spu.status === 1 ? '⬇️ 下架' : '⬆️ 上架' }}
                </button>
              </td>
            </tr>
            <tr v-if="filteredList.length === 0">
              <td colspan="7" class="text-center text-muted py-4">暂无商品数据</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 新增/编辑商品弹窗 -->
    <div class="modal fade" id="productModal" tabindex="-1">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ isEdit ? '编辑商品' : '新增商品' }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">商品名称 <span class="text-danger">*</span></label>
                <input v-model="form.name" class="form-control" placeholder="如：有机西兰花">
                <!-- 名称重复提示 -->
                <div v-if="nameChecking" class="mt-1" style="font-size:12px;color:#999;">⏳ 检查名称中...</div>
                <div v-else-if="nameExists" class="mt-1" style="font-size:12px;color:#ff4d4f;">❌ 该商品名称已存在</div>
                <div v-else-if="form.name && !isEdit" class="mt-1" style="font-size:12px;color:#52c41a;">✅ 名称可用</div>
              </div>
              <div class="col-md-6">
                <label class="form-label">品牌/产地</label>
                <input v-model="form.brand" class="form-control" placeholder="如：山东寿光">
              </div>
              <div class="col-md-6">
                <label class="form-label">一级分类 <span class="text-danger">*</span></label>
                <select v-model="selectedTopCatId" class="form-select" @change="onTopCatChange">
                  <option :value="null">-- 请选择一级分类 --</option>
                  <option v-for="cat in topCategories" :key="cat.id" :value="cat.id">
                    {{ cat.name }}
                  </option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">二级分类 <span class="text-danger">*</span></label>
                <select v-model="form.categoryId" class="form-select" :disabled="subCategories.length === 0">
                  <option :value="null">-- 请选择二级分类 --</option>
                  <option v-for="cat in subCategories" :key="cat.id" :value="cat.id">
                    {{ cat.name }}
                  </option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">上架状态</label>
                <select v-model="form.status" class="form-select">
                  <option :value="1">上架</option>
                  <option :value="0">下架</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">是否冷链</label>
                <select v-model="form.isColdChain" class="form-select">
                  <option :value="1">需要冷链</option>
                  <option :value="0">常温配送</option>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">保质期（天，0=不限）</label>
                <input v-model.number="form.shelfLife" class="form-control" type="number">
              </div>
              <div class="col-12">
                <label class="form-label">商品描述</label>
                <textarea v-model="form.description" class="form-control" rows="2" placeholder="商品描述信息"></textarea>
              </div>
              <div class="col-12">
                <label class="form-label">主图URL</label>
                <input v-model="form.mainImage" class="form-control" placeholder="图片地址">
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
            <button type="button" class="btn btn-primary" @click="submitProduct" :disabled="submitting">
              {{ submitting ? '保存中...' : '保存' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- SKU 管理弹窗 -->
    <div class="modal fade" id="skuModal" tabindex="-1">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">📋 SKU管理 - {{ currentSpu?.name }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <table class="table table-sm">
              <thead>
              <tr>
                <th>SKU名称</th>
                <th>编码</th>
                <th>售价</th>
                <th>原价</th>
                <th>库存</th>
                <th>预警库存</th>
                <th>状态</th>
              </tr>
              </thead>
              <tbody>
              <tr v-for="sku in skuList" :key="sku.id">
                <td>{{ sku.skuName }}</td>
                <td><code>{{ sku.skuCode }}</code></td>
                <td style="vertical-align: middle;">
                  <div class="input-group input-group-sm" style="width: 90px; margin: 0;">
                    <span class="input-group-text" style="padding: 0.2rem 0.4rem;">¥</span>
                    <input
                      v-model.number="sku.price"
                      type="number"
                      step="0.01"
                      min="0"
                      class="form-control form-control-sm"
                      style="width: 65px; padding: 0.2rem 0.3rem;"
                      @change="saveSku(sku)"
                    >
                  </div>
                </td>
                <td style="vertical-align: middle;">
                  <div class="input-group input-group-sm" style="width: 90px; margin: 0;">
                    <span class="input-group-text" style="padding: 0.2rem 0.4rem;">¥</span>
                    <input
                      v-model.number="sku.originalPrice"
                      type="number"
                      step="0.01"
                      min="0"
                      class="form-control form-control-sm"
                      style="width: 65px; padding: 0.2rem 0.3rem;"
                      @change="saveSku(sku)"
                    >
                  </div>
                </td>
                <td>
                  <input v-model.number="sku.stock" type="number" class="form-control form-control-sm"
                         style="width:80px" @change="saveSku(sku)">
                </td>
                <td>
                  <input v-model.number="sku.warningStock" type="number" class="form-control form-control-sm"
                         style="width:80px" @change="saveSku(sku)">
                </td>
                <td>
                    <span :class="sku.status === 1 ? 'badge bg-success' : 'badge bg-secondary'">
                      {{ sku.status === 1 ? '启用' : '禁用' }}
                    </span>
                </td>
              </tr>
              <tr v-if="skuList.length === 0">
                <td colspan="7" class="text-center text-muted">暂无SKU</td>
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
import { ref, computed, watch, onMounted } from 'vue'
import { productApi, categoryApi } from '@/api'

// 商品列表
const productList = ref([])
const searchKeyword = ref('')
const filterStatus = ref('')

// 表单相关
const form = ref({})
const isEdit = ref(false)
const submitting = ref(false)
const nameExists = ref(false)       // 商品名是否已存在
const nameChecking = ref(false)     // 是否正在检查

// SKU 相关
const currentSpu = ref(null)
const skuList = ref([])

// 分类相关
const topCategories = ref([])      // 一级分类列表
const subCategories = ref([])      // 二级分类列表（根据选中的一级分类加载）
const selectedTopCatId = ref(null) // 选中的一级分类ID
const categoryMap = ref({})        // 分类ID → 分类名称
const categoryParentMap = ref({})  // 二级分类ID → 一级分类ID

// 获取分类名称
function getCategoryName(catId) {
  return categoryMap.value[catId] || `ID:${catId}`
}

// 获取完整分类路径（一级 > 二级）
function getCategoryPath(catId) {
  if (!catId) return '-'
  const name = categoryMap.value[catId]
  if (!name) return `ID:${catId}`
  const parentId = categoryParentMap.value[catId]
  if (parentId) {
    const pName = categoryMap.value[parentId]
    return pName ? `${pName} > ${name}` : name
  }
  return name
}

// 加载所有分类
async function loadAllCategories() {
  try {
    const topRes = await categoryApi.getTopCategories()
    if (topRes.code !== 200) return
    topCategories.value = topRes.data
    topRes.data.forEach(c => { categoryMap.value[c.id] = c.name })
    // 加载所有二级分类
    const promises = topRes.data.map(tc => categoryApi.getSubCategories(tc.id))
    const results = await Promise.all(promises)
    results.forEach((res, idx) => {
      if (res.code === 200) {
        res.data.forEach(sc => {
          categoryMap.value[sc.id] = sc.name
          categoryParentMap.value[sc.id] = topRes.data[idx].id
        })
      }
    })
  } catch (e) {
    console.error('加载分类失败:', e)
  }
}

// 选中一级分类时加载二级分类
async function onTopCatChange() {
  subCategories.value = []
  form.value.categoryId = null
  if (!selectedTopCatId.value) return
  try {
    const res = await categoryApi.getSubCategories(selectedTopCatId.value)
    if (res.code === 200) subCategories.value = res.data
  } catch (e) {
    console.error('加载二级分类失败:', e)
  }
}

// 搜索 + 筛选（前端 computed 响应式过滤，不需要重新请求后端）
const filteredList = computed(() => {
  let list = productList.value
  if (searchKeyword.value) {
    const kw = searchKeyword.value.toLowerCase()
    list = list.filter(s => s.name.toLowerCase().includes(kw))
  }
  if (filterStatus.value !== '') {
    list = list.filter(s => s.status === Number(filterStatus.value))
  }
  return list
})

// 格式化时间
const formatTime = (t) => {
  if (!t) return '-'
  return t.replace('T', ' ').substring(0, 16)
}

// 加载商品列表
const loadProducts = async () => {
  const res = await productApi.getAll()
  if (res.code === 200) {
    productList.value = res.data.records || res.data
  }
}

// 打开新增弹窗
const openAddModal = () => {
  isEdit.value = false
  selectedTopCatId.value = null
  subCategories.value = []
  form.value = {
    name: '', categoryId: null, brand: '', description: '',
    mainImage: '', isColdChain: 0, shelfLife: 0, status: 1, skuList: []
  }
  new bootstrap.Modal(document.getElementById('productModal')).show()
}

// 打开编辑弹窗
const openEditModal = (spu) => {
  isEdit.value = true
  form.value = { ...spu, skuList: [] }
  // 自动回填分类：根据 categoryId 找到对应的一级分类并加载二级分类
  if (spu.categoryId) {
    const parentId = categoryParentMap.value[spu.categoryId]
    if (parentId) {
      selectedTopCatId.value = parentId
      const catId = spu.categoryId // 先保存，因为 onTopCatChange 会重置 categoryId
      onTopCatChange().then(() => {
        form.value.categoryId = catId // 恢复为当前商品的分类ID
      })
    }
  }
  new bootstrap.Modal(document.getElementById('productModal')).show()
}

// 提交商品（新增/编辑）
const submitProduct = async () => {
  if (!form.value.name || !form.value.categoryId) {
    alert('请填写商品名称，并选择完整的分类（一级+二级）')
    return
  }
  submitting.value = true
  try {
    const res = isEdit.value
      ? await productApi.update(form.value)
      : await productApi.save(form.value)
    if (res.code === 200) {
      alert(isEdit.value ? '更新成功' : '新增成功')
      bootstrap.Modal.getInstance(document.getElementById('productModal')).hide()
      loadProducts()
    } else {
      alert(res.message || '操作失败')
    }
  } finally {
    submitting.value = false
  }
}

// 监听商品名输入，延迟500ms检查是否已存在
let nameTimer = null
watch(() => form.value.name, (newVal) => {
  clearTimeout(nameTimer)
  nameExists.value = false
  if (!newVal || isEdit.value) return  // 编辑模式不检查
  nameChecking.value = true
  nameTimer = setTimeout(async () => {
    const res = await productApi.checkName(newVal)
    nameExists.value = res.code === 200 && res.data === true
    nameChecking.value = false
  }, 500)
})

// 上下架
const toggleStatus = async (spu) => {
  const newStatus = spu.status === 1 ? 0 : 1
  const action = newStatus === 1 ? '上架' : '下架'
  if (!confirm(`确定要${action}「${spu.name}」吗？`)) return

  const res = await productApi.updateStatus(spu.id, newStatus)
  if (res.code === 200) {
    spu.status = newStatus  // 乐观更新：直接改本地数据，体验更快
  }
}

// 打开 SKU 弹窗
const openSkuModal = async (spu) => {
  currentSpu.value = spu
  const res = await productApi.getSkus(spu.id)
  skuList.value = res.code === 200 ? res.data : []
  new bootstrap.Modal(document.getElementById('skuModal')).show()
}

// 保存sku
const saveSku = async (sku) => {
  const res = await productApi.updateSku(sku)
  if (res.code !== 200) {
    alert('库存更新失败')
  }
}

onMounted(() => {
  loadAllCategories()
  loadProducts()
})
</script>
