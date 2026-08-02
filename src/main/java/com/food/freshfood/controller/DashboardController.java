package com.food.freshfood.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.food.freshfood.Result;
import com.food.freshfood.entity.OrderInfo;
import com.food.freshfood.entity.Sku;
import com.food.freshfood.entity.User;
import com.food.freshfood.mapper.OrderInfoMapper;
import com.food.freshfood.mapper.SkuMapper;
import com.food.freshfood.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    @Autowired
    private OrderInfoMapper orderInfoMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SkuMapper skuMapper;

    /**
     * 获取仪表盘统计数据
     * 返回：今日订单数、今日销售额、待发货数、用户总数
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();

        // 1. 今日订单数：今天创建的订单总数
        //    原理：用 QueryWrapper 构造 WHERE 条件
        //    create_time >= 今天0点 AND create_time < 明天0点
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now().plusDays(1), LocalTime.MIN);

        // 性能优化：4次查询改为3次SQL聚合，今日销售额改用SQL SUM替代Java内存求和
        // 1. 今日订单数（SQL COUNT）
        stats.put("todayOrderCount", orderInfoMapper.countTodayOrders(todayStart, todayEnd));

        // 2. 今日销售额（SQL SUM，避免查出全部订单再Java求和）
        stats.put("todaySales", orderInfoMapper.sumTodaySales(todayStart, todayEnd));

        // 3. 待发货数：status=1（已付款）的订单
        stats.put("pendingShipCount", orderInfoMapper.countPendingShip());

        // 4. 用户总数
        Integer totalUsers = userMapper.selectCount(null);  // null = 不加条件，查全部
        stats.put("totalUsers", totalUsers);

        return Result.success("查询成功", stats);
    }

    /**
     * 获取库存预警列表
     * 返回：库存 <= 预警库存 的 SKU 列表
     */
    @GetMapping("/low-stock")
    public Result<List<Sku>> getLowStock() {
        // 直接调用 SkuMapper 中已有的方法
        List<Sku> lowStockSkus = skuMapper.findLowStockSkus();
        return Result.success("查询成功", lowStockSkus);
    }
}