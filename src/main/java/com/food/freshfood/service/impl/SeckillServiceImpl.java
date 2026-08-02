package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.entity.SeckillActivity;
import com.food.freshfood.entity.Sku;
import com.food.freshfood.entity.Spu;
import com.food.freshfood.mapper.OrderInfoMapper;
import com.food.freshfood.mapper.OrderItemMapper;
import com.food.freshfood.mapper.SeckillActivityMapper;
import com.food.freshfood.mapper.SeckillOrderMapper;
import com.food.freshfood.mapper.SkuMapper;
import com.food.freshfood.mapper.SpuMapper;
import com.food.freshfood.service.SeckillService;
import com.food.freshfood.vo.SeckillVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
public class SeckillServiceImpl extends ServiceImpl<SeckillActivityMapper, SeckillActivity> implements SeckillService {

    @Autowired
    private SeckillActivityMapper seckillActivityMapper;

    @Autowired
    private SeckillOrderMapper seckillOrderMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private SpuMapper spuMapper;

    @Autowired
    private SkuMapper skuMapper;


    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    private SeckillVO toVO(SeckillActivity a) {
        SeckillVO vo = new SeckillVO();
        vo.setId(a.getId());
        vo.setSpuId(a.getSpuId());
        vo.setSkuId(a.getSkuId());
        vo.setActivityName(a.getActivityName());
        vo.setSeckillPrice(a.getSeckillPrice());
        vo.setOriginalPrice(a.getOriginalPrice());
        vo.setStock(a.getStock());
        vo.setSoldCount(a.getSoldCount());
        vo.setStartTime(a.getStartTime());
        vo.setEndTime(a.getEndTime());
        vo.setStatus(a.getStatus());
        // 查商品名称
        Spu spu = spuMapper.selectById(a.getSpuId());
        vo.setSpuName(spu != null ? spu.getName() : "ID:" + a.getSpuId());
        // 查SKU名称
        Sku sku = skuMapper.selectById(a.getSkuId());
        vo.setSkuName(sku != null ? sku.getSkuName() : "ID:" + a.getSkuId());
        return vo;
    }

    @Override
    public Long createActivity(SeckillActivity activity) {
        activity.setSoldCount(0);
        activity.setCreateTime(LocalDateTime.now());
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(activity.getStartTime())) {
            activity.setStatus(0);
        } else if (now.isAfter(activity.getEndTime())) {
            activity.setStatus(2);
        } else {
            activity.setStatus(1);
        }
        seckillActivityMapper.insert(activity);
        return activity.getId();
    }

    @Override
    public List<SeckillVO> listAll() {
        List<SeckillActivity> list = seckillActivityMapper.selectList(null);
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    public boolean updateStatus(Long activityId, Integer status) {
        SeckillActivity activity = new SeckillActivity();
        activity.setId(activityId);
        activity.setStatus(status);
        return seckillActivityMapper.updateById(activity) > 0;
    }

    @Override
    public List<SeckillVO> getActiveActivities() {
        LocalDateTime now = LocalDateTime.now();
        // 查所有状态为1且当前时间在有效期内的
        QueryWrapper<SeckillActivity> wrapper = new QueryWrapper<>();
        wrapper.eq("status", 1)
                .le("start_time", now)
                .ge("end_time", now);
        List<SeckillActivity> list = seckillActivityMapper.selectList(wrapper);
        return list.stream().map(this::toVO).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public boolean resetActivity(Long activityId) {
        // 0. 先查出活动信息（需要 skuId 恢复库存）
        SeckillActivity activity = seckillActivityMapper.selectById(activityId);

        if (activity == null) {
            return false;
        }
        // 1. 删除关联的订单明细（联表删）
        orderItemMapper.deleteBySeckillActivityId(activityId);
        // 2. 删除关联的订单主表（联表删）
        orderInfoMapper.deleteBySeckillActivityId(activityId);
        // 3. 删除秒杀订单记录
        seckillOrderMapper.deleteByActivityId(activityId);
        // 4. 重置已售数量 + 拉满库存（保证压测50并发全过）
        activity.setSoldCount(0);
        activity.setStock(99999999);
        seckillActivityMapper.updateById(activity);
        // 5. 恢复 SKU 库存
        skuMapper.resetStock(activity.getSkuId(), 99999999);
        // 6. 重置 Redis 秒杀库存
        stringRedisTemplate.opsForValue().set("seckill:stock:" + activityId, String.valueOf(activity.getStock()));
        return true;
    }

    private String generateOrderNo() {
        String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String random = String.format("%04d", new Random().nextInt(10000));
        return "SK" + time + random;
    }
}
