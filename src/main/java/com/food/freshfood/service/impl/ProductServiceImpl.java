package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.dto.SpuDTO;
import com.food.freshfood.entity.Category;
import com.food.freshfood.entity.Sku;
import com.food.freshfood.entity.Spu;
import com.food.freshfood.mapper.CategoryMapper;
import com.food.freshfood.mapper.SkuMapper;
import com.food.freshfood.mapper.SpuMapper;
import com.food.freshfood.service.ProductService;
import com.food.freshfood.vo.SpuDetailVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl extends ServiceImpl<SpuMapper, Spu> implements ProductService {

    @Autowired
    private CategoryMapper categoryMapper;
    @Autowired
    private SpuMapper spuMapper;
    @Autowired
    private SkuMapper skuMapper;

    // ==================== 分类 ====================

    @Override
    public List<Category> getTopCategories() {
        return categoryMapper.findTopCategories();
    }

    @Override
    public List<Category> getSubCategories(Long parentId) {
        return categoryMapper.findByParentId(parentId);
    }

    // ==================== SPU 查询 ====================

    @Override
    public List<Spu> listByCategory(Long categoryId) {
        return spuMapper.findByCategoryId(categoryId);
    }

    @Override
    public List<Spu> listByParentCategory(Long parentId) {
        return spuMapper.findByParentCategoryId(parentId);
    }

    @Override
    public List<Spu> search(String keyword) {
        return spuMapper.searchByKeyword(keyword);
    }

    @Override
    public SpuDetailVO getDetail(Long spuId) {
        // 1. �?SPU
        Spu spu = spuMapper.selectById(spuId);
        if (spu == null) return null;

        // 2. �?SKU 列表
        List<Sku> skuList = skuMapper.findBySpuId(spuId);

        // 3. 查分类名
        Category category = categoryMapper.selectById(spu.getCategoryId());

        // 4. 组装 VO
        SpuDetailVO vo = new SpuDetailVO();
        BeanUtils.copyProperties(spu, vo);
        vo.setCategoryName(category != null ? category.getName() : "未知分类");

        // 5. 计算价格区间
        if (skuList != null && !skuList.isEmpty()) {
            BigDecimal min = skuList.stream()
                    .map(Sku::getPrice).min(BigDecimal::compareTo).orElse(BigDecimal.ZERO);
            BigDecimal max = skuList.stream()
                    .map(Sku::getPrice).max(BigDecimal::compareTo).orElse(BigDecimal.ZERO);
            vo.setMinPrice(min);
            vo.setMaxPrice(max);

            // 转换 SKU 列表
            vo.setSkuList(skuList.stream().map(sku -> {
                SpuDetailVO.SkuVO skuVO = new SpuDetailVO.SkuVO();
                BeanUtils.copyProperties(sku, skuVO);
                return skuVO;
            }).collect(Collectors.toList()));
        }

        return vo;
    }

    // ==================== SPU 新增/编辑 ====================
    @Override
    public boolean existsByName(String name) {
        List<Spu> list = spuMapper.findByName(name);
        return list != null && !list.isEmpty();
    }

    @Override
    @Transactional
    public Long saveSpu(SpuDTO dto) {
        // 0. 检查商品名是否已存在
        if (existsByName(dto.getName())) {
            throw new RuntimeException("商品名「" + dto.getName() + "」已存在");
        }
        // 1. 保存 SPU
        Spu spu = new Spu();
        BeanUtils.copyProperties(dto, spu);
        spu.setCreateTime(LocalDateTime.now());
        spu.setUpdateTime(LocalDateTime.now());
        spuMapper.insert(spu);

        // 2. 保存 SKU 列表
        if (dto.getSkuList() != null) {
            for (SpuDTO.SkuItem item : dto.getSkuList()) {
                Sku sku = new Sku();
                sku.setSpuId(spu.getId());
                BeanUtils.copyProperties(item, sku);
                sku.setCreateTime(LocalDateTime.now());
                sku.setUpdateTime(LocalDateTime.now());
                skuMapper.insert(sku);
            }
        }
        return spu.getId();
    }

    @Override
    @Transactional
    public boolean updateSpu(SpuDTO dto) {
        if (dto.getId() == null) return false;

        // 1. 更新 SPU
        Spu spu = new Spu();
        BeanUtils.copyProperties(dto, spu);
        spu.setUpdateTime(LocalDateTime.now());
        spuMapper.updateById(spu);

        // 2. 先删�?SKU，再插新�?
        if (dto.getSkuList() != null) {
            LambdaQueryWrapper<Sku> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Sku::getSpuId, dto.getId());
            skuMapper.delete(wrapper);

            for (SpuDTO.SkuItem item : dto.getSkuList()) {
                Sku sku = new Sku();
                sku.setSpuId(dto.getId());
                BeanUtils.copyProperties(item, sku);
                sku.setCreateTime(LocalDateTime.now());
                sku.setUpdateTime(LocalDateTime.now());
                skuMapper.insert(sku);
            }
        }
        return true;
    }
    @Override
    @Transactional
    public boolean updateSku(Sku sku) {
        if (sku.getId() == null) return false;
        Sku dbSku = skuMapper.selectById(sku.getId());
        dbSku.setPrice(sku.getPrice());
        dbSku.setOriginalPrice(sku.getOriginalPrice());
        dbSku.setStock(sku.getStock());
        dbSku.setWarningStock(sku.getWarningStock());
        dbSku.setUpdateTime(LocalDateTime.now());

        // 只更新sku表，全程不操作spu
        skuMapper.updateById(dbSku);
        return true;
    }

    @Override
    public boolean updateSpuStatus(Long spuId, Integer status) {
        Spu spu = new Spu();
        spu.setId(spuId);
        spu.setStatus(status);
        spu.setUpdateTime(LocalDateTime.now());
        return spuMapper.updateById(spu) > 0;
    }

    // ==================== SKU 库存 ====================

    @Override
    public List<Sku> getSkusBySpuId(Long spuId) {
        return skuMapper.findBySpuId(spuId);
    }

    @Override
    public boolean decreaseStock(Long skuId, Integer quantity) {
        return skuMapper.decreaseStock(skuId, quantity) > 0;
    }

    @Override
    public List<Sku> getLowStockSkus() {
        return skuMapper.findLowStockSkus();
    }


    @Override
    public List<Spu> listAll() {
        return spuMapper.findAll();
    }

    @Override
    public boolean updateSkuStock(Long skuId, Integer stock) {
        Sku sku = new Sku();
        sku.setId(skuId);
        sku.setStock(stock);
        sku.setUpdateTime(LocalDateTime.now());
        return skuMapper.updateById(sku) > 0;
    }

}
