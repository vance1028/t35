package com.police.eom.web.dto;

public class SlotRecommendationRequest {
    private String category;
    private String caseNo;
    private int limit = 5;

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getCaseNo() { return caseNo; }
    public void setCaseNo(String caseNo) { this.caseNo = caseNo; }
    public int getLimit() { return limit; }
    public void setLimit(int limit) { this.limit = limit; }
}
