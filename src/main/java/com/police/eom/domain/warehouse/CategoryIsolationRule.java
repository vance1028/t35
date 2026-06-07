package com.police.eom.domain.warehouse;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "category_isolation_rules")
public class CategoryIsolationRule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "category_a", nullable = false, length = 32)
    private String categoryA;

    @Column(name = "category_b", nullable = false, length = 32)
    private String categoryB;

    @Column(name = "rule_type", nullable = false, length = 16)
    private String ruleType = "NO_MIX";

    @Column(nullable = false, length = 255)
    private String description = "";

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) createdAt = LocalDateTime.now();
    }

    public boolean matches(String cat1, String cat2) {
        return (categoryA.equals(cat1) && categoryB.equals(cat2)) ||
               (categoryA.equals(cat2) && categoryB.equals(cat1));
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCategoryA() { return categoryA; }
    public void setCategoryA(String categoryA) { this.categoryA = categoryA; }
    public String getCategoryB() { return categoryB; }
    public void setCategoryB(String categoryB) { this.categoryB = categoryB; }
    public String getRuleType() { return ruleType; }
    public void setRuleType(String ruleType) { this.ruleType = ruleType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
