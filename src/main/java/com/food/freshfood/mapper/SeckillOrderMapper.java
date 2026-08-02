package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.SeckillOrder;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SeckillOrderMapper extends BaseMapper<SeckillOrder> {

    @Delete("DELETE FROM seckill_order WHERE activity_id = #{activityId}")
    int deleteByActivityId(@Param("activityId") Long activityId);
}
