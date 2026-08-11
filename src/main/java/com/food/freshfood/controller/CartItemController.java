package com.food.freshfood.controller;

import com.food.freshfood.Result;
import com.food.freshfood.entity.CartItem;
import com.food.freshfood.service.CartItemService;
import com.food.freshfood.vo.CartItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cart")
public class CartItemController {
    @Autowired
    private CartItemService cartItemService;

    // 查询用户购物车（联表带出商品信息）
    @GetMapping("/list")
    public Result<List<CartItemVO>> getUserCart(@RequestParam Long userId) {
        List<CartItemVO> cartItems = cartItemService.listCartByUserId(userId);
        return Result.success("查询成功", cartItems);
    }

    // 添加购物车：同用户同SKU存在则加数量，否则新增
    @PostMapping("/add")
    public Result<CartItem> addUserCart(@RequestBody CartItem cartItem) {
        boolean success = cartItemService.addCart(
                cartItem.getUserId(),
                cartItem.getSkuId(),
                cartItem.getSpuId(),
                cartItem.getQuantity()
        );
        if (success) {
            return Result.success("添加购物车成功", cartItem);
        } else {
            return Result.error(500, "添加购物车失败");
        }
    }

    // 修改数量：body 传 id + quantity（quantity 为增加的数量，可为负）
    @PutMapping("/update")
    public Result<CartItem> updateUserCart(@RequestBody CartItem cartItem) {
        boolean success = cartItemService.updateCartQuantity(
                cartItem.getId(),
                cartItem.getQuantity()
        );
        if (success) {
            return Result.success("修改成功", cartItem);
        } else {
            return Result.error(500, "修改失败");
        }
    }

    // 删除购物车项
    @DeleteMapping("/delete")
    public Result<String> deleteUserCart(@RequestParam Long id) {
        boolean success = cartItemService.deleteCartItem(id);
        if (success) {
            return Result.success("删除成功");
        } else {
            return Result.error(500, "删除失败");
        }
    }
}
