-- 确保左侧菜单数据已存在
INSERT INTO left_side_menu (id, type, type_name, order_num, create_time) VALUES
(1, 'new', '新品种草', 1, NOW()),
(2, 'super', '超级蔬食', 2, NOW()),
(3, 'light', '轻乳茶', 3, NOW()),
(4, 'signature', '招牌奶茶', 4, NOW()),
(5, 'member', '会员随心配', 5, NOW()),
(6, 'fresh', '清爽鲜果茶', 6, NOW());

-- 添加菜单数据
INSERT INTO menu (left_side_menu_id, menu_name, money, order_num, create_time, `explain`) VALUES
-- 新品种草
(1, '乌漆嘛黑', '15', 1, NOW(), '优选甜度≥8°的完熟桑葚颗颗手剥，搭配香水柠檬、风梨'),
(1, '三重莓果·晚安杯', '22', 2, NOW(), '优选三种新鲜超级食物——蓝莓、草莓、桑葚'),
(1, '芝芝莓莓', '19', 3, NOW(), '选用浓郁芝士与新鲜草莓调制而成'),

-- 超级蔬食
(2, '奇异果优格', '18', 1, NOW(), '新西兰奇异果搭配希腊酸奶，清爽可口'),
(2, '蔬菜轻食沙拉', '25', 2, NOW(), '新鲜蔬菜、藜麦、鸡胸肉，健康低卡'),
(2, '牛油果三明治', '20', 3, NOW(), '牛油果、全麦面包、鸡蛋，营养丰富'),

-- 轻乳茶
(3, '芝士奶盖茉莉', '16', 1, NOW(), '芝士奶盖搭配清香茉莉，层次丰富'),
(3, '轻盈奶茶', '14', 2, NOW(), '低糖低脂，口感轻盈不腻'),
(3, '乌龙轻奶茶', '15', 3, NOW(), '乌龙茶底搭配轻盈奶泡，回甘持久'),

-- 招牌奶茶
(4, '经典奶茶', '12', 1, NOW(), '经典配方，浓郁香醇'),
(4, '黑糖珍珠奶茶', '16', 2, NOW(), '黑糖珍珠，嚼劲十足'),
(4, '红豆奶茶', '15', 3, NOW(), '红豆与奶茶的完美结合，香甜可口'),

-- 会员随心配
(5, '会员特调', '18', 1, NOW(), '会员专属定制，可选糖度冰度'),
(5, '会员专享奶茶', '20', 2, NOW(), '特别配方，仅限会员购买'),
(5, '会员限定果茶', '22', 3, NOW(), '季节限定水果，会员专享'),

-- 清爽鲜果茶
(6, '满杯百香果', '17', 1, NOW(), '新鲜百香果，酸甜可口'),
(6, '柠檬绿茶', '14', 2, NOW(), '鲜榨柠檬汁与绿茶的清爽组合'),
(6, '蜜桃乌龙', '16', 3, NOW(), '蜜桃果肉与乌龙茶的香甜搭配'); 