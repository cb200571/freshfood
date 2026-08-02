package com.food.freshfood.service;

import com.food.freshfood.entity.Address;

import java.util.List;

public interface AddressService {
    List<Address> getUserAddresses(Long userId);

    // 获取用户的默认地址
    Address getDefaultAddress(Long userId);

    // 添加地址
    boolean addAddress(Address address);

    // 更新地址
    boolean updateAddress(Address address);

    // 删除地址
    boolean deleteAddress(Long addressId, Long userId);

    // 设置默认地址
    boolean setDefaultAddress(Long addressId, Long userId);
}
