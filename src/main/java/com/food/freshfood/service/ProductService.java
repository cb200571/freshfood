package com.food.freshfood.service;

import com.food.freshfood.dto.SkuDTO;
import com.food.freshfood.dto.SpuDTO;
import com.food.freshfood.entity.Category;
import com.food.freshfood.entity.Sku;
import com.food.freshfood.entity.Spu;
import com.food.freshfood.vo.SpuDetailVO;

import java.util.List;

public interface ProductService {

    // ========== 分类 ==========
    List<Category> getTopCategories();
    List<Category> getSubCategories(Long parentId);

    // ========== SPU ==========
    List<Spu> listByCategory(Long categoryId);
    List<Spu> listByParentCategory(Long parentId);
    List<Spu> search(String keyword);
    SpuDetailVO getDetail(Long spuId);

    // ========== SPU 新增/编辑 ==========
    Long saveSpu(SpuDTO dto);
    boolean updateSpu(SpuDTO dto);
    boolean updateSku(Sku sku);
    boolean updateSpuStatus(Long spuId, Integer status);

    // ========== SKU 库存 ==========
    List<Sku> getSkusBySpuId(Long spuId);
    boolean decreaseStock(Long skuId, Integer quantity);
    List<Sku> getLowStockSkus();
    boolean updateSkuStock(Long skuId, Integer stock);

    // ========== 商户端 ==========
    List<Spu> listAll();
    boolean existsByName(String name);
}
