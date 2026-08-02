package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.dto.CreateOrderDTO;
import com.food.freshfood.entity.OrderInfo;
import com.food.freshfood.entity.OrderItem;
import com.food.freshfood.entity.Coupon;
import com.food.freshfood.entity.CouponUser;
import com.food.freshfood.entity.SeckillActivity;
import com.food.freshfood.entity.SeckillOrder;
import com.food.freshfood.mapper.CouponMapper;
import com.food.freshfood.mapper.CouponUserMapper;
import com.food.freshfood.mapper.SeckillActivityMapper;
import com.food.freshfood.mapper.SeckillOrderMapper;
import com.food.freshfood.mapper.OrderInfoMapper;
import com.food.freshfood.mapper.OrderItemMapper;
import com.food.freshfood.mapper.SkuMapper;
import com.food.freshfood.service.OrderService;
import com.food.freshfood.service.SeckillStockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;
import org.springframework.data.redis.core.StringRedisTemplate;
@Service
public class OrderServiceImpl extends ServiceImpl<OrderInfoMapper, OrderInfo> implements OrderService {


    @Autowired
    private OrderItemMapper orderItemMapper;


    @Autowired
    private SkuMapper skuMapper;

    @Autowired
    private CouponUserMapper couponUserMapper;

    @Autowired
    private CouponMapper couponMapper;

    @Autowired
    private SeckillActivityMapper seckillActivityMapper;

    @Autowired
    private SeckillOrderMapper seckillOrderMapper;


    @Override
    @Transactional
    public OrderInfo createOrder(CreateOrderDTO dto) {
            // 1. 生成订单号
            String orderNo = generateOrderNo();

            // 2. 计算总金额
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (CreateOrderDTO.OrderItemDTO item : dto.getItems()) {
                BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
                totalAmount = totalAmount.add(itemTotal);
            }

            // 3. 处理秒杀
            if (dto.getSeckillActivityId() != null) {



                SeckillActivity activity = seckillActivityMapper.selectById(dto.getSeckillActivityId());
                LocalDateTime now = LocalDateTime.now();
                if (activity == null || activity.getStatus() != 1
                        || now.isBefore(activity.getStartTime()) || now.isAfter(activity.getEndTime())) {
                    throw new RuntimeException("秒杀活动不存在或已结束");
                }
                // 每人限购一件
                QueryWrapper<SeckillOrder> checkWrapper = new QueryWrapper<>();
                checkWrapper.eq("activity_id", dto.getSeckillActivityId()).eq("user_id", dto.getUserId());
                int count = seckillOrderMapper.selectCount(checkWrapper);
                if (count > 0) {
                    throw new RuntimeException("您已参与过该秒杀活动");
                }

            }

            // 4. 计算优惠
            BigDecimal discount = BigDecimal.ZERO;
            if (dto.getCouponUserId() != null) {
                CouponUser cu = couponUserMapper.selectById(dto.getCouponUserId());
                if (cu != null && cu.getStatus() == 0) {
                    Coupon coupon = couponMapper.selectById(cu.getCouponId());
                    if (coupon != null) {
                        if (totalAmount.compareTo(coupon.getMinSpend()) >= 0) {
                            if (coupon.getType() == 1) {
                                discount = coupon.getAmount();
                            } else if (coupon.getType() == 2) {
                                discount = totalAmount.multiply(new BigDecimal("1").subtract(coupon.getAmount()));
                            }
                            // 使用优惠券：标记已用
                            cu.setStatus(1);
                            cu.setOrderNo(orderNo);
                            couponUserMapper.updateById(cu);
                        }
                    }
                }
            }

            // 5. 创建订单
            OrderInfo order = new OrderInfo();
            order.setOrderNo(orderNo);
            order.setUserId(dto.getUserId());
            order.setTotalAmount(totalAmount);
            order.setPayAmount(totalAmount.subtract(discount).compareTo(BigDecimal.ZERO) > 0 ? totalAmount.subtract(discount) : BigDecimal.ZERO);
            order.setFreightAmount(BigDecimal.ZERO);
            order.setStatus(0);  // 待付款
            order.setReceiverName(dto.getReceiverName());
            order.setReceiverPhone(dto.getReceiverPhone());
            order.setReceiverAddress(dto.getReceiverAddress());
            baseMapper.insert(order);

            // 6. 创建秒杀订单记录
            if (dto.getSeckillActivityId() != null) {
                SeckillOrder seckillOrder = new SeckillOrder();
                seckillOrder.setActivityId(dto.getSeckillActivityId());
                seckillOrder.setUserId(dto.getUserId());
                seckillOrder.setSkuId(dto.getItems().get(0).getSkuId());
                seckillOrder.setOrderNo(orderNo);
                seckillOrder.setSeckillPrice(dto.getItems().get(0).getPrice());
                seckillOrder.setStatus(0);
                seckillOrder.setCreateTime(LocalDateTime.now());
                seckillOrderMapper.insert(seckillOrder);
            }

            // 7. 创建订单详情
            for (CreateOrderDTO.OrderItemDTO item : dto.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(order.getId());
                orderItem.setOrderNo(orderNo);
                orderItem.setSpuId(item.getSpuId());
                orderItem.setSkuId(item.getSkuId());
                orderItem.setProductName(item.getProductName());
                orderItem.setSkuName(item.getSkuName());
                orderItem.setProductImage(item.getProductImage());
                orderItem.setPrice(item.getPrice());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setTotalAmount(item.getPrice().multiply(new BigDecimal(item.getQuantity())));
                orderItemMapper.insert(orderItem);

                // 8. 扣减库存
                boolean success = decreaseStock(item.getSkuId(), item.getQuantity());
                if (!success) {
                    throw new RuntimeException("库存不足");
                }
            }

            return order;
        }

        @Override
        public List<OrderInfo> getUserOrders(Long userId) {
            QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
            wrapper.eq("user_id", userId)
                    .orderByDesc("create_time");
            return baseMapper.selectList(wrapper);
        }

        @Override
        public OrderInfo getOrderDetail(String orderNo) {
            QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
            wrapper.eq("order_no", orderNo);
            return baseMapper.selectOne(wrapper);
        }

        @Override
        public boolean payOrder(String orderNo) {
            QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
            wrapper.eq("order_no", orderNo);
            OrderInfo order = baseMapper.selectOne(wrapper);

            if (order == null || order.getStatus() != 0) {
                return false;
            }

            order.setStatus(1);  // 已付款
            order.setPayTime(LocalDateTime.now());
            return baseMapper.updateById(order) > 0;
        }

        @Override
        public boolean cancelOrder(String orderNo) {
            QueryWrapper<OrderInfo> wrapper = new QueryWrapper<>();
            wrapper.eq("order_no", orderNo);
            OrderInfo order = baseMapper.selectOne(wrapper);

            if (order == null || order.getStatus() != 0) {
                return false;
            }

            order.setStatus(4);  // 已取消
            return baseMapper.updateById(order) > 0;
        }

        private boolean decreaseStock(Long skuId, Integer quantity) {
            // 调用 SkuMapper 的原子扣减方法：UPDATE sku SET stock = stock - #{quantity} WHERE id = #{skuId} AND stock >= #{quantity}
            // 原来是空实现直接 return true，库存扣减根本没生效，现已修复
            return skuMapper.decreaseStock(skuId, quantity) > 0;
        }

        // 原子计数器，保证同一毫秒内订单号不重复
        private static final AtomicInteger ORDER_SEQ = new AtomicInteger(0);

        private String generateOrderNo() {
            // 生成订单号：时间戳(毫秒) + 原子递增序号(取后6位) + 随机数(防猜测)
            String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
            String seq = String.format("%03d", ORDER_SEQ.incrementAndGet() % 1000);
            String random = String.format("%04d", ThreadLocalRandom.current().nextInt(10000));
            return time + seq + random;
        }
    }





