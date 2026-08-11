package com.food.freshfood.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.food.freshfood.entity.CartItem;
import com.food.freshfood.mapper.CartItemMapper;
import com.food.freshfood.service.CartItemService;
import com.food.freshfood.vo.CartItemVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;


@Service
public class CartItemServiceImpl extends ServiceImpl<CartItemMapper, CartItem> implements CartItemService {
    @Autowired
    private CartItemMapper cartItemMapper;
    @Override
    public List<CartItemVO> listCartByUserId(Long userId){
        return cartItemMapper.selectCartWithProduct(userId);
    }
    @Override
    public boolean addCart(Long userId, Long skuId, Long spuId, Integer quantity){
        QueryWrapper<CartItem> wrapper=new QueryWrapper<CartItem>();
        wrapper.eq("user_id",userId)
                .eq("sku_id",skuId);
        CartItem oldItem = baseMapper.selectOne(wrapper);
        if(oldItem!=null){
            oldItem.setQuantity(oldItem.getQuantity()+quantity);
            return baseMapper.updateById(oldItem) > 0;
        }
        else {
            CartItem cartItem = new CartItem();
            cartItem.setUserId(userId);
            cartItem.setSkuId(skuId);
            cartItem.setSpuId(spuId);
            cartItem.setQuantity(quantity);
            cartItem.setCreateTime(LocalDateTime.now());
            cartItem.setUpdateTime(LocalDateTime.now());
            return baseMapper.insert(cartItem) > 0;
        }

    }

    @Override
    public boolean updateCartQuantity(Long id, Integer quantity){
        CartItem oldItem = baseMapper.selectById(id);
        // 校验购物车记录是否存在
        if (oldItem == null){
            return false;
        }
        oldItem.setQuantity(oldItem.getQuantity() + quantity);
        oldItem.setUpdateTime(LocalDateTime.now());
        return baseMapper.updateById(oldItem) > 0;


    }


    @Override
    public boolean deleteCartItem(Long id){
        return baseMapper.deleteById(id)>0;

    }

}

