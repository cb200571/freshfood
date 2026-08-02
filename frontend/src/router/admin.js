const adminRoutes = [
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('@/views/admin/AdminLogin.vue'),
    meta: { title: '商户登录' }
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/AdminLayout.vue'),
    meta: { requiresAdmin: true },//标记该路由组需要管理员登录鉴权
    redirect: '/admin/dashboard',//访问 /admin 时自动重定向到子页面 /admin/dashboard
    children: [
      {
        path: 'dashboard',//子路由路径，不用写完整 /admin/dashboard，会自动拼接父path
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '数据概览' }
      },
      {
        path: 'products',
        name: 'AdminProducts',
        component: () => import('@/views/admin/ProductList.vue'),
        meta: { title: '商品管理' }
      },
      {
        path: 'orders',
        name: 'AdminOrders',
        component: () => import('@/views/admin/OrderManagement.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: () => import('@/views/admin/UserManagement.vue'),
        meta: { title: '用户管理' }
      },
      {
        path: 'coupons',
        name: 'AdminCoupons',
        component: () => import('@/views/admin/CouponManagement.vue'),
        meta: { title: '优惠券' }
      },
      {
        path: 'seckill',
        name: 'AdminSeckill',
        component: () => import('@/views/admin/SeckillManagement.vue'),
        meta: { title: '限时秒杀' }
      }
    ]
  }
]
export default adminRoutes
