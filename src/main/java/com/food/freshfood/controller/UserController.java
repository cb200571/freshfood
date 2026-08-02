package com.food.freshfood.controller;
import  com.food.freshfood.dto.RegisterDTO;
import  com.food.freshfood.dto.LoginDTO;
import  com.food.freshfood.vo.LoginResultVO;
import  com.food.freshfood.dto.SendCodeDTO;
import  com.food.freshfood.entity.User;
import org.springframework.validation.annotation.Validated;
import  com.food.freshfood.service.UserService;
import  com.food.freshfood.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.validation.BindingResult;
import javax.validation.Valid;
import com.food.freshfood.Result;



@RestController
@RequestMapping("/api/user")//给所有用户接口统一加一个地址前缀
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private UserMapper userMapper;
    // 检查用户名是否已存在


    @PostMapping("/register")//接收 POST 请求，路径是 /api/user/register
    public Result<String> register(@Valid @RequestBody RegisterDTO registerDTO,BindingResult bindingResult) {//@RequestBody：把前端传来的http请求体里的 JSON 自动转成 RegisterDTO 对象
        //@Valid
        //作用：对紧跟其后的对象（registerDTO）内部的属性进行合法性校验。它需要配合在 RegisterDTO 类字段上定义的约束注解
        //如果校验不通过
        if (bindingResult.hasErrors()) {
            String errorMsg = bindingResult.getFieldError().getDefaultMessage();//拿到我写的提示语！
            return Result.error(400, "参数错误：" + errorMsg);
        }
        User user=new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(registerDTO.getPassword());
        user.setPhone(registerDTO.getPhone());
        user.setEmail(registerDTO.getEmail());


        boolean success = userService.register(user);
        if (success) {
            return Result.success("注册成功");
        } else {
            return Result.error(409, "用户名或手机号已存在");
        }


    }
    // ========== 新增：发送验证码 ==========
    @PostMapping("/sendCode")
    public Result<String> sendCode(@Valid @RequestBody SendCodeDTO sendCodeDTO) {
        // 检查手机号是否已注册
        User existUser = userMapper.findByPhone(sendCodeDTO.getPhone());
        if (existUser == null) {
            return Result.error(404, "该手机号未注册");
        }

        boolean success = userService.sendLoginCode(sendCodeDTO.getPhone());
        if (success) {
            return Result.success("验证码已发送");
        } else {
            return Result.error("验证码发送失败");
        }
    }

    // ========== 新增：统一登录入口（两种方式） ==========
    @PostMapping("/login")
    public Result<LoginResultVO> login(@Validated @RequestBody LoginDTO loginDTO) {

        if (loginDTO.isPasswordLogin()) {
            // === 路径A：账号密码登录 ===
            return loginByUsernameAndPassword(loginDTO);
        } else {
            // === 路径B：手机验证码登录 ===
            return loginByPhoneAndCode(loginDTO);
        }
    }

    /**
     * 账号密码登录
     */
    private Result<LoginResultVO> loginByUsernameAndPassword(LoginDTO dto) {
        // 1. 查用户
        User user = userMapper.findByUsername(dto.getUsername().trim());
        if (user == null) {
            return Result.error(404, "用户不存在");
        }

        // 2. 校验密码
        if (!dto.getPassword().equals(user.getPassword())) {
            return Result.error(401, "密码错误");
        }

        // 3. 生成 Token（后面接入 JWT）
        String token = generateToken(user.getId(), user.getUsername());

        LoginResultVO result = new LoginResultVO();
        result.setUserId(user.getId());
        result.setToken(token);
        result.setUsername(user.getUsername());
        result.setPhone(user.getPhone());
        result.setRole(user.getRole());
        return Result.success("登录成功", result);
    }

    /**
     * 手机验证码登录
     */
    private Result<LoginResultVO> loginByPhoneAndCode(LoginDTO dto) {
        // 1. 查用户
        User user = userMapper.findByPhone(dto.getPhone());
        if (user == null) {
            return Result.error(404, "该手机号未注册");
        }

        // 2. 校验验证码
        boolean valid = userService.verifyCode(dto.getPhone(), dto.getCode());
        if (!valid) {
            return Result.error(401, "验证码错误或已过期");
        }

        // 3. 生成 Token
        String token = generateToken(user.getId(), user.getUsername());

        LoginResultVO result = new LoginResultVO();
        result.setUserId(user.getId());
        result.setToken(token);
        result.setUsername(user.getUsername());
        result.setPhone(user.getPhone());
        result.setRole(user.getRole());
        return Result.success("登录成功", result);
    }

    // ==================== 商户端接口 ====================

    // 商户端：获取所有用户列表
    @GetMapping("/admin/list")
    public Result<java.util.List<User>> getAllUsers() {
        java.util.List<User> users = userMapper.selectList(null);
        // 隐藏密码字段
        for (User u : users) {
            u.setPassword(null);
        }
        return Result.success("查询成功", users);
    }

    /**
     * 生成 Token（占位方法，后面接 JWT）
     */
    private String generateToken(Long userId, String username) {
        // TODO: 后面替换为 JWT 工具类
        return "mock_token_" + userId + "_" + System.currentTimeMillis();
    }

}
