CREATE TABLE IF NOT EXISTS `cart_item` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `sku_id` BIGINT NOT NULL COMMENT 'SKU ID',
    `spu_id` BIGINT NOT NULL COMMENT '商品ID',
    `quantity` INT NOT NULL DEFAULT 1 COMMENT '数量',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_sku` (`user_id`, `sku_id`),
    INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';
