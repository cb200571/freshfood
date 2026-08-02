package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.entity.Address;
import com.food.freshfood.entity.User;
import com.food.freshfood.mapper.AddressMapper;
import com.food.freshfood.service.AddressService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AddressServiceImpl extends ServiceImpl<AddressMapper,Address>  implements AddressService {
    @Override
    //获取用户所有地址
    public List<Address> getUserAddresses(Long userId) {
        QueryWrapper<Address> wrapper = new QueryWrapper<>();//QueryWrapper 是 MyBatis-Plus 条件构造器，用来拼接 SQL 查询条件，不用手写 XML/SQL 语句。
        //链式条件拼接
        wrapper.eq("user_id", userId)//第一个参数：数据库表字段名 user_id ,第二个参数：传入的参数 userId,对应 SQL： where user_id = #{userId}
                .orderByDesc("is_default")//效果：默认地址排在最前面。
                .orderByDesc("create_time");//效果：同是默认 / 非默认地址时，最新创建的地址靠前
        return baseMapper.selectList(wrapper);
    }

    @Override
    //获取默认地址
    public Address getDefaultAddress(Long userId) {
        QueryWrapper<Address> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId)
                .eq("is_default", 1)
                .last("LIMIT 1");
        return baseMapper.selectOne(wrapper);
    }

    //添加地址
    @Override
    @Transactional//@Transactional 是 Spring 提供的声明式事务注解，保证一组数据库操作要么全部成功，要么全部回滚，避免出现半成功脏数据。
    public boolean addAddress(Address address) {
        // 如果新地址设为默认，先把其他地址改为非默认
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            clearDefaultAddress(address.getUserId());
        }
        return baseMapper.insert(address) > 0;
    }
//更新地址
    @Override
    @Transactional
    public boolean updateAddress(Address address) {
        if (address.getIsDefault() != null && address.getIsDefault() == 1) {
            clearDefaultAddress(address.getUserId());
        }
        return baseMapper.updateById(address) > 0;
    }
//删除地址
    @Override
    public boolean deleteAddress(Long addressId, Long userId) {
        QueryWrapper<Address> wrapper = new QueryWrapper<>();
        wrapper.eq("id", addressId)
                .eq("user_id", userId);
        return baseMapper.delete(wrapper) > 0;
    }
//设置默认地址
    @Override
    @Transactional
    public boolean setDefaultAddress(Long addressId, Long userId) {
        // 先清除该用户的所有默认地址
        clearDefaultAddress(userId);
        // 再设置新的默认地址
        Address address = new Address();
        address.setId(addressId);
        address.setIsDefault(1);
        return baseMapper.updateById(address) > 0;
    }
//清空默认地址
    private void clearDefaultAddress(Long userId) {
        Address update = new Address();
        update.setIsDefault(0);
        QueryWrapper<Address> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId)
                .eq("is_default", 1);//wrapper 不存放表数据，只存放查询 / 更新的筛选条件
        baseMapper.update(update, wrapper);///参数 1：entity → 要修改成什么值（SET 部分）参数 2：wrapper → 哪些数据要改（WHERE 条件）
        /*合起来的sql:UPDATE address
        SET is_default = 0
        WHERE user_id = ? AND is_default = 1
        */

    }


}
