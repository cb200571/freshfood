package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.Spu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface SpuMapper extends BaseMapper<Spu> {

    /**
     * 根据分类ID查询该分类下所有上架商品
     */
    @Select("SELECT * FROM spu WHERE category_id = #{categoryId} AND status = 1")
    List<Spu> findByCategoryId(Long categoryId);

    /**
     * 关键词搜索：匹配商品名、品牌、描述
     */
    @Select("SELECT * FROM spu WHERE status = 1 " +
            "AND (name LIKE CONCAT('%', #{keyword}, '%') " +
            "OR brand LIKE CONCAT('%', #{keyword}, '%') " +
            "OR description LIKE CONCAT('%', #{keyword}, '%'))")
    List<Spu> searchByKeyword(String keyword);

    /**
     * 根据父分类ID查询下属所有上架商品（联表分类表）
     */
    @Select("SELECT s.* FROM spu s " +
            "INNER JOIN category c ON s.category_id = c.id " +
            "WHERE c.parent_id = #{parentId} AND s.status = 1")
    List<Spu> findByParentCategoryId(@Param("parentId") Long parentId);

    /**
     * 商户端：查询全部商品（不筛选状态，按创建时间倒序）
     */
    @Select("SELECT * FROM spu ORDER BY create_time DESC")
    List<Spu> findAll();


    @Select("SELECT * FROM spu WHERE name LIKE CONCAT('%', #{name}, '%') LIMIT 1")
    List<Spu> findByName(@Param("name") String name);
}