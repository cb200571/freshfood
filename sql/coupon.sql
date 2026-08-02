-- 优惠券表
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '优惠券名称',
  `type` INT NOT NULL DEFAULT 1 COMMENT '类型：1=满减 2=折扣',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '优惠金额或折扣比例',
  `min_spend` DECIMAL(10,2) DEFAULT 0 COMMENT '最低消费金额',
  `start_time` DATETIME COMMENT '有效期开始',
  `end_time` DATETIME COMMENT '有效期结束',
  `total` INT NOT NULL DEFAULT 0 COMMENT '发放总量',
  `used` INT NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券表';

-- 用户优惠券关联表
CREATE TABLE IF NOT EXISTS `coupon_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `coupon_id` BIGINT NOT NULL COMMENT '优惠券ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `order_no` VARCHAR(50) DEFAULT NULL COMMENT '使用的订单号',
  `status` INT NOT NULL DEFAULT 0 COMMENT '状态：0=未使用 1=已使用 2=已过期',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';
