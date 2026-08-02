//用于新增/编辑商品时接收前端数据


package com.food.freshfood.dto;

import lombok.Data;

import javax.validation.Valid;
import javax.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;
@Valid
@Data
public class SpuDTO {
    private Long id;//新增时为 null，编辑时传 id，复用同一个 DTO

    @NotBlank(message="商品名称不能为空")
    private String name;

    @NotNull(message="请选择商品分类")
    private Long categoryId;

    private String brand;
    private String description;
    private String mainImage;
    private String detailImages;

    @NotNull(message = "请选择是否需要冷链配送")
    @Min(value = 0, message = "请选择：0-不需要冷链 1-需要冷链")
    @Max(value = 1, message = "请选择：0-不需要冷链 1-需要冷链")
    private Integer isColdChain;

    @Min(value = 0, message = "保质期不能为负数，如果是永久商品请填0")
    private Integer shelfLife;


    @NotNull(message = "请选择上架状态")
    @Min(value = 0, message = "请选择：0-下架 1-上架")
    @Max(value = 1, message = "请选择：0-下架 1-上架")
    private Integer status;
    @Valid
    private List<SkuItem> skuList;//一次请求同时传 SPU 信息 + 多个 SKU，方便一次性新增/编辑
/*
// 非静态内部类（需要外部类实例）
SpuDTO spu = new SpuDTO();SpuDTO.SkuItem sku = spu.new SkuItem();
// 静态内部类（可以直接创建）
SpuDTO.SkuItem sku2 = new SpuDTO.SkuItem();
*/
    @Data
    public static class SkuItem {//无spuId,因为 skuList 已经在 SpuDTO 内部了，spuId 由后端从父级 Spu 的 id 自动注入：
    private Long id;

    @NotBlank(message = "SKU名称不能为空")
    private String skuName;


    private String skuCode;

    @NotNull(message = "价格不能为空")
    @DecimalMin(value = "0.01", message = "价格必须大于0")
    private BigDecimal price;//BigDecimal 就是 Java 里专门存「钱、价格、金额、高精度小数」的类型,
//@DecimalMin特别适合小数 / 金额 / 超大数值场景


    @NotNull(message = "原价不能为空")
    @DecimalMin(value = "0.01", message = "原价必须大于0")
    private BigDecimal originalPrice;

    @NotNull(message = "库存不能为空")
    @Min(value = 0, message = "库存不能为负数")
    private Integer stock;

    @Min(value = 0, message = "预警库存不能为负数")
    private Integer warningStock;

    @Min(value = 0, message = "称重标识只能为0或1")
    @Max(value = 1, message = "称重标识只能为0或1")
    private Integer isBulkWeight;

    private String priceUnit;
    private String weightDesc;
    private String specJson;
    private String image;

}
}
