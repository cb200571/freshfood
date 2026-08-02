package com.food.freshfood.vo;
//它就是后端给前端的 “数据专用快递盒”，里面只放前端页面需要的字段，不把数据库里的所有字段都塞过去。
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SpuDetailVO {

    // ========== SPU 基础字段 ==========
    private Long id;
    private String name;
    private Long categoryId;
    private String categoryName;
    private String brand;
    private String description;
    private String mainImage;
    private String detailImages;
    private Integer isColdChain;
    private Integer shelfLife;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // ========== SKU 价格区间 ==========
    private BigDecimal minPrice;
    private BigDecimal maxPrice;

    // ========== SKU 列表 ==========
    private List<SkuVO> skuList;

    @Data
    public static class SkuVO {
        private Long id;
        private String skuName;
        private String skuCode;
        private BigDecimal price;
        private BigDecimal originalPrice;
        private Integer stock;
        private Integer warningStock;
        private Integer isBulkWeight;
        private String priceUnit;
        private String weightDesc;
        private String specJson;
        private String image;
    }
}
