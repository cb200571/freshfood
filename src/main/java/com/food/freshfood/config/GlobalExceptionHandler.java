package com.food.freshfood.config;

import com.food.freshfood.Result;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    public Result<String> handleException(Exception e) {
        e.printStackTrace();  // 打印详细错误到控制台
        return Result.error(500, "服务器错误: " + e.getMessage());
    }
}
