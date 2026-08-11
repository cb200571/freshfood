import { test, expect } from '@playwright/test'
import { adminlogin } from '../helpers/auth.js'
import { admin } from '../fixtures/test-data.js'
import { getUserId, createCoupon, getUserCoupons } from '../helpers/setup.js'

// ===== 商户端-优惠券用例（TC-105 ~ TC-108）=====
// 创建优惠券的用例已在 09-admin.spec.js（商户端）覆盖，这里补充其余用例。
// 发放会触发 alert，点击前先处理弹窗。

const gotoCoupons = async (page) => {
  await adminlogin(page, admin.username, admin.password)
  await page.getByText('优惠券').click()
  await page.waitForURL('**/admin/coupons')
  await expect(page.getByText('🎫 优惠券管理')).toBeVisible()
}

test('TC-106 商户端展示全部优惠券', async ({ page }) => {
  await gotoCoupons(page)
  // 列表展示已存在的优惠券
  await expect(page.locator('table.table tbody tr').first()).toBeVisible()
  await expect(page.locator('th', { hasText: '名称' })).toBeVisible()
  await expect(page.locator('th', { hasText: '状态' })).toBeVisible()
})

test('TC-107 切换优惠券状态生效', async ({ page }) => {
  await gotoCoupons(page)
  // 新建一张专属测试券，避免影响真实数据
  const coupon = await createCoupon(page)
  await page.reload()

  const row = page.locator('tr', { hasText: coupon.name })
  await expect(row).toBeVisible()
  const statusBadge = row.locator('td').nth(7).locator('.badge')
  await expect(statusBadge).toHaveText('启用')

  // 禁用 -> 状态变"禁用"
  await row.locator('button', { hasText: '禁用' }).click()
  await expect(statusBadge).toHaveText('禁用')
  // 启用 -> 状态变回"启用"
  await row.locator('button', { hasText: '启用' }).click()
  await expect(statusBadge).toHaveText('启用')
})

test('TC-108 给用户发放优惠券成功', async ({ page }) => {
  const coupon = await createCoupon(page)
  const userId = await getUserId(page)

  await gotoCoupons(page)
  await page.reload()
  const row = page.locator('tr', { hasText: coupon.name })
  await expect(row).toBeVisible()
  await row.locator('button', { hasText: '发放' }).click()

  // 输入要发放的用户ID
  await page.locator('#issueModal input[type="number"]').fill(String(userId))
  const dialogPromise = page.waitForEvent('dialog')
  await page.locator('#issueModal .modal-footer .btn-primary').click()
  const dialog = await dialogPromise
  expect(dialog.message()).toContain('发放成功')
  await dialog.accept()

  // 用户端能看到这张券
  const userCoupons = await getUserCoupons(page, userId)
  expect(userCoupons.some((c) => c.name === coupon.name)).toBe(true)
})
