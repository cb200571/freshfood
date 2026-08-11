import { test, expect } from '@playwright/test'
import { testUser } from '../fixtures/test-data.js'
import { login } from '../helpers/auth.js'

// ===== 登录模块测试用例 =====

test('使用正确账号密码登录成功', async ({ page }) => {
  // 调用封装好的登录函数（填账号、密码、点登录、等跳转）
  await login(page, testUser.username, testUser.password)

  // 断言：登录成功后回到首页，顶部 logo 可见
  await expect(page.locator('.logo-txt')).toBeVisible()
})

test('使用错误密码登录提示失败', async ({ page }) => {
  // 打开登录页
  await page.goto('/login')

  // 填正确用户名 + 错误密码
  await page.getByPlaceholder('请输入用户名').fill(testUser.username)
  await page.getByPlaceholder('请输入密码').fill('WrongPass_999')

  // 点登录按钮
  await page.locator('.btn-submit').click()

  // 断言：页面出现登录失败的提示框（class 是 alert-box，文本含"登录失败"）
  await expect(page.locator('.alert-box')).toContainText('密码错误')
})
