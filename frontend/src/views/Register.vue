<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { userApi } from '@/api'

const router = useRouter()

// 状态
const form = ref({
  username: '',
  phone: '',
  password: '',
  confirm: '',
  email: ''
})
const errs = ref({ username: '', phone: '', password: '', confirm: '', email: '' })
const touched = ref({ username: false, phone: false, password: false, confirm: false, email: false })
const showPwd = ref(false)
const showConfirm = ref(false)
const agreed = ref(false)
const submitting = ref(false)
const alertMsg = ref('')
const alertOk = ref(false)

// 校验规则
const rules = {
  username: { re: /^[\u4e00-\u9fa5a-zA-Z0-9]{2,20}$/, msg: '2-20位中文/字母/数字' },
  phone: { re: /^1[3-9]\d{9}$/, msg: '手机号格式不正确' },
  email: { re: /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/, msg: '邮箱格式不正确' },
}

// 校验单个字段
const check = (field) => {
  touched.value[field] = true
  const v = form.value[field]

  if (field === 'password') {
    if (!v) { errs.value.password = '密码不能为空'; return false }
    if (v.length < 8 || v.length > 20) { errs.value.password = '密码长度8-20位'; return false }
    if (!/(?=.*[a-z])/.test(v)) { errs.value.password = '需包含小写字母'; return false }
    if (!/(?=.*[A-Z])/.test(v)) { errs.value.password = '需包含大写字母'; return false }
    if (!/(?=.*\d)/.test(v)) { errs.value.password = '需包含数字'; return false }
    if (!/(?=.*[@$!%*?&])/.test(v)) { errs.value.password = '需包含特殊字符'; return false }
    errs.value.password = ''
    return true
  }

  if (field === 'confirm') {
    if (v !== form.value.password) { errs.value.confirm = '两次密码不一致'; return false }
    errs.value.confirm = ''
    return true
  }

  if (field === 'email') {
    if (!v) { errs.value.email = ''; return true } // 选填，可空
    if (!rules.email.re.test(v)) { errs.value.email = rules.email.msg; return false }
    errs.value.email = ''
    return true
  }

  if (!v) { errs.value[field] = '此项不能为空'; return false }
  if (rules[field] && !rules[field].re.test(v)) { errs.value[field] = rules[field].msg; return false }
  errs.value[field] = ''
  return true
}

// 密码强度
const pwdLevel = computed(() => {
  const v = form.value.password
  if (!v) return 0
  let s = 0
  if (/[a-z]/.test(v)) s++
  if (/[A-Z]/.test(v)) s++
  if (/\d/.test(v)) s++
  if (/[@$!%*?&]/.test(v)) s++
  if (v.length >= 12) s = Math.min(s + 1, 4)
  return Math.min(s, 4)
})

const pwdLevelTxt = computed(() => {
  return ['', '弱', '一般', '良好', '强'][pwdLevel.value] || ''
})

// 填写进度
const progress = computed(() => {
  const fields = ['username', 'phone', 'password', 'confirm']
  const done = fields.filter(f => form.value[f] && !errs.value[f]).length
  return Math.round((done / fields.length) * 100)
})

// 字段样式
const fClass = (field) => {
  if (!touched.value[field]) return ''
  if (errs.value[field]) return 'err'
  if (form.value[field]) return 'ok'
  return ''
}

const sIcon = (field) => {
  if (errs.value[field]) return '❌'
  if (form.value[field]) return '✅'
  return ''
}

// 注册提交
const doRegister = async () => {
  const fields = ['username', 'phone', 'password', 'confirm']
  let ok = true
  fields.forEach(f => { if (!check(f)) ok = false })
  if (form.value.email) check('email')
  if (!ok) return
  if (!agreed.value) {
    alertMsg.value = '❌ 请先阅读并同意用户协议'
    alertOk.value = false
    return
  }

  submitting.value = true
  alertMsg.value = ''
  try {
    const body = {
      username: form.value.username.trim(),
      phone: form.value.phone,
      password: form.value.password,
    }
    if (form.value.email) body.email = form.value.email.trim()

    const data = await userApi.register(body)  // 使用封装的 API

    if (data.code === 200) {
      alertOk.value = true
      alertMsg.value = '✅ 注册成功！即将跳转到登录页...'
      setTimeout(() => router.push('/login'), 1500)  // 使用路由跳转
    } else {
      alertOk.value = false
      alertMsg.value = '❌ ' + (data.message || '注册失败，请稍后重试')
    }
  } catch {
    alertOk.value = false
    alertMsg.value = '❌ 网络错误'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="reg-page">
    <!-- Logo 和注册卡片容器 -->
    <div class="reg-container">
      <!-- Logo -->
      <div class="reg-logo">
        <span class="logo-icon">🥬</span>
        <div class="logo-name">鲜果生鲜</div>
        <div class="logo-sub">加入我们，享受新鲜每一天</div>
      </div>

      <!-- 注册卡片 -->
      <div class="reg-card">
        <h2>📝 创建账户</h2>
      <!-- 防止浏览器自动填充的隐藏输入框 -->
      <input type="text" style="display:none">
      <input type="password" style="display:none">
      <input type="tel" style="display:none">

      <!-- 完成进度 -->
      <div class="progress-bar-wrap">
        <div class="progress-bar-fill" :style="{ width: progress + '%' }"></div>
      </div>

      <!-- 用户名 -->
      <div class="form-group">
        <label>用户名</label>
        <div class="input-wrap">
          <span class="input-icon">👤</span>
          <input type="text" v-model="form.username"
                 :class="fClass('username')"
                 placeholder="2-20位中文/字母/数字"
                 autocomplete="off"
                 readonly
                 @focus="$event.target.removeAttribute('readonly')"
                 @input="check('username')">
          <span class="status-icon" v-if="touched.username">{{ sIcon('username') }}</span>
        </div>
        <div class="hint-row">
          <span class="hint-err" v-if="errs.username">{{ errs.username }}</span>
          <span class="hint-info" v-else>中文、字母、数字均可</span>
        </div>
      </div>

      <!-- 手机号 -->
      <div class="form-group">
        <label>手机号</label>
        <div class="input-wrap">
          <span class="input-icon">📱</span>
          <input type="tel" v-model="form.phone"
                 :class="fClass('phone')"
                 placeholder="11位手机号"
                 autocomplete="off"
                 readonly
                 @focus="$event.target.removeAttribute('readonly')"
                 @input="check('phone')">
          <span class="status-icon" v-if="touched.phone">{{ sIcon('phone') }}</span>
        </div>
        <div class="hint-row">
          <span class="hint-err" v-if="errs.phone">{{ errs.phone }}</span>
        </div>
      </div>

      <!-- 密码 -->
      <div class="form-group">
        <label>密码</label>
        <div class="input-wrap">
          <span class="input-icon">🔒</span>
          <input :type="showPwd ? 'text' : 'password'"
                 v-model="form.password"
                 :class="fClass('password')"
                 placeholder="8-20位，含大小写+数字+特殊字符"
                 autocomplete="off"
                 readonly
                 @focus="$event.target.removeAttribute('readonly')"
                 @input="check('password')">
          <span class="toggle-eye" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁️' }}</span>
        </div>
        <!-- 密码强度条 -->
        <div class="pwd-strength" :class="'s' + pwdLevel" v-if="form.password">
          <div class="bar"></div>
          <div class="bar"></div>
          <div class="bar"></div>
          <div class="bar"></div>
          <span class="lvl-txt">{{ pwdLevelTxt }}</span>
        </div>
        <div class="hint-row">
          <span class="hint-err" v-if="errs.password">{{ errs.password }}</span>
        </div>
      </div>

      <!-- 确认密码 -->
      <div class="form-group">
        <label>确认密码</label>
        <div class="input-wrap">
          <span class="input-icon">🔑</span>
          <input :type="showConfirm ? 'text' : 'password'"
                 v-model="form.confirm"
                 :class="fClass('confirm')"
                 placeholder="再次输入密码"
                 @input="check('confirm')">
          <span class="toggle-eye" @click="showConfirm = !showConfirm">{{ showConfirm ? '🙈' : '👁️' }}</span>
        </div>
        <div class="hint-row">
          <span class="hint-err" v-if="errs.confirm">{{ errs.confirm }}</span>
        </div>
      </div>

      <!-- 邮箱（选填） -->
      <div class="form-group">
        <label>邮箱 <span style="color: #aaa; font-size: 11px;">（选填）</span></label>
        <div class="input-wrap">
          <span class="input-icon">📧</span>
          <input type="email" v-model="form.email"
                 :class="fClass('email')"
                 @input="check('email')">
          <span class="status-icon" v-if="touched.email && form.email">{{ sIcon('email') }}</span>
        </div>
        <div class="hint-row">
          <span class="hint-err" v-if="errs.email">{{ errs.email }}</span>
        </div>
      </div>

      <!-- 用户协议 -->
      <label class="agreement">
        <input type="checkbox" v-model="agreed">
        我已阅读并同意 <a href="#" @click.prevent>《用户服务协议》</a> 和 <a href="#" @click.prevent>《隐私政策》</a>
      </label>

      <!-- 提交 -->
      <button class="btn-submit" @click="doRegister" :disabled="submitting">
        {{ submitting ? '注册中...' : '立即注册' }}
      </button>

      <!-- 跳登录 -->
      <div class="link-row">
        已有账户？<router-link to="/login">点击此处去登录</router-link>
      </div>

      <!-- 结果提示 -->
      <div v-if="alertMsg" class="alert-box"
           :class="alertOk ? 'alert alert-success' : 'alert alert-danger'">
        {{ alertMsg }}
      </div>
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

.reg-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background-image: url('@/assets/background.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
}

.reg-page::before {
  content: '';
  position: fixed;
  inset: 0;
  background: rgba(30, 20, 60, 0.15);
  z-index: 0;
}

/* 容器 */
.reg-container {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  align-self: flex-end;
  margin-right: 5%;
}

/* Logo */
.reg-logo {
  text-align: center;
  margin-bottom: 20px;
  color: white;
  align-self: center;
}

.reg-logo .logo-icon {
  font-size: 44px;
  display: block;
  margin-bottom: 6px;
}

.reg-logo .logo-name {
  font-size: 22px;
  font-weight: 700;
}

.reg-logo .logo-sub {
  font-size: 13px;
  opacity: 0.75;
  margin-top: 4px;
}

/* 卡片 */
.reg-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 32px 36px;
  box-shadow: 0 24px 64px rgba(0, 0, 0, 0.35);
  width: 560px;
  min-width: 560px;
}

.reg-card h2 {
  font-size: 20px;
  font-weight: 700;
  color: #222;
  margin-bottom: 22px;
  text-align: center;
}

/* 进度条 */
.progress-bar-wrap {
  height: 4px;
  background: #eee;
  border-radius: 4px;
  margin-bottom: 22px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  border-radius: 4px;
  background: linear-gradient(90deg, #667eea, #764ba2);
  transition: width 0.4s ease;
}

/* 输入框 */
.form-group {
  margin-bottom: 14px;
}

.form-group label {
  font-size: 13px;
  color: #555;
  margin-bottom: 5px;
  display: block;
}

.input-wrap {
  position: relative;
}

.input-wrap .input-icon {
  position: absolute;
  left: 11px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 15px;
  pointer-events: none;
}

.input-wrap input {
  width: 100%;
  padding: 11px 38px 11px 38px;
  border: 2px solid #e8e8e8;
  border-radius: 10px;
  font-size: 14px;
  outline: none;
  background: #fafafa;
  transition: border-color 0.2s, background 0.2s;
}

.input-wrap input:focus {
  border-color: #764ba2;
  background: white;
}

.input-wrap input.ok {
  border-color: #2dbe60;
}

.input-wrap input.err {
  border-color: #ff4d4f;
}

.input-wrap .status-icon {
  position: absolute;
  right: 11px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 15px;
}

.input-wrap .toggle-eye {
  position: absolute;
  right: 11px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 15px;
  cursor: pointer;
  color: #aaa;
}

.hint-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 4px;
}

.hint-err {
  color: #ff4d4f;
  font-size: 11px;
}

.hint-info {
  color: #aaa;
  font-size: 11px;
}

/* 密码强度条 */
.pwd-strength {
  display: flex;
  gap: 3px;
  align-items: center;
  margin-top: 6px;
}

.pwd-strength .bar {
  flex: 1;
  height: 3px;
  border-radius: 2px;
  background: #eee;
  transition: background 0.3s;
}

.s1 .bar:nth-child(1) { background: #ff4d4f; }
.s2 .bar:nth-child(-n+2) { background: #faad14; }
.s3 .bar:nth-child(-n+3) { background: #52c41a; }
.s4 .bar { background: #13c2c2; }

.pwd-strength .lvl-txt {
  font-size: 11px;
  color: #aaa;
  margin-left: 6px;
  white-space: nowrap;
}

/* 手机+发送码 */
.code-row {
  display: flex;
  gap: 8px;
}

.code-row .input-wrap {
  flex: 1;
}

.btn-sendcode {
  white-space: nowrap;
  border: 2px solid #764ba2;
  background: white;
  color: #764ba2;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  min-width: 90px;
  padding: 0 10px;
  transition: all 0.2s;
}

.btn-sendcode:hover:not(:disabled) {
  background: #f0eaff;
}

.btn-sendcode:disabled {
  border-color: #ccc;
  color: #aaa;
  cursor: not-allowed;
}

/* 协议 */
.agreement {
  display: flex;
  align-items: center;
  gap: 8px;
  margin: 12px 0 6px;
  font-size: 12px;
  color: #888;
  cursor: pointer;
}

.agreement input[type=checkbox] {
  accent-color: #764ba2;
  width: 14px;
  height: 14px;
  cursor: pointer;
}

.agreement a {
  color: #764ba2;
  text-decoration: none;
}

/* 提交按钮 */
.btn-submit {
  width: 100%;
  padding: 13px;
  border: none;
  border-radius: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 6px 20px rgba(118, 75, 162, 0.4);
  transition: transform 0.15s, opacity 0.2s;
  margin-top: 6px;
}

.btn-submit:hover:not(:disabled) {
  transform: translateY(-1px);
}

.btn-submit:active {
  transform: translateY(1px);
}

.btn-submit:disabled {
  opacity: 0.65;
  cursor: not-allowed;
  transform: none;
}

/* 底部跳登录 */
.link-row {
  text-align: center;
  margin-top: 16px;
  font-size: 13px;
  color: #999;
}

.link-row a {
  color: #764ba2;
  text-decoration: none;
  font-weight: 600;
}

.link-row a:hover {
  text-decoration: underline;
}

/* 结果框 */
.alert-box {
  margin-top: 14px;
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 13px;
}
</style>
