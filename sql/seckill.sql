-- 秒杀活动表
CREATE TABLE IF NOT EXISTS `seckill_activity` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `spu_id` BIGINT NOT NULL COMMENT '商品SPU ID',
  `sku_id` BIGINT NOT NULL COMMENT '商品SKU ID',
  `activity_name` VARCHAR(200) NOT NULL COMMENT '活动名称',
  `seckill_price` DECIMAL(10,2) NOT NULL COMMENT '秒杀价',
  `original_price` DECIMAL(10,2) NOT NULL COMMENT '原价',
  `stock` INT NOT NULL DEFAULT 0 COMMENT '秒杀库存',
  `sold_count` INT NOT NULL DEFAULT 0 COMMENT '已售数量',
  `start_time` DATETIME NOT NULL COMMENT '活动开始时间',
  `end_time` DATETIME NOT NULL COMMENT '活动结束时间',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态：0=未开始 1=进行中 2=已结束',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='秒杀活动表';

-- 秒杀订单表
CREATE TABLE IF NOT EXISTS `seckill_order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `activity_id` BIGINT NOT NULL COMMENT '秒杀活动ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `sku_id` BIGINT NOT NULL COMMENT 'SKU ID',
  `order_no` VARCHAR(50) NOT NULL COMMENT '订单号',
  `seckill_price` DECIMAL(10,2) NOT NULL COMMENT '秒杀价',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态：0=待付款 1=已付款 2=已取消',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='秒杀订单表';
