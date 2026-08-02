package com.food.freshfood;
import lombok.Data;

@Data
public class Result<T> {
    //Result：真正的类名
    //<T>：泛型，只是用来兼容各种数据，不改变类名
    private int code;
    private String message;
    private T data;
    //static 核心作用：方法属于类，不属于对象，不用 new 对象就能调用
    public static <T> Result<T> success(String message){
        //第一个<T> = 先定义一个万能占位类型
        Result<T> result=new Result<>();
        result.setCode(200);
        result.setMessage(message);
        return result;

    }
    public static <T> Result<T> success(String message, T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage(message);
        result.setData(data);
        return result;
    }

    public static <T> Result<T> error(int code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        return result;
    }

    public static <T> Result<T> error(String message) {
        return error(500, message);
    }

}
