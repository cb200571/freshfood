package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// 优惠券实体
@Data
@TableName("coupon")
public class Coupon {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;           // 优惠券名称
    private Integer type;          // 类型：1=满减 2=折扣
    private BigDecimal amount;     // 优惠金额（满减）或折扣比例（如0.85表示85折）
    private BigDecimal minSpend;   // 最低消费金额
    private LocalDateTime startTime; // 有效期开始
    private LocalDateTime endTime;   // 有效期结束
    private Integer total;         // 发放总量
    private Integer used;          // 已领取数量
    private Integer status;        // 状态：1=启用 0=禁用
    private LocalDateTime createTime;
}
