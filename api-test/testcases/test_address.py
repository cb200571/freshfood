from utils.assertions import assert_success
from utils.data_builder import build_address


class TestAddress:
    """地址增删改查测试"""

    def test_add_address(self, client, login_user_id):
        """添加地址"""
        buildAddress = build_address(login_user_id)
        address_resp = client.post("/address/add", json=buildAddress)
        assert_success(address_resp, "添加成功")

    def test_list_address(self, client, login_user_id):
        """查询用户地址列表"""
        address_resp = client.get("/address/list", params={"userId": login_user_id})
        assert_success(address_resp, "查询成功")
        assert len(address_resp["data"]) > 0, "添加地址后列表不应为空"

    def test_set_default_address(self, client, login_user_id):
        """设置默认地址"""
        # 先拿一个地址ID
        address_list = client.get("/address/list", params={"userId": login_user_id})
        address_id = address_list["data"][0]["id"]
        # 设为默认
        resp = client.put("/address/setDefault",
                          params={"addressId": address_id, "userId": login_user_id})
        assert_success(resp, "设置成功")

    def test_get_default_address(self, client, login_user_id):
        """查询默认地址"""
        resp = client.get("/address/default", params={"userId": login_user_id})
        assert_success(resp, "查询成功")
        assert resp["data"]["isDefault"] == 1, "默认地址 isDefault 应为 1"

    def test_update_address(self, client, login_user_id):
        """更新地址"""
        address_list = client.get("/address/list", params={"userId": login_user_id})
        assert_success(address_list, "查询成功")
        address_dto = address_list["data"][0]
        address_dto["detailAddress"] = "东枣园乡政府"
        addressdto_update = client.put("/address/update", json=address_dto)
        assert_success(addressdto_update, "更新成功")
        address_list_new = client.get("/address/list", params={"userId": login_user_id})
        assert_success(address_list_new, "查询成功")
        latest_addr = address_list_new["data"][0]
        assert latest_addr["detailAddress"] == "东枣园乡政府", f"更新失败"

    def test_delete_address(self, client, login_user_id):
        """删除地址"""
        # 先拿一个地址ID
        address_list = client.get("/address/list", params={"userId": login_user_id})
        if not address_list["data"]:
            return  # 没地址就跳过
        address_id = address_list["data"][0]["id"]
        # 删除
        resp = client.delete("/address/delete",
                             params={"addressId": address_id, "userId": login_user_id})
        assert_success(resp, "删除成功")
        # 验证：再查列表，应该没有这个地址了
        address_list_new = client.get("/address/list", params={"userId": login_user_id})
        ids = [a["id"] for a in address_list_new["data"]]
        assert address_id not in ids, "删除后地址仍存在"



