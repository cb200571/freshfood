package com.food.freshfood.controller;

import com.food.freshfood.Result;
import com.food.freshfood.entity.Category;
import com.food.freshfood.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private ProductService productService;

    @GetMapping("/top")
    public Result<List<Category>> getTopCategories() {
        List<Category> list = productService.getTopCategories();
        return Result.success("查询成功", list);
    }

    @GetMapping("/sub/{parentId}")
    public Result<List<Category>> getSubCategories(@PathVariable Long parentId) {
        List<Category> list = productService.getSubCategories(parentId);
        return Result.success("查询成功", list);
    }
}
