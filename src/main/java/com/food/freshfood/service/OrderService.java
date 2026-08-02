package com.food.freshfood.service;

import com.food.freshfood.dto.CreateOrderDTO;
import com.food.freshfood.entity.OrderInfo;

import java.util.List;

public interface OrderService {
    // 创建订单
    OrderInfo createOrder(CreateOrderDTO dto);

    // 获取用户订单列表
    List<OrderInfo> getUserOrders(Long userId);

    // 获取订单详情
    OrderInfo getOrderDetail(String orderNo);

    // 支付订单
    boolean payOrder(String orderNo);

    // 取消订单
    boolean cancelOrder(String orderNo);

}
