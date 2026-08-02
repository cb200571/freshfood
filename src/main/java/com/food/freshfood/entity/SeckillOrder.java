package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// 秒杀订单实体
@Data
@TableName("seckill_order")
public class SeckillOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long activityId;      // 秒杀活动ID
    private Long userId;          // 用户ID
    private Long skuId;           // SKU ID
    private String orderNo;       // 订单号
    private BigDecimal seckillPrice; // 秒杀价
    private Integer status;       // 状态：0=待付款 1=已付款 2=已取消
    private LocalDateTime createTime;
}
