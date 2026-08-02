
import pytest
from utils.api_client import APIClient
from utils.data_builder import build_register_user
from utils.assertions import assert_success, assert_error

class TestCategoryTop:
    def test_get_top_categories(self, client):
        resp = client.get("/category/top")
        assert_success(resp,"查询成功")
        data = resp.get("data")
        assert isinstance(data, list), f"data 应为列表，实际类型：{type(data)}"
        for category in data:
            assert category["parentId"] == 0, (
                          f"一级分类 parentId 应为 0，实际：{category['parentId']}"
                      )
    def test_get_sub_categories(self, client):
            resp = client.get("/category/sub/1")
            assert_success(resp,"查询成功")
            data = resp.get("data")
            assert isinstance(data, list), f"data 应为列表，实际类型：{type(data)}"
            for category in data:
                assert category["parentId"] == 1, (
                              f"一级分类 parentId 应为 1，实际：{category['parentId']}"
                          )

