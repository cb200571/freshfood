import {test,expect} from '@playwright/test'
import { login } from '../helpers/auth.js'
import {testUser} from "../fixtures/test-data.js";


//
test('搜索关键词能搜出商品', async ({ page }) => {
  await page.goto('/shop')
  // 注意：Shop 页搜索框的 placeholder 用中文省略号"…"
  await page.getByPlaceholder('搜索水果、蔬菜、肉禽蛋…').fill('菠菜')
  await page.getByPlaceholder('搜索水果、蔬菜、肉禽蛋…').press('Enter')
  await expect(page.getByText('有机菠菜')).toBeVisible();
})
//切换一级分类
test('切换商品分类展示对应商品', async ({ page }) => {
  await page.goto('/shop')
  await page.locator('.cat-item').nth(1).click()
  await expect(page.getByText("热带水果")).toBeVisible()
})

// 商品详情页
test('商品详情页展示完整信息', async ({ page }) => {
  await page.goto('/shop')
  await page.locator('.product-card').first().click()
  await expect(page.getByText('商品详情')).toBeVisible()
})

// ========== 全链路：登录 → 加购 → 下单 ==========

test('登录后加入购物车并提交订单', async ({ page }) => {
  // 登录
  await login(page, testUser.username, testUser.password)

  // 1. 点第一个商品卡片，进商品详情页
  await page.locator('.product-card').first().click()
  // 等待跳转到详情页
  await page.waitForURL('**/product/**')

  // 2. 详情页只有一个"加入购物车"按钮，点击打开规格弹窗
  await page.locator('.btn-cart').click()
  // 等待规格弹窗出现（弹窗底部有确认按钮）
  await expect(page.locator('.modal-btn.cart-btn')).toBeVisible()
  // 点击弹窗内的"加入购物车"确认
  await page.locator('.modal-btn.cart-btn').click()

  // 3. 打开购物车
  await page.goto('/cart')
  await expect(page.locator('.checkout-btn')).toBeVisible()

  // 4. 点结算 → 跳确认订单页
  await page.locator('.checkout-btn').click()
  await page.waitForURL(/\/orderConfirm/)//可以兼容带参数的地址


  // 5. 若没有地址则新增一个
  if (!(await page.locator('.address-text').count())) {
    await page.locator('.add-address-btn').click()
    await page.getByPlaceholder('请输入收件人姓名').fill('自动化测试')
    await page.getByPlaceholder('请输入手机号').fill('13800001111')
    await page.getByPlaceholder('如：广东省').fill('广东省')
    await page.getByPlaceholder('如：深圳市').fill('深圳市')
    await page.getByPlaceholder('如：南山区').fill('南山区')
    await page.getByPlaceholder('街道、门牌号等').fill('科技园1号')
    await page.locator('.save-btn').click()
  }

  // 6. 提交订单 → 跳支付页
  await page.locator('.submit-btn').click()
  page.on('dialog', async dialog=>{

    await dialog.accept(); //确认、点击确定

  })

  await page.waitForURL(/\/pay/)
})

test('登录后立即购买并提交订单', async ({ page }) => {
  // 登录
  await login(page, testUser.username, testUser.password)

  // 1. 点第一个商品卡片，进商品详情页
  await page.locator('.product-card').first().click()
  // 等待跳转到详情页
  await page.waitForURL('**/product/**')
  await page.locator('.btn-buy').click()
  await expect(page.locator('.modal-btn.buy-btn')).toBeVisible()
  await page.locator('.modal-btn.buy-btn').click()
  await page.waitForURL(/\/orderConfirm/)

  // 5. 若没有地址则新增一个
  if (!(await page.locator('.address-text').count())) {
    await page.locator('.add-address-btn').click()
    await page.getByPlaceholder('请输入收件人姓名').fill('自动化测试')
    await page.getByPlaceholder('请输入手机号').fill('13800001111')
    await page.getByPlaceholder('如：广东省').fill('广东省')
    await page.getByPlaceholder('如：深圳市').fill('深圳市')
    await page.getByPlaceholder('如：南山区').fill('南山区')
    await page.getByPlaceholder('街道、门牌号等').fill('科技园1号')
    await page.locator('.save-btn').click()
  }

  // 6. 提交订单 → 跳支付页
  await page.locator('.submit-btn').click()
  page.on('dialog', async dialog=>{

    await dialog.accept(); //确认、点击确定

  })

  await page.waitForURL(/\/pay/)
})
