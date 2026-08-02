import random
import string
import re
from datetime import datetime, timedelta

def random_username():
    suffix = "".join(random.choices(string.ascii_lowercase + string.digits, k=6))
    return f"t{suffix}"

def random_phone():
    prefix = random.choice(["13", "15", "18"])
    suffix = "".join(random.choices(string.digits, k=9))
    return f"{prefix}{suffix}"

def build_register_user():
    return {
        "username": random_username(),
        "password": "Test@1234",
        "phone": random_phone(),
        "email": "test@example.com",
    }

def build_product(category_id=None):
    """生成随机商品数据，category_id 不传时可从接口动态获取"""
    random_suffix = "".join(random.choices(string.ascii_lowercase + string.digits, k=6))
    return {
        "name": f"测试商品_{random_suffix}",
        "categoryId": category_id,
        "brand": "测试品牌",
        "description": "测试描述",
        "mainImage": "http://test.jpg",
        "isColdChain": 0,
        "shelfLife": 7,
        "status": 1,
        "skuList": [build_sku()]
    }

def build_sku():
    """生成随机 SKU 数据"""
    return {
        "skuName": f"SKU_{random_username()}",
        "price": round(random.uniform(10, 100), 2),
        "originalPrice": round(random.uniform(10, 100), 2),
        "stock": random.randint(50, 500),
        "warningStock": random.randint(5, 20)
    }



def build_order(user_id=None,items=None):
    return {
        "userId": user_id,
        "receiverName": f"Test_{random_username()}",
        "receiverPhone": random_phone(),
        "receiverAddress": "河北省邢台市临西县东枣园乡",
        "couponUserId": None,
        "seckillActivityId": None,
        "items": [items]
    }

def build_OrderItemDTO(spu_id=None,sku_id=None,sku_name=None):
    return {
        "spuId": spu_id,
        "skuId": sku_id,
        "productName": re.match(r"([\u4e00-\u9fa5]+)", sku_name).group(1),
        "skuName": sku_name,
        "productImage":"http://test.jpg",
        "price":5.90,
        "quantity":random.randint(1, 10)
    }



def build_coupon():
    """生成优惠券数据（满减券）"""
    return {
        "name": f"测试优惠券_{random_username()}",
        "type": 1,
        "amount": round(random.uniform(5, 50), 2),
        "minSpend": 100,
        "total": 100,
        "status": 1
    }

def build_seckill(spu_id=None, sku_id=None):
    """生成秒杀活动数据"""
    return {
        "spuId": spu_id,
        "skuId": sku_id,
        "activityName": f"秒杀_{random_username()}",
        "seckillPrice": round(random.uniform(1, 50), 2),
        "originalPrice": round(random.uniform(50, 200), 2),
        "stock": 100,
        "startTime": (datetime.now() - timedelta(hours=1)).strftime("%Y-%m-%dT%H:%M:%S"),
        "endTime": (datetime.now() + timedelta(days=7)).strftime("%Y-%m-%dT%H:%M:%S"),
        "status": 1
    }

#地址dto
def build_address(user_id=None):
    current_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    return {
        "userId": user_id,
        "receiverName": f"Test_{random_username()}",
        "receiverPhone": random_phone(),
        "province":"河北",
        "city":"邢台",
        "district":"临西县",
        "detailAddress":"东枣园乡",
        "isDefault":0,
        "createTime":current_time,
        "updateTime":current_time
    }





