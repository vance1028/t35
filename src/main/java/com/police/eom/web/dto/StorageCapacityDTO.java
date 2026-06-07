package com.police.eom.web.dto;

public class StorageCapacityDTO {
    private Long id;
    private String code;
    private String name;
    private int totalCapacity;
    private int usedCapacity;
    private int freeCapacity;
    private double usageRate;
    private boolean warning;

    public StorageCapacityDTO() {}

    public StorageCapacityDTO(Long id, String code, String name, int totalCapacity, int usedCapacity) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.totalCapacity = totalCapacity;
        this.usedCapacity = usedCapacity;
        this.freeCapacity = totalCapacity - usedCapacity;
        this.usageRate = totalCapacity > 0 ? (double) usedCapacity / totalCapacity : 0.0;
        this.warning = this.usageRate >= 0.9;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getTotalCapacity() { return totalCapacity; }
    public void setTotalCapacity(int totalCapacity) { this.totalCapacity = totalCapacity; }
    public int getUsedCapacity() { return usedCapacity; }
    public void setUsedCapacity(int usedCapacity) { this.usedCapacity = usedCapacity; }
    public int getFreeCapacity() { return freeCapacity; }
    public void setFreeCapacity(int freeCapacity) { this.freeCapacity = freeCapacity; }
    public double getUsageRate() { return usageRate; }
    public void setUsageRate(double usageRate) { this.usageRate = usageRate; }
    public boolean isWarning() { return warning; }
    public void setWarning(boolean warning) { this.warning = warning; }
}
