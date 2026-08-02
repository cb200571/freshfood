package com.food.freshfood.service;
import  com.food.freshfood.entity.User;

public interface UserService{

    //注册
    boolean register(User user);
    //发送验证码
    public boolean sendLoginCode(String phone);//接口 interface 中的方法默认 public abstract
    // 校验验证码
    boolean verifyCode(String phone, String code);





}
