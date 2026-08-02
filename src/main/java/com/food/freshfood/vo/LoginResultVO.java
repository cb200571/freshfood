package com.food.freshfood.vo;
import lombok.Data;

@Data
public class LoginResultVO {
    private Long userId;
    private String token;
    private String username;
    private String phone;
    private Integer role;
}
