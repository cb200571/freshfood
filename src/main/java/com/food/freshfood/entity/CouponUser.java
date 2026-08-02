package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

// 用户领取优惠券记录
@Data
@TableName("coupon_user")
public class CouponUser {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long couponId;       // 优惠券ID
    private Long userId;         // 用户ID
    private String orderNo;      // 使用的订单号（未使用为null）
    private Integer status;      // 状态：0=未使用 1=已使用 2=已过期
    private LocalDateTime createTime;
}
