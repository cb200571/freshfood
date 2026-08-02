package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.entity.Coupon;
import com.food.freshfood.entity.CouponUser;
import com.food.freshfood.mapper.CouponMapper;
import com.food.freshfood.mapper.CouponUserMapper;
import com.food.freshfood.service.CouponService;
import com.food.freshfood.vo.UserCouponVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class CouponServiceImpl extends ServiceImpl<CouponMapper, Coupon> implements CouponService {

    @Autowired
    private CouponMapper couponMapper;

    @Autowired
    private CouponUserMapper couponUserMapper;

    @Override
    public Long createCoupon(Coupon coupon) {
        coupon.setUsed(0);
        coupon.setCreateTime(LocalDateTime.now());
        couponMapper.insert(coupon);
        return coupon.getId();
    }

    @Override
    public List<Coupon> listAll() {
        return couponMapper.selectList(null);
    }

    @Override
    public boolean updateStatus(Long couponId, Integer status) {
        Coupon coupon = new Coupon();
        coupon.setId(couponId);
        coupon.setStatus(status);
        return couponMapper.updateById(coupon) > 0;
    }

    @Override
    public boolean issueCoupon(Long couponId, Long userId) {
        // 检查优惠券是否存在且有效
        Coupon coupon = couponMapper.selectById(couponId);
        if (coupon == null || coupon.getStatus() != 1) {
            return false;
        }
        // 检查库存
        if (coupon.getUsed() >= coupon.getTotal()) {
            return false;
        }
        // 检查用户是否已领取
        QueryWrapper<CouponUser> checkWrapper = new QueryWrapper<>();
        checkWrapper.eq("coupon_id", couponId).eq("user_id", userId);
        Integer count = couponUserMapper.selectCount(checkWrapper);
        if (count > 0) {
            return false; // 已领取
        }
        // 发放
        CouponUser couponUser = new CouponUser();
        couponUser.setCouponId(couponId);
        couponUser.setUserId(userId);
        couponUser.setStatus(0); // 未使用
        couponUser.setCreateTime(LocalDateTime.now());
        couponUserMapper.insert(couponUser);

        // 更新已领取数量
        coupon.setUsed(coupon.getUsed() + 1);
        couponMapper.updateById(coupon);
        return true;
    }

    @Override
    public List<CouponUser> getUserCoupons(Long userId) {
        QueryWrapper<CouponUser> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        return couponUserMapper.selectList(wrapper);
    }
    @Override
    public List<UserCouponVO> getUserCouponDetail(Long userId) {
        QueryWrapper<CouponUser> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        List<CouponUser> list = couponUserMapper.selectList(wrapper);

        List<UserCouponVO> result = new ArrayList<>();
        for (CouponUser cu : list) {
            Coupon coupon = couponMapper.selectById(cu.getCouponId());
            if (coupon == null) continue;
            UserCouponVO vo = new UserCouponVO();
            vo.setId(cu.getId());
            vo.setCouponId(coupon.getId());
            vo.setName(coupon.getName());
            vo.setType(coupon.getType());
            vo.setAmount(coupon.getAmount());
            vo.setMinSpend(coupon.getMinSpend());
            vo.setStartTime(coupon.getStartTime());
            vo.setEndTime(coupon.getEndTime());
            vo.setStatus(cu.getStatus());
            vo.setOrderNo(cu.getOrderNo());
            result.add(vo);
        }
        return result;
    }
}
