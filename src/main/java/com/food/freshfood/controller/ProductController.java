package com.food.freshfood.controller;

import com.food.freshfood.Result;
import com.food.freshfood.dto.SkuDTO;
import com.food.freshfood.dto.SpuDTO;
import com.food.freshfood.entity.Sku;
import com.food.freshfood.entity.Spu;
import com.food.freshfood.service.ProductService;
import com.food.freshfood.vo.SpuDetailVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    // ==================== 分类查询 ====================

    @GetMapping("/category/{categoryId}")
    public Result<List<Spu>> listByCategory(@PathVariable Long categoryId) {
        List<Spu> list = productService.listByCategory(categoryId);
        return Result.success("查询成功", list);
    }

    @GetMapping("/parent-category/{parentId}")
    public Result<List<Spu>> listByParentCategory(@PathVariable Long parentId) {
        List<Spu> list = productService.listByParentCategory(parentId);
        return Result.success("查询成功", list);
    }

    // ==================== 搜索 ====================

    @GetMapping("/search")
    public Result<List<Spu>> search(@RequestParam String keyword) {
        List<Spu> list = productService.search(keyword);
        return Result.success("查询成功", list);
    }

    // ==================== 商品详情 ====================

    @GetMapping("/detail/{spuId}")
    public Result<SpuDetailVO> getDetail(@PathVariable Long spuId) {
        SpuDetailVO vo = productService.getDetail(spuId);
        if (vo == null) {
            return Result.error(404, "商品不存在");
        }
        return Result.success("查询成功", vo);
    }

    // ==================== 商户端：查询所有商品 ====================
    // 恢复成全量返回 List，兼容前端下拉框、单条回显、批量选择等老逻辑
    @GetMapping("/list")
    public Result<List<Spu>> listAll() {
        return Result.success("查询成功", productService.listAll());
    }

    // ==================== 商品新增/编辑 ====================
    @GetMapping("/check-name")
    public Result<Boolean> checkName(@RequestParam String name) {
        boolean exists = productService.existsByName(name);
        return Result.success("查询成功", exists);
    }
    @PostMapping("/save")
    public Result<Long> saveSpu(@RequestBody SpuDTO dto) {
        Long id = productService.saveSpu(dto);
        return Result.success("新增成功", id);
    }

    @PutMapping("/update")
    public Result<String> updateSpu(@RequestBody SpuDTO dto) {
        boolean ok = productService.updateSpu(dto);
        return ok ? Result.success("更新成功") : Result.error("更新失败");
    }
    @PutMapping("/update/sku")
    public Result<String> updateSku(@RequestBody Sku sku) {
        boolean ok = productService.updateSku(sku);
        return ok ? Result.success("更新成功") : Result.error("更新失败");
    }


    @PutMapping("/status/{spuId}")
    public Result<String> updateStatus(@PathVariable Long spuId, @RequestParam Integer status) {
        boolean ok = productService.updateSpuStatus(spuId, status);
        return ok ? Result.success("状态更新成功") : Result.error("状态更新失败");
    }

    // ==================== SKU 库存 ====================

    @GetMapping("/skus/{spuId}")
    public Result<List<Sku>> getSkus(@PathVariable Long spuId) {
        List<Sku> list = productService.getSkusBySpuId(spuId);
        return Result.success("查询成功", list);
    }

    @PostMapping("/stock/decrease")
    public Result<String> decreaseStock(@RequestBody SkuDTO dto) {
        boolean ok = productService.decreaseStock(dto.getSkuId(), dto.getQuantity());
        return ok ? Result.success("扣库存成功") : Result.error("库存不足");
    }

    @PutMapping("/stock/{skuId}")
    public Result<String> updateStock(@PathVariable Long skuId, @RequestParam Integer stock) {
        boolean ok = productService.updateSkuStock(skuId, stock);
        return ok ? Result.success("库存更新成功") : Result.error("库存更新失败");
    }

    @GetMapping("/low-stock")
    public Result<List<Sku>> getLowStockSkus() {
        List<Sku> list = productService.getLowStockSkus();
        return Result.success("查询成功", list);
    }
}
