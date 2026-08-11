import { test, expect } from '@playwright/test'
import { adminlogin } from '../helpers/auth.js'
import { admin } from '../fixtures/test-data.js'
import { createSeckillActivity } from '../helpers/setup.js'

// ===== 商户端-秒杀管理用例（TC-109 ~ TC-112）=====
// 创建秒杀用例已在 09-admin.spec.js 覆盖，这里补充列表展示与状态切换。
// 结束活动会触发 confirm，点击前先处理弹窗。

const gotoSecKill = async (page) => {
  await adminlogin(page, admin.username, admin.password)
  await page.getByText('限时秒杀').click()
  await page.waitForURL('**/admin/seckill')
  await expect(page.getByText('⚡ 限时秒杀')).toBeVisible()
}

test('TC-110 商户端展示全部秒杀活动', async ({ page }) => {
  await gotoSecKill(page)
  // 列表展示已存在的秒杀活动
  await expect(page.locator('table.table tbody tr').first()).toBeVisible()
  await expect(page.locator('th', { hasText: '活动名称' })).toBeVisible()
  await expect(page.locator('th', { hasText: '状态' })).toBeVisible()
})

test('TC-111 切换活动状态用户端变化', async ({ page }) => {
  // 新建一个进行中的活动（时间范围覆盖当前时间，后端自动置为 status=1）
  const activity = await createSeckillActivity(page)

  await gotoSecKill(page)
  const row = page.locator('tr', { hasText: activity.activityName })
  await expect(row).toBeVisible()
  const statusBadge = row.locator('td').nth(8).locator('.badge')
  await expect(statusBadge).toHaveText('进行中')

  // 点击"结束"，活动变为已结束（用户端将不再展示）
  page.on('dialog', (d) => d.accept())
  await row.locator('button', { hasText: '结束' }).click()
  await expect(statusBadge).toHaveText('已结束')
})
