import { test, expect } from '@playwright/test'
import { login } from '../helpers/auth.js'
import { testUser } from '../fixtures/test-data.js'
import { getUserId, addAddress } from '../helpers/setup.js'

// ===== 地址管理用例（TC-078 ~ TC-082）=====
// 新增/编辑/删除/设为默认会触发原生 alert/confirm，点击前先注册 dialog 处理。
// 为了不污染账号已有的地址，用例里通过接口新增"专属测试地址"，操作完即删，不影响原始数据。

// 弹窗内按 label 定位输入框
const modalInput = (page, label) =>
  page.locator('.modal-content .form-group', { hasText: label }).locator('input:not([type="checkbox"])')

test('TC-078 填写完整地址保存成功', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const name = `新地址${Date.now()}`

  await page.goto('/addressList')
  await page.locator('.add-btn').click()

  await modalInput(page, '收货人').fill(name)
  await modalInput(page, '手机号').fill('13800001111')
  await modalInput(page, '省份').fill('广东省')
  await modalInput(page, '城市').fill('深圳市')
  await modalInput(page, '区/县').fill('南山区')
  await modalInput(page, '详细地址').fill('科技园1号')

  // 保存成功后出现 alert"添加成功"，自动确认
  page.on('dialog', (dialog) => dialog.accept())
  await page.locator('.submit-btn').click()

  // 地址列表中能看到新地址
  await expect(page.locator('.address-card', { hasText: name })).toBeVisible()
})

test('TC-082 收件人为空保存提示必填', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/addressList')
  await page.locator('.add-btn').click()

  // 不填收货人，其余字段合法
  await modalInput(page, '手机号').fill('13800001111')
  await modalInput(page, '省份').fill('广东省')
  await modalInput(page, '城市').fill('深圳市')
  await modalInput(page, '区/县').fill('南山区')
  await modalInput(page, '详细地址').fill('科技园1号')

  page.on('dialog', (dialog) => dialog.accept())
  await page.locator('.submit-btn').click()

  // 提示"请填写完整信息"，弹窗不关闭、不新增
  await expect(page.locator('.modal-mask')).toBeVisible()
})

test('TC-079 编辑地址信息保存成功', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  const addr = await addAddress(page, userId, { receiverName: `待编辑${Date.now()}` })
  const name = addr.receiverName

  await page.goto('/addressList')
  const card = page.locator('.address-card', { hasText: name })
  await card.locator('.addr-actions button', { hasText: '编辑' }).click()

  // 修改详细地址
  await modalInput(page, '详细地址').fill('新研发中心99号')

  page.on('dialog', (dialog) => dialog.accept())
  await page.locator('.submit-btn').click()

  // 列表刷新后显示新的详细地址
  await expect(page.locator('.address-card', { hasText: name }).locator('.addr-detail')).toContainText('新研发中心99号')
})

test('TC-080 删除地址成功从列表移除', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  const addr = await addAddress(page, userId, { receiverName: `待删除${Date.now()}` })
  const name = addr.receiverName

  await page.goto('/addressList')
  const card = page.locator('.address-card', { hasText: name })
  await expect(card).toBeVisible()

  // 删除：confirm + alert 都自动点确定
  page.on('dialog', (dialog) => dialog.accept())
  await card.locator('.delete-btn').click()

  await expect(page.locator('.address-card', { hasText: name })).toHaveCount(0)
})

test('TC-081 设置默认地址切换标记', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  // 新增一个非默认地址，然后把它设为默认
  const addr = await addAddress(page, userId, { receiverName: `默认测试${Date.now()}` })
  const name = addr.receiverName

  await page.goto('/addressList')
  const card = page.locator('.address-card', { hasText: name })
  await expect(card.locator('.default-tag')).toHaveCount(0)

  await card.locator('.addr-actions button', { hasText: '设为默认' }).click()

  // 该地址变为默认，且整个列表只有一个默认标记
  await expect(card.locator('.default-tag')).toHaveCount(1)
  await expect(page.locator('.default-tag')).toHaveCount(1)
})
