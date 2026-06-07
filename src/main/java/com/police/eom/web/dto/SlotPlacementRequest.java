package com.police.eom.web.dto;

public class SlotPlacementRequest {
    private Long evidenceId;
    private Long slotId;
    private Long placedBy;
    private String remark;

    public Long getEvidenceId() { return evidenceId; }
    public void setEvidenceId(Long evidenceId) { this.evidenceId = evidenceId; }
    public Long getSlotId() { return slotId; }
    public void setSlotId(Long slotId) { this.slotId = slotId; }
    public Long getPlacedBy() { return placedBy; }
    public void setPlacedBy(Long placedBy) { this.placedBy = placedBy; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
