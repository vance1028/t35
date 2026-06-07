package com.police.eom.domain.warehouse;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "slot_evidence_placement")
public class SlotEvidencePlacement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "slot_id", nullable = false)
    private Long slotId;

    @Column(name = "evidence_id", nullable = false, unique = true)
    private Long evidenceId;

    @Column(name = "placed_at", nullable = false)
    private LocalDateTime placedAt;

    @Column(name = "placed_by")
    private Long placedBy;

    @Column(nullable = false, length = 500)
    private String remark = "";

    @PrePersist
    public void prePersist() {
        if (placedAt == null) placedAt = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getSlotId() { return slotId; }
    public void setSlotId(Long slotId) { this.slotId = slotId; }
    public Long getEvidenceId() { return evidenceId; }
    public void setEvidenceId(Long evidenceId) { this.evidenceId = evidenceId; }
    public LocalDateTime getPlacedAt() { return placedAt; }
    public void setPlacedAt(LocalDateTime placedAt) { this.placedAt = placedAt; }
    public Long getPlacedBy() { return placedBy; }
    public void setPlacedBy(Long placedBy) { this.placedBy = placedBy; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
