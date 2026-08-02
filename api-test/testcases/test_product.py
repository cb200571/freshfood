from utils.assertions import assert_success
from utils.data_builder import build_product

class TestProduct:
    """商品测试"""

    def test_list_by_category(self, client):
        """按二级分类ID查商品"""
        cat_resp = client.get("/category/top")
        parent_id = cat_resp["data"][0]["id"]
        parent_resp = client.get(f"/product/parent-category/{parent_id}")
        products = parent_resp["data"]
        if not products:
            return
        category_id = products[0]["categoryId"]

        resp = client.get(f"/product/category/{category_id}")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)
        for item in data:
            assert item["categoryId"] == category_id, (
                f"categoryId 应为 {category_id}，实际：{item['categoryId']}"
            )

    def test_list_by_parent_category(self, client):
        """按一级分类ID查所有商品"""
        cat_resp = client.get("/category/top")
        parent_id = cat_resp["data"][0]["id"]

        resp = client.get(f"/product/parent-category/{parent_id}")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)
        if data:
            for item in data:
                assert "id" in item, "商品缺少 id"
                assert "name" in item, "商品缺少 name"

    def test_list_all(self, client):
        """查询所有商品"""
        resp = client.get("/product/list")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_get_skus(self, client):
        """查商品的SKU列表"""
        cat_resp = client.get("/category/top")
        parent_id = cat_resp["data"][0]["id"]
        product_resp = client.get(f"/product/parent-category/{parent_id}")
        products = product_resp["data"]
        if not products:
            return
        spu_id = products[0]["id"]

        resp = client.get(f"/product/skus/{spu_id}")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)
        if data:
            for sku in data:
                assert "id" in sku, "SKU 缺少 id"
                assert "skuName" in sku, "SKU 缺少 skuName"

    def test_get_low_stock(self, client):
        """查询低库存商品"""
        resp = client.get("/product/low-stock")
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_search(self, client):
        """搜索商品"""
        resp = client.get("/product/list")
        name = resp["data"][0]["name"]
        resp = client.get("/product/search", params={"keyword": name})
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, list)

    def test_product_detail(self, client):
        """商品详情"""
        resp = client.get("/product/list")
        spuid = resp["data"][0]["id"]
        resp = client.get(f"/product/detail/{spuid}") #`f"xxx{变量}"`：格式化字符串，自动把 `{变量}` 替换成变量的值
        assert_success(resp, "查询成功")
        data = resp.get("data")
        assert isinstance(data, dict), f"详情应返回对象，实际：{type(data)}"
        assert data["id"] == spuid, f"id 应为 {spuid}，实际：{data['id']}"

    def test_save_product(self, client):
        """新增商品"""
        # 第一步：取一个一级分类ID，再从分类查商品接口拿一个二级分类ID
        cat_resp = client.get("/category/top")
        parent_id = cat_resp["data"][0]["id"]
        product_resp = client.get(f"/product/parent-category/{parent_id}")
        products = product_resp["data"]
        if products:
            category_id = products[0]["categoryId"]
        else:
            return  # 没分类数据就跳过

        # 第二步：构造商品数据，传分类ID
        product_data = build_product(category_id)

        # 第三步：发送请求
        resp = client.post("/product/save", json=product_data)
        assert_success(resp, "新增成功")
        assert isinstance(resp["data"], int), f"应返回商品ID，实际：{resp['data']}"
