from utils.assertions import assert_success
from utils.data_builder import build_coupon, build_seckill, build_product


class TestUserCrud:
    """用户模块补充"""

    def test_send_code(self, client, registered_user):
        """给已注册的手机号发验证码"""
        resp = client.post("/user/sendCode", json={"phone": registered_user["phone"]})
        assert_success(resp, "验证码已发送")


class TestProductCrud:
    """商品模块补充：更新/扣库存/查重"""

    def test_check_name(self, client):
        """检查商品名是否存在"""
        resp = client.get("/product/check-name", params={"name": "测试"})
        assert_success(resp, "查询成功")

    def test_update_product(self, client):
        """更新商品（改个名字）"""
        # 先取一个商品
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        p = products[0]
        p["name"] = f"{p['name']}_改"
        resp = client.put("/product/update", json=p)
        assert_success(resp, "更新成功")

    def test_update_sku(self, client):
        """更新SKU价格"""
        # 先取商品
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        spu_id = products[0]["id"]
        # 取SKU
        sku_resp = client.get(f"/product/skus/{spu_id}")
        skus = sku_resp["data"]
        if not skus:
            return
        sku = skus[0]
        sku["price"] = float(sku["price"]) + 1.00
        resp = client.put("/product/update/sku", json=sku)
        assert_success(resp, "更新成功")

    def test_decrease_stock(self, client):
        """扣减SKU库存"""
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        sku_resp = client.get(f"/product/skus/{products[0]['id']}")
        skus = sku_resp["data"]
        if not skus:
            return
        sku_id = skus[0]["id"]
        resp = client.post("/product/stock/decrease", json={"skuId": sku_id, "quantity": 1})
        assert_success(resp)

    def test_update_stock(self, client):
        """更新SKU库存"""
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        sku_resp = client.get(f"/product/skus/{products[0]['id']}")
        skus = sku_resp["data"]
        if not skus:
            return
        sku_id = skus[0]["id"]
        resp = client.put(f"/product/stock/{sku_id}", params={"stock": 200})
        assert_success(resp, "库存更新成功")


class TestOrderCrud:
    """订单模块补充"""

    def test_order_items(self, client, created_order):
        """查订单商品列表"""
        resp = client.get("/order/items", params={"orderNo": created_order["order_no"]})
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_admin_order_list(self, client):
        """商户端查所有订单"""
        resp = client.get("/order/admin/list")
        assert_success(resp, "查询成功")
        assert isinstance(resp["data"], list)

    def test_admin_ship(self, client, created_order):
        """商户端发货（需先支付，订单状态：待付款→已付款→已发货）"""
        order_no = created_order["order_no"]
        # 先支付：待付款(0) → 已付款(1)
        client.post("/order/pay", params={"orderNo": order_no})
        # 再发货：已付款(1) → 已发货(2)
        resp = client.post("/order/admin/ship", params={"orderNo": order_no})
        assert_success(resp, "发货成功")

    def test_admin_complete(self, client, created_order):
        """商户端完成订单（需先支付+发货）"""
        order_no = created_order["order_no"]
        # 支付 → 已付款(1)
        client.post("/order/pay", params={"orderNo": order_no})
        # 发货 → 已发货(2)
        client.post("/order/admin/ship", params={"orderNo": order_no})
        # 完成 → 已完成(3)
        resp = client.post("/order/admin/complete", params={"orderNo": order_no})
        assert_success(resp, "订单已完成")


class TestCouponCrud:
    """优惠券模块补充"""

    def test_create_coupon(self, client):
        """创建优惠券"""
        resp = client.post("/coupon/create", json=build_coupon())
        assert_success(resp, "创建成功")
        assert isinstance(resp["data"], int), "应返回优惠券ID"

    def test_update_coupon_status(self, client):
        """更新优惠券状态（禁用）"""
        resp = client.get("/coupon/list")
        coupons = resp["data"]
        if not coupons:
            return
        cid = coupons[0]["id"]
        resp = client.put(f"/coupon/status/{cid}", params={"status": 0})
        assert_success(resp, "更新成功")
        # 改回启用
        client.put(f"/coupon/status/{cid}", params={"status": 1})

    def test_issue_coupon(self, client, login_user_id):
        """发放优惠券给用户"""
        resp = client.get("/coupon/list")
        coupons = resp["data"]
        if not coupons:
            return
        cid = coupons[0]["id"]
        resp = client.post("/coupon/issue", params={"couponId": cid, "userId": login_user_id})
        assert_success(resp, "发放成功")


class TestSeckillCrud:
    """秒杀模块补充"""

    def test_create_seckill(self, client):
        """创建秒杀活动"""
        # 先取商品和SKU
        resp = client.get("/product/list")
        products = resp["data"]
        if not products:
            return
        spu_id = products[0]["id"]
        sku_resp = client.get(f"/product/skus/{spu_id}")
        skus = sku_resp["data"]
        if not skus:
            return
        sku_id = skus[0]["id"]

        resp = client.post("/seckill/create", json=build_seckill(spu_id, sku_id))
        assert_success(resp, "创建成功")
        assert isinstance(resp["data"], int), "应返回活动ID"

    def test_update_seckill_status(self, client):
        """更新秒杀活动状态"""
        resp = client.get("/seckill/list")
        activities = resp["data"]
        if not activities:
            return
        aid = activities[0]["id"]
        resp = client.put(f"/seckill/status/{aid}", params={"status": 0})
        assert_success(resp, "更新成功")
        # 改回启用
        client.put(f"/seckill/status/{aid}", params={"status": 1})

    def test_reset_seckill(self, client):
        """重置秒杀活动"""
        resp = client.get("/seckill/list")
        activities = resp["data"]
        if not activities:
            return
        aid = activities[0]["id"]
        resp = client.post("/seckill/reset", params={"activityId": aid})
        assert_success(resp, "重置成功")
