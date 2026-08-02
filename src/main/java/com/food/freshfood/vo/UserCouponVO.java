package com.food.freshfood.vo;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class UserCouponVO {
    private Long id;
    private Long couponId;
    private String name;
    private Integer type;
    private BigDecimal amount;
    private BigDecimal minSpend;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer status;
    private String orderNo;
}
