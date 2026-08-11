<!--
  日期时间输入框：既可以直接手填文字，也保留原生日期选择器
  用法：<DateTimeInput v-model="form.startTime" placeholder="如：2026-08-11 14:30" />
  - 文本框：可自由输入（支持 2026-08-11 14:30 / 2026/08/11 14:30 等格式）
  - 右侧 📅 按钮：打开浏览器原生日期时间选择器，选完自动回填
  提交前请用 utils/datetime.js 的 toISO() 统一转成后端格式
-->
<template>
  <div class="date-time-input">
    <input
      type="text"
      class="form-control"
      :value="displayValue"
      :placeholder="placeholder"
      autocomplete="off"
      @input="$emit('update:modelValue', $event.target.value)"
    />
    <label class="cal-trigger" title="选择日期时间">
      <span class="cal-icon">📅</span>
      <input
        type="datetime-local"
        :value="pickerValue"
        tabindex="-1"
        @change="onPick"
      />
    </label>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: { type: String, default: '' },
  placeholder: { type: String, default: '如：2026-08-11 14:30' },
})

const emit = defineEmits(['update:modelValue'])

const pad = (n) => String(n).padStart(2, '0')

// 文本框展示：把 ISO 的 T 换成空格，读起来更自然
const displayValue = computed(() => (props.modelValue || '').replace('T', ' '))

// 原生选择器的值必须是 yyyy-MM-ddTHH:mm，从现有值解析出来；解析不了就留空
const pickerValue = computed(() => {
  const s = String(props.modelValue || '').trim()
  const m = s.match(/(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})[\sT](\d{1,2}):(\d{2})/)
  return m ? `${m[1]}-${pad(m[2])}-${pad(m[3])}T${pad(m[4])}:${m[5]}` : ''
})

// 从原生选择器选完，回填到文本框（值是 yyyy-MM-ddTHH:mm）
const onPick = (e) => {
  emit('update:modelValue', e.target.value)
}
</script>

<style scoped>
.date-time-input {
  position: relative;
}

.date-time-input .form-control {
  padding-right: 38px; /* 给日历按钮留位 */
}

.cal-trigger {
  position: absolute;
  right: 4px;
  top: 50%;
  transform: translateY(-50%);
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  background: #f1f3f5;
  border-radius: 6px;
  z-index: 2;
}

.cal-trigger:hover {
  background: #e2e6ea;
}

.cal-trigger .cal-icon {
  font-size: 15px;
  pointer-events: none;
}

/* 透明的原生选择器铺满日历按钮：点击按钮即打开选择器 */
.cal-trigger input[type="datetime-local"] {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
  border: none;
  background: transparent;
}
</style>
