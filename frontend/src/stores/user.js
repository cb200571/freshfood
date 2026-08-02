// Pinia 是Vue3 官方新一代状态管理库，用来全局共享数据。
// 用 Pinia 管理用户登录状态，任何组件都能响应式地获取登录信息。
// 仓库 = 存放全局共享数据、函数的容器，所有组件都能读取 / 调用。
/*使用方法： import { useUserStore } from '@/stores/user'
调用函数，得到仓库实例
const userStore = useUserStore()

// 然后就能用里面的数据/方法
console.log(userStore.token)
userStore.logout()
*/
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
// defineStore:Pinia 内置函数，专门用来创建一个全局数据仓库。第一个参数 'user':仓库唯一标识名（ID）。
export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref(localStorage.getItem('token') || '')//读取浏览器本地存储中 key=token 的值。
  const userName = ref(localStorage.getItem('userName') || '')
  const userPhone = ref(localStorage.getItem('userPhone') || '')
  const userId = ref(localStorage.getItem('userId') || '')
  // 计算属性：是否已登录 computed：依赖已有响应式数据、自动计算出新值的属性，isLogin 的值自动根据 token 算出，token 有值就为 true（已登录）
  const isLogin = computed(() => !!token.value)//!!：连续两次取反，最终目的：把任意数据 强制转为 纯布尔值

  // 登录方法
  //入参 data：后端登录接口返回的用户信息对象。
  function login(data) {
    token.value = data.token
    userName.value = data.username
    userPhone.value = data.phone || ''
    localStorage.setItem('token', data.token)
    localStorage.setItem('userName', data.username)
    localStorage.setItem('userPhone', data.phone || '')
    if (data.userId) {
      userId.value = data.userId
      localStorage.setItem('userId', data.userId)
    }
  }

  // 退出方法
  function logout() {
    token.value = ''
    userName.value = ''
    userPhone.value = ''
    localStorage.removeItem('token')
    localStorage.removeItem('userName')
    localStorage.removeItem('userPhone')
    userId.value = ''
    localStorage.removeItem('userId')
  }

  return { token, userName, userPhone, userId, isLogin, login, logout }
})
/*export const useUserStore = defineStore('user', () => {}):创建全局仓库
第一个参数 'user'：仓库唯一 id
第二个参数是回调，里面写变量、方法；
 */
