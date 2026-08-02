import pytest
from utils.api_client import APIClient
from utils.data_builder import build_register_user, build_order, build_OrderItemDTO
from utils.assertions import assert_success
@pytest.fixture(scope="class")#标记这个函数是 pytest 的 fixture。fixture的作用：测试用例在参数里写上这个函数名，pytest 就会自动调这个函数，把返回值传进用例
def client():
      return APIClient()

@pytest.fixture(scope="class")#同一个类下的用例共享一个用户
def registered_user(client):
      user = build_register_user()
      resp = client.post("/user/register", json=user)
      assert resp.get("code") == 200, f"注册失败：{resp}"
      return user

@pytest.fixture
def logged_in_client(client, registered_user):
      resp = client.post("/user/login", json={
          "username": registered_user["username"],
          "password": registered_user["password"],
      })
      token = resp["data"]["token"]
      client.token = token #自动触发@token.setter 修饰的赋值方法；
      return client



@pytest.fixture(scope="class")
def login_info(client, registered_user):
    # 统一执行登录，只执行1次
    login_data = {
        "username": registered_user["username"],
        "password": registered_user["password"]
    }
    resp = client.post("/user/login", json=login_data)
    assert resp["code"] == 200
    # 返回登录接口完整返回体，包含token、userId
    return resp["data"]

# 按需封装单独user_id夹具，简化传参
@pytest.fixture(scope="class")
def login_user_id(login_info):
    return login_info["userId"]

# 下单 fixture：登录拿 userId → 查商品拿 skuId → 下单 → 返回订单号
@pytest.fixture
def created_order(client, registered_user):
    """
    每个测试方法都用它时会重新创建一个新订单，
    保证 pay 和 cancel 互不干扰（一个订单只能支付或取消一次）
    """
    # 登录拿 userId
    resp = client.post("/user/login", json={
        "username": registered_user["username"],
        "password": registered_user["password"]
    })
    user_id = resp["data"]["userId"]

    # 查一级分类下的商品，拿 spuId/skuId/skuName
    cat_resp = client.get("/category/top")
    parent_id = cat_resp["data"][0]["id"]
    product_resp = client.get(f"/product/parent-category/{parent_id}")
    products = product_resp["data"]
    if not products:
        pytest.skip("没有商品数据，跳过下单相关测试")
    spu_id = products[0]["id"]

    sku_resp = client.get(f"/product/skus/{spu_id}")
    assert_success(sku_resp, "查询成功")
    sku_id = sku_resp["data"][0]["id"]
    sku_name = sku_resp["data"][0]["skuName"]

    # 下单
    order_data = build_order(user_id, build_OrderItemDTO(spu_id, sku_id, sku_name))
    resp = client.post("/order/create", json=order_data)
    assert_success(resp, "下单成功")

    # 返回订单号和用户ID，供各测试方法使用
    return {"user_id": user_id, "order_no": resp["data"]["orderNo"]}
