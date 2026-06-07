package com.police.eom.web.dto;

public class SlotMoveRequest {
    private Long evidenceId;
    private Long fromSlotId;
    private Long toSlotId;
    private Long movedBy;
    private String remark;

    public Long getEvidenceId() { return evidenceId; }
    public void setEvidenceId(Long evidenceId) { this.evidenceId = evidenceId; }
    public Long getFromSlotId() { return fromSlotId; }
    public void setFromSlotId(Long fromSlotId) { this.fromSlotId = fromSlotId; }
    public Long getToSlotId() { return toSlotId; }
    public void setToSlotId(Long toSlotId) { this.toSlotId = toSlotId; }
    public Long getMovedBy() { return movedBy; }
    public void setMovedBy(Long movedBy) { this.movedBy = movedBy; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
