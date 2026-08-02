from utils.assertions import assert_success


class TestOrder:
    """订单流程测试"""

    def test_create_order(self, created_order):
        """下单成功，能拿到订单号"""
        assert created_order["order_no"], "下单应返回订单号"

    def test_pay_order(self, client, created_order):
        """支付订单：状态 0待付款 → 1已付款"""
        resp = client.post("/order/pay", params={"orderNo": created_order["order_no"]})
        assert_success(resp, "支付成功")

    def test_cancel_order(self, client, created_order):
        """取消订单：状态 0待付款 → 4已取消"""
        resp = client.post("/order/cancel", params={"orderNo": created_order["order_no"]})
        assert_success(resp, "取消成功")

    def test_order_list(self, client, created_order):
        """查询用户订单列表"""
        resp = client.get("/order/list", params={"userId": created_order["user_id"]})
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)
        if data:
            assert "orderNo" in data[0], "订单列表缺少订单号"

    def test_order_detail(self, client, created_order):
        """查询订单详情"""
        resp = client.get("/order/detail", params={"orderNo": created_order["order_no"]})
        assert_success(resp, "查询成功")
        assert resp["data"]["orderNo"] == created_order["order_no"], "订单号不匹配"
