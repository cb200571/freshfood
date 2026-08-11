import { test, expect } from '@playwright/test'
import { login } from '../helpers/auth.js'
import { testUser } from '../fixtures/test-data.js'
import { getUserId, getAvailableSkus, clearCart, addToCart } from '../helpers/setup.js'

// ===== 购物车模块用例（TC-055 ~ TC-061）=====
// 为避免购物车历史数据影响断言，每个用例先通过接口清空购物车，再构造确定数量的商品。
// 删除/清空会触发原生 confirm 弹窗，需要在点击前注册 dialog 处理。

// 解析 "¥5.90" -> 5.9
const parsePrice = (text) => Number(text.replace('¥', '').trim())

test('TC-061 空购物车展示空状态且结算禁用', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)

  await page.goto('/cart')
  await expect(page.locator('.empty-text')).toHaveText('购物车是空的')
  // 没有商品时底部结算栏不渲染
  await expect(page.locator('.checkout-btn')).toHaveCount(0)
})

test('TC-055 打开购物车正确展示商品信息', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const [sku] = await getAvailableSkus(page, 1)
  await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  await expect(page.locator('.cart-item')).toHaveCount(1)
  await expect(page.locator('.item-name')).toBeVisible()
  await expect(page.locator('.item-sku')).toBeVisible()
  await expect(page.locator('.item-price')).toBeVisible()
  await expect(page.locator('.price-value')).toBeVisible()
})

test('TC-056 修改商品数量金额实时更新', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const [sku] = await getAvailableSkus(page, 1)
  await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  const price = parsePrice(await page.locator('.item-price').textContent())

  // 点击加号，数量 1 -> 2
  await page.locator('.quantity-control button').nth(1).click()
  await expect(page.locator('.quantity-control span')).toHaveText('2')
  // 小计和合计同步更新为 价格 * 数量
  await expect(page.locator('.price-value')).toHaveText(`¥${(price * 2).toFixed(2)}`)

  // 点击减号，数量 2 -> 1
  await page.locator('.quantity-control button').nth(0).click()
  await expect(page.locator('.quantity-control span')).toHaveText('1')
  await expect(page.locator('.price-value')).toHaveText(`¥${(price * 1).toFixed(2)}`)
})

test('TC-058 删除购物车商品成功', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const [sku] = await getAvailableSkus(page, 1)
  await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  // 点击删除会弹 confirm，点"确定"
  page.on('dialog', (dialog) => dialog.accept())
  await page.locator('.item-delete').click()

  await expect(page.locator('.cart-item')).toHaveCount(0)
  await expect(page.locator('.empty-text')).toHaveText('购物车是空的')
})

test('TC-059 全选与取消全选联动合计更新', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const skus = await getAvailableSkus(page, 2)
  for (const sku of skus) await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  // 等两个商品都渲染出来（底部"全选"框也带 .checkbox.checked，所以按商品范围计数）
  await expect(page.locator('.cart-item .checkbox.checked')).toHaveCount(2)

  // 取消全选：所有商品不选中，合计为 0
  await page.locator('.select-all').click()
  await expect(page.locator('.cart-item .checkbox.checked')).toHaveCount(0)
  await expect(page.locator('.price-value')).toHaveText('¥0.00')
  await expect(page.locator('.total-count')).toContainText('已选 0 件')
  // 结算按钮禁用
  await expect(page.locator('.checkout-btn')).toBeDisabled()

  // 再次点击全选：全部选中
  await page.locator('.select-all').click()
  await expect(page.locator('.cart-item .checkbox.checked')).toHaveCount(2)
})

test('TC-060 只勾选部分商品合计按选中计算', async ({ page }) => {
  await login(page, testUser.username, testUser.password)
  const userId = await getUserId(page)
  await clearCart(page, userId)
  const skus = await getAvailableSkus(page, 2)
  for (const sku of skus) await addToCart(page, userId, sku, 1)

  await page.goto('/cart')
  // 等两个商品都渲染出来再读取单价
  await expect(page.locator('.cart-item')).toHaveCount(2)
  const prices = []
  for (const item of await page.locator('.cart-item').all()) {
    prices.push(parsePrice(await item.locator('.item-price').textContent()))
  }

  // 取消勾选第一个商品，合计只统计第二个商品
  await page.locator('.cart-item').nth(0).locator('.item-checkbox').click()
  await expect(page.locator('.cart-item .checkbox.checked')).toHaveCount(1)
  await expect(page.locator('.price-value')).toHaveText(`¥${prices[1].toFixed(2)}`)
})
