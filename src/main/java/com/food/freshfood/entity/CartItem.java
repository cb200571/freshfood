// 购物车项实体
package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("cart_item")
public class CartItem {
    @TableId(type = IdType.AUTO)
    private Long id;            // 购物车项ID
    private Long userId;        // 属于哪个用户
    private Long skuId;         // 哪个SKU
    private Long spuId;         // 哪个商品
    private Integer quantity;   // 数量
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
