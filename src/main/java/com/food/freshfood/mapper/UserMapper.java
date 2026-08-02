package com.food.freshfood.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.food.freshfood.entity.User;
import org.apache.ibatis.annotations.Insert;//MyBatis 的注解
import org.apache.ibatis.annotations.Mapper;//MyBatis 的注解
import org.apache.ibatis.annotations.Select;//MyBatis 的注解
//告诉 Spring：这是 MyBatis 的 Mapper 接口（操作数据库的）
@Mapper
public interface UserMapper extends BaseMapper<User> {
    /*BaseMapper<User>这是 MyBatis-Plus 的核心接口，你只要继承它，不用写 XML、不用写 SQL，直接拥有全套增删改查！
    selectById（根据 ID 查）
    selectList（条件查询）
    insert（新增）
    updateById（根据 ID 修改）
    deleteById（根据 ID 删除）
    delete（条件删除）
    */
    // 根据用户名查询用户（用于注册时检查用户名是否已存在）,这个方法BaseMapper没有自定义

    @Select("select * from user where username = #{username}")
    User findByUsername(String username);
/*    @Select：标注在方法上方，专属绑定紧邻的这一个方法，这个 SQL 只属于findByUsername。
    findByUsername(String username)：
    String username：传入用户名，自动填充到 SQL 里#{username}
    User：数据库查到数据，自动封装成 User 实体类返回；查不到返回 null

 */
    //验证手机号是否已经被注册
    @Select("select * from user where phone = #{phone}")
    User findByPhone(String phone);


    /* 插入新用户（注册）
    @Insert("insert into user (username, password, email, phone, create_time)"+"values (#{username}, #{password}, #{email}, #{phone}, NOW())")
    int insert(User user);//成功插入 → 返回1,失败0    BaseMapper已经内置
    */


}
