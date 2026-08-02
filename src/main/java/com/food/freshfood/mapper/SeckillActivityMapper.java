package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.SeckillActivity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface SeckillActivityMapper extends BaseMapper<SeckillActivity> {

    // 原子扣减秒杀库存：WHERE sold_count < stock 利用数据库行锁保证不超卖
    // 返回1=扣减成功，返回0=库存已售罄
    @Update("UPDATE seckill_activity SET sold_count = sold_count + 1 WHERE id = #{activityId} AND sold_count < stock")
    int increaseSoldCount(@Param("activityId") Long activityId);
}
