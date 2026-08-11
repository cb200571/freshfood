package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.CartItem;
import com.food.freshfood.vo.CartItemVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CartItemMapper extends BaseMapper<CartItem> {

    // 联表查询购物车：购物车表 JOIN 商品表(spu) JOIN 规格表(sku)
    // 带出商品名、SKU名、价格、图片
    @Select("SELECT c.id, c.user_id, c.sku_id, c.spu_id, c.quantity, " +
            "p.name AS name, " +
            "s.sku_name AS sku_name, " +
            "s.price AS price, " +
            "p.main_image AS image " +
            "FROM cart_item c " +
            "LEFT JOIN spu p ON c.spu_id = p.id " +
            "LEFT JOIN sku s ON c.sku_id = s.id " +
            "WHERE c.user_id = #{userId} " +
            "ORDER BY c.create_time DESC")
    List<CartItemVO> selectCartWithProduct(@Param("userId") Long userId);
}
