<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { userApi } from '@/api'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const user = useUserStore()

// 状态
const mode = ref('pwd')
const username = ref('')
const password = ref('')
const phone = ref('')
const code = ref('')
const showPwd = ref(false)
const submitting = ref(false)
const alertMsg = ref('')
const alertOk = ref(false)
const codeCD = ref(0)
const errs = ref({ username: '', password: '', phone: '', code: '' })

// 表单校验
const validate = () => {
  let ok = true
  if (mode.value === 'pwd') {
    if (!username.value.trim()) { errs.value.username = '用户名不能为空'; ok = false }
    if (!password.value) { errs.value.password = '密码不能为空'; ok = false }
  } else {
    if (!/^1[3-9]\d{9}$/.test(phone.value)) { errs.value.phone = '手机号格式不正确'; ok = false }
    if (code.value.length < 6) { errs.value.code = '请输入6位验证码'; ok = false }
  }
  return ok
}

// 发送验证码
const sendCode = async () => {
  if (!/^1[3-9]\d{9}$/.test(phone.value)) {
    errs.value.phone = '请先输入正确的手机号'
    return
  }
  try {
    const data = await userApi.sendCode(phone.value)
    if (data.code === 200) {
      codeCD.value = 60
      const t = setInterval(() => {
        codeCD.value--
        if (codeCD.value <= 0) clearInterval(t)
      }, 1000)
      alertMsg.value = '✅ 验证码已发送，请查看后端控制台（开发环境）'
      alertOk.value = true
    } else {
      alertMsg.value = '❌ ' + (data.message || '发送失败')
      alertOk.value = false
    }
  } catch {
    alertMsg.value = '❌ 网络错误，请确认后端服务已启动'
    alertOk.value = false
  }
  setTimeout(() => alertMsg.value = '', 3000)
}

// 登录
const doLogin = async () => {
  if (!validate()) return
  submitting.value = true
  alertMsg.value = ''
  try {
    const data = mode.value === 'pwd'
      ? await userApi.loginByPassword(username.value.trim(), password.value)
      : await userApi.loginByPhone(phone.value, code.value)

    if (data.code === 200) {
      alertOk.value = true
      alertMsg.value = '✅ 登录成功！正在跳转...'
      user.login(data.data)  // 使用 Pinia store 保存登录状态
      setTimeout(() => router.push('/'), 1000)  // 使用路由跳转
    } else {
      alertOk.value = false
      alertMsg.value = '❌ ' + (data.message || '登录失败，请检查账号密码')
    }
  } catch {
    alertOk.value = false
    alertMsg.value = '❌ 网络错误，请确认后端服务已启动（localhost:8080）'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="login-page">
    <!-- Logo 区 -->
    <div class="login-logo">
      <span class="logo-icon">🥬</span>
      <div class="logo-name">鲜果生鲜</div>
      <div class="logo-sub">新鲜直达 · 品质保障</div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <!-- Tab -->
      <div class="mode-tabs">
        <div class="mode-tab" :class="{ active: mode === 'pwd' }" @click="mode = 'pwd'">账号密码登录</div>
        <div class="mode-tab" :class="{ active: mode === 'phone' }" @click="mode = 'phone'">手机验证码登录</div>
      </div>

      <!-- 账号密码 -->
      <template v-if="mode === 'pwd'">
        <div class="form-group">
          <label>用户名</label>
          <div class="input-wrap">
            <span class="input-icon">👤</span>
            <input type="text" v-model="username" placeholder="请输入用户名"
                   :class="{ 'is-error': errs.username }" @input="errs.username = ''">
          </div>
          <div class="error-hint" v-if="errs.username">{{ errs.username }}</div>
        </div>
        <div class="form-group">
          <label>密码</label>
          <div class="input-wrap">
            <span class="input-icon">🔒</span>
            <input :type="showPwd ? 'text' : 'password'" v-model="password" placeholder="请输入密码"
                   :class="{ 'is-error': errs.password }" @input="errs.password = ''">
            <span class="toggle-pwd" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁️' }}</span>
          </div>
          <div class="error-hint" v-if="errs.password">{{ errs.password }}</div>
        </div>
      </template>

      <!-- 手机验证码 -->
      <template v-else>
        <div class="form-group">
          <label>手机号</label>
          <div class="input-wrap code-row" style="display: flex;">
            <div class="input-wrap" style="flex: 1;">
              <span class="input-icon">📱</span>
              <input type="tel" v-model="phone" placeholder="请输入手机号"
                     :class="{ 'is-error': errs.phone }" @input="errs.phone = ''">
            </div>
            <button class="btn-sendcode" @click="sendCode" :disabled="codeCD > 0">
              {{ codeCD > 0 ? codeCD + 's 后重发' : '发送验证码' }}
            </button>
          </div>
          <div class="error-hint" v-if="errs.phone">{{ errs.phone }}</div>
        </div>
        <div class="form-group">
          <label>验证码</label>
          <div class="input-wrap">
            <span class="input-icon">✉️</span>
            <input type="text" v-model="code" maxlength="6" placeholder="请输入6位验证码"
                   :class="{ 'is-error': errs.code }" @input="errs.code = ''">
          </div>
          <div class="error-hint" v-if="errs.code">{{ errs.code }}</div>
        </div>
      </template>

      <!-- 提交 -->
      <button class="btn-submit" @click="doLogin" :disabled="submitting">
        {{ submitting ? '登录中...' : '立即登录' }}
      </button>

      <!-- 底部跳注册 - 改用 router-link -->
      <div class="link-row">
        若无账户，<router-link to="/register">点击此处去注册</router-link>
      </div>
      <div class="link-row" style="margin-top: 8px;">
        <router-link to="/admin/login" style="color: #999; font-size: 13px;">
          🏪 商户登录入口
        </router-link>
      </div>

      <!-- 结果提示 -->
      <div v-if="alertMsg" class="alert-box"
           :class="alertOk ? 'alert alert-success' : 'alert alert-danger'">
        {{ alertMsg }}
      </div>
    </div>
  </div>
</template>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.login-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 20px;
  /* 背景图 */
  background-image: url('@/assets/login.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
}

/* 背景遮罩 */
.login-page::before {
  content: '';
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  z-index: 0;
}

/* 顶部 Logo 区 */
.login-logo {
  position: relative;
  z-index: 1;
  text-align: center;
  margin-bottom: 24px;
  color: white;
}

.login-logo .logo-icon {
  font-size: 48px;
  display: block;
  margin-bottom: 8px;
}

.login-logo .logo-name {
  font-size: 24px;
  font-weight: 700;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
}

.login-logo .logo-sub {
  font-size: 13px;
  opacity: 0.8;
  margin-top: 4px;
}

/* 卡片 */
.login-card {
  position: relative;
  z-index: 1;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 32px 36px;
  box-shadow: 0 24px 64px rgba(0, 0, 0, 0.3);
  width: 100%;
  max-width: 420px;
}

/* Tab 切换 */
.mode-tabs {
  display: flex;
  border-radius: 10px;
  background: #f0f0f0;
  padding: 4px;
  margin-bottom: 24px;
}

.mode-tab {
  flex: 1;
  text-align: center;
  padding: 8px 0;
  border-radius: 8px;
  font-size: 14px;
  cursor: pointer;
  color: #666;
  transition: all 0.25s;
  user-select: none;
}

.mode-tab.active {
  background: white;
  color: #2dbe60;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 输入框 */
.form-group {
  margin-bottom: 16px;
}

.form-group label {
  font-size: 13px;
  color: #555;
  margin-bottom: 6px;
  display: block;
}

.input-wrap {
  position: relative;
  display: flex;
  align-items: center;
}

.input-wrap .input-icon {
  position: absolute;
  left: 12px;
  font-size: 16px;
  pointer-events: none;
}

.input-wrap input {
  width: 100%;
  padding: 11px 14px 11px 38px;
  border: 2px solid #e8e8e8;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
  background: #fafafa;
}

.input-wrap input:focus {
  border-color: #43e97b;
  background: white;
}

.input-wrap input.is-error {
  border-color: #ff4d4f;
}

.input-wrap .toggle-pwd {
  position: absolute;
  right: 12px;
  font-size: 16px;
  cursor: pointer;
  color: #aaa;
}

.error-hint {
  color: #ff4d4f;
  font-size: 12px;
  margin-top: 4px;
}

/* 发送验证码行 */
.code-row {
  display: flex;
  gap: 8px;
}

.code-row input {
  flex: 1;
}

.btn-sendcode {
  white-space: nowrap;
  padding: 0 14px;
  border: 2px solid #43e97b;
  background: white;
  color: #2dbe60;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 96px;
}

.btn-sendcode:disabled {
  border-color: #ccc;
  color: #aaa;
  cursor: not-allowed;
}

/* 提交按钮 */
.btn-submit {
  width: 100%;
  padding: 13px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 6px 20px rgba(67, 233, 123, 0.45);
  transition: transform 0.15s, box-shadow 0.15s;
  margin-top: 8px;
}

.btn-submit:hover {
  transform: translateY(-1px);
  box-shadow: 0 8px 24px rgba(67, 233, 123, 0.55);
}

.btn-submit:active {
  transform: translateY(1px);
}

.btn-submit:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

/* 底部提示 */
.link-row {
  text-align: center;
  margin-top: 18px;
  font-size: 13px;
  color: #999;
}

.link-row a {
  color: #2dbe60;
  text-decoration: none;
  font-weight: 600;
}

.link-row a:hover {
  text-decoration: underline;
}

/* 结果提示 */
.alert-box {
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
  margin-top: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
}
</style>
