package com.food.freshfood.service;

import com.food.freshfood.entity.CartItem;
import com.food.freshfood.vo.CartItemVO;
import org.springframework.stereotype.Service;
import java.util.List;
@Service
public interface CartItemService {
    List<CartItemVO> listCartByUserId(Long userId);
    // 加购：同用户同SKU存在则加数量，否则新增
    boolean addCart(Long userId, Long skuId, Long spuId, Integer quantity);

    // 改数量
    boolean updateCartQuantity(Long id, Integer quantity);

    // 删除一项·
    boolean deleteCartItem(Long id);


}
