package com.food.freshfood.service;

import com.food.freshfood.entity.Coupon;
import com.food.freshfood.entity.CouponUser;
import com.food.freshfood.vo.UserCouponVO;

import java.util.List;

public interface CouponService {
    // 创建优惠券
    Long createCoupon(Coupon coupon);

    // 获取所有优惠券
    List<Coupon> listAll();

    // 更新优惠券状态
    boolean updateStatus(Long couponId, Integer status);

    // 发放优惠券给用户
    boolean issueCoupon(Long couponId, Long userId);

    // 获取用户已领取的优惠券
    List<CouponUser> getUserCoupons(Long userId);
    List<UserCouponVO> getUserCouponDetail(Long userId);

}
