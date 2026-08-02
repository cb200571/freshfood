package com.food.freshfood.dto;
import lombok.Data;
import javax.validation.constraints.Pattern;
@Data
public class SendCodeDTO {

    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;
}
