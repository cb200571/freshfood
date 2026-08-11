import { test, expect } from '@playwright/test'
import { adminlogin } from '../helpers/auth.js'
import { admin } from '../fixtures/test-data.js'
import {
  getUserId, createPendingOrder, payOrder, shipOrder, completeOrder,
} from '../helpers/setup.js'

// ===== 商户端-订单管理用例（TC-100 ~ TC-104）=====
// 订单表有压测遗留的数万条待付款订单，直接渲染"全部/待付款"会非常慢。
// 因此这里用 page.route 把订单列表接口 mock 成一份很小的数据（只有当前用例要用的
// 订单），保证页面秒开且断言确定；但"创建/支付/发货/完成"仍是真实后端接口。
// 发货/完成会触发 confirm，点击前先处理弹窗。

// 用给定订单列表 mock 商户端订单列表接口（按 status 参数过滤）
async function mockOrderList(page, rows) {
  await page.route(/\/api\/order\/admin\/list(\?.*)?$/, async (route) => {
    const url = new URL(route.request().url())
    const status = url.searchParams.get('status')
    const data = status === null ? rows : rows.filter((r) => String(r.status) === status)
    await route.fulfill({
      contentType: 'application/json',
      body: JSON.stringify({ code: 200, message: 'ok', data }),
    })
  })
}

// 构造订单列表行数据
const orderRow = (orderNo, status, userId) => ({
  id: Math.floor(Math.random() * 100000),
  orderNo,
  userId,
  receiverName: '自动化测试',
  receiverPhone: '13800001111',
  receiverAddress: '广东省深圳市南山区科技园1号',
  totalAmount: 5.9,
  payAmount: 5.9,
  status,
  createTime: '2026-08-11 10:00:00',
})

const gotoOrders = async (page) => {
  await adminlogin(page, admin.username, admin.password)
  await page.getByText('订单管理').click()
  await page.waitForURL('**/admin/orders')
  await expect(page.getByText('📋 订单管理')).toBeVisible()
}

test('TC-100 商户端打开订单列表展示全部', async ({ page }) => {
  const userId = await getUserId(page)
  const a = await createPendingOrder(page, userId)
  const b = await createPendingOrder(page, userId)
  await mockOrderList(page, [orderRow(a.orderNo, 0, userId), orderRow(b.orderNo, 1, userId)])

  await gotoOrders(page)
  // 状态筛选按钮齐全
  for (const label of ['全部', '待付款', '待发货', '已发货', '已完成', '已取消']) {
    await expect(page.locator('button', { hasText: label }).first()).toBeVisible()
  }
  // 列表展示订单（订单号已渲染）
  await expect(page.locator('table.table tbody tr code').first()).toBeVisible()
  await expect(page.locator('table.table tbody tr')).toHaveCount(2)
})

test('TC-101 按状态筛选订单正确', async ({ page }) => {
  const userId = await getUserId(page)
  const pending = await createPendingOrder(page, userId)
  await mockOrderList(page, [
    orderRow(pending.orderNo, 0, userId),
    orderRow(pending.orderNo, 1, userId),
    orderRow(pending.orderNo, 2, userId),
    orderRow(pending.orderNo, 3, userId),
  ])

  await gotoOrders(page)
  // 点"已完成"，只展示已完成订单
  await page.locator('button', { hasText: '已完成' }).click()
  await expect(page.locator('button', { hasText: '已完成' })).toHaveClass(/btn-primary/)
  await expect(page.locator('table.table tbody tr')).toHaveCount(1)
  await expect(page.locator('table.table tbody tr').first().locator('td').nth(4)).toContainText('已完成')
})

test('TC-102 已付款订单发货成功', async ({ page }) => {
  const userId = await getUserId(page)
  const paid = await createPendingOrder(page, userId)
  expect(await payOrder(page, paid.orderNo)).toBe(true) // 已付款 status=1
  await mockOrderList(page, [orderRow(paid.orderNo, 1, userId)])

  await gotoOrders(page)
  const row = page.locator('tr', { hasText: paid.orderNo })
  await expect(row).toBeVisible()
  await expect(row.locator('td').nth(4)).toContainText('待发货')

  page.on('dialog', (d) => d.accept())
  await row.locator('button', { hasText: '发货' }).click()
  // 真实发货接口调用成功后，状态乐观更新为"已发货"
  await expect(row.locator('td').nth(4)).toContainText('已发货')
})

test('TC-103 待付款订单无发货入口', async ({ page }) => {
  const userId = await getUserId(page)
  const pending = await createPendingOrder(page, userId) // 待付款 status=0
  await mockOrderList(page, [orderRow(pending.orderNo, 0, userId)])

  await gotoOrders(page)
  const row = page.locator('tr', { hasText: pending.orderNo })
  await expect(row).toBeVisible()
  // 待付款订单不展示"发货"按钮
  await expect(row.locator('button', { hasText: '发货' })).toHaveCount(0)
})

test('TC-104 已发货订单完成成功', async ({ page }) => {
  const userId = await getUserId(page)
  const shipped = await createPendingOrder(page, userId)
  expect(await payOrder(page, shipped.orderNo)).toBe(true)
  expect(await shipOrder(page, shipped.orderNo)).toBe(true) // 已发货 status=2
  await mockOrderList(page, [orderRow(shipped.orderNo, 2, userId)])

  await gotoOrders(page)
  const row = page.locator('tr', { hasText: shipped.orderNo })
  await expect(row).toBeVisible()
  await expect(row.locator('td').nth(4)).toContainText('已发货')

  page.on('dialog', (d) => d.accept())
  await row.locator('button', { hasText: '完成' }).click()
  // 真实完成接口调用成功后，状态乐观更新为"已完成"
  await expect(row.locator('td').nth(4)).toContainText('已完成')
})
