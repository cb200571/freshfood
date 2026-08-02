#断言
def assert_success(resp, expected_msg=None):#给形参写 变量名=默认值，该参数调用时可以不传
      assert resp.get("code") == 200, (
          f"期望 code=200，实际 code={resp.get('code')}，message={resp.get('message')}"#断言失败!-200后输出的自定义报错文本
      )
      if expected_msg:
          assert expected_msg in resp.get("message", ""), (
              f"期望 message 包含「{expected_msg}」，实际「{resp.get('message')}」"
          )
def assert_error(resp, expected_code=500, expected_msg=None):
      assert resp.get("code") == expected_code, (
          f"期望 code={expected_code}，实际 code={resp.get('code')}，message={resp.get('message')}"
      )
      if expected_msg:
          assert expected_msg in resp.get("message", ""), (
              f"期望 message 包含「{expected_msg}」，实际「{resp.get('message')}」"
          )