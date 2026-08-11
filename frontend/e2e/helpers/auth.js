import { expect } from '@playwright/test'

// ===== 登录操作封装 =====
export async function login(page, username, password) {
  await page.goto('/login')

  await page.getByPlaceholder('请输入用户名').fill(username)

  await page.getByPlaceholder('请输入密码').fill(password)

  // 4. 点击"立即登录"按钮（class 是 btn-submit）
  await page.locator('.btn-submit').click()

  // 5. 等待登录成功：URL 跳转回首页
  await page.waitForURL('**/')
}
export async function adminlogin(page,username,password){
  await page.goto('/admin/login')
  await page.getByPlaceholder('请输入商户账号').fill(username)
  await page.getByPlaceholder('请输入密码').fill(password)
  await page.locator('.btn-primary').click()
  await page.waitForURL('**/admin/dashboard')

}
