-- 公安证据与枪械管理平台 - 种子数据
-- 使用 INSERT IGNORE 保证多次启动不报主键冲突（schema.sql 用了 IF NOT EXISTS，表不会重建）

-- ==================== 仓库库位初始化数据 ====================

-- 1. 仓库
INSERT IGNORE INTO warehouses (id, code, name, address, description, status) VALUES
  (1, 'WZ-CK-A', '物证仓A', '刑侦楼1层西侧', '主要存放普通物证和生物检材', 'ACTIVE'),
  (2, 'WZ-CK-B', '物证仓B', '刑侦楼1层东侧', '存放危险品、枪支弹药等特殊物证', 'ACTIVE');

-- 2. 库区
INSERT IGNORE INTO warehouse_zones (id, warehouse_id, code, name, zone_type, description, status) VALUES
  (1, 1, 'A-NORMAL', '普通物证区', 'NORMAL', '存放一般物证', 'ACTIVE'),
  (2, 1, 'A-BIO', '生物检材区', 'REFRIGERATED', '冷藏存放生物检材', 'ACTIVE'),
  (3, 1, 'A-ELEC', '电子物证区', 'ELECTRONIC', '存放电子设备', 'ACTIVE'),
  (4, 2, 'B-DANGER', '危险品区', 'DANGEROUS', '存放易燃易爆、有毒有害物品', 'ACTIVE'),
  (5, 2, 'B-FIREARM', '枪械区', 'FIREARM', '存放枪支弹药', 'ACTIVE');

-- 3. 货架
INSERT IGNORE INTO warehouse_racks (id, zone_id, code, name, rows_count, columns_count, sort_order, description, status) VALUES
  (1, 1, 'A-N-R01', 'A普通区1号货架', 5, 4, 1, '', 'ACTIVE'),
  (2, 1, 'A-N-R02', 'A普通区2号货架', 5, 4, 2, '', 'ACTIVE'),
  (3, 2, 'A-B-R01', 'A生物区1号货架', 4, 3, 1, '冷藏货架', 'ACTIVE'),
  (4, 3, 'A-E-R01', 'A电子区1号货架', 5, 4, 1, '防静电货架', 'ACTIVE'),
  (5, 4, 'B-D-R01', 'B危险品区1号货架', 3, 2, 1, '防爆货架', 'ACTIVE'),
  (6, 5, 'B-F-R01', 'B枪械区1号货架', 5, 3, 1, '枪柜', 'ACTIVE');

-- 4. 库位（自动生成每个货架的库位）
-- A-N-R01: 5层 x 4列 = 20个库位，容量3
INSERT IGNORE INTO warehouse_slots (id, rack_id, code, row_num, col_num, capacity, occupied_count, slot_type, description, status, version) VALUES
  (1, 1, 'A-N-01-01', 1, 1, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (2, 1, 'A-N-01-02', 1, 2, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (3, 1, 'A-N-01-03', 1, 3, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (4, 1, 'A-N-01-04', 1, 4, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (5, 1, 'A-N-02-01', 2, 1, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (6, 1, 'A-N-02-02', 2, 2, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (7, 1, 'A-N-02-03', 2, 3, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (8, 1, 'A-N-02-04', 2, 4, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (9, 1, 'A-N-03-01', 3, 1, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (10, 1, 'A-N-03-02', 3, 2, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (11, 1, 'A-N-03-03', 3, 3, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (12, 1, 'A-N-03-04', 3, 4, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (13, 1, 'A-N-04-01', 4, 1, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (14, 1, 'A-N-04-02', 4, 2, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (15, 1, 'A-N-04-03', 4, 3, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (16, 1, 'A-N-04-04', 4, 4, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (17, 1, 'A-N-05-01', 5, 1, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (18, 1, 'A-N-05-02', 5, 2, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (19, 1, 'A-N-05-03', 5, 3, 3, 0, 'NORMAL', '', 'ACTIVE', 0),
  (20, 1, 'A-N-05-04', 5, 4, 3, 0, 'NORMAL', '', 'ACTIVE', 0);

-- A-B-R01: 4层 x 3列 = 12个库位，容量2（生物检材）
INSERT IGNORE INTO warehouse_slots (id, rack_id, code, row_num, col_num, capacity, occupied_count, slot_type, description, status, version) VALUES
  (21, 3, 'A-B-01-01', 1, 1, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (22, 3, 'A-B-01-02', 1, 2, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (23, 3, 'A-B-01-03', 1, 3, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (24, 3, 'A-B-02-01', 2, 1, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (25, 3, 'A-B-02-02', 2, 2, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (26, 3, 'A-B-02-03', 2, 3, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (27, 3, 'A-B-03-01', 3, 1, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (28, 3, 'A-B-03-02', 3, 2, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (29, 3, 'A-B-03-03', 3, 3, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (30, 3, 'A-B-04-01', 4, 1, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (31, 3, 'A-B-04-02', 4, 2, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0),
  (32, 3, 'A-B-04-03', 4, 3, 2, 0, 'REFRIGERATED', '', 'ACTIVE', 0);

-- A-E-R01: 5层 x 4列 = 20个库位，容量4（电子物证）
INSERT IGNORE INTO warehouse_slots (id, rack_id, code, row_num, col_num, capacity, occupied_count, slot_type, description, status, version) VALUES
  (33, 4, 'A-E-01-01', 1, 1, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (34, 4, 'A-E-01-02', 1, 2, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (35, 4, 'A-E-01-03', 1, 3, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (36, 4, 'A-E-01-04', 1, 4, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (37, 4, 'A-E-02-01', 2, 1, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (38, 4, 'A-E-02-02', 2, 2, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (39, 4, 'A-E-02-03', 2, 3, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (40, 4, 'A-E-02-04', 2, 4, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (41, 4, 'A-E-03-01', 3, 1, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (42, 4, 'A-E-03-02', 3, 2, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (43, 4, 'A-E-03-03', 3, 3, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (44, 4, 'A-E-03-04', 3, 4, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (45, 4, 'A-E-04-01', 4, 1, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (46, 4, 'A-E-04-02', 4, 2, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (47, 4, 'A-E-04-03', 4, 3, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (48, 4, 'A-E-04-04', 4, 4, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (49, 4, 'A-E-05-01', 5, 1, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (50, 4, 'A-E-05-02', 5, 2, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (51, 4, 'A-E-05-03', 5, 3, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0),
  (52, 4, 'A-E-05-04', 5, 4, 4, 0, 'ANTI_STATIC', '', 'ACTIVE', 0);

-- B-D-R01: 3层 x 2列 = 6个库位，容量1（危险品单独存放）
INSERT IGNORE INTO warehouse_slots (id, rack_id, code, row_num, col_num, capacity, occupied_count, slot_type, description, status, version) VALUES
  (53, 5, 'B-D-01-01', 1, 1, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0),
  (54, 5, 'B-D-01-02', 1, 2, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0),
  (55, 5, 'B-D-02-01', 2, 1, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0),
  (56, 5, 'B-D-02-02', 2, 2, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0),
  (57, 5, 'B-D-03-01', 3, 1, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0),
  (58, 5, 'B-D-03-02', 3, 2, 1, 0, 'EXPLOSION_PROOF', '', 'ACTIVE', 0);

-- B-F-R01: 5层 x 3列 = 15个库位，容量5（枪械）
INSERT IGNORE INTO warehouse_slots (id, rack_id, code, row_num, col_num, capacity, occupied_count, slot_type, description, status, version) VALUES
  (59, 6, 'B-F-01-01', 1, 1, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (60, 6, 'B-F-01-02', 1, 2, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (61, 6, 'B-F-01-03', 1, 3, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (62, 6, 'B-F-02-01', 2, 1, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (63, 6, 'B-F-02-02', 2, 2, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (64, 6, 'B-F-02-03', 2, 3, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (65, 6, 'B-F-03-01', 3, 1, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (66, 6, 'B-F-03-02', 3, 2, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (67, 6, 'B-F-03-03', 3, 3, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (68, 6, 'B-F-04-01', 4, 1, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (69, 6, 'B-F-04-02', 4, 2, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (70, 6, 'B-F-04-03', 4, 3, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (71, 6, 'B-F-05-01', 5, 1, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (72, 6, 'B-F-05-02', 5, 2, 5, 0, 'ARMORED', '', 'ACTIVE', 0),
  (73, 6, 'B-F-05-03', 5, 3, 5, 0, 'ARMORED', '', 'ACTIVE', 0);

-- 5. 库区类别约束
-- 普通物证区拒绝存放特殊类别（只能放普通类别）
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (13, 1, 'BIOLOGICAL', 'DENY'),
  (14, 1, 'ELECTRONIC', 'DENY'),
  (15, 1, 'DANGEROUS', 'DENY'),
  (16, 1, 'EXPLOSIVE', 'DENY'),
  (17, 1, 'FLAMMABLE', 'DENY'),
  (18, 1, 'TOXIC', 'DENY'),
  (19, 1, 'FIREARM', 'DENY'),
  (20, 1, 'AMMO', 'DENY'),
  (21, 1, 'OXIDIZER', 'DENY');

-- 生物检材区只允许放BIOLOGICAL
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (1, 2, 'BIOLOGICAL', 'ALLOW');

-- 危险品区只允许放DANGEROUS、EXPLOSIVE、FLAMMABLE、TOXIC
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (2, 4, 'DANGEROUS', 'ALLOW'),
  (3, 4, 'EXPLOSIVE', 'ALLOW'),
  (4, 4, 'FLAMMABLE', 'ALLOW'),
  (5, 4, 'TOXIC', 'ALLOW');

-- 危险品区拒绝放普通类别
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (6, 4, 'WEAPON', 'DENY'),
  (7, 4, 'ELECTRONIC', 'DENY'),
  (8, 4, 'DOCUMENT', 'DENY'),
  (9, 4, 'OTHER', 'DENY');

-- 枪械区只允许放FIREARM、AMMO
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (10, 5, 'FIREARM', 'ALLOW'),
  (11, 5, 'AMMO', 'ALLOW');

-- 电子物证区只允许放ELECTRONIC
INSERT IGNORE INTO zone_category_restrictions (id, zone_id, category, restriction_type) VALUES
  (12, 3, 'ELECTRONIC', 'ALLOW');

-- 6. 隔离规则（不能混放的类别）
INSERT IGNORE INTO category_isolation_rules (id, category_a, category_b, rule_type, description) VALUES
  (1, 'FLAMMABLE', 'OXIDIZER', 'NO_MIX', '易燃物与氧化剂不能混放'),
  (2, 'FLAMMABLE', 'TOXIC', 'NO_MIX', '易燃物与有毒物不能混放'),
  (3, 'EXPLOSIVE', 'FLAMMABLE', 'NO_MIX', '爆炸物与易燃物不能混放'),
  (4, 'BIOLOGICAL', 'OTHER', 'NO_MIX', '生物检材不能与普通物证混放'),
  (5, 'FIREARM', 'AMMO', 'NO_MIX', '枪支与弹药不能混放（分库存放）');

-- ==================== 原有种子数据 ====================

INSERT IGNORE INTO officers (id, police_no, name, department, rank_title, status) VALUES
  (1, '030001', '王建国', '刑侦支队', '一级警督', 'ACTIVE'),
  (2, '030002', '李志强', '刑侦支队', '二级警司', 'ACTIVE'),
  (3, '030003', '赵晓敏', '物证管理科', '三级警长', 'ACTIVE'),
  (4, '030004', '陈海涛', '特巡警支队', '一级警司', 'ACTIVE');

INSERT IGNORE INTO evidence (id, evidence_no, case_no, name, category, description, status, location, registered_by) VALUES
  (1, 'WZ-2026-0001', 'AJ-2026-0101', '作案匕首一把', 'WEAPON', '案发现场提取的折叠匕首', 'IN_STORAGE', '物证仓A-03', 3),
  (2, 'WZ-2026-0002', 'AJ-2026-0101', '血迹样本', 'BIOLOGICAL', '现场地面血迹棉签提取', 'IN_STORAGE', '物证仓A-04', 3),
  (3, 'WZ-2026-0003', 'AJ-2026-0205', '涉案手机一部', 'ELECTRONIC', '黑色智能手机，待数据勘验', 'REGISTERED', '暂存柜B-11', 2);

INSERT IGNORE INTO custody_records (id, evidence_id, action, from_officer, to_officer, remark, occurred_at) VALUES
  (1, 1, 'REGISTER', NULL, 3, '入库登记', '2026-05-20 09:00:00.000'),
  (2, 2, 'REGISTER', NULL, 3, '入库登记', '2026-05-20 09:10:00.000'),
  (3, 3, 'REGISTER', NULL, 2, '暂存登记', '2026-05-22 14:30:00.000');

INSERT IGNORE INTO firearms (id, serial_no, model, type, caliber, status) VALUES
  (1, 'QX-77-100231', '92式手枪', 'PISTOL', '9mm', 'IN_STORE'),
  (2, 'QX-77-100232', '92式手枪', 'PISTOL', '9mm', 'ISSUED'),
  (3, 'QX-79-200145', '79式微冲', 'SUBMACHINE_GUN', '7.62mm', 'IN_STORE');

INSERT IGNORE INTO firearm_issuances (id, firearm_id, officer_id, purpose, ammo_issued, issued_at, due_at, status) VALUES
  (1, 2, 4, '武装巡逻执勤', 15, '2026-06-01 08:00:00.000', '2026-06-01 20:00:00.000', 'ISSUED');

-- ==================== 数据迁移：将现有物证映射到具体库位 ====================

-- 物证1: 作案匕首 (WEAPON) -> 普通物证区 A-N-01-03 (id=3)
UPDATE evidence SET slot_id = 3, location = 'A-N-01-03' WHERE id = 1;
INSERT IGNORE INTO slot_evidence_placement (id, slot_id, evidence_id, placed_at, placed_by, remark) VALUES
  (1, 3, 1, '2026-05-20 09:00:00.000', 3, '数据迁移-历史数据上架');
UPDATE warehouse_slots SET occupied_count = 1 WHERE id = 3;

-- 物证2: 血迹样本 (BIOLOGICAL) -> 生物检材区 A-B-01-01 (id=21)
UPDATE evidence SET slot_id = 21, location = 'A-B-01-01' WHERE id = 2;
INSERT IGNORE INTO slot_evidence_placement (id, slot_id, evidence_id, placed_at, placed_by, remark) VALUES
  (2, 21, 2, '2026-05-20 09:10:00.000', 3, '数据迁移-历史数据上架');
UPDATE warehouse_slots SET occupied_count = 1 WHERE id = 21;

-- 物证3: 涉案手机 (ELECTRONIC) -> 电子物证区 A-E-01-01 (id=33)
UPDATE evidence SET slot_id = 33, location = 'A-E-01-01' WHERE id = 3;
INSERT IGNORE INTO slot_evidence_placement (id, slot_id, evidence_id, placed_at, placed_by, remark) VALUES
  (3, 33, 3, '2026-05-22 14:30:00.000', 2, '数据迁移-历史数据上架');
UPDATE warehouse_slots SET occupied_count = 1 WHERE id = 33;
