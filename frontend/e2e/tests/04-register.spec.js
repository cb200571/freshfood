import { test, expect } from '@playwright/test'

// ===== 注册模块用例（TC-001 ~ TC-036）=====
// 前端注册页为"输入即校验"，输入非法值后 .hint-err 会实时显示错误提示。
// 注意：用户名/手机号/密码输入框带 readonly（聚焦时才去除），因此先用 click 聚焦再 fill。

// 生成合法且唯一的注册数据
const validForm = () => ({
  username: `auto${Date.now()}`,              // 2-20位 字母+数字
  phone: `138${String(Date.now()).slice(-8)}`, // 1[3-9] 开头的 11 位手机号
  password: 'Test@1234',
  confirm: 'Test@1234',
  email: 'test@example.com',
})

// 注册页输入框定位
const input = (page, name) => {
  const selectors = {
    username: 'input[placeholder="2-20位中文/字母/数字"]',
    phone: 'input[placeholder="11位手机号"]',
    password: 'input[placeholder="8-20位，含大小写+数字+特殊字符"]',
    confirm: 'input[placeholder="再次输入密码"]',
    email: 'input[type="email"]',
  }
  return page.locator(selectors[name])
}

// 获取某个输入框所在表单组的错误提示元素
const errOf = (page, name) =>
  input(page, name)
    .locator('xpath=ancestor::div[contains(@class,"form-group")]')
    .locator('.hint-err')

// 填字段（带 readonly 的先点击聚焦）
async function setField(page, name, value) {
  const field = input(page, name)
  await field.click()
  await field.fill(value)
}

// 填写全部合法字段（可覆盖某个字段的值）
async function fillValidForm(page, overrides = {}) {
  const data = { ...validForm(), ...overrides }
  for (const name of ['username', 'phone', 'password', 'confirm', 'email']) {
    await setField(page, name, data[name])
  }
  return data
}

// ===== 用户名 =====
test('TC-002 用户名为空注册提示必填', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page, { username: '' })
  await page.locator('.btn-submit').click()
  await expect(errOf(page, 'username')).toHaveText('此项不能为空')
})

test('TC-003 输入1位用户名提示长度不足', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'username', 'a')
  await expect(errOf(page, 'username')).toHaveText('2-20位中文/字母/数字')
})

test('TC-006 输入21位用户名提示长度超限', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'username', 'a'.repeat(21))
  await expect(errOf(page, 'username')).toHaveText('2-20位中文/字母/数字')
})

test('TC-007 用户名含特殊字符提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'username', 'test@#$')
  await expect(errOf(page, 'username')).toHaveText('2-20位中文/字母/数字')
})

test('TC-008 用户名含空格提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'username', 'ab cd')
  await expect(errOf(page, 'username')).toHaveText('2-20位中文/字母/数字')
})

test('TC-009 用户名含下划线提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'username', 'ab_cd')
  await expect(errOf(page, 'username')).toHaveText('2-20位中文/字母/数字')
})

// ===== 手机号 =====
test('TC-012 手机号为空注册提示必填', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page, { phone: '' })
  await page.locator('.btn-submit').click()
  await expect(errOf(page, 'phone')).toHaveText('此项不能为空')
})

test('TC-013 输入10位手机号提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'phone', '1380013800')
  await expect(errOf(page, 'phone')).toHaveText('手机号格式不正确')
})

test('TC-014 输入12位手机号提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'phone', '138001380001')
  await expect(errOf(page, 'phone')).toHaveText('手机号格式不正确')
})

test('TC-015 手机号第二位为2提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'phone', '12800138000')
  await expect(errOf(page, 'phone')).toHaveText('手机号格式不正确')
})

test('TC-018 手机号非1开头提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'phone', '23800138000')
  await expect(errOf(page, 'phone')).toHaveText('手机号格式不正确')
})

test('TC-019 手机号含字母提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'phone', '1380013800a')
  await expect(errOf(page, 'phone')).toHaveText('手机号格式不正确')
})

// ===== 密码 =====
test('TC-021 密码为空注册提示必填', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page, { password: '' })
  await page.locator('.btn-submit').click()
  await expect(errOf(page, 'password')).toHaveText('密码不能为空')
})

test('TC-022 输入7位密码提示长度不足', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'Abc1234')
  await expect(errOf(page, 'password')).toHaveText('密码长度8-20位')
})

test('TC-025 输入21位密码提示长度超限', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'Test@1234567890123456')
  await expect(errOf(page, 'password')).toHaveText('密码长度8-20位')
})

test('TC-026 密码无大写字母提示需含大写', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'test@1234')
  await expect(errOf(page, 'password')).toHaveText('需包含大写字母')
})

test('TC-027 密码无小写字母提示需含小写', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'TEST@1234')
  await expect(errOf(page, 'password')).toHaveText('需包含小写字母')
})

test('TC-028 密码无数字提示需含数字', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'Test@abcd')
  await expect(errOf(page, 'password')).toHaveText('需包含数字')
})

test('TC-029 密码无特殊字符提示需含特殊字符', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'password', 'Test12345')
  await expect(errOf(page, 'password')).toHaveText('需包含特殊字符')
})

// ===== 确认密码 =====
test('TC-030 两次密码不一致提示校验失败', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page, { confirm: 'Test@5678' })
  await page.locator('.btn-submit').click()
  await expect(errOf(page, 'confirm')).toHaveText('两次密码不一致')
})

// ===== 邮箱（选填）=====
test('TC-032 输入无@的邮箱提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'email', 'test.com')
  await expect(errOf(page, 'email')).toHaveText('邮箱格式不正确')
})

test('TC-033 邮箱缺少域名后缀提示格式错误', async ({ page }) => {
  await page.goto('/register')
  await setField(page, 'email', 'test@qq')
  await expect(errOf(page, 'email')).toHaveText('邮箱格式不正确')
})

// ===== 协议 =====
test('TC-035 未勾选用户协议注册提示需同意', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page)
  await page.locator('.btn-submit').click()
  await expect(page.locator('.alert-box')).toContainText('请先阅读并同意用户协议')
})

// ===== 注册成功 =====
test('TC-001/036 使用合法信息注册成功并跳转登录页', async ({ page }) => {
  await page.goto('/register')
  await fillValidForm(page)
  // 勾选用户协议
  await page.locator('.agreement input[type="checkbox"]').check()
  await page.locator('.btn-submit').click()
  // 提示注册成功，1.5 秒后自动跳转登录页
  await expect(page.locator('.alert-box')).toContainText('注册成功')
  await page.waitForURL('**/login')
})
