import {test,expect} from '@playwright/test'
import { login } from '../helpers/auth.js'
import {testUser} from "../fixtures/test-data.js";



// 单点1：首页加载
test("首页正常展示商品分类和推荐商品",async({page})=>{
  await page.goto('/')
  await expect(page.locator('.section-title').first()).toBeVisible()
  await expect(page.locator('.product-card').first()).toBeVisible()
})
//6
test('搜索关键词能搜出商品', async ({ page }) => {
  await page.goto('/')
  await page.getByPlaceholder('搜索新鲜蔬果、肉禽...').fill('菠菜')
  await page.getByPlaceholder('搜索新鲜蔬果、肉禽...').press('Enter')
  await expect(page.getByText('有机菠菜')).toBeVisible();
})
// 单点3：切换一级分类
test('点击商品分类展示对应商品', async ({ page }) => {
  await page.goto('/')
  await page.locator('.cat-item').nth(0).click()
  await expect(page.locator('.cat-item.active',{hasText:"新鲜蔬菜"})).toHaveClass(/active/)
})
//单点4：首页点击限时秒杀去看看直接跳转到对应商品详情页
test('首页点击限时秒杀去看看直接跳转到对应商品详情页',async({page})=>{
  await page.goto('/')
  if(!(page.locator('.seckill-card >> nth=0 >> .seckill-btn').count())){

  }
  await page.locator('.seckill-card >> nth=0 >> .seckill-btn').click()
  await page.waitForURL('**/product/**')
  await expect(page.locator('.btn-buy')).toBeVisible()
})

//单点5 点击首页推荐商品进入商品详情页
test('点击首页推荐商品进入商品详情页',async({page})=>{
  await page.goto('/')
  await page.locator('.product-card').first().click()
  await page.waitForURL('**/product/**')
  await expect(page.locator('.btn-buy')).toBeVisible()
})
//单点6：首页点击头像进入个人中心
test('首页点击头像进入个人中心',async({page})=>{
  await login(page,testUser.username,testUser.password)
  await page.goto('/')
  await page.locator('.user-avatar').click()
  await expect(page.getByText('退出登录')).toBeVisible()
})
