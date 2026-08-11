import { test, expect } from '@playwright/test'
import { adminlogin } from '../helpers/auth.js'
import { admin } from '../fixtures/test-data.js'
import { createProduct } from '../helpers/setup.js'

// ===== 商户端-商品管理用例（TC-091 ~ TC-099）=====
// 为避免破坏真实商品数据，需要"编辑/上下架/SKU"等用例都用接口新建的专属测试商品。
// 新增/编辑/上下架会触发 alert/confirm，点击前先处理弹窗。
// 商品列表数据量会随运行累积，放宽单测超时时间。
test.setTimeout(60_000)

// 进入商品管理页
const gotoProducts = async (page) => {
  await adminlogin(page, admin.username, admin.password)
  await page.getByText('商品管理').click()
  await page.waitForURL('**/admin/products')
  await expect(page.getByText('📦 商品管理')).toBeVisible()
}

// 打开"新增商品"弹窗并填好必填项（一级+二级分类）
async function openAddWithName(page, name) {
  await page.getByRole('button', { name: '新增商品' }).click()
  await expect(page.locator('#productModal .modal-content')).toBeVisible()
  await page.locator('#productModal input[placeholder="如：有机西兰花"]').fill(name)
  await page.locator('#productModal .form-select').nth(0).selectOption({ index: 1 })
  await expect(page.locator('#productModal .form-select').nth(1)).toBeEnabled()
  await page.locator('#productModal .form-select').nth(1).selectOption({ index: 1 })
}

// 点"保存"，自动接收弹出的 alert 并返回提示内容。
// 校验类 alert 是点击时同步弹出的，会阻塞 click；因此用 page.on 提前挂一个
// 自动 accept 的处理器（同时记录内容），点完再轮询拿到提示语。
async function saveProductModal(page) {
  let msg = ''
  page.on('dialog', async (d) => { msg = d.message(); await d.accept() })
  await page.locator('#productModal .modal-footer .btn-primary').click()
  await expect.poll(() => msg, { timeout: 10000 }).not.toBe('')
  return msg
}

test('TC-091 商户端打开商品列表展示全部商品', async ({ page }) => {
  await gotoProducts(page)
  // 表格展示商品数据（含已上架）
  await expect(page.locator('table.table tbody tr').first()).toBeVisible()
  await expect(page.locator('table.table tbody .badge').first()).toBeVisible()
  // 操作列有编辑 / SKU / 上下架
  await expect(page.locator('button', { hasText: '编辑' }).first()).toBeVisible()
  await expect(page.locator('button', { hasText: 'SKU' }).first()).toBeVisible()
})

test('TC-092 填完整信息新增商品成功', async ({ page }) => {
  await gotoProducts(page)
  const name = `新增商品${Date.now()}`
  await openAddWithName(page, name)

  expect(await saveProductModal(page)).toContain('新增成功')

  // 列表出现新商品
  await expect(page.locator('tr', { hasText: name })).toBeVisible()
})

test('TC-093 新增同名商品提示已存在', async ({ page }) => {
  await gotoProducts(page)
  // 取一个已存在的商品名
  const existingName = (await page.locator('table.table tbody tr').first().locator('td').nth(1).textContent()).trim()
  await openAddWithName(page, existingName)

  expect(await saveProductModal(page)).toContain('已存在')
})

test('TC-094 输入已存在名称实时提示重复', async ({ page }) => {
  await gotoProducts(page)
  const existingName = (await page.locator('table.table tbody tr').first().locator('td').nth(1).textContent()).trim()
  await page.getByRole('button', { name: '新增商品' }).click()
  await page.locator('#productModal input[placeholder="如：有机西兰花"]').fill(existingName)
  // 500ms 防抖 + 接口检查后，输入框下方实时提示
  await expect(page.locator('#productModal').getByText('该商品名称已存在')).toBeVisible()
})

test('TC-095 必填项留空保存提示校验', async ({ page }) => {
  await gotoProducts(page)
  await page.getByRole('button', { name: '新增商品' }).click()
  await expect(page.locator('#productModal .modal-content')).toBeVisible()

  expect(await saveProductModal(page)).toContain('请填写商品名称')
})

test('TC-096 编辑商品信息保存成功', async ({ page }) => {
  await gotoProducts(page)
  // 新建专属测试商品，避免改到真实商品
  const product = await createProduct(page)
  await page.reload()

  const row = page.locator('tr', { hasText: product.name })
  await expect(row).toBeVisible()
  await row.locator('button', { hasText: '编辑' }).click()
  await expect(page.locator('#productModal .modal-content')).toBeVisible()

  // 修改品牌
  await page.locator('#productModal input[placeholder="如：山东寿光"]').fill('自动编辑品牌')

  const dialogPromise = page.waitForEvent('dialog')
  await page.locator('#productModal .modal-footer .btn-primary').click()
  const dialog = await dialogPromise
  expect(dialog.message()).toContain('更新成功')
  await dialog.accept()
})

test('TC-097 商品上架下架状态切换', async ({ page }) => {
  await gotoProducts(page)
  const product = await createProduct(page)
  await page.reload()

  const row = page.locator('tr', { hasText: product.name })
  await expect(row).toBeVisible()
  // 状态徽章在第 5 列
  const statusBadge = row.locator('td').nth(4).locator('.badge')
  await expect(statusBadge).toHaveText('上架')

  page.on('dialog', (d) => d.accept())
  // 下架
  await row.locator('button', { hasText: '下架' }).click()
  await expect(statusBadge).toHaveText('下架')
  // 上架
  await row.locator('button', { hasText: '上架' }).click()
  await expect(statusBadge).toHaveText('上架')
})

test('TC-098 编辑SKU价格库存成功', async ({ page }) => {
  await gotoProducts(page)
  // 新建带 SKU 的测试商品
  const product = await createProduct(page)
  await page.reload()

  const row = page.locator('tr', { hasText: product.name })
  await expect(row).toBeVisible()
  await row.locator('button', { hasText: 'SKU' }).click()

  // 修改第一个 SKU 的价格，触发 @change 保存
  const [resp] = await Promise.all([
    page.waitForResponse((r) => r.url().includes('/api/product/update/sku')),
    page.locator('#skuModal input[type="number"]').first().fill('9.99'),
  ])
  expect(resp.status()).toBe(200)
})

test('TC-099 输入商品名搜索筛选', async ({ page }) => {
  await gotoProducts(page)
  const product = await createProduct(page)
  await page.reload()

  await page.getByPlaceholder('搜索商品名称...').fill(product.name)
  // 只显示匹配的那一行
  await expect(page.locator('table.table tbody tr', { hasText: product.name })).toHaveCount(1)
})
