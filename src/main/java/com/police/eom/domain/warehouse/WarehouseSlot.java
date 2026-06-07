package com.police.eom.domain.warehouse;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "warehouse_slots")
public class WarehouseSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "rack_id", nullable = false)
    private Long rackId;

    @Column(nullable = false, unique = true, length = 32)
    private String code;

    @Column(name = "row_num", nullable = false)
    private Integer rowNum = 1;

    @Column(name = "col_num", nullable = false)
    private Integer colNum = 1;

    @Column(nullable = false)
    private Integer capacity = 1;

    @Column(name = "occupied_count", nullable = false)
    private Integer occupiedCount = 0;

    @Column(name = "slot_type", nullable = false, length = 32)
    private String slotType = "NORMAL";

    @Column(nullable = false, length = 500)
    private String description = "";

    @Column(nullable = false, length = 16)
    private String status = "ACTIVE";

    @Version
    @Column(nullable = false)
    private Integer version = 0;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    public void prePersist() {
        LocalDateTime now = LocalDateTime.now();
        if (createdAt == null) createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    public void preUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public boolean hasAvailableCapacity() {
        return occupiedCount < capacity;
    }

    public int getAvailableCapacity() {
        return capacity - occupiedCount;
    }

    public double getUsageRate() {
        if (capacity <= 0) return 0.0;
        return (double) occupiedCount / capacity;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getRackId() { return rackId; }
    public void setRackId(Long rackId) { this.rackId = rackId; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public Integer getRowNum() { return rowNum; }
    public void setRowNum(Integer rowNum) { this.rowNum = rowNum; }
    public Integer getColNum() { return colNum; }
    public void setColNum(Integer colNum) { this.colNum = colNum; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public Integer getOccupiedCount() { return occupiedCount; }
    public void setOccupiedCount(Integer occupiedCount) { this.occupiedCount = occupiedCount; }
    public String getSlotType() { return slotType; }
    public void setSlotType(String slotType) { this.slotType = slotType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getVersion() { return version; }
    public void setVersion(Integer version) { this.version = version; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
