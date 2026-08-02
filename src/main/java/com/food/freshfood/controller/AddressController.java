package com.food.freshfood.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.food.freshfood.Result;
import com.food.freshfood.entity.Address;
import com.food.freshfood.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController//等价 @Controller + @ResponseBody @ResponseBody：方法返回值直接转为 JSON 格式响应给前端，不再跳转页面
@RequestMapping("/api/address")
public class AddressController {
    @Autowired//Spring 依赖注入注解，根据类型（AddressService） 从 Spring IoC 容器中查找对应的 Bean实例赋值给addressService
    private AddressService addressService;

    // 获取用户的所有地址
    @GetMapping("/list")
    public Result<List<Address>> getUserAddresses(@RequestParam Long userId) {//@RequestParam：接收URL 查询参数
        List<Address> addresses = addressService.getUserAddresses(userId);
        return Result.success("查询成功", addresses);
    }

    // 获取用户的默认地址
    @GetMapping("/default")
    public Result<Address> getDefaultAddress(@RequestParam Long userId) {
        Address address = addressService.getDefaultAddress(userId);
        if (address != null) {
            return Result.success("查询成功", address);  // ✅ 修正
        } else {
            return Result.error(404, "未找到默认地址");
        }
    }

    // 添加地址
    @PostMapping("/add")
    public Result<String> addAddress(@RequestBody Address address) {
        boolean success = addressService.addAddress(address);
        return success ? Result.success("添加成功") : Result.error(500, "添加失败");
    }

    // 更新地址
    @PutMapping("/update")
    public Result<String> updateAddress(@RequestBody Address address) {
        boolean success = addressService.updateAddress(address);
        return success ? Result.success("更新成功") : Result.error(500, "更新失败");
    }

    // 删除地址
    @DeleteMapping("/delete")
    public Result<String> deleteAddress(@RequestParam Long addressId, @RequestParam Long userId) {
        boolean success = addressService.deleteAddress(addressId, userId);
        return success ? Result.success("删除成功") : Result.error(500, "删除失败");
    }

    // 设置默认地址
    @PutMapping("/setDefault")
    public Result<String> setDefaultAddress(@RequestParam Long addressId, @RequestParam Long userId) {
        boolean success = addressService.setDefaultAddress(addressId, userId);
        return success ? Result.success("设置成功") : Result.error(500, "设置失败");
    }
}
