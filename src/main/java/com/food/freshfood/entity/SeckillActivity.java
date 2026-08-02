package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// 秒杀活动实体
@Data
@TableName("seckill_activity")
public class SeckillActivity {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long spuId;              // 商品SPU ID
    private Long skuId;              // 商品SKU ID
    private String activityName;     // 活动名称
    private BigDecimal seckillPrice; // 秒杀价
    private BigDecimal originalPrice;// 原价
    private Integer stock;           // 秒杀库存
    private Integer soldCount;       // 已售数量
    private LocalDateTime startTime; // 活动开始时间
    private LocalDateTime endTime;   // 活动结束时间
    private Integer status;          // 状态：0=未开始 1=进行中 2=已结束
    private LocalDateTime createTime;
}
