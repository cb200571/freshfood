import pytest
from utils.api_client import APIClient
from utils.data_builder import build_register_user
from utils.assertions import assert_success, assert_error
#正常注册
class TestUserRegister:
    def test_register_success(self, client):
        user = build_register_user()
        resp = client.post("/user/register", json=user)
        assert_success(resp, "注册成功")
    #重复注册
    def test_register_duplicate(self, client, registered_user):
        resp = client.post("/user/register", json=registered_user)
        assert_error(resp, 409, "已存在")
class TestUserLogin:
     def test_login_success(self,client, registered_user):
         username = registered_user["username"]
         password = registered_user["password"]
         login_data = {
                 "username": username,
                 "password": password
             }
         resp = client.post("/user/login", json=login_data)
         assert resp.get("code") == 200, f"登录失败：{resp}"
         assert "token" in resp.get("data", {}), "登录响应未返回token"

     def test_login_fail_wrong_password(self, client, registered_user):
               """密码错误，预期返回 401"""
               username = registered_user["username"]
               resp = client.post("/user/login", json={
                   "username": username,
                   "password": "wrong_password"
               })
               assert resp.get("code") == 401, f"期望 401，实际：{resp}"

     def test_login_fail_userNoExists(self, client):
                    """用户不存在，预期返回 404"""

                    resp = client.post("/user/login", json={
                        "username": "username",
                        "password": "wrong_password"
                    })
                    assert resp.get("code") == 404, f"期望 404，实际：{resp}"