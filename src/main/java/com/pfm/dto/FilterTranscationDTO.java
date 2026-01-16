package com.pfm.dto;

import com.pfm.entity.TxnType;

public class FilterTranscationDTO {

    private Long category;
    private TxnType type;   // INCOME or EXPENSE
    private String fromDate;
    private String toDate;

    public Long getCategory() {
        return category;
    }
    public void setCategory(Long category) {
        this.category = category;
    }
    public TxnType getType() {
        return type;
    }
    public void setType(TxnType type) {
        this.type = type;
    }
    public String getFromDate() {
        return fromDate;
    }
    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }
    public String getToDate() {
        return toDate;
    }
    public void setToDate(String toDate) {
        this.toDate = toDate;
    }
}
