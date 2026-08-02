package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.Sku;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface  SkuMapper extends BaseMapper<Sku> {
    @Select("SELECT * FROM sku WHERE spu_id = #{spuId} AND status = 1")
    List<Sku> findBySpuId(Long spuId);//用户打开商品详情页时，查该商品下所有可售规格（status=1 才显示）
    @Update("UPDATE sku SET stock = stock - #{quantity} " +
            "WHERE id = #{skuId} AND stock >= #{quantity}")
    int decreaseStock(@Param("skuId") Long skuId, @Param("quantity") Integer quantity);//影响行数，返回 0 说明库存不足，返回 1 说明扣成功
    @Select("SELECT * FROM sku WHERE stock <= warning_stock AND status = 1")
    List<Sku> findLowStockSkus();//查所有"当前库存 ≤ 预警库存"的 SKU，给后台管理员补货提醒用

    @Update("UPDATE sku SET stock = #{stock} WHERE id = #{skuId}")
    int resetStock(@Param("skuId") Long skuId, @Param("stock") Integer stock);//压测重置用：恢复SKU库存




}
