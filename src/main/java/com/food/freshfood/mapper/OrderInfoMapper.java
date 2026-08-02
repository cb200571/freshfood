package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.OrderInfo;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Mapper
public interface OrderInfoMapper extends BaseMapper<OrderInfo> {

    @Select("SELECT COUNT(*) FROM order_info WHERE create_time >= #{todayStart} AND create_time < #{todayEnd}")
    int countTodayOrders(@Param("todayStart") LocalDateTime todayStart, @Param("todayEnd") LocalDateTime todayEnd);

    @Select("SELECT COALESCE(SUM(pay_amount), 0) FROM order_info WHERE create_time >= #{todayStart} AND create_time < #{todayEnd} AND status = 1")
    BigDecimal sumTodaySales(@Param("todayStart") LocalDateTime todayStart, @Param("todayEnd") LocalDateTime todayEnd);

    @Select("SELECT COUNT(*) FROM order_info WHERE status = 1")
    int countPendingShip();

    @Delete("DELETE oi FROM order_info oi INNER JOIN seckill_order so ON oi.order_no = so.order_no WHERE so.activity_id = #{activityId}")
    int deleteBySeckillActivityId(@Param("activityId") Long activityId);
}
