package com.food.freshfood.controller;

import com.food.freshfood.Result;
import com.food.freshfood.entity.SeckillActivity;
import com.food.freshfood.service.SeckillService;
import com.food.freshfood.vo.SeckillVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/seckill")
public class SeckillController {

    @Autowired
    private SeckillService seckillService;

    @PostMapping("/create")
    public Result<Long> createActivity(@RequestBody SeckillActivity activity) {
        Long id = seckillService.createActivity(activity);
        return Result.success("创建成功", id);
    }

    @GetMapping("/list")
    public Result<List<SeckillVO>> listAll() {
        List<SeckillVO> list = seckillService.listAll();
        return Result.success("查询成功", list);
    }

    @PutMapping("/status/{id}")
    public Result<String> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        boolean ok = seckillService.updateStatus(id, status);
        return ok ? Result.success("更新成功") : Result.error("更新失败");
    }

    @GetMapping("/active")
    public Result<List<SeckillVO>> getActiveActivities() {
        List<SeckillVO> list = seckillService.getActiveActivities();
        return Result.success("查询成功", list);
    }

    // 重置秒杀活动（压测专用：清空订单、恢复库存）
    @PostMapping("/reset")
    public Result<String> resetActivity(@RequestParam Long activityId) {
        boolean ok = seckillService.resetActivity(activityId);
        return ok ? Result.success("重置成功") : Result.error("重置失败");
    }

}
