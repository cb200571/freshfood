import { test, expect } from '@playwright/test'

// 首页核心元素验证
test('首页正常加载并展示核心模块', async ({ page }) => {
  // 打开首页
  await page.goto('/')

  // 断言顶部 logo 存在且文本正确
  // locator('.logo-txt') = 通过 CSS 类名定位到 logo 元素
  // toHaveText() = 断言元素内的文本完全等于期望值
  await expect(page.locator('.logo-txt')).toHaveText('🥬 鲜果生鲜')

  // 断言搜索框存在（placeholder 文本匹配）
  // getByPlaceholder() = 通过占位符文本定位输入框
  await expect(page.getByPlaceholder('搜索新鲜蔬果、肉禽...')).toBeVisible()

  // 断言"商品分类"区块标题可见
  // .section-title = 区块标题的类名，.first() = 取第一个匹配的元素
  await expect(page.locator('.section-title').first()).toBeVisible()
})
