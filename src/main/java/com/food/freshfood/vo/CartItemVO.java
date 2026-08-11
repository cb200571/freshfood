package com.food.freshfood.vo;

import lombok.Data;

import java.math.BigDecimal;

// 购物车视图对象：购物车项 + 商品/规格信息
@Data
public class CartItemVO {
    private Long id;            // 购物车项ID
    private Long userId;        // 用户ID
    private Long skuId;         // SKU ID
    private Long spuId;         // 商品ID
    private Integer quantity;   // 数量
    // ===== 联表带出的商品信息 =====
    private String name;        // 商品名（来自 spu）
    private String skuName;     // SKU 规格名（来自 sku）
    private BigDecimal price;   // 价格（来自 sku）
    private String image;       // 图片（来自 sku.image）
}
