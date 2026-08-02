from utils.assertions import assert_success

class TestDashboard:
    """仪表盘测试"""

    def test_get_stats(self, client):
        """获取统计数据"""
        resp = client.get("/dashboard/stats")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        # 应该包含4个统计字段
        assert "todayOrderCount" in data, "缺少今日订单数"
        assert "todaySales" in data, "缺少今日销售额"
        assert "pendingShipCount" in data, "缺少待发货数"
        assert "totalUsers" in data, "缺少用户总数"

    def test_dashboard_low_stock(self, client):
        """获取库存预警列表"""
        resp = client.get("/dashboard/low-stock")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)


class TestCoupon:
    """优惠券测试"""

    def test_coupon_list(self, client):
        """获取所有优惠券"""
        resp = client.get("/coupon/list")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_my_coupons(self, client, registered_user):
        """获取用户优惠券（新注册用户应该没有优惠券）"""
        resp = client.post("/user/login", json={
            "username": registered_user["username"],
            "password": registered_user["password"]
        })
        user_id = resp["data"]["userId"]

        resp = client.get("/coupon/my/detail", params={"userId": user_id})
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)


class TestSeckill:
    """秒杀测试"""

    def test_seckill_list(self, client):
        """获取所有秒杀活动"""
        resp = client.get("/seckill/list")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_seckill_active(self, client):
        """获取进行中的秒杀活动"""
        resp = client.get("/seckill/active")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)


class TestAdmin:
    """商户端查询测试"""

    def test_user_admin_list(self, client):
        """获取所有用户"""
        resp = client.get("/user/admin/list")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)
        if data:
            # 用户列表的密码值必须是 null，不能泄露真实密码
            assert data[0]["password"] is None, "用户列表不应该返回密码"

    def test_product_update_status(self, client):
        """上下架商品"""
        # 先取一个商品
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        spu_id = products[0]["id"]

        # 改成下架（0），断言成功
        resp = client.put(f"/product/status/{spu_id}", params={"status": 0})
        assert_success(resp, "状态更新成功")
        # 改回上架（1）
        resp = client.put(f"/product/status/{spu_id}", params={"status": 1})
        assert_success(resp, "状态更新成功")
