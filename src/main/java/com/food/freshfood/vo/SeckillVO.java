package com.food.freshfood.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SeckillVO {
    private Long id;
    private Long spuId;
    private Long skuId;
    private String spuName;
    private String skuName;
    private String activityName;
    private BigDecimal seckillPrice;
    private BigDecimal originalPrice;
    private Integer stock;
    private Integer soldCount;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer status;
}
