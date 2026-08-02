package com.food.freshfood.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.food.freshfood.Result;
import com.food.freshfood.dto.CreateOrderDTO;
import com.food.freshfood.entity.OrderInfo;
import com.food.freshfood.entity.OrderItem;
import com.food.freshfood.mapper.OrderInfoMapper;
import com.food.freshfood.mapper.OrderItemMapper;
import com.food.freshfood.service.OrderService;
import com.food.freshfood.service.SeckillStockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/api/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;
    @Autowired
    private SeckillStockService seckillStockService;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    // 创建订单

    @PostMapping("/create")
    public Result<OrderInfo> createOrder(@RequestBody CreateOrderDTO dto) {
        try {
            // ===== 秒杀预扣（在事务之前执行）=====
            if (dto.getSeckillActivityId() != null) {
                // 第一道防线：Redis 预减
                String stockKey = "seckill:stock:" + dto.getSeckillActivityId();
                String luaScript = "local stock = redis.call('DECR', KEYS[1]); if stock < 0 then redis.call('INCR', KEYS[1]); return -1; end; return stock;";
                DefaultRedisScript<Long> redisScript = new DefaultRedisScript<>(luaScript, Long.class);
                Long remain = stringRedisTemplate.execute(redisScript, Collections.singletonList(stockKey));
                if (remain == null || remain < 0) {
                    return Result.error(500, "秒杀库存不足");
                }

                // 第二道防线：数据库行锁扣减（独立事务，几毫秒释放）
                seckillStockService.decrement(dto.getSeckillActivityId());
            }
            // ===== 秒杀预扣结束 =====

            OrderInfo order = orderService.createOrder(dto);
            return Result.success("下单成功", order);
        } catch (Exception e) {
            return Result.error(500, "下单失败：" + e.getMessage());
        }
    }

    // 获取用户订单列表
    @GetMapping("/list")
    public Result<List<OrderInfo>> getUserOrders(@RequestParam Long userId) {
        List<OrderInfo> orders = orderService.getUserOrders(userId);
        return Result.success("查询成功", orders);
    }

    // 获取订单详情
    @GetMapping("/detail")
    public Result<OrderInfo> getOrderDetail(@RequestParam String orderNo) {
        OrderInfo order = orderService.getOrderDetail(orderNo);
        if (order == null) {
            return Result.error(404, "订单不存在");
        }
        return Result.success("查询成功", order);
    }

    // 获取订单商品列表
    @GetMapping("/items")
    public Result<List<OrderItem>> getOrderItems(@RequestParam String orderNo) {
        QueryWrapper<OrderItem> wrapper = new QueryWrapper<>();
        wrapper.eq("order_no", orderNo);
        List<OrderItem> items = orderItemMapper.selectList(wrapper);
        return Result.success("查询成功", items);
    }

    // 支付订单
    @PostMapping("/pay")
    public Result<String> payOrder(@RequestParam String orderNo) {
        boolean success = orderService.payOrder(orderNo);
        if (success) {
            return Result.success("支付成功");
        } else {
            return Result.error(500, "支付失败");
        }
    }

    // 取消订单
    @PostMapping("/cancel")
    public Result<String> cancelOrder(@RequestParam String orderNo) {
        boolean success = orderService.cancelOrder(orderNo);
        if (success) {
            return Result.success("取消成功");
        } else {
            return Result.error(500, "取消失败");
        }
    }

    // ==================== 商户端接口 ====================

    // 商户端：获取所有订单
    @GetMapping("/admin/list")
    public Result<List<OrderInfo>> adminOrderList(@RequestParam(required = false) Integer status) {
        QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
        if (status != null) {
            wrapper.eq("status", status);
        }
        wrapper.orderByDesc("create_time");
        List<OrderInfo> orders = orderInfoMapper.selectList(wrapper);
        return Result.success("查询成功", orders);
    }

    // 商户端：发货
    @PostMapping("/admin/ship")
    public Result<String> shipOrder(@RequestParam String orderNo) {
        OrderInfo order = orderService.getOrderDetail(orderNo);
        if (order == null) {
            return Result.error(404, "订单不存在");
        }
        if (order.getStatus() != 1) {
            return Result.error(400, "只有已付款的订单才能发货");
        }
        order.setStatus(2);  // 已发货
        order.setUpdateTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);
        return Result.success("发货成功");
    }

    // 商户端：完成订单
    @PostMapping("/admin/complete")
    public Result<String> completeOrder(@RequestParam String orderNo) {
        OrderInfo order = orderService.getOrderDetail(orderNo);
        if (order == null) {
            return Result.error(404, "订单不存在");
        }
        if (order.getStatus() != 2) {
            return Result.error(400, "只有已发货的订单才能完成");
        }
        order.setStatus(3);  // 已完成
        order.setUpdateTime(LocalDateTime.now());
        orderInfoMapper.updateById(order);
        return Result.success("订单已完成");
    }
}