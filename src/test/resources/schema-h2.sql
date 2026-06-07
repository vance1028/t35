-- H2 (MySQL 模式) 测试用表结构，去掉了 ENGINE/CHARSET 等 MySQL 专有子句

-- ==================== 仓库库位管理 ====================

CREATE TABLE IF NOT EXISTS warehouses (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    code        VARCHAR(32)  NOT NULL,
    name        VARCHAR(128) NOT NULL,
    address     VARCHAR(255) NOT NULL DEFAULT '',
    description VARCHAR(500) NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_warehouses_code UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS warehouse_zones (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    warehouse_id BIGINT      NOT NULL,
    code        VARCHAR(32)  NOT NULL,
    name        VARCHAR(128) NOT NULL,
    zone_type   VARCHAR(32)  NOT NULL DEFAULT 'NORMAL',
    description VARCHAR(500) NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_zones_warehouse_code UNIQUE (warehouse_id, code),
    CONSTRAINT fk_zones_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses (id)
);

CREATE TABLE IF NOT EXISTS warehouse_racks (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    zone_id     BIGINT       NOT NULL,
    code        VARCHAR(32)  NOT NULL,
    name        VARCHAR(128) NOT NULL,
    rows_count  INT          NOT NULL DEFAULT 5,
    columns_count INT        NOT NULL DEFAULT 4,
    sort_order  INT          NOT NULL DEFAULT 0,
    description VARCHAR(500) NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_racks_zone_code UNIQUE (zone_id, code),
    CONSTRAINT fk_racks_zone FOREIGN KEY (zone_id) REFERENCES warehouse_zones (id)
);

CREATE TABLE IF NOT EXISTS warehouse_slots (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    rack_id     BIGINT       NOT NULL,
    code        VARCHAR(32)  NOT NULL,
    row_num     INT          NOT NULL DEFAULT 1,
    col_num     INT          NOT NULL DEFAULT 1,
    capacity    INT          NOT NULL DEFAULT 1,
    occupied_count INT       NOT NULL DEFAULT 0,
    slot_type   VARCHAR(32)  NOT NULL DEFAULT 'NORMAL',
    description VARCHAR(500) NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    version     INT          NOT NULL DEFAULT 0,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_slots_code UNIQUE (code),
    CONSTRAINT fk_slots_rack FOREIGN KEY (rack_id) REFERENCES warehouse_racks (id)
);

CREATE TABLE IF NOT EXISTS slot_category_restrictions (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    slot_id     BIGINT       NOT NULL,
    category    VARCHAR(32)  NOT NULL,
    restriction_type VARCHAR(16) NOT NULL DEFAULT 'ALLOW',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_slot_category UNIQUE (slot_id, category, restriction_type),
    CONSTRAINT fk_restrictions_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id)
);

CREATE TABLE IF NOT EXISTS zone_category_restrictions (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    zone_id     BIGINT       NOT NULL,
    category    VARCHAR(32)  NOT NULL,
    restriction_type VARCHAR(16) NOT NULL DEFAULT 'ALLOW',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_zone_category UNIQUE (zone_id, category, restriction_type),
    CONSTRAINT fk_zone_restrictions_zone FOREIGN KEY (zone_id) REFERENCES warehouse_zones (id)
);

CREATE TABLE IF NOT EXISTS category_isolation_rules (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    category_a  VARCHAR(32)  NOT NULL,
    category_b  VARCHAR(32)  NOT NULL,
    rule_type   VARCHAR(16)  NOT NULL DEFAULT 'NO_MIX',
    description VARCHAR(255) NOT NULL DEFAULT '',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_isolation_categories UNIQUE (category_a, category_b, rule_type)
);

-- ==================== 原有表结构 ====================

CREATE TABLE IF NOT EXISTS officers (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    police_no   VARCHAR(32)  NOT NULL,
    name        VARCHAR(64)  NOT NULL,
    department  VARCHAR(128) NOT NULL DEFAULT '',
    rank_title  VARCHAR(64)  NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_officers_police_no UNIQUE (police_no)
);

CREATE TABLE IF NOT EXISTS evidence (
    id            BIGINT        NOT NULL AUTO_INCREMENT,
    evidence_no   VARCHAR(48)   NOT NULL,
    case_no       VARCHAR(48)   NOT NULL,
    name          VARCHAR(128)  NOT NULL,
    category      VARCHAR(32)   NOT NULL DEFAULT 'OTHER',
    description   VARCHAR(1000) NOT NULL DEFAULT '',
    status        VARCHAR(16)   NOT NULL DEFAULT 'REGISTERED',
    location      VARCHAR(128)  NOT NULL DEFAULT '',
    slot_id       BIGINT        NULL,
    registered_by BIGINT        NULL,
    created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_evidence_no UNIQUE (evidence_no),
    CONSTRAINT fk_evidence_officer FOREIGN KEY (registered_by) REFERENCES officers (id),
    CONSTRAINT fk_evidence_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id)
);

CREATE TABLE IF NOT EXISTS slot_evidence_placement (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    slot_id     BIGINT       NOT NULL,
    evidence_id BIGINT       NOT NULL UNIQUE,
    placed_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    placed_by   BIGINT       NULL,
    remark      VARCHAR(500) NOT NULL DEFAULT '',
    PRIMARY KEY (id),
    CONSTRAINT fk_placement_slot FOREIGN KEY (slot_id) REFERENCES warehouse_slots (id),
    CONSTRAINT fk_placement_evidence FOREIGN KEY (evidence_id) REFERENCES evidence (id)
);

CREATE TABLE IF NOT EXISTS custody_records (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    evidence_id  BIGINT       NOT NULL,
    action       VARCHAR(16)  NOT NULL,
    from_officer BIGINT       NULL,
    to_officer   BIGINT       NULL,
    remark       VARCHAR(500) NOT NULL DEFAULT '',
    occurred_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_custody_evidence FOREIGN KEY (evidence_id) REFERENCES evidence (id),
    CONSTRAINT fk_custody_from FOREIGN KEY (from_officer) REFERENCES officers (id),
    CONSTRAINT fk_custody_to FOREIGN KEY (to_officer) REFERENCES officers (id)
);

CREATE TABLE IF NOT EXISTS firearms (
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    serial_no   VARCHAR(48)  NOT NULL,
    model       VARCHAR(64)  NOT NULL,
    type        VARCHAR(32)  NOT NULL DEFAULT 'PISTOL',
    caliber     VARCHAR(32)  NOT NULL DEFAULT '',
    status      VARCHAR(16)  NOT NULL DEFAULT 'IN_STORE',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT uk_firearm_serial UNIQUE (serial_no)
);

CREATE TABLE IF NOT EXISTS firearm_issuances (
    id            BIGINT      NOT NULL AUTO_INCREMENT,
    firearm_id    BIGINT      NOT NULL,
    officer_id    BIGINT      NOT NULL,
    purpose       VARCHAR(255) NOT NULL DEFAULT '',
    ammo_issued   INT         NOT NULL DEFAULT 0,
    ammo_returned INT         NULL,
    issued_at     TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_at        TIMESTAMP   NOT NULL,
    returned_at   TIMESTAMP   NULL,
    status        VARCHAR(16) NOT NULL DEFAULT 'ISSUED',
    PRIMARY KEY (id),
    CONSTRAINT fk_issuance_firearm FOREIGN KEY (firearm_id) REFERENCES firearms (id),
    CONSTRAINT fk_issuance_officer FOREIGN KEY (officer_id) REFERENCES officers (id)
);
