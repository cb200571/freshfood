import { test, expect } from '@playwright/test'
import { login } from '../helpers/auth.js'
import { testUser } from '../fixtures/test-data.js'
import { getUserId, createPendingOrder } from '../helpers/setup.js'

// ===== 订单管理用例（TC-073 ~ TC-077）=====
// 订单列表依赖账号已产生的历史订单；"待付款订单取消"用例通过接口先创建一个待付款订单，保证数据确定。

test('TC-073 打开我的订单展示订单列表', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/orderList')
  await expect(page.locator('.top-bar .title')).toHaveText('我的订单')
  await expect(page.locator('.order-tabs')).toBeVisible()
  // 账号已有历史订单，应展示订单卡片
  await expect(page.locator('.order-card').first()).toBeVisible()
  await expect(page.locator('.order-no').first()).toBeVisible()
  await expect(page.locator('.order-status').first()).toBeVisible()
})

test('TC-074 点击订单查看详情信息完整', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/orderList')
  await page.locator('.order-card').first().locator('.order-header').click()
  await page.waitForURL(/\/orderDetail/)

  // 详情页展示订单状态、收货信息、商品信息、订单信息、金额汇总
  await expect(page.locator('.detail-page')).toBeVisible()
  await expect(page.locator('.status-text')).toBeVisible()
  await expect(page.locator('.info-card').first()).toBeVisible()
  // 至少存在：收货信息 / 商品信息 / 订单信息 三张卡片
  await expect(page.locator('.info-card')).toHaveCount(4)
})

test('TC-075 待付款订单取消成功', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  // 先通过接口创建一个待付款订单
  const order = await createPendingOrder(page, userId)
  expect(order.orderNo).toBeTruthy()

  await page.goto(`/orderDetail?orderNo=${order.orderNo}`)
  await expect(page.locator('.status-text')).toHaveText('待付款')
  await expect(page.locator('.btn-cancel')).toBeVisible()

  // 点击取消：confirm + alert 都自动点确定
  page.on('dialog', (dialog) => dialog.accept())
  await page.locator('.btn-cancel').click()

  // 取消后状态变为"已取消"
  await expect(page.locator('.status-text')).toHaveText('已取消')
})

test('TC-077 订单状态标签切换筛选', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/orderList')
  // 点击"待付款"标签，应高亮
  await page.locator('.order-tab-item').nth(1).click()
  await expect(page.locator('.order-tab-item').nth(1)).toHaveClass(/active/)

  // 筛选后要么展示订单卡片，要么展示空状态，页面不能报错
  const cards = await page.locator('.order-card').count()
  if (cards > 0) {
    await expect(page.locator('.order-card').first()).toBeVisible()
  } else {
    await expect(page.locator('.empty-state')).toBeVisible()
  }
})
