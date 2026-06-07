package com.police.eom.domain.warehouse;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "zone_category_restrictions")
public class ZoneCategoryRestriction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "zone_id", nullable = false)
    private Long zoneId;

    @Column(nullable = false, length = 32)
    private String category;

    @Column(name = "restriction_type", nullable = false, length = 16)
    private String restrictionType = "ALLOW";

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getZoneId() { return zoneId; }
    public void setZoneId(Long zoneId) { this.zoneId = zoneId; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getRestrictionType() { return restrictionType; }
    public void setRestrictionType(String restrictionType) { this.restrictionType = restrictionType; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
