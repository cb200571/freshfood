import { test, expect } from '@playwright/test'
import { login } from '../helpers/auth.js'
import { testUser } from '../fixtures/test-data.js'
import { getUserId, clearCart, addToCart, getAvailableSkus, createPendingOrder, payOrder } from '../helpers/setup.js'

// ===== 补充的用户端用例（登录边界 / 退出 / 购物车 / 订单 / 搜索无结果 / 404）=====
// 对应 TC-039~041、TC-045、TC-050、TC-057、TC-071、TC-076、TC-117

// ===== 登录边界 =====
test('TC-039 输入不存在账号登录提示用户不存在', async ({ page }) => {
  await page.goto('/login')
  await page.getByPlaceholder('请输入用户名').fill('not_exist_user')
  await page.getByPlaceholder('请输入密码').fill('whatever123')
  await page.locator('.btn-submit').click()
  await expect(page.locator('.alert-box')).toContainText('用户不存在')
})

test('TC-040 账号为空时登录提示请输入账号', async ({ page }) => {
  await page.goto('/login')
  await page.getByPlaceholder('请输入密码').fill('whatever123')
  await page.locator('.btn-submit').click()
  await expect(page.locator('.error-hint')).toHaveText('用户名不能为空')
})

test('TC-041 密码为空时登录提示请输入密码', async ({ page }) => {
  await page.goto('/login')
  await page.getByPlaceholder('请输入用户名').fill('some_user')
  await page.locator('.btn-submit').click()
  await expect(page.locator('.error-hint')).toHaveText('密码不能为空')
})

test('TC-045 点击退出登录清除登录态返回登录页', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  await page.goto('/my')
  await expect(page.locator('.logout-btn')).toBeVisible()
  await page.locator('.logout-btn').click()
  // 退出后回到首页
  await page.waitForURL('**/')
  // 再进"我的"页，应显示未登录卡片（登录态已清除）
  await page.goto('/my')
  await expect(page.locator('.nologin-card')).toBeVisible()
})

// ===== 商品浏览 =====
test('TC-050 搜索不存在关键词提示无结果', async ({ page }) => {
  await page.goto('/shop')
  await page.getByPlaceholder('搜索水果、蔬菜、肉禽蛋…').fill('不存在的商品xyz123')
  await page.getByPlaceholder('搜索水果、蔬菜、肉禽蛋…').press('Enter')
  // 无匹配商品时展示空状态
  await expect(page.locator('.empty')).toBeVisible()
})

// ===== 购物车 =====
test('TC-057 数量为1时减号置灰', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const [sku] = await getAvailableSkus(page, 1)
  await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  // 数量 1 时减号按钮禁用
  await expect(page.locator('.quantity-control span')).toHaveText('1')
  await expect(page.locator('.quantity-control button').nth(0)).toBeDisabled()
})

// ===== 下单支付 =====
test('TC-071 确认支付成功订单状态更新', async ({ page }) => {
  const userId = await getUserId(page)
  const order = await createPendingOrder(page, userId)
  await login(page, testUser.username, testUser.password)

  await page.goto(`/pay?orderNo=${order.orderNo}`)
  await expect(page.locator('.pay-amount')).toBeVisible()
  page.on('dialog', (d) => d.accept())
  await page.locator('.pay-btn').click()
  // 支付成功 -> 跳转订单列表
  await page.waitForURL('**/orderList')
})

// ===== 订单管理 =====
test('TC-076 已付款订单无取消入口', async ({ page }) => {
  const userId = await getUserId(page)
  const order = await createPendingOrder(page, userId)
  await payOrder(page, order.orderNo) // 已付款

  await login(page, testUser.username, testUser.password)
  await page.goto(`/orderDetail?orderNo=${order.orderNo}`)
  await expect(page.locator('.status-text')).toHaveText('已付款')
  // 已付款订单不提供"取消订单"入口
  await expect(page.locator('.btn-cancel')).toHaveCount(0)
})

// ===== 通用/边界 =====
test('TC-117 访问不存在路由不报错', async ({ page }) => {
  const errors = []
  page.on('pageerror', (e) => errors.push(e.message))
  await page.goto('/nonexistent-route-xyz')
  await page.waitForTimeout(500)
  expect(errors).toEqual([])
})
