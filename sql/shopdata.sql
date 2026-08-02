-- ============================================
-- 第一批商品数据：叶菜类、根茎类、茄果类、菌菇类、豆制品
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 叶菜类 (category_id=9) ====================

-- 菠菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('有机菠菜', 9, '阳光农场', '新鲜采摘有机菠菜，无农药残留，口感鲜嫩', 'https://img.alicdn.com/imgextra/i1/O1CN01菠菜.jpg', 1, 3, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '有机菠菜 250g', 'YC-BC-250G', 5.90, 7.90, 200, 20, 0, '件', '250g/袋', 1),
       (@spu1, '有机菠菜 500g', 'YC-BC-500G', 9.90, 13.90, 150, 15, 0, '件', '500g/袋', 1);

-- 生菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('罗马生菜', 9, '绿野蔬菜', '进口罗马生菜品种，脆嫩多汁，适合沙拉', 'https://img.alicdn.com/imgextra/i2/O1CN01生菜.jpg', 1, 3, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '罗马生菜 300g', 'YC-SC-300G', 4.50, 5.90, 180, 18, 0, '件', '300g/颗', 1),
       (@spu2, '罗马生菜 500g*2颗', 'YC-SC-500G2', 7.90, 10.90, 100, 10, 0, '件', '500g*2颗', 1);

-- 上海青
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('上海青小油菜', 9, '阳光农场', '嫩绿鲜甜上海青，纤维细腻，快炒即食', 'https://img.alicdn.com/imgextra/i3/O1CN01上海青.jpg', 1, 3, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '上海青 300g', 'YC-SHQ-300G', 3.90, 5.50, 200, 20, 0, '件', '300g/袋', 1);

-- 油麦菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('油麦菜', 9, '绿野蔬菜', '新鲜油麦菜，口感清脆，蒜蓉清炒最佳', 'https://img.alicdn.com/imgextra/i4/O1CN01油麦菜.jpg', 1, 3, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '油麦菜 250g', 'YC-YMC-250G', 3.50, 4.90, 180, 18, 0, '件', '250g/袋', 1);

-- 大白菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('山东大白菜', 9, '阳光农场', '山东产地直供，叶片紧实，炖煮鲜甜', 'https://img.alicdn.com/imgextra/i5/O1CN01大白菜.jpg', 0, 7, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '大白菜 1颗(约1.5kg)', 'YC-DBC-1.5KG', 4.90, 6.90, 150, 15, 0, '件', '约1.5kg/颗', 1);

-- 西兰花
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('有机西兰花', 9, '阳光农场', '新鲜有机西兰花，花蕾紧实，营养丰富', 'https://img.alicdn.com/imgextra/i6/O1CN01西兰花.jpg', 1, 5, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '西兰花 300g', 'YC-XLH-300G', 6.90, 8.90, 120, 12, 0, '件', '300g/颗', 1);

-- 空心菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('空心菜', 9, '绿野蔬菜', '夏季时令空心菜，茎脆叶嫩，清炒蒜香', 'https://img.alicdn.com/imgextra/i7/O1CN01空心菜.jpg', 1, 2, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '空心菜 250g', 'YC-KXC-250G', 3.90, 5.50, 150, 15, 0, '件', '250g/袋', 1);

-- 韭菜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新鲜韭菜', 9, '阳光农场', '头茬韭菜，香气浓郁，包饺子炒鸡蛋首选', 'https://img.alicdn.com/imgextra/i8/O1CN01韭菜.jpg', 1, 2, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '韭菜 250g', 'YC-JC-250G', 4.50, 5.90, 160, 16, 0, '件', '250g/袋', 1);


-- ==================== 根茎类 (category_id=10) ====================

-- 土豆
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('黄心土豆', 10, '黄土高原', '优质黄心土豆，粉糯香甜，适合炖煮炒', 'https://img.alicdn.com/imgextra/i1/O1CN01土豆.jpg', 0, 30, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '黄心土豆 1kg', 'GJ-TD-1KG', 3.90, 5.90, 300, 30, 0, '件', '1kg/袋', 1),
       (@spu9, '黄心土豆 2.5kg', 'GJ-TD-2.5KG', 8.90, 12.90, 150, 15, 0, '件', '2.5kg/袋', 1),
       (@spu9, '黄心土豆 5kg', 'GJ-TD-5KG', 15.90, 22.90, 80, 10, 0, '件', '5kg/箱', 1);

-- 胡萝卜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('水果胡萝卜', 10, '阳光农场', '迷你水果胡萝卜，脆甜可口，可生吃可烹饪', 'https://img.alicdn.com/imgextra/i2/O1CN01胡萝卜.jpg', 1, 7, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '水果胡萝卜 340g', 'GJ-HLB-340G', 8.90, 11.90, 120, 12, 0, '件', '340g/袋', 1);

-- 紫薯
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('小紫薯', 10, '薯香园', '粉糯香甜小紫薯，花青素丰富，蒸烤皆宜', 'https://img.alicdn.com/imgextra/i3/O1CN01紫薯.jpg', 0, 20, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '小紫薯 1kg', 'GJ-ZS-1KG', 7.90, 10.90, 100, 10, 0, '件', '1kg/袋', 1);

-- 莲藕
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('洪湖莲藕', 10, '湖鲜坊', '洪湖产地直供，藕节粗壮，煲汤粉糯', 'https://img.alicdn.com/imgextra/i4/O1CN01莲藕.jpg', 1, 7, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '莲藕 500g', 'GJ-LO-500G', 6.90, 9.90, 100, 10, 0, '件', '500g/份', 1);

-- 山药
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('铁棍山药', 10, '怀庆府', '河南焦作铁棍山药，粉糯细腻，滋补佳品', 'https://img.alicdn.com/imgextra/i5/O1CN01山药.jpg', 0, 15, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '铁棍山药 1kg', 'GJ-SY-1KG', 15.90, 19.90, 80, 10, 0, '件', '1kg/份', 1);

-- 洋葱
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('紫皮洋葱', 10, '阳光农场', '新鲜紫皮洋葱，辛辣提味，炒菜必备', 'https://img.alicdn.com/imgextra/i6/O1CN01洋葱.jpg', 0, 30, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '紫皮洋葱 500g', 'GJ-YC-500G', 3.50, 4.90, 200, 20, 0, '件', '500g/袋', 1);


-- ==================== 茄果类 (category_id=11) ====================

-- 西红柿
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('普罗旺斯西红柿', 11, '绿野蔬菜', '沙瓤多汁，自然成熟，番茄味浓郁', 'https://img.alicdn.com/imgextra/i1/O1CN01西红柿.jpg', 0, 5, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '普罗旺斯西红柿 500g', 'QG-FQ-500G', 6.90, 8.90, 180, 20, 0, '件', '500g/盒', 1),
       (@spu15, '普罗旺斯西红柿 1kg', 'QG-FQ-1KG', 11.90, 15.90, 100, 10, 0, '件', '1kg/盒', 1);

-- 黄瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('水果黄瓜', 11, '阳光农场', '迷你水果黄瓜，脆嫩无籽，清甜爽口', 'https://img.alicdn.com/imgextra/i2/O1CN01黄瓜.jpg', 1, 5, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '水果黄瓜 500g', 'QG-HG-500G', 5.90, 7.90, 150, 15, 0, '件', '500g/袋', 1);

-- 青椒
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('薄皮青椒', 11, '绿野蔬菜', '薄皮青椒，微辣提味，虎皮青椒首选', 'https://img.alicdn.com/imgextra/i3/O1CN01青椒.jpg', 1, 7, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '薄皮青椒 300g', 'QG-QJ-300G', 4.50, 5.90, 160, 16, 0, '件', '300g/袋', 1);

-- 茄子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('长茄子', 11, '阳光农场', '紫黑油亮长茄子，肉质细嫩，红烧清蒸皆宜', 'https://img.alicdn.com/imgextra/i4/O1CN01茄子.jpg', 1, 5, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '长茄子 500g', 'QG-QZ-500G', 4.90, 6.90, 140, 14, 0, '件', '500g/份', 1);

-- 冬瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('冬瓜', 11, '绿野蔬菜', '新鲜冬瓜，清热消暑，煲汤必备', 'https://img.alicdn.com/imgextra/i5/O1CN01冬瓜.jpg', 0, 15, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '冬瓜 约2kg', 'QG-DG-2KG', 5.90, 8.90, 80, 10, 1, '斤', '约2kg/份', 1);

-- 南瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('贝贝南瓜', 11, '阳光农场', '日本品种贝贝南瓜，粉糯香甜如板栗', 'https://img.alicdn.com/imgextra/i6/O1CN01南瓜.jpg', 0, 20, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '贝贝南瓜 1个(约500g)', 'QG-BBNG-500G', 9.90, 12.90, 100, 10, 0, '件', '约500g/个', 1);


-- ==================== 菌菇类 (category_id=12) ====================

-- 香菇
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜香菇', 12, '菌菇世家', '当日采摘新鲜香菇，肉质厚实，香气浓郁', 'https://img.alicdn.com/imgextra/i1/O1CN01香菇.jpg', 1, 5, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '鲜香菇 250g', 'JG-XG-250G', 7.90, 9.90, 100, 10, 0, '件', '250g/盒', 1),
       (@spu21, '鲜香菇 500g', 'JG-XG-500G', 13.90, 17.90, 60, 8, 0, '件', '500g/盒', 1);

-- 金针菇
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('金针菇', 12, '菌菇世家', '新鲜金针菇，口感爽滑，火锅烧烤必备', 'https://img.alicdn.com/imgextra/i2/O1CN01金针菇.jpg', 1, 5, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '金针菇 150g', 'JG-JZG-150G', 3.90, 5.50, 200, 20, 0, '件', '150g/袋', 1),
       (@spu22, '金针菇 300g', 'JG-JZG-300G', 6.90, 9.90, 120, 12, 0, '件', '300g/袋', 1);

-- 杏鲍菇
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('杏鲍菇', 12, '菌菇世家', '肥厚杏鲍菇，口感似鲍鱼，煎炒烤皆宜', 'https://img.alicdn.com/imgextra/i3/O1CN01杏鲍菇.jpg', 1, 7, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '杏鲍菇 200g', 'JG-XPG-200G', 5.90, 7.90, 120, 12, 0, '件', '200g/盒', 1);

-- 平菇
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新鲜平菇', 12, '绿野蔬菜', '鲜嫩平菇，价格实惠，家常小炒首选', 'https://img.alicdn.com/imgextra/i4/O1CN01平菇.jpg', 1, 3, 1);
SET @spu24 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu24, '平菇 250g', 'JG-PG-250G', 3.90, 5.50, 180, 18, 0, '件', '250g/袋', 1);

-- 海鲜菇
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('海鲜菇', 12, '菌菇世家', '蟹味海鲜菇，鲜嫩爽滑，煲汤炒菜提鲜', 'https://img.alicdn.com/imgextra/i5/O1CN01海鲜菇.jpg', 1, 5, 1);
SET @spu25 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu25, '海鲜菇 150g', 'JG-HXG-150G', 5.90, 7.90, 100, 10, 0, '件', '150g/盒', 1);


-- ==================== 豆制品 (category_id=13) ====================

-- 老豆腐
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('老豆腐', 13, '豆香坊', '传统石磨老豆腐，豆香浓郁，炖煮入味', 'https://img.alicdn.com/imgextra/i1/O1CN01老豆腐.jpg', 1, 3, 1);
SET @spu26 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu26, '老豆腐 400g', 'DZ-LDF-400G', 3.50, 4.90, 150, 15, 0, '件', '400g/盒', 1);

-- 嫩豆腐
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('嫩豆腐', 13, '豆香坊', '滑嫩细腻内酯豆腐，入口即化，凉拌佳品', 'https://img.alicdn.com/imgextra/i2/O1CN01嫩豆腐.jpg', 1, 3, 1);
SET @spu27 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu27, '嫩豆腐 350g', 'DZ-NDF-350G', 3.90, 5.50, 140, 14, 0, '件', '350g/盒', 1);

-- 豆腐皮
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('豆腐皮', 13, '豆香坊', '优质豆腐皮，薄而韧，凉拌炒菜涮火锅', 'https://img.alicdn.com/imgextra/i3/O1CN01豆腐皮.jpg', 1, 5, 1);
SET @spu28 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu28, '豆腐皮 200g', 'DZ-DFP-200G', 5.90, 7.90, 100, 10, 0, '件', '200g/袋', 1);

-- 腐竹
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('手工腐竹', 13, '豆香坊', '传统手工腐竹，豆香醇厚，火锅凉拌必备', 'https://img.alicdn.com/imgextra/i4/O1CN01腐竹.jpg', 0, 60, 1);
SET @spu29 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu29, '腐竹 250g', 'DZ-FZ-250G', 12.90, 16.90, 80, 10, 0, '件', '250g/袋', 1);

-- 豆干
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('五香豆干', 13, '豆香坊', '五香卤制豆干，口感紧实，零食佐餐两相宜', 'https://img.alicdn.com/imgextra/i5/O1CN01豆干.jpg', 1, 15, 1);
SET @spu30 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu30, '五香豆干 200g', 'DZ-WXDG-200G', 6.90, 8.90, 120, 12, 0, '件', '200g/袋', 1);


-- ============================================
-- 第一批数据统计：
-- 叶菜类 (id=9): 8个SPU, 10个SKU
-- 根茎类 (id=10): 6个SPU, 8个SKU
-- 茄果类 (id=11): 6个SPU, 7个SKU
-- 菌菇类 (id=12): 5个SPU, 7个SKU
-- 豆制品 (id=13): 5个SPU, 5个SKU
-- 合计：30个SPU, 37个SKU
-- ============================================
-- ============================================
-- 第二批商品数据：热带水果、浆果类、柑橘类、瓜类、进口水果
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 热带水果 (category_id=14) ====================

-- 芒果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('海南金煌芒', 14, '热带果园', '海南直发金煌芒，果肉细腻无纤维，甜度高达19度', 'https://img.alicdn.com/imgextra/i1/O1CN01芒果.jpg', 0, 10, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '海南金煌芒 2.5kg', 'RD-MG-2.5KG', 16.90, 22.90, 100, 10, 0, '件', '2.5kg/箱(约5-7个)', 1),
       (@spu1, '海南金煌芒 5kg', 'RD-MG-5KG', 29.90, 39.90, 50, 5, 0, '件', '5kg/箱(约12-15个)', 1);

-- 榴莲
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('金枕头榴莲', 14, '热带果园', '泰国进口金枕头，果肉金黄饱满，香甜软糯', 'https://img.alicdn.com/imgextra/i2/O1CN01榴莲.jpg', 1, 5, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '金枕头榴莲 整果(约3kg)', 'RD-LL-3KG', 89.90, 119.90, 30, 5, 0, '件', '约3kg/个', 1),
       (@spu2, '金枕头榴莲肉 500g', 'RD-LLR-500G', 49.90, 65.90, 50, 5, 0, '件', '500g/盒', 1);

-- 菠萝
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('海南香水菠萝', 14, '热带果园', '海南香水菠萝，果眼浅免挖，香甜不涩口', 'https://img.alicdn.com/imgextra/i3/O1CN01菠萝.jpg', 0, 7, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '香水菠萝 1个(约1kg)', 'RD-BL-1KG', 9.90, 12.90, 100, 10, 0, '件', '约1kg/个', 1);

-- 火龙果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('越南红心火龙果', 14, '热带果园', '越南进口红心火龙果，甜度高，花青素丰富', 'https://img.alicdn.com/imgextra/i4/O1CN01火龙果.jpg', 1, 7, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '红心火龙果 2个(约500g)', 'RD-HLG-500G', 15.90, 19.90, 80, 10, 0, '件', '约500g/2个', 1),
       (@spu4, '红心火龙果 4个(约1kg)', 'RD-HLG-1KG', 28.90, 35.90, 50, 5, 0, '件', '约1kg/4个', 1);

-- 百香果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('黄金百香果', 14, '热带果园', '福建黄金百香果，香甜多汁，维C之王', 'https://img.alicdn.com/imgextra/i5/O1CN01百香果.jpg', 0, 10, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '黄金百香果 12个', 'RD-BXG-12', 19.90, 25.90, 80, 10, 0, '件', '12个/盒', 1);

-- 山竹
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('泰国山竹', 14, '热带果园', '泰国进口山竹，果肉雪白饱满，清甜爽口', 'https://img.alicdn.com/imgextra/i6/O1CN01山竹.jpg', 1, 5, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '泰国山竹 500g', 'RD-SZ-500G', 19.90, 25.90, 60, 8, 0, '件', '500g/份', 1);


-- ==================== 浆果类 (category_id=15) ====================

-- 草莓
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('丹东99草莓', 15, '鲜果汇', '丹东产地直供，个大味甜，奶香浓郁', 'https://img.alicdn.com/imgextra/i7/O1CN01草莓.jpg', 1, 3, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '丹东99草莓 250g', 'JB-CM-250G', 19.90, 25.90, 80, 10, 0, '件', '250g/盒', 1),
       (@spu7, '丹东99草莓 500g', 'JB-CM-500G', 35.90, 45.90, 50, 5, 0, '件', '500g/盒', 1),
       (@spu7, '丹东99草莓 1kg礼盒', 'JB-CM-1KG', 65.90, 79.90, 20, 5, 0, '件', '1kg/礼盒', 1);

-- 蓝莓
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('云南蓝莓', 15, '鲜果汇', '云南高山蓝莓，花青素丰富，酸甜可口', 'https://img.alicdn.com/imgextra/i8/O1CN01蓝莓.jpg', 1, 5, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '云南蓝莓 125g*2盒', 'JB-LM-250G', 15.90, 19.90, 100, 10, 0, '件', '125g*2盒', 1),
       (@spu8, '云南蓝莓 125g*4盒', 'JB-LM-500G', 28.90, 35.90, 50, 5, 0, '件', '125g*4盒', 1);

-- 车厘子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('智利车厘子', 15, '鲜果汇', '智利进口JJ级车厘子，果径30mm+，脆甜多汁', 'https://img.alicdn.com/imgextra/i9/O1CN01车厘子.jpg', 1, 5, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '智利车厘子 500g', 'JB-CLZ-500G', 39.90, 49.90, 50, 5, 0, '件', '500g/盒', 1),
       (@spu9, '智利车厘子 1kg', 'JB-CLZ-1KG', 69.90, 89.90, 30, 5, 0, '件', '1kg/盒', 1);

-- 红树莓
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('云南红树莓', 15, '鲜果汇', '新鲜红树莓，酸甜可口，富含花青素', 'https://img.alicdn.com/imgextra/i10/O1CN01树莓.jpg', 1, 3, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '红树莓 125g', 'JB-HSM-125G', 15.90, 19.90, 60, 8, 0, '件', '125g/盒', 1);


-- ==================== 柑橘类 (category_id=16) ====================

-- 脐橙
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('赣南脐橙', 16, '橙心诚意', '正宗赣南脐橙，汁多味甜，维C满满', 'https://img.alicdn.com/imgextra/i11/O1CN01脐橙.jpg', 0, 15, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '赣南脐橙 2.5kg', 'GJ-QC-2.5KG', 19.90, 25.90, 120, 15, 0, '件', '2.5kg/箱', 1),
       (@spu11, '赣南脐橙 5kg', 'GJ-QC-5KG', 35.90, 45.90, 60, 10, 0, '件', '5kg/箱', 1);

-- 砂糖橘
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('金秋砂糖橘', 16, '橙心诚意', '广西金秋砂糖橘，皮薄易剥，甜如蜜糖', 'https://img.alicdn.com/imgextra/i12/O1CN01砂糖橘.jpg', 0, 10, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '砂糖橘 2.5kg', 'GJ-STJ-2.5KG', 15.90, 19.90, 100, 10, 0, '件', '2.5kg/箱', 1),
       (@spu12, '砂糖橘 5kg', 'GJ-STJ-5KG', 28.90, 35.90, 60, 8, 0, '件', '5kg/箱', 1);

-- 沃柑
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('武鸣沃柑', 16, '橙心诚意', '广西武鸣沃柑，皮薄多汁，橘橙风味', 'https://img.alicdn.com/imgextra/i13/O1CN01沃柑.jpg', 0, 15, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '武鸣沃柑 2.5kg', 'GJ-WG-2.5KG', 22.90, 29.90, 80, 10, 0, '件', '2.5kg/箱', 1);

-- 柠檬
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('安岳柠檬', 16, '橙心诚意', '四川安岳柠檬，酸爽多汁，泡水调味佳品', 'https://img.alicdn.com/imgextra/i14/O1CN01柠檬.jpg', 0, 20, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '安岳柠檬 5个', 'GJ-NM-5', 9.90, 12.90, 120, 12, 0, '件', '5个/袋', 1),
       (@spu14, '安岳柠檬 10个', 'GJ-NM-10', 16.90, 22.90, 80, 10, 0, '件', '10个/袋', 1);


-- ==================== 瓜类 (category_id=17) ====================

-- 西瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('麒麟西瓜', 17, '瓜果飘香', '8424麒麟瓜，皮薄瓤红，甜度高水分足', 'https://img.alicdn.com/imgextra/i15/O1CN01西瓜.jpg', 1, 5, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '麒麟西瓜 整个(约5kg)', 'GL-XG-5KG', 19.90, 25.90, 60, 8, 0, '件', '约5kg/个', 1),
       (@spu15, '麒麟西瓜 半个(约2.5kg)', 'GL-XG-2.5KG', 12.90, 16.90, 80, 10, 0, '件', '约2.5kg/半个', 1);

-- 哈密瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新疆哈密瓜', 17, '瓜果飘香', '新疆产地直发，脆甜爽口，瓜香浓郁', 'https://img.alicdn.com/imgextra/i16/O1CN01哈密瓜.jpg', 0, 10, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '哈密瓜 1个(约2kg)', 'GL-HMG-2KG', 19.90, 25.90, 60, 8, 0, '件', '约2kg/个', 1);

-- 蜜瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('海南玫珑蜜瓜', 17, '瓜果飘香', '日本品种玫珑瓜，翡翠绿瓤，冰淇淋口感', 'https://img.alicdn.com/imgextra/i17/O1CN01蜜瓜.jpg', 1, 7, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '玫珑蜜瓜 1个(约1.5kg)', 'GL-MG-1.5KG', 29.90, 39.90, 50, 5, 0, '件', '约1.5kg/个', 1);

-- 木瓜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('海南红心木瓜', 17, '瓜果飘香', '海南红心木瓜，肉厚籽少，香甜软糯', 'https://img.alicdn.com/imgextra/i18/O1CN01木瓜.jpg', 0, 7, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '红心木瓜 2个(约1.5kg)', 'GL-MG-2-1.5KG', 19.90, 25.90, 60, 8, 0, '件', '约1.5kg/2个', 1);


-- ==================== 进口水果 (category_id=18) ====================

-- 佳沛奇异果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('佳沛金果奇异果', 18, 'Zespri佳沛', '新西兰进口佳沛金果，维C丰富，香甜细腻', 'https://img.alicdn.com/imgextra/i19/O1CN01奇异果.jpg', 1, 10, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '佳沛金果 6个', 'JK-QYG-6', 39.90, 49.90, 60, 8, 0, '件', '6个/盒', 1),
       (@spu19, '佳沛金果 12个', 'JK-QYG-12', 69.90, 89.90, 30, 5, 0, '件', '12个/盒', 1);

-- 牛油果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('墨西哥牛油果', 18, '进口鲜果', '墨西哥哈斯牛油果，口感绵密，健康脂肪来源', 'https://img.alicdn.com/imgextra/i20/O1CN01牛油果.jpg', 1, 7, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '牛油果 3个', 'JK-NYG-3', 25.90, 32.90, 60, 8, 0, '件', '3个/袋', 1),
       (@spu20, '牛油果 6个', 'JK-NYG-6', 45.90, 59.90, 30, 5, 0, '件', '6个/袋', 1);

-- 提子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('澳洲无籽红提', 18, '进口鲜果', '澳洲进口无籽红提，脆甜多汁，果粉均匀', 'https://img.alicdn.com/imgextra/i21/O1CN01提子.jpg', 1, 7, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '澳洲红提 500g', 'JK-HT-500G', 29.90, 39.90, 50, 5, 0, '件', '500g/盒', 1);

-- 青苹果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新西兰青苹果', 18, '进口鲜果', '新西兰火箭青苹果，酸甜脆爽，果香浓郁', 'https://img.alicdn.com/imgextra/i22/O1CN01青苹果.jpg', 0, 20, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '新西兰青苹果 4个', 'JK-QPG-4', 19.90, 25.90, 80, 10, 0, '件', '4个/袋', 1);

-- 释迦果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('台湾释迦果', 18, '进口鲜果', '台湾凤梨释迦，口感绵密似冰淇淋，甜蜜芳香', 'https://img.alicdn.com/imgextra/i23/O1CN01释迦.jpg', 1, 5, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '释迦果 1个(约400g)', 'JK-SJG-400G', 29.90, 39.90, 40, 5, 0, '件', '约400g/个', 1);


-- ============================================
-- 第二批数据统计：
-- 热带水果 (id=14): 6个SPU, 8个SKU
-- 浆果类 (id=15): 4个SPU, 7个SKU
-- 柑橘类 (id=16): 4个SPU, 6个SKU
-- 瓜类 (id=17): 4个SPU, 5个SKU
-- 进口水果 (id=18): 5个SPU, 6个SKU
-- 合计：23个SPU, 32个SKU
-- ============================================
-- ============================================
-- 第三批商品数据：猪肉、牛羊肉、禽肉、蛋类、加工肉品
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 猪肉 (category_id=19) ====================

-- 五花肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('黑猪五花肉', 19, '黑猪牧场', '生态散养黑猪，五花三层分明，适合红烧', 'https://img.alicdn.com/imgextra/i1/O1CN01五花肉.jpg', 1, 3, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '黑猪五花肉 300g', 'ZR-WH-300G', 19.90, 25.90, 80, 10, 0, '件', '300g/盒', 1),
       (@spu1, '黑猪五花肉 500g', 'ZR-WH-500G', 30.90, 38.90, 50, 5, 0, '件', '500g/盒', 1);

-- 里脊肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('猪里脊肉', 19, '黑猪牧场', '纯瘦里脊肉，肉质细嫩，糖醋里脊首选', 'https://img.alicdn.com/imgextra/i2/O1CN01里脊肉.jpg', 1, 3, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '猪里脊肉 300g', 'ZR-LJ-300G', 18.90, 23.90, 80, 10, 0, '件', '300g/盒', 1);

-- 肋排
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('精肋排', 19, '黑猪牧场', '精选肋排，骨小肉多，红烧糖醋皆宜', 'https://img.alicdn.com/imgextra/i3/O1CN01肋排.jpg', 1, 3, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '精肋排 500g', 'ZR-LP-500G', 35.90, 45.90, 50, 5, 0, '件', '500g/盒', 1);

-- 前腿肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('猪前腿肉', 19, '黑猪牧场', '肥瘦相间前腿肉，适合炒菜做馅', 'https://img.alicdn.com/imgextra/i4/O1CN01前腿肉.jpg', 1, 3, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '猪前腿肉 500g', 'ZR-QT-500G', 16.90, 21.90, 80, 10, 0, '件', '500g/盒', 1);

-- 梅花肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('梅花肉', 19, '黑猪牧场', '猪肩胛梅花肉，肥瘦相间，煎烤涮皆宜', 'https://img.alicdn.com/imgextra/i5/O1CN01梅花肉.jpg', 1, 3, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '梅花肉 300g', 'ZR-MHR-300G', 17.90, 22.90, 80, 10, 0, '件', '300g/盒', 1);


-- ==================== 牛羊肉 (category_id=20) ====================

-- 牛腩
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('澳洲谷饲牛腩', 20, '牛牛牧场', '澳洲进口谷饲牛腩，肥瘦相间，炖煮软烂', 'https://img.alicdn.com/imgextra/i6/O1CN01牛腩.jpg', 1, 3, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '牛腩 500g', 'NR-NN-500G', 39.90, 49.90, 50, 5, 0, '件', '500g/盒', 1),
       (@spu6, '牛腩 1kg', 'NR-NN-1KG', 69.90, 89.90, 30, 5, 0, '件', '1kg/盒', 1);

-- 牛排
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('原切西冷牛排', 20, '牛牛牧场', '澳洲M3级原切西冷，雪花纹理清晰，入口即化', 'https://img.alicdn.com/imgextra/i7/O1CN01牛排.jpg', 1, 7, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '西冷牛排 150g*2片', 'NR-NP-150G2', 59.90, 79.90, 50, 5, 0, '件', '150g*2片/盒', 1);

-- 肥牛卷
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('精品肥牛卷', 20, '牛牛牧场', '精选肥牛卷，肥瘦相间，涮火锅必备', 'https://img.alicdn.com/imgextra/i8/O1CN01肥牛卷.jpg', 1, 7, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '肥牛卷 250g', 'NR-FNJ-250G', 25.90, 32.90, 80, 10, 0, '件', '250g/盒', 1),
       (@spu8, '肥牛卷 500g', 'NR-FNJ-500G', 45.90, 59.90, 50, 5, 0, '件', '500g/盒', 1);

-- 牛腱子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('牛腱子肉', 20, '牛牛牧场', '精选牛腱子，肉质紧实，卤牛肉首选', 'https://img.alicdn.com/imgextra/i9/O1CN01牛腱子.jpg', 1, 3, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '牛腱子 500g', 'NR-JZ-500G', 42.90, 55.90, 40, 5, 0, '件', '500g/盒', 1);

-- 羊肉卷
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('内蒙羔羊肉卷', 20, '草原牧场', '内蒙古锡盟羔羊，肉质鲜嫩无膻味', 'https://img.alicdn.com/imgextra/i10/O1CN01羊肉卷.jpg', 1, 7, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '羔羊肉卷 250g', 'NR-YRJ-250G', 29.90, 39.90, 60, 8, 0, '件', '250g/盒', 1),
       (@spu10, '羔羊肉卷 500g', 'NR-YRJ-500G', 52.90, 69.90, 30, 5, 0, '件', '500g/盒', 1);

-- 羊排
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('法式羊排', 20, '草原牧场', '精选法式羊排，骨肉相连，煎烤香嫩', 'https://img.alicdn.com/imgextra/i11/O1CN01羊排.jpg', 1, 5, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '法式羊排 400g', 'NR-YP-400G', 49.90, 65.90, 40, 5, 0, '件', '400g/盒', 1);


-- ==================== 禽肉 (category_id=21) ====================

-- 鸡胸肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新鲜鸡胸肉', 21, '正大食品', '优质白羽鸡胸肉，低脂高蛋白，健身首选', 'https://img.alicdn.com/imgextra/i12/O1CN01鸡胸肉.jpg', 1, 3, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '鸡胸肉 500g', 'QR-JXR-500G', 12.90, 16.90, 120, 12, 0, '件', '500g/袋', 1);

-- 鸡翅
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('冰鲜鸡翅中', 21, '正大食品', '精选鸡翅中，肉质饱满，烤翅可乐鸡翅首选', 'https://img.alicdn.com/imgextra/i13/O1CN01鸡翅.jpg', 1, 3, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '鸡翅中 500g', 'QR-JCZ-500G', 18.90, 23.90, 100, 10, 0, '件', '500g/袋', 1);

-- 三黄鸡
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('散养三黄鸡', 21, '正大食品', '散养三黄鸡，肉质紧实，煲汤鲜美', 'https://img.alicdn.com/imgextra/i14/O1CN01三黄鸡.jpg', 1, 3, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '三黄鸡 整只(约1.2kg)', 'QR-SHJ-1.2KG', 29.90, 38.90, 50, 5, 0, '件', '约1.2kg/只', 1);

-- 鸭腿
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新鲜鸭腿', 21, '华英鸭业', '优质鸭腿，肉质紧实，酱鸭卤鸭首选', 'https://img.alicdn.com/imgextra/i15/O1CN01鸭腿.jpg', 1, 3, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '鸭腿 2只(约500g)', 'QR-YT-500G', 16.90, 21.90, 80, 10, 0, '件', '约500g/2只', 1);

-- 鸡腿
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('大鸡腿', 21, '正大食品', '新鲜大鸡腿，肉多骨少，红烧烤制皆宜', 'https://img.alicdn.com/imgextra/i16/O1CN01鸡腿.jpg', 1, 3, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '大鸡腿 4只(约800g)', 'QR-JT-800G', 19.90, 25.90, 80, 10, 0, '件', '约800g/4只', 1);


-- ==================== 蛋类 (category_id=22) ====================

-- 土鸡蛋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('散养土鸡蛋', 22, '农家鲜', '林下散养土鸡蛋，蛋黄饱满，营养丰富', 'https://img.alicdn.com/imgextra/i17/O1CN01土鸡蛋.jpg', 0, 15, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '土鸡蛋 10枚', 'DL-TJD-10', 15.90, 19.90, 150, 15, 0, '件', '10枚/盒', 1),
       (@spu17, '土鸡蛋 30枚', 'DL-TJD-30', 39.90, 49.90, 80, 10, 0, '件', '30枚/盒', 1);

-- 乌鸡蛋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('绿壳乌鸡蛋', 22, '农家鲜', '绿壳乌鸡蛋，富含卵磷脂，滋补佳品', 'https://img.alicdn.com/imgextra/i18/O1CN01乌鸡蛋.jpg', 0, 15, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '乌鸡蛋 10枚', 'DL-WJD-10', 19.90, 25.90, 80, 10, 0, '件', '10枚/盒', 1);

-- 鹌鹑蛋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新鲜鹌鹑蛋', 22, '农家鲜', '新鲜鹌鹑蛋，小巧营养，火锅卤味必备', 'https://img.alicdn.com/imgextra/i19/O1CN01鹌鹑蛋.jpg', 0, 10, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '鹌鹑蛋 30枚', 'DL-ACD-30', 9.90, 12.90, 120, 12, 0, '件', '30枚/盒', 1);

-- 咸鸭蛋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('高邮咸鸭蛋', 22, '农家鲜', '江苏高邮咸鸭蛋，红油沙心，佐粥佳品', 'https://img.alicdn.com/imgextra/i20/O1CN01咸鸭蛋.jpg', 0, 30, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '咸鸭蛋 6枚', 'DL-XYD-6', 12.90, 16.90, 100, 10, 0, '件', '6枚/盒', 1),
       (@spu20, '咸鸭蛋 12枚', 'DL-XYD-12', 22.90, 29.90, 60, 8, 0, '件', '12枚/盒', 1);


-- ==================== 加工肉品 (category_id=23) ====================

-- 火腿肠
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('双汇火腿肠', 23, '双汇', '经典王中王火腿肠，肉质紧实，方便即食', 'https://img.alicdn.com/imgextra/i21/O1CN01火腿肠.jpg', 0, 90, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '火腿肠 10支装', 'JG-HTC-10', 15.90, 19.90, 200, 20, 0, '件', '10支/袋', 1);

-- 培根
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('烟熏培根', 23, '荷美尔', '经典烟熏培根，肥瘦相间，早餐煎烤首选', 'https://img.alicdn.com/imgextra/i22/O1CN01培根.jpg', 1, 30, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '培根 200g', 'JG-PG-200G', 15.90, 19.90, 100, 10, 0, '件', '200g/盒', 1);

-- 午餐肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('梅林午餐肉', 23, '梅林', '经典梅林午餐肉，肉粒可见，火锅必备', 'https://img.alicdn.com/imgextra/i23/O1CN01午餐肉.jpg', 0, 365, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '午餐肉 340g', 'JG-WCR-340G', 16.90, 21.90, 120, 12, 0, '件', '340g/罐', 1);

-- 香肠
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('广式腊肠', 23, '皇上皇', '正宗广式腊肠，甜香适口，煲仔饭首选', 'https://img.alicdn.com/imgextra/i24/O1CN01腊肠.jpg', 0, 90, 1);
SET @spu24 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu24, '广式腊肠 250g', 'JG-LC-250G', 19.90, 25.90, 80, 10, 0, '件', '250g/袋', 1);

-- 丸子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('撒尿牛肉丸', 23, '海霸王', '潮汕风味牛肉丸，弹牙爆汁，火锅必备', 'https://img.alicdn.com/imgextra/i25/O1CN01牛肉丸.jpg', 1, 60, 1);
SET @spu25 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu25, '牛肉丸 250g', 'JG-NRW-250G', 18.90, 23.90, 100, 10, 0, '件', '250g/袋', 1);


-- ============================================
-- 第三批数据统计：
-- 猪肉 (id=19): 5个SPU, 6个SKU
-- 牛羊肉 (id=20): 6个SPU, 8个SKU
-- 禽肉 (id=21): 5个SPU, 5个SKU
-- 蛋类 (id=22): 4个SPU, 5个SKU
-- 加工肉品 (id=23): 5个SPU, 5个SKU
-- 合计：25个SPU, 29个SKU
-- ============================================
-- ============================================
-- 第四批商品数据：鱼类、虾蟹类、贝类、冷冻海鲜
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 鱼类 (category_id=24) ====================

-- 三文鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('挪威三文鱼', 24, '深海珍鲜', '挪威进口三文鱼，肉质橙红鲜嫩，刺身首选', 'https://img.alicdn.com/imgextra/i1/O1CN01三文鱼.jpg', 1, 3, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '三文鱼刺身 250g', 'HL-SWY-250G', 49.90, 65.90, 50, 5, 0, '件', '250g/盒', 1),
       (@spu1, '三文鱼整段 500g', 'HL-SWY-500G', 89.90, 119.90, 30, 5, 0, '件', '500g/段', 1);

-- 带鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('东海带鱼段', 24, '深海珍鲜', '东海野生带鱼，肉质细嫩，干煎红烧皆宜', 'https://img.alicdn.com/imgextra/i2/O1CN01带鱼.jpg', 1, 7, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '带鱼段 500g', 'HL-DY-500G', 19.90, 25.90, 80, 10, 0, '件', '500g/袋', 1);

-- 鲈鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜活鲈鱼', 24, '深海珍鲜', '鲜活海鲈鱼，肉质鲜嫩，清蒸最佳', 'https://img.alicdn.com/imgextra/i3/O1CN01鲈鱼.jpg', 1, 2, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '鲜活鲈鱼 1条(约400g)', 'HL-LY-400G', 22.90, 29.90, 60, 8, 0, '件', '约400g/条', 1);

-- 巴沙鱼柳
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('越南巴沙鱼柳', 24, '深海珍鲜', '越南进口巴沙鱼柳，无骨无刺，老少皆宜', 'https://img.alicdn.com/imgextra/i4/O1CN01巴沙鱼.jpg', 1, 7, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '巴沙鱼柳 500g', 'HL-BSY-500G', 15.90, 19.90, 100, 10, 0, '件', '500g/袋', 1);

-- 秋刀鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('冷冻秋刀鱼', 24, '深海珍鲜', '日本秋刀鱼，盐烤香酥，日料必备', 'https://img.alicdn.com/imgextra/i5/O1CN01秋刀鱼.jpg', 1, 30, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '秋刀鱼 3条装', 'HL-QDY-3', 15.90, 19.90, 80, 10, 0, '件', '3条/袋', 1);

-- 银鳕鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('阿拉斯加银鳕鱼', 24, '深海珍鲜', '阿拉斯加银鳕鱼，肉质白嫩细腻，宝宝辅食首选', 'https://img.alicdn.com/imgextra/i6/O1CN01银鳕鱼.jpg', 1, 7, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '银鳕鱼 250g', 'HL-YXY-250G', 69.90, 89.90, 30, 5, 0, '件', '250g/盒', 1);

-- 金鲳鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('湛江金鲳鱼', 24, '深海珍鲜', '湛江深海金鲳鱼，肉厚刺少，香煎清蒸皆宜', 'https://img.alicdn.com/imgextra/i7/O1CN01金鲳鱼.jpg', 1, 5, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '金鲳鱼 1条(约350g)', 'HL-JCY-350G', 19.90, 25.90, 60, 8, 0, '件', '约350g/条', 1);


-- ==================== 虾蟹类 (category_id=25) ====================

-- 基围虾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜活基围虾', 25, '海鲜码头', '鲜活基围虾，肉质Q弹，白灼蒜蓉皆宜', 'https://img.alicdn.com/imgextra/i8/O1CN01基围虾.jpg', 1, 2, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '基围虾 500g', 'XH-JWX-500G', 39.90, 49.90, 50, 5, 0, '件', '500g/盒', 1);

-- 白虾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('厄瓜多尔白虾', 25, '海鲜码头', '南美进口白虾，个大饱满，虾肉紧实', 'https://img.alicdn.com/imgextra/i9/O1CN01白虾.jpg', 1, 7, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '白虾 40/50 1kg', 'XH-BX-1KG', 49.90, 65.90, 50, 5, 0, '件', '1kg/盒', 1);

-- 北极甜虾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('加拿大北极甜虾', 25, '海鲜码头', '加拿大进口北极甜虾，肉质鲜甜，即食刺身', 'https://img.alicdn.com/imgextra/i10/O1CN01北极甜虾.jpg', 1, 7, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '北极甜虾 200g', 'XH-BJTX-200G', 29.90, 39.90, 60, 8, 0, '件', '200g/盒', 1);

-- 小龙虾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('盱眙小龙虾', 25, '海鲜码头', '江苏盱眙小龙虾，肉质饱满，麻辣十三香首选', 'https://img.alicdn.com/imgextra/i11/O1CN01小龙虾.jpg', 1, 5, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '小龙虾 4-6钱 1kg', 'XH-XLX-1KG', 39.90, 55.90, 50, 5, 0, '件', '1kg/袋', 1);

-- 大闸蟹
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('阳澄湖大闸蟹', 25, '蟹状元', '正宗阳澄湖大闸蟹，蟹黄饱满，金秋美味', 'https://img.alicdn.com/imgextra/i12/O1CN01大闸蟹.jpg', 1, 3, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '大闸蟹 4两公 4只', 'XH-DZX-4', 129.90, 169.90, 30, 5, 0, '件', '4只/盒', 1),
       (@spu12, '大闸蟹礼盒 8只', 'XH-DZX-8', 258.90, 328.90, 20, 3, 0, '件', '8只/礼盒', 1);

-- 生蚝
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('乳山生蚝', 25, '海鲜码头', '山东乳山生蚝，个大肥美，蒜蓉烤制首选', 'https://img.alicdn.com/imgextra/i13/O1CN01生蚝.jpg', 1, 3, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '生蚝 1kg(约8-10个)', 'XH-SH-1KG', 29.90, 39.90, 60, 8, 0, '件', '约8-10个/kg', 1);


-- ==================== 贝类 (category_id=26) ====================

-- 花蛤
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜活花蛤', 26, '海鲜码头', '吐沙干净鲜活花蛤，爆炒鲜香，啤酒搭档', 'https://img.alicdn.com/imgextra/i14/O1CN01花蛤.jpg', 1, 2, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '花蛤 500g', 'BL-HG-500G', 9.90, 12.90, 100, 10, 0, '件', '500g/袋', 1),
       (@spu14, '花蛤 1kg', 'BL-HG-1KG', 16.90, 22.90, 60, 8, 0, '件', '1kg/袋', 1);

-- 扇贝
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('大连扇贝', 26, '海鲜码头', '大连鲜活扇贝，肉质鲜嫩，蒜蓉粉丝蒸首选', 'https://img.alicdn.com/imgextra/i15/O1CN01扇贝.jpg', 1, 3, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '扇贝 1kg(约15-20个)', 'BL-SB-1KG', 25.90, 32.90, 50, 5, 0, '件', '约15-20个/kg', 1);

-- 蛏子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜活蛏子', 26, '海鲜码头', '新鲜蛏子，肉质肥美，葱姜炒制鲜甜', 'https://img.alicdn.com/imgextra/i16/O1CN01蛏子.jpg', 1, 2, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '蛏子 500g', 'BL-CZ-500G', 15.90, 19.90, 80, 10, 0, '件', '500g/袋', 1);

-- 蛤蜊
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('黄蚬子', 26, '海鲜码头', '丹东黄蚬子，肉厚味鲜，辣炒绝佳', 'https://img.alicdn.com/imgextra/i17/O1CN01黄蚬子.jpg', 1, 2, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '黄蚬子 500g', 'BL-HXZ-500G', 12.90, 16.90, 80, 10, 0, '件', '500g/袋', 1);

-- 鲍鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鲜活鲍鱼', 26, '海鲜码头', '福建连江鲍鱼，肉质厚实，滋补佳品', 'https://img.alicdn.com/imgextra/i18/O1CN01鲍鱼.jpg', 1, 3, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '鲍鱼 6头 约300g', 'BL-BY-300G', 49.90, 65.90, 30, 5, 0, '件', '约300g/6只', 1);


-- ==================== 冷冻海鲜 (category_id=27) ====================

-- 冷冻虾仁
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('去壳虾仁', 27, '海鲜码头', '精选去壳虾仁，肉质Q弹，炒菜首选', 'https://img.alicdn.com/imgextra/i19/O1CN01虾仁.jpg', 1, 90, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '虾仁 200g', 'LD-XR-200G', 19.90, 25.90, 100, 10, 0, '件', '200g/袋', 1),
       (@spu19, '虾仁 500g', 'LD-XR-500G', 42.90, 55.90, 60, 8, 0, '件', '500g/袋', 1);

-- 冷冻鱿鱼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('鱿鱼须', 27, '海鲜码头', '新鲜鱿鱼须，口感弹牙，烧烤铁板首选', 'https://img.alicdn.com/imgextra/i20/O1CN01鱿鱼.jpg', 1, 90, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '鱿鱼须 250g', 'LD-YYX-250G', 15.90, 19.90, 80, 10, 0, '件', '250g/袋', 1);

-- 冷冻章鱼足
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('章鱼足', 27, '海鲜码头', '进口章鱼足，肉质紧实，日料刺身首选', 'https://img.alicdn.com/imgextra/i21/O1CN01章鱼足.jpg', 1, 90, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '章鱼足 200g', 'LD-ZYZ-200G', 25.90, 32.90, 60, 8, 0, '件', '200g/袋', 1);

-- 冷冻扇贝肉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('扇贝肉', 27, '海鲜码头', '精选扇贝肉，去壳去内脏，方便烹饪', 'https://img.alicdn.com/imgextra/i22/O1CN01扇贝肉.jpg', 1, 90, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '扇贝肉 200g', 'LD-SBR-200G', 18.90, 23.90, 80, 10, 0, '件', '200g/袋', 1);

-- 冷冻墨鱼仔
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('墨鱼仔', 27, '海鲜码头', '新鲜墨鱼仔，肉质鲜嫩，爆炒烧烤皆宜', 'https://img.alicdn.com/imgextra/i23/O1CN01墨鱼仔.jpg', 1, 90, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '墨鱼仔 250g', 'LD-MYZ-250G', 16.90, 21.90, 80, 10, 0, '件', '250g/袋', 1);


-- ============================================
-- 第四批数据统计：
-- 鱼类 (id=24): 7个SPU, 8个SKU
-- 虾蟹类 (id=25): 6个SPU, 7个SKU
-- 贝类 (id=26): 5个SPU, 6个SKU
-- 冷冻海鲜 (id=27): 5个SPU, 6个SKU
-- 合计：23个SPU, 27个SKU
-- ============================================
-- ============================================
-- 第五批商品数据：米面杂粮、食用油、调味品、方便速食
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 米面杂粮 (category_id=28) ====================

-- 东北大米
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('五常稻花香大米', 28, '北大荒', '黑龙江五常稻花香，米香浓郁，软糯可口', 'https://img.alicdn.com/imgextra/i1/O1CN01大米.jpg', 0, 365, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '稻花香大米 5kg', 'LM-DM-5KG', 39.90, 49.90, 100, 10, 0, '件', '5kg/袋', 1),
       (@spu1, '稻花香大米 10kg', 'LM-DM-10KG', 69.90, 89.90, 60, 8, 0, '件', '10kg/袋', 1);

-- 茉莉香米
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('泰国茉莉香米', 28, '金轮', '泰国进口茉莉香米，米粒修长，清香扑鼻', 'https://img.alicdn.com/imgextra/i2/O1CN01香米.jpg', 0, 365, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '茉莉香米 5kg', 'LM-MLX-5KG', 45.90, 59.90, 80, 10, 0, '件', '5kg/袋', 1);

-- 红薯粉条
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('手工红薯粉条', 28, '农家自制', '传统手工红薯粉条，Q弹爽滑，炖菜必备', 'https://img.alicdn.com/imgextra/i3/O1CN01粉条.jpg', 0, 180, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '红薯粉条 500g', 'LM-FT-500G', 12.90, 16.90, 100, 10, 0, '件', '500g/袋', 1);

-- 燕麦片
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('澳洲燕麦片', 28, '西麦', '澳洲进口纯燕麦片，高纤低脂，早餐首选', 'https://img.alicdn.com/imgextra/i4/O1CN01燕麦片.jpg', 0, 365, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '燕麦片 1kg', 'LM-YMP-1KG', 19.90, 25.90, 120, 12, 0, '件', '1kg/袋', 1);

-- 小米
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('山西沁州黄小米', 28, '沁州黄', '山西沁州黄小米，米油浓厚，养胃佳品', 'https://img.alicdn.com/imgextra/i5/O1CN01小米.jpg', 0, 365, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '黄小米 2.5kg', 'LM-XM-2.5KG', 22.90, 29.90, 80, 10, 0, '件', '2.5kg/袋', 1);

-- 挂面
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('龙须挂面', 28, '陈克明', '细如龙须挂面，口感爽滑，汤面拌面首选', 'https://img.alicdn.com/imgextra/i6/O1CN01挂面.jpg', 0, 365, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '龙须挂面 500g', 'LM-GM-500G', 8.90, 11.90, 150, 15, 0, '件', '500g/包', 1);


-- ==================== 食用油 (category_id=29) ====================

-- 橄榄油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('特级初榨橄榄油', 29, '欧丽薇兰', '西班牙进口特级初榨橄榄油，健康烹饪首选', 'https://img.alicdn.com/imgextra/i7/O1CN01橄榄油.jpg', 0, 540, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '橄榄油 500ml', 'SY-GLY-500ML', 59.90, 79.90, 60, 8, 0, '件', '500ml/瓶', 1),
       (@spu7, '橄榄油 1L', 'SY-GLY-1L', 99.90, 129.90, 40, 5, 0, '件', '1L/瓶', 1);

-- 花生油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('压榨一级花生油', 29, '鲁花', '物理压榨一级花生油，香味浓郁，炒菜香', 'https://img.alicdn.com/imgextra/i8/O1CN01花生油.jpg', 0, 540, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '花生油 1.8L', 'SY-HSY-1.8L', 45.90, 59.90, 80, 10, 0, '件', '1.8L/瓶', 1),
       (@spu8, '花生油 5L', 'SY-HSY-5L', 109.90, 139.90, 50, 5, 0, '件', '5L/桶', 1);

-- 菜籽油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('低芥酸菜籽油', 29, '金龙鱼', '低芥酸菜籽油，清淡健康，适合日常烹饪', 'https://img.alicdn.com/imgextra/i9/O1CN01菜籽油.jpg', 0, 540, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '菜籽油 1.8L', 'SY-CZY-1.8L', 35.90, 45.90, 80, 10, 0, '件', '1.8L/瓶', 1);

-- 亚麻籽油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('冷榨亚麻籽油', 29, '长白工坊', '冷榨亚麻籽油，富含α-亚麻酸，宝宝辅食首选', 'https://img.alicdn.com/imgextra/i10/O1CN01亚麻籽油.jpg', 0, 365, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '亚麻籽油 250ml', 'SY-YMZ-250ML', 39.90, 49.90, 50, 5, 0, '件', '250ml/瓶', 1);

-- 玉米油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('一级玉米油', 29, '福临门', '非转基因玉米油，清淡不油腻，适合凉拌炒菜', 'https://img.alicdn.com/imgextra/i11/O1CN01玉米油.jpg', 0, 540, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '玉米油 1.8L', 'SY-YMY-1.8L', 32.90, 42.90, 80, 10, 0, '件', '1.8L/瓶', 1);


-- ==================== 调味品 (category_id=30) ====================

-- 生抽
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('特级酿造生抽', 30, '海天', '特级酿造生抽，鲜味十足，炒菜凉拌首选', 'https://img.alicdn.com/imgextra/i12/O1CN01生抽.jpg', 0, 540, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '生抽 500ml', 'TW-SC-500ML', 9.90, 12.90, 200, 20, 0, '件', '500ml/瓶', 1);

-- 老抽
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('草菇老抽', 30, '海天', '草菇老抽，上色红亮，红烧必备', 'https://img.alicdn.com/imgextra/i13/O1CN01老抽.jpg', 0, 540, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '老抽 500ml', 'TW-LC-500ML', 10.90, 13.90, 180, 18, 0, '件', '500ml/瓶', 1);

-- 蚝油
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('蚝油', 30, '海天', '鲜蚝熬制蚝油，提鲜增味，炒菜点蘸皆宜', 'https://img.alicdn.com/imgextra/i14/O1CN01蚝油.jpg', 0, 540, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '蚝油 700g', 'TW-HY-700G', 12.90, 16.90, 150, 15, 0, '件', '700g/瓶', 1);

-- 食盐
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('加碘食盐', 30, '中盐', '精制加碘食盐，烹饪必备调味品', 'https://img.alicdn.com/imgextra/i15/O1CN01食盐.jpg', 0, 1825, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '加碘盐 400g', 'TW-SY-400G', 2.50, 3.50, 300, 30, 0, '件', '400g/袋', 1);

-- 白糖
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('优级白砂糖', 30, '太古', '优级白砂糖，甜度纯净，烘焙烹饪首选', 'https://img.alicdn.com/imgextra/i16/O1CN01白糖.jpg', 0, 730, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '白砂糖 500g', 'TW-BT-500G', 6.90, 8.90, 200, 20, 0, '件', '500g/袋', 1);

-- 料酒
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('葱姜料酒', 30, '王致和', '葱姜料酒，去腥提香，腌制烹饪必备', 'https://img.alicdn.com/imgextra/i17/O1CN01料酒.jpg', 0, 540, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '料酒 500ml', 'TW-LJ-500ML', 7.90, 9.90, 180, 18, 0, '件', '500ml/瓶', 1);

-- 醋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('山西老陈醋', 30, '紫林', '山西老陈醋，酸香醇厚，凉拌蘸饺子首选', 'https://img.alicdn.com/imgextra/i18/O1CN01醋.jpg', 0, 730, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '老陈醋 500ml', 'TW-CC-500ML', 12.90, 16.90, 120, 12, 0, '件', '500ml/瓶', 1);


-- ==================== 方便速食 (category_id=31) ====================

-- 方便面
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('康师傅红烧牛肉面', 31, '康师傅', '经典红烧牛肉面，浓郁汤底，方便快捷', 'https://img.alicdn.com/imgextra/i19/O1CN01方便面.jpg', 0, 180, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '红烧牛肉面 5连包', 'FM-BM-5', 13.90, 16.90, 200, 20, 0, '件', '5连包/袋', 1);

-- 螺蛳粉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('柳州螺蛳粉', 31, '好欢螺', '正宗柳州螺蛳粉，酸辣鲜爽，嗦粉上瘾', 'https://img.alicdn.com/imgextra/i20/O1CN01螺蛳粉.jpg', 0, 180, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '螺蛳粉 3包', 'FM-LSF-3', 29.90, 38.90, 150, 15, 0, '件', '3包/组', 1);

-- 自热火锅
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('自热小火锅', 31, '海底捞', '海底捞自热火锅，随时随地吃火锅', 'https://img.alicdn.com/imgextra/i21/O1CN01自热火锅.jpg', 0, 180, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '自热火锅 荤菜版', 'FM-ZRHG-1', 35.90, 45.90, 80, 10, 0, '件', '1盒/份', 1);

-- 速冻水饺
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('猪肉白菜水饺', 31, '湾仔码头', '手工包制水饺，皮薄馅大，早餐速食首选', 'https://img.alicdn.com/imgextra/i22/O1CN01水饺.jpg', 1, 90, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '水饺 500g', 'FM-SJ-500G', 19.90, 25.90, 100, 10, 0, '件', '500g/袋', 1);

-- 速冻汤圆
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('黑芝麻汤圆', 31, '湾仔码头', '香甜黑芝麻汤圆，软糯可口，元宵佳节必备', 'https://img.alicdn.com/imgextra/i23/O1CN01汤圆.jpg', 1, 90, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '汤圆 500g', 'FM-TY-500G', 16.90, 21.90, 100, 10, 0, '件', '500g/袋', 1);


-- ============================================
-- 第五批数据统计：
-- 米面杂粮 (id=28): 6个SPU, 7个SKU
-- 食用油 (id=29): 5个SPU, 6个SKU
-- 调味品 (id=30): 7个SPU, 7个SKU
-- 方便速食 (id=31): 5个SPU, 5个SKU
-- 合计：23个SPU, 25个SKU
-- ============================================
-- ============================================
-- 第六批商品数据：膨化食品、饼干糕点、坚果炒货、果干蜜饯
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 膨化食品 (category_id=32) ====================

-- 薯片
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('乐事原味薯片', 32, '乐事', '经典原味薯片，薄脆可口，追剧零食首选', 'https://img.alicdn.com/imgextra/i1/O1CN01薯片.jpg', 0, 270, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '原味薯片 75g', 'PH-SP-75G', 7.90, 9.90, 200, 20, 0, '件', '75g/袋', 1),
       (@spu1, '原味薯片 150g', 'PH-SP-150G', 13.90, 17.90, 120, 12, 0, '件', '150g/桶', 1);

-- 虾条
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('上好佳鲜虾片', 32, '上好佳', '经典鲜虾片，虾味浓郁，童年回忆', 'https://img.alicdn.com/imgextra/i2/O1CN01虾条.jpg', 0, 270, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '鲜虾片 80g', 'PH-XT-80G', 5.90, 7.90, 200, 20, 0, '件', '80g/袋', 1);

-- 爆米花
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('焦糖味爆米花', 32, '趣莱福', '电影院同款焦糖爆米花，酥脆香甜', 'https://img.alicdn.com/imgextra/i3/O1CN01爆米花.jpg', 0, 180, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '爆米花 108g', 'PH-BMH-108G', 12.90, 16.90, 100, 10, 0, '件', '108g/桶', 1);

-- 锅巴
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('小米锅巴', 32, '卧龙', '手工小米锅巴，麻辣鲜香，嘎嘣脆', 'https://img.alicdn.com/imgextra/i4/O1CN01锅巴.jpg', 0, 180, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '小米锅巴 108g', 'PH-GB-108G', 8.90, 11.90, 150, 15, 0, '件', '108g/袋', 1);

-- 膨化圈
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('旺旺仙贝', 32, '旺旺', '经典旺旺仙贝，米果酥脆，老少皆宜', 'https://img.alicdn.com/imgextra/i5/O1CN01仙贝.jpg', 0, 270, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '旺旺仙贝 52g*2包', 'PH-XB-52G2', 9.90, 12.90, 180, 18, 0, '件', '52g*2包/组', 1);


-- ==================== 饼干糕点 (category_id=33) ====================

-- 奥利奥
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('奥利奥夹心饼干', 33, '奥利奥', '经典扭一扭舔一舔泡一泡，巧克力夹心饼干', 'https://img.alicdn.com/imgextra/i6/O1CN01奥利奥.jpg', 0, 365, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '奥利奥 97g', 'BG-ALO-97G', 7.90, 9.90, 200, 20, 0, '件', '97g/包', 1),
       (@spu6, '奥利奥家庭装 303g', 'BG-ALO-303G', 16.90, 21.90, 100, 10, 0, '件', '303g/包', 1);

-- 好丽友派
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('好丽友·派', 33, '好丽友', '巧克力涂层棉花糖夹心，好朋友好丽友', 'https://img.alicdn.com/imgextra/i7/O1CN01好丽友.jpg', 0, 300, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '好丽友派 6枚装', 'BG-HLY-6', 13.90, 17.90, 120, 12, 0, '件', '6枚/盒', 1);

-- 蛋黄酥
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('手工蛋黄酥', 33, '轩妈', '手工制作蛋黄酥，酥皮层层分明，蛋黄流油', 'https://img.alicdn.com/imgextra/i8/O1CN01蛋黄酥.jpg', 0, 30, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '蛋黄酥 6枚装', 'BG-DHS-6', 29.90, 39.90, 80, 10, 0, '件', '6枚/盒', 1);

-- 面包
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('全麦吐司面包', 33, '桃李', '全麦吐司面包，低脂健康，早餐首选', 'https://img.alicdn.com/imgextra/i9/O1CN01面包.jpg', 0, 15, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '全麦吐司 400g', 'BG-QM-400G', 12.90, 16.90, 100, 10, 0, '件', '400g/袋', 1);

-- 华夫饼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('原味华夫饼', 33, '港荣', '松软华夫饼，奶香浓郁，下午茶点心', 'https://img.alicdn.com/imgextra/i10/O1CN01华夫饼.jpg', 0, 60, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '华夫饼 408g', 'BG-HFB-408G', 15.90, 19.90, 100, 10, 0, '件', '408g/箱', 1);

-- 月饼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('蛋黄莲蓉月饼', 33, '广州酒家', '经典广式蛋黄莲蓉月饼，中秋送礼首选', 'https://img.alicdn.com/imgextra/i11/O1CN01月饼.jpg', 0, 90, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '蛋黄莲蓉月饼 4个装', 'BG-YB-4', 68.90, 88.90, 50, 5, 0, '件', '4个/盒', 1);


-- ==================== 坚果炒货 (category_id=34) ====================

-- 每日坚果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('沃隆每日坚果', 34, '沃隆', '7日份每日坚果，科学配比，营养均衡', 'https://img.alicdn.com/imgextra/i12/O1CN01每日坚果.jpg', 0, 270, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '每日坚果 7日装', 'JG-MRJG-7', 29.90, 39.90, 100, 10, 0, '件', '25g*7袋/盒', 1),
       (@spu12, '每日坚果 30日装', 'JG-MRJG-30', 99.90, 129.90, 50, 5, 0, '件', '25g*30袋/盒', 1);

-- 碧根果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('美国碧根果', 34, '三只松鼠', '美国进口碧根果，奶香浓郁，易剥壳', 'https://img.alicdn.com/imgextra/i13/O1CN01碧根果.jpg', 0, 270, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '碧根果 210g', 'JG-BGG-210G', 19.90, 25.90, 100, 10, 0, '件', '210g/袋', 1);

-- 夏威夷果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('澳洲夏威夷果', 34, '三只松鼠', '澳洲进口夏威夷果，奶香四溢，送开壳器', 'https://img.alicdn.com/imgextra/i14/O1CN01夏威夷果.jpg', 0, 270, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '夏威夷果 200g', 'JG-XWYG-200G', 22.90, 29.90, 100, 10, 0, '件', '200g/袋', 1);

-- 腰果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('越南腰果', 34, '三只松鼠', '越南进口腰果，颗粒饱满，香脆可口', 'https://img.alicdn.com/imgextra/i15/O1CN01腰果.jpg', 0, 270, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '腰果 200g', 'JG-YG-200G', 19.90, 25.90, 100, 10, 0, '件', '200g/袋', 1);

-- 开心果
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('美国开心果', 34, '三只松鼠', '美国进口开心果，自然开口，原色原香', 'https://img.alicdn.com/imgextra/i16/O1CN01开心果.jpg', 0, 270, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '开心果 210g', 'JG-KXG-210G', 25.90, 32.90, 100, 10, 0, '件', '210g/袋', 1);

-- 瓜子
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('洽洽山核桃味瓜子', 34, '洽洽', '山核桃味瓜子，入味三分，越嗑越香', 'https://img.alicdn.com/imgextra/i17/O1CN01瓜子.jpg', 0, 270, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '瓜子 200g', 'JG-GZ-200G', 9.90, 12.90, 150, 15, 0, '件', '200g/袋', 1);

-- 巴旦木
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('加州巴旦木', 34, '三只松鼠', '美国加州巴旦木，颗粒饱满，香脆营养', 'https://img.alicdn.com/imgextra/i18/O1CN01巴旦木.jpg', 0, 270, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '巴旦木 200g', 'JG-BDM-200G', 19.90, 25.90, 100, 10, 0, '件', '200g/袋', 1);


-- ==================== 果干蜜饯 (category_id=35) ====================

-- 芒果干
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('芒果干', 35, '百草味', '泰芒制作芒果干，酸甜软糯，果香浓郁', 'https://img.alicdn.com/imgextra/i19/O1CN01芒果干.jpg', 0, 270, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '芒果干 108g', 'GG-MGG-108G', 12.90, 16.90, 150, 15, 0, '件', '108g/袋', 1);

-- 葡萄干
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新疆绿葡萄干', 35, '百草味', '新疆吐鲁番绿葡萄干，自然甜，无籽免洗', 'https://img.alicdn.com/imgextra/i20/O1CN01葡萄干.jpg', 0, 365, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '绿葡萄干 200g', 'GG-PTG-200G', 12.90, 16.90, 120, 12, 0, '件', '200g/袋', 1);

-- 草莓干
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('冻干草莓', 35, '百草味', 'FD冻干草莓，保留原味，酥脆酸甜', 'https://img.alicdn.com/imgextra/i21/O1CN01草莓干.jpg', 0, 270, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '冻干草莓 50g', 'GG-CMG-50G', 15.90, 19.90, 100, 10, 0, '件', '50g/罐', 1);

-- 红枣
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('新疆若羌红枣', 35, '百草味', '新疆若羌灰枣，皮薄肉厚，甘甜滋补', 'https://img.alicdn.com/imgextra/i22/O1CN01红枣.jpg', 0, 365, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '若羌红枣 500g', 'GG-HZ-500G', 19.90, 25.90, 100, 10, 0, '件', '500g/袋', 1);

-- 山楂片
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('山楂片', 35, '百草味', '酸甜山楂片，开胃消食，童年味道', 'https://img.alicdn.com/imgextra/i23/O1CN01山楂片.jpg', 0, 270, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '山楂片 108g', 'GG-SZP-108G', 8.90, 11.90, 150, 15, 0, '件', '108g/袋', 1);

-- 柿饼
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('富平柿饼', 35, '百草味', '陕西富平柿饼，软糯流心，甜蜜可口', 'https://img.alicdn.com/imgextra/i24/O1CN01柿饼.jpg', 0, 180, 1);
SET @spu24 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu24, '柿饼 250g', 'GG-SB-250G', 16.90, 22.90, 80, 10, 0, '件', '250g/盒', 1);


-- ============================================
-- 第六批数据统计：
-- 膨化食品 (id=32): 5个SPU, 6个SKU
-- 饼干糕点 (id=33): 6个SPU, 7个SKU
-- 坚果炒货 (id=34): 7个SPU, 8个SKU
-- 果干蜜饯 (id=35): 6个SPU, 6个SKU
-- 合计：24个SPU, 27个SKU
-- ============================================

-- ============================================
-- 第七批商品数据：饮用水、果汁饮料、乳制品、茶饮、口腔护理、身体护理、家庭清洁、纸品湿巾
-- 生成时间：2026-06-11
-- ============================================

-- ==================== 饮用水 (category_id=36) ====================

-- 矿泉水
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('百岁山矿泉水', 36, '百岁山', '天然矿泉水，富含矿物质，口感甘甜', 'https://img.alicdn.com/imgextra/i1/O1CN01矿泉水.jpg', 0, 365, 1);
SET @spu1 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu1, '百岁山 570ml*24瓶', 'YS-KS-24', 39.90, 49.90, 100, 10, 0, '件', '570ml*24瓶/箱', 1);

-- 纯净水
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('怡宝纯净水', 36, '怡宝', '纯净水，清冽甘甜，日常饮用首选', 'https://img.alicdn.com/imgextra/i2/O1CN01纯净水.jpg', 0, 365, 1);
SET @spu2 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu2, '怡宝 555ml*24瓶', 'YS-CJS-24', 29.90, 38.90, 120, 12, 0, '件', '555ml*24瓶/箱', 1);

-- 苏打水
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('屈臣氏苏打水', 36, '屈臣氏', '无糖苏打水，清爽解腻，调酒必备', 'https://img.alicdn.com/imgextra/i3/O1CN01苏打水.jpg', 0, 540, 1);
SET @spu3 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu3, '苏打水 330ml*6罐', 'YS-SDS-6', 19.90, 25.90, 80, 10, 0, '件', '330ml*6罐/组', 1);

-- 气泡水
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('巴黎水气泡水', 36, '巴黎水', '法国进口天然气泡水，口感细腻，高端饮品', 'https://img.alicdn.com/imgextra/i4/O1CN01气泡水.jpg', 0, 540, 1);
SET @spu4 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu4, '巴黎水 330ml*4瓶', 'YS-QPS-4', 29.90, 39.90, 60, 8, 0, '件', '330ml*4瓶/组', 1);


-- ==================== 果汁饮料 (category_id=37) ====================

-- 鲜橙多
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('统一鲜橙多', 37, '统一', '鲜橙多果汁饮料，维C满满，酸甜可口', 'https://img.alicdn.com/imgextra/i5/O1CN01鲜橙多.jpg', 0, 365, 1);
SET @spu5 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu5, '鲜橙多 450ml*15瓶', 'GZ-XCD-15', 39.90, 49.90, 80, 10, 0, '件', '450ml*15瓶/箱', 1);

-- 果粒橙
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('美汁源果粒橙', 37, '美汁源', '含真实果粒的橙汁饮料，口感丰富', 'https://img.alicdn.com/imgextra/i6/O1CN01果粒橙.jpg', 0, 365, 1);
SET @spu6 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu6, '果粒橙 450ml*15瓶', 'GZ-GLC-15', 42.90, 55.90, 80, 10, 0, '件', '450ml*15瓶/箱', 1);

-- 椰汁
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('椰树椰汁', 37, '椰树', '正宗海南椰汁，天然椰香，老少皆宜', 'https://img.alicdn.com/imgextra/i7/O1CN01椰汁.jpg', 0, 365, 1);
SET @spu7 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu7, '椰汁 245ml*24罐', 'GZ-YZ-24', 59.90, 75.90, 60, 8, 0, '件', '245ml*24罐/箱', 1);

-- 凉茶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('王老吉凉茶', 37, '王老吉', '怕上火喝王老吉，草本凉茶，清热降火', 'https://img.alicdn.com/imgextra/i8/O1CN01凉茶.jpg', 0, 540, 1);
SET @spu8 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu8, '王老吉 310ml*24罐', 'GZ-LC-24', 59.90, 75.90, 60, 8, 0, '件', '310ml*24罐/箱', 1);

-- 可乐
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('可口可乐', 37, '可口可乐', '经典可口可乐，畅爽解渴，聚会必备', 'https://img.alicdn.com/imgextra/i9/O1CN01可乐.jpg', 0, 365, 1);
SET @spu9 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu9, '可乐 330ml*24罐', 'GZ-KL-24', 49.90, 62.90, 80, 10, 0, '件', '330ml*24罐/箱', 1);


-- ==================== 乳制品 (category_id=38) ====================

-- 纯牛奶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('特仑苏纯牛奶', 38, '特仑苏', '醇香浓郁特仑苏，3.6g优质乳蛋白', 'https://img.alicdn.com/imgextra/i10/O1CN01纯牛奶.jpg', 1, 180, 1);
SET @spu10 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu10, '特仑苏 250ml*12盒', 'RZ-CHN-12', 59.90, 75.90, 80, 10, 0, '件', '250ml*12盒/箱', 1);

-- 酸奶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('安慕希酸奶', 38, '安慕希', '希腊风味酸奶，浓稠丝滑，美味健康', 'https://img.alicdn.com/imgextra/i11/O1CN01酸奶.jpg', 1, 180, 1);
SET @spu11 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu11, '安慕希 205g*12盒', 'RZ-SN-12', 55.90, 69.90, 80, 10, 0, '件', '205g*12盒/箱', 1);

-- 鲜牛奶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('每日鲜语鲜牛奶', 38, '每日鲜语', '巴氏杀菌鲜牛奶，7天保质期，新鲜直达', 'https://img.alicdn.com/imgextra/i12/O1CN01鲜牛奶.jpg', 1, 7, 1);
SET @spu12 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu12, '鲜牛奶 720ml', 'RZ-XNN-720ML', 15.90, 19.90, 100, 10, 0, '件', '720ml/瓶', 1);

-- 奶酪棒
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('百吉福奶酪棒', 38, '百吉福', '儿童奶酪棒，高钙营养，好吃又健康', 'https://img.alicdn.com/imgextra/i13/O1CN01奶酪棒.jpg', 1, 270, 1);
SET @spu13 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu13, '奶酪棒 5支装', 'RZ-NLB-5', 19.90, 25.90, 100, 10, 0, '件', '5支/袋', 1);

-- 奶粉
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('全脂奶粉', 38, '雀巢', '新西兰进口奶源全脂奶粉，香浓顺滑', 'https://img.alicdn.com/imgextra/i14/O1CN01奶粉.jpg', 0, 730, 1);
SET @spu14 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu14, '全脂奶粉 400g', 'RZ-NF-400G', 39.90, 49.90, 60, 8, 0, '件', '400g/袋', 1);


-- ==================== 茶饮 (category_id=39) ====================

-- 绿茶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('西湖龙井绿茶', 39, '卢正浩', '明前西湖龙井，豆香清雅，回味甘甜', 'https://img.alicdn.com/imgextra/i15/O1CN01龙井.jpg', 0, 365, 1);
SET @spu15 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu15, '龙井 100g罐装', 'CY-LJ-100G', 89.90, 119.90, 50, 5, 0, '件', '100g/罐', 1);

-- 红茶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('正山小种红茶', 39, '正山堂', '武夷山正山小种，松烟香桂圆味，红茶经典', 'https://img.alicdn.com/imgextra/i16/O1CN01红茶.jpg', 0, 730, 1);
SET @spu16 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu16, '正山小种 100g', 'CY-HC-100G', 69.90, 89.90, 50, 5, 0, '件', '100g/罐', 1);

-- 茉莉花茶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('茉莉花茶', 39, '吴裕泰', '七窨茉莉花茶，花香鲜灵，茶味醇厚', 'https://img.alicdn.com/imgextra/i17/O1CN01茉莉花茶.jpg', 0, 365, 1);
SET @spu17 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu17, '茉莉花茶 200g', 'CY-MLHC-200G', 39.90, 49.90, 80, 10, 0, '件', '200g/罐', 1);

-- 普洱茶
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('云南普洱熟茶', 39, '大益', '云南勐海普洱熟茶，陈香醇厚，养胃暖身', 'https://img.alicdn.com/imgextra/i18/O1CN01普洱茶.jpg', 0, 1825, 1);
SET @spu18 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu18, '普洱茶 357g饼', 'CY-PEC-357G', 79.90, 99.90, 40, 5, 0, '件', '357g/饼', 1);

-- 茶饮料
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('东方树叶茉莉花茶', 39, '东方树叶', '0糖0卡0脂，纯茶萃取，健康茶饮', 'https://img.alicdn.com/imgextra/i19/O1CN01东方树叶.jpg', 0, 365, 1);
SET @spu19 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu19, '东方树叶 500ml*15瓶', 'CY-DFSC-15', 49.90, 62.90, 80, 10, 0, '件', '500ml*15瓶/箱', 1);


-- ==================== 口腔护理 (category_id=40) ====================

-- 牙膏
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('云南白药牙膏', 40, '云南白药', '含云南白药活性成分，护龈固齿', 'https://img.alicdn.com/imgextra/i20/O1CN01牙膏.jpg', 0, 1095, 1);
SET @spu20 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu20, '云南白药 180g', 'KQ-YG-180G', 29.90, 38.90, 150, 15, 0, '件', '180g/支', 1);

-- 牙刷
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('软毛牙刷', 40, '狮王', '日本狮王超细软毛牙刷，呵护牙龈', 'https://img.alicdn.com/imgextra/i21/O1CN01牙刷.jpg', 0, 1095, 1);
SET @spu21 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu21, '软毛牙刷 2支装', 'KQ-YS-2', 19.90, 25.90, 150, 15, 0, '件', '2支/组', 1);

-- 漱口水
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('李施德林漱口水', 40, '李施德林', '冰蓝零度漱口水，杀菌清新口气', 'https://img.alicdn.com/imgextra/i22/O1CN01漱口水.jpg', 0, 730, 1);
SET @spu22 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu22, '漱口水 250ml', 'KQ-SSS-250ML', 25.90, 32.90, 100, 10, 0, '件', '250ml/瓶', 1);


-- ==================== 身体护理 (category_id=41) ====================

-- 沐浴露
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('力士沐浴露', 41, '力士', '恒久嫩肤沐浴露，持久留香，肌肤丝滑', 'https://img.alicdn.com/imgextra/i23/O1CN01沐浴露.jpg', 0, 1095, 1);
SET @spu23 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu23, '沐浴露 750ml', 'ST-MYL-750ML', 29.90, 38.90, 120, 12, 0, '件', '750ml/瓶', 1);

-- 洗手液
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('滴露洗手液', 41, '滴露', '抑菌洗手液，有效抑菌99.9%，温和不伤手', 'https://img.alicdn.com/imgextra/i24/O1CN01洗手液.jpg', 0, 1095, 1);
SET @spu24 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu24, '洗手液 500ml', 'ST-XSY-500ML', 19.90, 25.90, 150, 15, 0, '件', '500ml/瓶', 1);

-- 身体乳
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('凡士林身体乳', 41, '凡士林', '倍护特润身体乳，深层滋润，秋冬必备', 'https://img.alicdn.com/imgextra/i25/O1CN01身体乳.jpg', 0, 1095, 1);
SET @spu25 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu25, '身体乳 400ml', 'ST-STR-400ML', 35.90, 45.90, 100, 10, 0, '件', '400ml/瓶', 1);

-- 毛巾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('纯棉毛巾', 41, '洁丽雅', '新疆长绒棉毛巾，柔软吸水，亲肤舒适', 'https://img.alicdn.com/imgextra/i26/O1CN01毛巾.jpg', 0, 0, 1);
SET @spu26 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu26, '毛巾 2条装', 'ST-MJ-2', 25.90, 32.90, 150, 15, 0, '件', '2条/组', 1);


-- ==================== 家庭清洁 (category_id=42) ====================

-- 洗洁精
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('立白洗洁精', 42, '立白', '生姜洗洁精，去油除腥，易冲洗无残留', 'https://img.alicdn.com/imgextra/i27/O1CN01洗洁精.jpg', 0, 1095, 1);
SET @spu27 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu27, '洗洁精 1.5kg', 'JQ-XJJ-1.5KG', 15.90, 19.90, 150, 15, 0, '件', '1.5kg/瓶', 1);

-- 洗衣液
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('蓝月亮洗衣液', 42, '蓝月亮', '深层洁净洗衣液，亮白增艳，温和护手', 'https://img.alicdn.com/imgextra/i28/O1CN01洗衣液.jpg', 0, 1095, 1);
SET @spu28 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu28, '洗衣液 2kg', 'JQ-XY-2KG', 29.90, 39.90, 120, 12, 0, '件', '2kg/瓶', 1);

-- 消毒液
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('84消毒液', 42, '龙安', '含氯消毒液，杀菌消毒，家居必备', 'https://img.alicdn.com/imgextra/i29/O1CN01消毒液.jpg', 0, 365, 1);
SET @spu29 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu29, '消毒液 1L', 'JQ-XDY-1L', 12.90, 16.90, 100, 10, 0, '件', '1L/瓶', 1);

-- 垃圾袋
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('抽绳垃圾袋', 42, '妙洁', '加厚抽绳垃圾袋，一拉收口，方便卫生', 'https://img.alicdn.com/imgextra/i30/O1CN01垃圾袋.jpg', 0, 0, 1);
SET @spu30 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu30, '垃圾袋 3卷60只', 'JQ-LJD-60', 12.90, 16.90, 200, 20, 0, '件', '60只/3卷', 1);

-- 保鲜膜
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('保鲜膜', 42, '妙洁', '食品级PE保鲜膜，锁鲜防串味', 'https://img.alicdn.com/imgextra/i31/O1CN01保鲜膜.jpg', 0, 0, 1);
SET @spu31 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu31, '保鲜膜 30cm*30m', 'JQ-BXM-30M', 9.90, 12.90, 150, 15, 0, '件', '30m/卷', 1);


-- ==================== 纸品湿巾 (category_id=43) ====================

-- 抽纸
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('维达抽纸', 43, '维达', '超韧抽纸，湿水不易破，柔软亲肤', 'https://img.alicdn.com/imgextra/i32/O1CN01抽纸.jpg', 0, 1095, 1);
SET @spu32 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu32, '抽纸 3层120抽*10包', 'ZP-CZ-10', 29.90, 38.90, 150, 15, 0, '件', '10包/提', 1);

-- 卷纸
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('维达卷纸', 43, '维达', '蓝色经典卷纸，4层加厚，柔韧亲肤', 'https://img.alicdn.com/imgextra/i33/O1CN01卷纸.jpg', 0, 1095, 1);
SET @spu33 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu33, '卷纸 4层200g*12卷', 'ZP-JZ-12', 29.90, 39.90, 150, 15, 0, '件', '12卷/提', 1);

-- 湿巾
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('婴儿湿巾', 43, '全棉时代', '纯棉婴儿湿巾，温和无刺激，手口专用', 'https://img.alicdn.com/imgextra/i34/O1CN01湿巾.jpg', 0, 730, 1);
SET @spu34 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu34, '湿巾 80抽*5包', 'ZP-SJ-5', 25.90, 32.90, 150, 15, 0, '件', '5包/组', 1);

-- 厨房纸
INSERT INTO spu (name, category_id, brand, description, main_image, is_cold_chain, shelf_life, status)
VALUES ('厨房纸巾', 43, '维达', '厨房专用纸巾，强力吸油吸水', 'https://img.alicdn.com/imgextra/i35/O1CN01厨房纸.jpg', 0, 1095, 1);
SET @spu35 = LAST_INSERT_ID();
INSERT INTO sku (spu_id, sku_name, sku_code, price, original_price, stock, warning_stock, is_bulk_weight, price_unit, weight_desc, status)
VALUES (@spu35, '厨房纸 75抽*6包', 'ZP-CFZ-6', 19.90, 25.90, 120, 12, 0, '件', '6包/组', 1);


-- ============================================
-- 第七批数据统计：
-- 饮用水 (id=36): 4个SPU, 4个SKU
-- 果汁饮料 (id=37): 5个SPU, 5个SKU
-- 乳制品 (id=38): 5个SPU, 5个SKU
-- 茶饮 (id=39): 5个SPU, 5个SKU
-- 口腔护理 (id=40): 3个SPU, 3个SKU
-- 身体护理 (id=41): 4个SPU, 4个SKU
-- 家庭清洁 (id=42): 5个SPU, 5个SKU
-- 纸品湿巾 (id=43): 4个SPU, 4个SKU
-- 合计：35个SPU, 35个SKU
-- ============================================
