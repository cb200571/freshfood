package com.food.freshfood.dto;
import lombok.Data;
import javax.validation.constraints.*;
import java.time.LocalDateTime;

@Data
public class RegisterDTO {
    // 用户名：4-20位，只能包含中文、字母、数字，不能有空格
    @NotBlank(message = "用户名不能为空")//专门用来检查字符串是不是 “真的有内容”。
    @Size(min =2 , max = 20, message = "用户名长度必须在2-20之间")
    @Pattern(regexp = "^[\\u4e00-\\u9fa5a-zA-Z0-9]+$", message = "用户名只能包含中文、字母、数字")//\u4e00-\u9fa5 → 中文，a-zA-Z → 字母，0-9 → 数字
    private String username;

    // 密码：8-20位，必须包含大写字母、小写字母、数字、特殊字符
    @NotBlank(message="密码不能为空")
    @Size(min =8,max=20, message="密码长度必须在8-20之间")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$",
            message = "密码必须包含大写字母、小写字母、数字和特殊字符(@$!%*?&)")
    private String password;



    // 邮箱：标准邮箱格式
    @Email(message = "邮箱格式不正确")
    private String email;

    // 手机号：11位，1开头
    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确，必须是11位数字，以1开头") //[3-9] → 第二位必须是 3/4/5/6/7/8/9,\\d{9} → 后面 9 位都是数字
    private String phone;


}
