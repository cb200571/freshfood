//商品分类

package com.food.freshfood.entity;
import java.time.LocalDateTime;
import lombok.Data;
import javax.validation.constraints.*;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@Data
@TableName("category")//表明映射注解
public class Category {
    @TableId(type=IdType.AUTO)
    private Long id;
    private String name;
    private Long parentId;//父类
    private Integer level;//层级
    private String icon;     // 分类图标 URL
    private Integer sort;    // 排序权重
    private Integer status;  // 1=启用 0=禁用
    private LocalDateTime createTime;









}

