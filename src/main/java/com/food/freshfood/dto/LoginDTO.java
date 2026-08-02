package com.food.freshfood.dto;
import lombok.Data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Data
public class LoginDTO {
//登录方式一
    @NotBlank(message = "用户名不能为空",groups = PasswordLogin.class)//专门用来检查字符串是不是 “真的有内容”。
    private String username;

    // 密码：8-20位，必须包含大写字母、小写字母、数字、特殊字符
    @NotBlank(message="密码不能为空",groups = PasswordLogin.class)
    private String password;

//登录方式二
    // 手机号：11位，1开头
    @NotBlank(message = "手机号不能为空", groups = PhoneLogin.class)
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确") //[3-9] → 第二位必须是 3/4/5/6/7/8/9,\\d{9} → 后面 9 位都是数字
    private String phone;

    //验证码
    @NotBlank(message="验证码不能为空", groups = PhoneLogin.class)
    private String code;

    // ====== 校验分组 ======
    public interface PasswordLogin {}  // 账号密码登录组
    public interface PhoneLogin {}     // 手机验证码登录组

    // 辅助方法：判断当前是哪种登录方式
    public boolean isPasswordLogin() {
        return username != null && !username.isEmpty();
    }




}
