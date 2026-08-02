package com.food.freshfood.dto;


import lombok.Data;
import java.util.List;

@Data
public class CreateOrderDTO {
        private Long userId;
        private String receiverName;
        private String receiverPhone;
        private String receiverAddress;
        private Long couponUserId;  // 使用的优惠券记录ID（coupon_user.id），不用券时为null
        private Long seckillActivityId; // 秒杀活动ID，非秒杀为null
        private List<OrderItemDTO> items;

        @Data
        public static class OrderItemDTO {
            private Long spuId;
            private Long skuId;
            private String productName;
            private String skuName;
            private String productImage;
            private java.math.BigDecimal price;
            private Integer quantity;
        }
    }
