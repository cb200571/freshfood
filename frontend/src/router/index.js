
import { createRouter, createWebHistory } from 'vue-router'
import adminRoutes from './admin.js'
//调用 createRouter 生成全局路由对象 router，后续用来管理所有页面跳转、路由守卫。
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('../views/HomeView.vue'),
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/Login.vue'),
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../views/Register.vue'),
    },
    {
      path: '/shop',
      name: 'shop',
      component: () => import('../views/Shop.vue'),
    },
    {
      path: '/my',
      name: 'my',
      component: () => import('../views/My.vue'),
    },
    {
      path: '/product/:id',
      name: 'product',
      component: () => import('../views/ProductDetail.vue')
    },
    {
      path: '/cart',
      name: 'cart',
      component: () => import('../views/Cart.vue')
    },
    {
      path: '/orderConfirm',
      name: 'orderConfirm',
      component: () => import('../views/OrderConfirm.vue')
    },
    {
      path: '/pay',
      name: 'pay',
      component: () => import('../views/Pay.vue')
    },
    {
      path: '/orderList',
      name: 'orderList',
      component: () => import('../views/OrderList.vue')
    },
    {
      path: '/orderDetail',
      name: 'orderDetail',
      component: () => import('../views/OrderDetail.vue')
    },

    {
      path: '/addressList',
      name: 'addressList',
      component: () => import('../views/AddressList.vue')
    },
    {
      path: '/my/coupons',
      name: 'myCoupons',
      component: () => import('../views/MyCoupons.vue')
    },
    ...adminRoutes,//商户端路由


  ],

})

// 在每次页面跳转之前，检查用户有没有权限访问目标页面。如果没有，就拦住不让进
router.beforeEach((to, from, next) => {
  // 如果访问的是需要管理员权限的页面
  if (to.meta.requiresAdmin) {
    const token = localStorage.getItem('admin_token')
    if (!token) {
      // 没有 token，跳转到商户登录页
      next('/admin/login')
    } else {
      next()
    }
  } else {
    next()
  }
})
export default router//导出 router，在 main.js 引入并 app.use(router) 挂载到全局，之后所有组件都能用 useRouter/useRoute
