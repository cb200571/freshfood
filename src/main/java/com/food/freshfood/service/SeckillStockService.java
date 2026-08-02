package com.food.freshfood.service;

import com.food.freshfood.mapper.SeckillActivityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SeckillStockService {

    @Autowired
    private SeckillActivityMapper seckillActivityMapper;

    @Transactional
    public void decrement(Long activityId) {
        int updated = seckillActivityMapper.increaseSoldCount(activityId);
        if (updated == 0) {
            throw new RuntimeException("秒杀库存不足");
        }
    }
}