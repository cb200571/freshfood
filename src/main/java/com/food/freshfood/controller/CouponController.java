package com.food.freshfood.controller;

import com.food.freshfood.Result;
import com.food.freshfood.entity.Coupon;
import com.food.freshfood.entity.CouponUser;
import com.food.freshfood.service.CouponService;
import com.food.freshfood.vo.UserCouponVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/coupon")
public class CouponController {

    @Autowired
    private CouponService couponService;

    // 商户端：创建优惠券
    @PostMapping("/create")
    public Result<Long> createCoupon(@RequestBody Coupon coupon) {
        Long id = couponService.createCoupon(coupon);
        return Result.success("创建成功", id);
    }


    // 商户端：获取所有优惠券
    @GetMapping("/list")
    public Result<List<Coupon>> listAll() {
        List<Coupon> list = couponService.listAll();
        return Result.success("查询成功", list);
    }

    // 商户端：更新优惠券状态（启用/禁用）
    @PutMapping("/status/{id}")
    public Result<String> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        boolean ok = couponService.updateStatus(id, status);
        return ok ? Result.success("更新成功") : Result.error("更新失败");
    }

    // 商户端：发放优惠券给用户
    @PostMapping("/issue")
    public Result<String> issueCoupon(@RequestParam Long couponId, @RequestParam Long userId) {
        boolean ok = couponService.issueCoupon(couponId, userId);
        return ok ? Result.success("发放成功") : Result.error("发放失败（可能已领取或库存不足）");
    }

    // 用户端：获取用户的优惠券
    @GetMapping("/my/detail")
    public Result<List<UserCouponVO>> getMyCoupons(@RequestParam Long userId) {
        List<UserCouponVO> list = couponService.getUserCouponDetail(userId);
        return Result.success("查询成功", list);
    }

}
