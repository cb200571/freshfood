import { test, expect } from '@playwright/test'
import { adminlogin } from '../helpers/auth.js'
import { admin } from '../fixtures/test-data.js'
import { createProduct } from '../helpers/setup.js'

// ===== 商户端-数据看板用例（TC-113 ~ TC-114）=====
// 商户登录成功即落在数据看板页。

test('TC-113 打开数据看板展示统计', async ({ page }) => {
  await adminlogin(page, admin.username, admin.password)
  await page.waitForURL('**/admin/dashboard')

  await expect(page.getByText('📊 数据概览')).toBeVisible()
  // 统计卡片：今日订单 / 今日销售额 / 待发货 / 用户总数
  await expect(page.locator('.stat-card').first()).toBeVisible()
  await expect(page.getByText('今日订单')).toBeVisible()
  await expect(page.getByText('今日销售额')).toBeVisible()
  await expect(page.getByText('待发货')).toBeVisible()
  await expect(page.getByText('用户总数')).toBeVisible()
})

test('TC-114 展示低库存预警列表', async ({ page }) => {
  // 先造一个低库存 SKU（库存 5 <= 预警 10），数据看板应能列出
  const skuName = `低库存SKU${Date.now()}`
  await createProduct(page, {
    skuList: [{ skuName, price: 1, originalPrice: 2, stock: 5, warningStock: 10 }],
  })

  await adminlogin(page, admin.username, admin.password)
  await page.waitForURL('**/admin/dashboard')

  await expect(page.getByText('库存预警')).toBeVisible()
  // 预警列表里能看到该低库存 SKU
  await expect(page.locator('body')).toContainText(skuName)
})
