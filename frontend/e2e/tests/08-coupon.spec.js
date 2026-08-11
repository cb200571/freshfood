import { test, expect } from '@playwright/test'
import { login } from '../helpers/auth.js'
import { testUser } from '../fixtures/test-data.js'

// ===== 优惠券用例（TC-083 ~ TC-084）=====

test('TC-083 打开我的优惠券展示已领券', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/my/coupons')
  await expect(page.locator('.coupon-card').first()).toBeVisible()
  await expect(page.locator('.coupon-amount').first()).toBeVisible()
  await expect(page.locator('.coupon-name').first()).toBeVisible()
  // 每张券展示"未使用 / 已使用 / 已过期"中的一种状态
  await expect(page.locator('.coupon-status').first()).toHaveText(/未使用|已使用|已过期/)
})

test('TC-084 优惠券各状态展示正确', async ({ page }) => {
  await login(page, testUser.username, testUser.password)

  await page.goto('/my/coupons')
  const count = await page.locator('.coupon-card').count()
  // 有券时每张卡片的状态文本与状态样式类一致
  for (let i = 0; i < count; i++) {
    const statusText = await page.locator('.coupon-status').nth(i).textContent()
    const cardClass = await page.locator('.coupon-card').nth(i).getAttribute('class')
    if (statusText === '未使用') {
      expect(cardClass).toContain('status-unused')
    } else if (statusText === '已使用') {
      expect(cardClass).toContain('status-used')
    } else if (statusText === '已过期') {
      expect(cardClass).toContain('status-expired')
    }
  }
})

test('未登录访问我的优惠券提示请先登录', async ({ page }) => {
  await page.goto('/my/coupons')
  await expect(page.getByText('请先登录')).toBeVisible()
})
