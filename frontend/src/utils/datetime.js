// 时间处理工具
// 商户端日期输入框支持"手填 + 原生选择器"两种方式，提交前统一转成后端能识别的 ISO 格式。

const pad = (n) => String(n).padStart(2, '0')

/**
 * 把用户填写的各种日期格式统一转成后端 LocalDateTime 能解析的格式
 * 兼容：
 *   2026-08-11T14:30          （原生选择器选出的值，原样保留）
 *   2026-08-11 14:30
 *   2026/08/11 14:30
 *   2026-8-11 14:30
 *   2026-08-11                （只填日期，补 00:00）
 * 解析不了时原样返回，交给后端校验提示。
 */
export function toISO(str) {
  if (!str) return ''
  const s = String(str).trim()
  // 已经是标准格式 yyyy-MM-ddTHH:mm(:ss)
  if (/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}(:\d{2})?$/.test(s)) return s
  // 通用格式：yyyy/MM/dd 或 yyyy-MM-dd，可带时间（空格或 T 分隔）
  const m = s.match(/^(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})(?:[\sT]+(\d{1,2}):(\d{2})(?::\d{2})?)?$/)
  if (m) {
    const [, y, mo, d, h, mi] = m
    const date = `${y}-${pad(mo)}-${pad(d)}`
    return h ? `${date}T${pad(h)}:${mi}` : `${date}T00:00`
  }
  return s
}
