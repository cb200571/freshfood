package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.OrderItem;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {

    @Delete("DELETE oi FROM order_item oi INNER JOIN seckill_order so ON oi.order_no = so.order_no WHERE so.activity_id = #{activityId}")
    int deleteBySeckillActivityId(@Param("activityId") Long activityId);
}