package com.food.freshfood.service.impl;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.entity.User;
import com.food.freshfood.service.UserService;
import  com.food.freshfood.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Random;
import java.util.concurrent.TimeUnit;


@Service//项目启动时，Spring 会自动创建这个类的对象
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
    @Autowired
    private RedisTemplate<String, String> redisTemplate;  // 验证码存Redis
   /*
     extends ServiceImpl<Mapper类型, 实体类型>
     继承后自动拥有：save()、getOne()、list()、update()、remove() 等方法
     不需要手动写 @Autowired 注入 UserMapper 了，父类已经注入好了
   */
   @Override
   //注册时校验用户名和手机号是否已经被注册
    public boolean register(User user){
        // 1. 检查用户名是否已被注册
        User existUser=baseMapper.findByUsername(user.getUsername());
        if(existUser != null){
            return false;
        }

        //验证手机号是否被注册
        User existPhoneUser=baseMapper.findByPhone(user.getPhone());
        if(existPhoneUser != null){
            return false;
        }
        //用户名手机号没被注册就插入
        int result =baseMapper.insert(user);
        return result>0;
    }
    @Override
    public boolean sendLoginCode(String phone) {
        String limitKey = "sms:login:limit:" + phone;
        String codeKey = "sms:login:code:" + phone;

        //1、60秒限流：同一个手机号1分钟只能发1次
        Boolean hasLimit = redisTemplate.hasKey(limitKey);
        if (Boolean.TRUE.equals(hasLimit)) {
            throw new RuntimeException("验证码60秒内请勿重复获取");
        }

        //2、安全生成6位验证码
        SecureRandom random = new SecureRandom();
        int codeNum = random.nextInt(900000) + 100000;
        String code = String.valueOf(codeNum);

        try {
            //3、存验证码1分钟 + 限流锁60秒
            redisTemplate.opsForValue().set(codeKey, code, 1, TimeUnit.MINUTES);
            redisTemplate.opsForValue().set(limitKey, "1", 60, TimeUnit.SECONDS);

            //TODO 正式环境替换短信接口
            //smsService.send(phone,"您的登录验证码："+code+"，1分钟有效");
            System.out.println("【测试登录验证码】手机号:"+phone+",验证码:"+code);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("验证码发送失败，请稍后重试");
        }
    }


    @Override
    //登录时校验验证码
    public boolean verifyCode(String phone, String code) {
        String cachedCode = redisTemplate.opsForValue().get("sms:login:code:" + phone);

        if (cachedCode == null || !cachedCode.equals(code)) {
            return false;
        }
        // 验证成功后删除，防止重复使用
        redisTemplate.delete("sms:login:code:" + phone);
        return true;
    }




}
