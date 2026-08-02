package com.food.freshfood.entity;
import java.time.LocalDateTime;
import lombok.Data;
import javax.validation.constraints.*;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@Data
@TableName("user")//表明映射注解
public class User {
    // @TableId 告诉 MyBatis-Plus 这个字段是主键
    // IdType.AUTO 表示主键自增
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    private String phone;
    private String email;
    private LocalDateTime createTime;
    private Integer role;


    // 自动去除空格（防脏数据）
    public void setUsername(String username){
         this.username=username==null?null:username.trim();
    }
    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

}
