package com.food.freshfood.service;

import com.food.freshfood.entity.SeckillActivity;
import com.food.freshfood.vo.SeckillVO;

import java.util.List;

public interface SeckillService {
    Long createActivity(SeckillActivity activity);
    List<SeckillVO> listAll();
    boolean updateStatus(Long activityId, Integer status);
    List<SeckillVO> getActiveActivities();

    // 重置秒杀活动（清空订单、恢复库存，供压测重复使用）
    boolean resetActivity(Long activityId);
}
