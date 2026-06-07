-- 公安证据与枪械管理平台 - 表结构（MySQL）

-- ==================== 仓库库位管理 ====================

CREATE TABLE IF NOT EXISTS warehouses (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    code            VARCHAR(32)  NOT NULL COMMENT '仓库编码',
    name            VARCHAR(128) NOT NULL COMMENT '仓库名称',
    address         VARCHAR(255) NOT NULL DEFAULT '' COMMENT '地址',
    description     VARCHAR(500) NOT NULL DEFAULT '' COMMENT '描述',
    status          VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-启用,DISABLED-禁用',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_warehouses_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='仓库表';

CREATE TABLE IF NOT EXISTS warehouse_zones (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    warehouse_id    BIGINT       NOT NULL COMMENT '所属仓库ID',
    code            VARCHAR(32)  NOT NULL COMMENT '库区编码',
    name            VARCHAR(128) NOT NULL COMMENT '库区名称',
    zone_type       VARCHAR(32)  NOT NULL DEFAULT 'NORMAL' COMMENT '库区类型：NORMAL-普通区,REFRIGERATED-冷藏区,DANGEROUS-危险品区,FIREARM-枪械区,ELECTRONIC-电子物证区',
    description     VARCHAR(500) NOT NULL DEFAULT '' COMMENT '描述',
    status          VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_zones_warehouse_code (warehouse_id, code),
    CONSTRAINT fk_zones_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库区表';

CREATE TABLE IF NOT EXISTS warehouse_racks (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    zone_id         BIGINT       NOT NULL COMMENT '所属库区ID',
    code            VARCHAR(32)  NOT NULL COMMENT '货架编码',
    name            VARCHAR(128) NOT NULL COMMENT '货架名称',
    rows_count      INT          NOT NULL DEFAULT 5 COMMENT '层数',
    columns_count   INT          NOT NULL DEFAULT 4 COMMENT '列数',
    sort_order      INT          NOT NULL DEFAULT 0 COMMENT '排序',
    description     VARCHAR(500) NOT NULL DEFAULT '' COMMENT '描述',
    status          VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_racks_zone_code (zone_id, code),
    CONSTRAINT fk_racks_zone FOREIGN KEY (zone_id) REFERENCES warehouse_zones (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='货架表';

CREATE TABLE IF NOT EXISTS warehouse_slots (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    rack_id         BIGINT       NOT NULL COMMENT '所属货架ID',
    code            VARCHAR(32)  NOT NULL COMMENT '库位编码，全局唯一',
    row_num         INT          NOT NULL DEFAULT 1 COMMENT '行号（层）',
    col_num         INT          NOT NULL DEFAULT 1 COMMENT '列号',
    capacity        INT          NOT NULL DEFAULT 1 COMMENT '容量（可放物证件数）',
    occupied_count  INT          NOT NULL DEFAULT 0 COMMENT '当前占用数',
    slot_type       VARCHAR(32)  NOT NULL DEFAULT 'NORMAL' COMMENT '库位类型',
    description     VARCHAR(500) NOT NULL DEFAULT '' COMMENT '描述',
    status          VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE-可用,DISABLED-禁用,FULL-已满',
    version         INT          NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_slots_code (code),
    KEY idx_slots_rack (rack_id),
    KEY idx_slots_status (status),
    CONSTRAINT fk_slots_rack FOREIGN KEY (rack_id) REFERENCES warehouse_racks (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库位表';

CREATE TABLE IF NOT EXISTS slot_category_restrictions (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    slot_id         BIGINT       NOT NULL COMMENT '库位ID',
    category        VARCHAR(32)  NOT NULL COMMENT '允许的物证类别，空表示允许所有',
    restriction_type VARCHAR(16) NOT NULL DEFAULT 'ALLOW' COMMENT 'ALLOW-允许,DENY-拒绝',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_slot_category (slot_id, category, restriction_type),
    CONSTRAINT fk_restrictions_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库位类别约束表';

CREATE TABLE IF NOT EXISTS zone_category_restrictions (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    zone_id         BIGINT       NOT NULL COMMENT '库区ID',
    category        VARCHAR(32)  NOT NULL COMMENT '允许的物证类别',
    restriction_type VARCHAR(16) NOT NULL DEFAULT 'ALLOW' COMMENT 'ALLOW-允许,DENY-拒绝',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_zone_category (zone_id, category, restriction_type),
    CONSTRAINT fk_zone_restrictions_zone FOREIGN KEY (zone_id) REFERENCES warehouse_zones (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库区类别约束表';

CREATE TABLE IF NOT EXISTS category_isolation_rules (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    category_a      VARCHAR(32)  NOT NULL COMMENT '物证类别A',
    category_b      VARCHAR(32)  NOT NULL COMMENT '物证类别B',
    rule_type       VARCHAR(16)  NOT NULL DEFAULT 'NO_MIX' COMMENT 'NO_MIX-不能同库位,NO_ADJACENT-不能相邻',
    description     VARCHAR(255) NOT NULL DEFAULT '' COMMENT '规则描述',
    created_at      DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_isolation_categories (category_a, category_b, rule_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='类别隔离规则表';

CREATE TABLE IF NOT EXISTS slot_evidence_placement (
    id              BIGINT       NOT NULL AUTO_INCREMENT,
    slot_id         BIGINT       NOT NULL COMMENT '库位ID',
    evidence_id     BIGINT       NOT NULL COMMENT '物证ID',
    placed_at       DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '上架时间',
    placed_by       BIGINT       NULL COMMENT '上架人',
    remark          VARCHAR(500) NOT NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (id),
    UNIQUE KEY uk_placement_evidence (evidence_id),
    KEY idx_placement_slot (slot_id),
    CONSTRAINT fk_placement_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id),
    CONSTRAINT fk_placement_evidence FOREIGN KEY (evidence_id) REFERENCES evidence (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库位物证占用记录表';

-- ==================== 原有表结构 ====================

CREATE TABLE IF NOT EXISTS officers (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    police_no   VARCHAR(32)  NOT NULL,
    name        VARCHAR(64)  NOT NULL,
    department  VARCHAR(128) NOT NULL DEFAULT '',
    rank_title  VARCHAR(64)  NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    created_at  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_officers_police_no (police_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS evidence (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    evidence_no  VARCHAR(48)  NOT NULL,
    case_no      VARCHAR(48)  NOT NULL,
    name         VARCHAR(128) NOT NULL,
    category     VARCHAR(32)  NOT NULL DEFAULT 'OTHER',
    description  VARCHAR(1000) NOT NULL DEFAULT '',
    status       VARCHAR(16)  NOT NULL DEFAULT 'REGISTERED',
    location     VARCHAR(128) NOT NULL DEFAULT '' COMMENT '旧位置字段，兼容历史数据',
    slot_id      BIGINT       NULL COMMENT '所在库位ID',
    registered_by BIGINT      NULL,
    created_at   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at   DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_evidence_no (evidence_no),
    KEY idx_evidence_case (case_no),
    KEY idx_evidence_status (status),
    KEY idx_evidence_slot (slot_id),
    CONSTRAINT fk_evidence_officer FOREIGN KEY (registered_by) REFERENCES officers (id),
    CONSTRAINT fk_evidence_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='物证表';

CREATE TABLE IF NOT EXISTS custody_records (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    evidence_id  BIGINT       NOT NULL,
    action       VARCHAR(16)  NOT NULL,
    from_officer BIGINT       NULL,
    to_officer   BIGINT       NULL,
    remark       VARCHAR(500) NOT NULL DEFAULT '',
    occurred_at  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    KEY idx_custody_evidence (evidence_id),
    CONSTRAINT fk_custody_evidence FOREIGN KEY (evidence_id) REFERENCES evidence (id),
    CONSTRAINT fk_custody_from FOREIGN KEY (from_officer) REFERENCES officers (id),
    CONSTRAINT fk_custody_to FOREIGN KEY (to_officer) REFERENCES officers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS firearms (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    serial_no   VARCHAR(48)  NOT NULL,
    model       VARCHAR(64)  NOT NULL,
    type        VARCHAR(32)  NOT NULL DEFAULT 'PISTOL',
    caliber     VARCHAR(32)  NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'IN_STORE',
    created_at  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_at  DATETIME(3)  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    PRIMARY KEY (id),
    UNIQUE KEY uk_firearm_serial (serial_no),
    KEY idx_firearm_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS firearm_issuances (
    id            BIGINT      NOT NULL AUTO_INCREMENT,
    firearm_id    BIGINT      NOT NULL,
    officer_id    BIGINT      NOT NULL,
    purpose       VARCHAR(255) NOT NULL DEFAULT '',
    ammo_issued   INT         NOT NULL DEFAULT 0,
    ammo_returned INT         NULL,
    issued_at     DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    due_at        DATETIME(3) NOT NULL,
    returned_at   DATETIME(3) NULL,
    status        VARCHAR(16) NOT NULL DEFAULT 'ISSUED',
    PRIMARY KEY (id),
    KEY idx_issuance_firearm (firearm_id),
    KEY idx_issuance_officer (officer_id),
    KEY idx_issuance_status (status),
    CONSTRAINT fk_issuance_firearm FOREIGN KEY (firearm_id) REFERENCES firearms (id),
    CONSTRAINT fk_issuance_officer FOREIGN KEY (officer_id) REFERENCES officers (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
