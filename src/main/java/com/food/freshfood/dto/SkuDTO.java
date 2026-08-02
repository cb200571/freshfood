package com.food.freshfood.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;

@Data
public class SkuDTO {
    @NotNull(message = "SKU ID不能为空")
    private Long skuId;

    @NotNull(message = "数量不能为空")
    @Positive(message = "数量必须大于0")//@Positive = 必须是正数
    private Integer quantity;




}
