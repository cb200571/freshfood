package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data//@Data，编译阶段自动生成全套方法：所有字段的 getXxx()、setXxx()toString()、equals()、hashCode()
@TableName("address")
public class Address {
        @TableId(type = IdType.AUTO)
        private Long id;
        private Long userId;
        private String receiverName;
        private String receiverPhone;
        private String province;
        private String city;
        private String district;
        private String detailAddress;
        private Integer isDefault;
        private LocalDateTime createTime;
        private LocalDateTime updateTime;

}
