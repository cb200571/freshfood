//标准化产品单元
package com.food.freshfood.entity;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("spu")
public class Spu {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;      // 商品名称
    private Long categoryId;  // 属于哪个二级分类的 id
    private String brand;    // 产地或品牌
    private String description;    // 商品描述
    private String mainImage;      // 主图 URL
    private String detailImages;   // 商品详情图（多图，逗号分隔 或 JSON 数组）


    private Integer isColdChain;   // 冷链标识：1=需要冷链 0=常温

    private Integer shelfLife;     // 保质期（天），0=不限
    private Integer status;         // 1=上架 0=下架

    private LocalDateTime createTime;

    private LocalDateTime updateTime;//时间由后端 LocalDateTime.now() 自动填，前端不传









}
