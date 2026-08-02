package com.food.freshfood.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.Category;
import org.apache.ibatis.annotations.Mapper;
import com.food.freshfood.entity.Category;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface CategoryMapper extends BaseMapper<Category> {
    @Select("select * from category where parent_id=0 and status=1 order by sort ASC")
    List<Category>  findTopCategories();//查询所有顶级分类
    @Select("SELECT * FROM category WHERE parent_id = #{parentId} AND status = 1 ORDER BY sort ASC")
    List<Category> findByParentId(Long parentId);//根据父ID查下一级分类







}
