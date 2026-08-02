//最小库存单元：代表的是“一件具体的实物”，侧重于后台的库存管理和销售履约
package com.food.freshfood.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("sku")
public class Sku {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long spuId;//SKU 和 SPU 之间的外键关联。比如"云南草莓 250g"这个 SKU，它的 spuId 指向"云南草莓"这个 SPU 的 id。跟sku表相关联

    private String skuName;
    private String skuCode;
    private BigDecimal price;//售价
    private BigDecimal originalPrice;

    private Integer stock;// 当前库存
    private Integer warningStock; // 库存预警值（低于此值触发补货提醒）


    private Integer isBulkWeight;// 散装称重：1=是（按重量计价）  0=否（按件）
    private String priceUnit; // 计价单位：件 / 斤 / kg / g
    private String weightDesc; // 规格描述，如"500g"、"约1斤"
    private String specJson;// 规格参数 JSON，如 {"规格":"500g","包装":"礼盒"}

    private String image;//图片URL


    private Integer status; // 状态：1=启用 0=禁用

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
