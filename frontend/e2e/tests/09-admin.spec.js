import { test, expect } from '@playwright/test'
import { testUser,admin } from '../fixtures/test-data.js'
import {adminlogin} from "../helpers/auth.js";

// ===== 商户端用例（TC-115 ~ TC-116）=====



test('TC-115 商户账号登录成功进入后台', async ({ page }) => {
  adminlogin(page,admin.username,admin.password)
  // 登录成功跳转数据看板
  await page.waitForURL('**/admin/dashboard')
  await expect(page.getByText('📊 数据概览')).toBeVisible()
  await expect(page.locator('.stat-card').first()).toBeVisible()
})

test('TC-116 未登录访问后台被拦截跳转商户登录页', async ({ page }) => {
  // 未登录直接访问后台路由
  await page.goto('/admin/dashboard')
  await page.waitForURL('**/admin/login')
  await expect(page.getByText('商户管理后台')).toBeVisible()
})

test('普通用户登录后台提示不是商户账号', async ({ page }) => {
  await page.goto('/admin/login')
  await page.getByPlaceholder('请输入商户账号').fill(testUser.username)
  await page.getByPlaceholder('请输入密码').fill(testUser.password)
  await page.locator('.btn-primary').click()

  await expect(page.locator('.text-danger')).toContainText('不是商户账号')
})
//
test('发放优惠券',async({page})=>{
  adminlogin(page,admin.username,admin.password)
  // 登录成功跳转数据看板
  await page.waitForURL('**/admin/dashboard')
  await page.getByText('优惠券').click()
  await page.locator('.btn-primary').first().click()
  await page.locator('.form-control').first().fill('测试优惠券')
  // 弹窗整体容器里面寻找按钮
  await page.locator(".modal-content").getByRole('button',{name:'创建', exact:true}).click()
  const dialog=await page.waitForEvent('dialog')
  expect (dialog.message()).toBe('创建成功')
})
test('创建优惠券',async({page})=>{
  adminlogin(page,admin.username,admin.password)
  // 登录成功跳转数据看板
  await page.waitForURL('**/admin/dashboard')
  await page.getByText('优惠券').click()
  await page.locator('.btn-primary').first().click()
  await page.locator('.form-control').first().fill('测试优惠券')
  // 弹窗整体容器里面寻找按钮
  await page.locator(".modal-content").getByRole('button',{name:'创建', exact:true}).click()
  const dialog=await page.waitForEvent('dialog')
  expect (dialog.message()).toBe('创建成功')
})
test('创建限时秒杀',async({page})=>{
  adminlogin(page,admin.username,admin.password)
  // 登录成功跳转数据看板
  await page.waitForURL('**/admin/dashboard')
  await page.getByText('限时秒杀').click()
  await page.locator('.btn-primary').first().click()
  await page.locator('.form-control').first().fill('测试限时秒杀')
  // 弹窗整体容器里面寻找按钮
  await page.locator('.modal-content').getByPlaceholder("搜索商品名称...").fill('菠菜')
  await page.locator('select.form-select').first().selectOption({label:"有机菠菜"})
  await page.locator('.col-6').locator('input.form-control[type="number"]').first().fill('3')
  await page.locator('.modal-content .date-time-input input[type="text"]').nth(0).fill('2026-08-10 00:00');
  await page.locator('.modal-content .date-time-input input[type="text"]').nth(1).fill('2026-12-30 00:00');
  await page.locator(".modal-content").getByRole('button',{name:'创建', exact:true}).click()
  const dialog=await page.waitForEvent('dialog')
  expect (dialog.message()).toBe('创建成功')
})
