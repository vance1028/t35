package com.police.eom.service;

import com.police.eom.domain.Evidence;
import com.police.eom.domain.warehouse.*;
import com.police.eom.repo.EvidenceRepository;
import com.police.eom.repo.warehouse.*;
import com.police.eom.web.ApiException;
import com.police.eom.web.dto.StorageCapacityDTO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class WarehouseService {

    private final WarehouseRepository warehouseRepo;
    private final WarehouseZoneRepository zoneRepo;
    private final WarehouseRackRepository rackRepo;
    private final WarehouseSlotRepository slotRepo;
    private final SlotCategoryRestrictionRepository slotRestrictionRepo;
    private final ZoneCategoryRestrictionRepository zoneRestrictionRepo;
    private final CategoryIsolationRuleRepository isolationRuleRepo;
    private final SlotEvidencePlacementRepository placementRepo;
    private final EvidenceRepository evidenceRepo;

    public WarehouseService(WarehouseRepository warehouseRepo,
                            WarehouseZoneRepository zoneRepo,
                            WarehouseRackRepository rackRepo,
                            WarehouseSlotRepository slotRepo,
                            SlotCategoryRestrictionRepository slotRestrictionRepo,
                            ZoneCategoryRestrictionRepository zoneRestrictionRepo,
                            CategoryIsolationRuleRepository isolationRuleRepo,
                            SlotEvidencePlacementRepository placementRepo,
                            EvidenceRepository evidenceRepo) {
        this.warehouseRepo = warehouseRepo;
        this.zoneRepo = zoneRepo;
        this.rackRepo = rackRepo;
        this.slotRepo = slotRepo;
        this.slotRestrictionRepo = slotRestrictionRepo;
        this.zoneRestrictionRepo = zoneRestrictionRepo;
        this.isolationRuleRepo = isolationRuleRepo;
        this.placementRepo = placementRepo;
        this.evidenceRepo = evidenceRepo;
    }

    public List<Warehouse> listWarehouses() {
        return warehouseRepo.findAll();
    }

    public Warehouse getWarehouse(Long id) {
        return warehouseRepo.findById(id)
                .orElseThrow(() -> ApiException.notFound("仓库不存在"));
    }

    public List<WarehouseZone> listZones(Long warehouseId) {
        return zoneRepo.findByWarehouseId(warehouseId);
    }

    public WarehouseZone getZone(Long id) {
        return zoneRepo.findById(id)
                .orElseThrow(() -> ApiException.notFound("库区不存在"));
    }

    public List<WarehouseRack> listRacks(Long zoneId) {
        return rackRepo.findByZoneIdOrderBySortOrderAsc(zoneId);
    }

    public WarehouseRack getRack(Long id) {
        return rackRepo.findById(id)
                .orElseThrow(() -> ApiException.notFound("货架不存在"));
    }

    public List<WarehouseSlot> listSlots(Long rackId) {
        return slotRepo.findByRackIdOrderByRowNumAscColNumAsc(rackId);
    }

    public WarehouseSlot getSlot(Long id) {
        return slotRepo.findById(id)
                .orElseThrow(() -> ApiException.notFound("库位不存在"));
    }

    public WarehouseSlot getSlotByCode(String code) {
        return slotRepo.findByCode(code)
                .orElseThrow(() -> ApiException.notFound("库位不存在: " + code));
    }

    public List<Evidence> getEvidenceInSlot(Long slotId) {
        return evidenceRepo.findBySlotId(slotId);
    }

    @Transactional
    public void placeEvidence(Long evidenceId, Long slotId, Long placedBy, String remark) {
        Evidence evidence = evidenceRepo.findById(evidenceId)
                .orElseThrow(() -> ApiException.notFound("物证不存在"));
        
        if (evidence.getSlotId() != null) {
            throw ApiException.conflict("物证已在库位中，请先移库或下架");
        }

        validatePlacement(evidence, slotId);

        WarehouseSlot slot = slotRepo.findByIdWithLock(slotId)
                .orElseThrow(() -> ApiException.notFound("库位不存在"));

        if (slot.getOccupiedCount() >= slot.getCapacity()) {
            throw ApiException.conflict("库位容量已满");
        }

        slot.setOccupiedCount(slot.getOccupiedCount() + 1);
        if (slot.getOccupiedCount() >= slot.getCapacity()) {
            slot.setStatus("FULL");
        }
        slotRepo.save(slot);

        SlotEvidencePlacement placement = new SlotEvidencePlacement();
        placement.setSlotId(slotId);
        placement.setEvidenceId(evidenceId);
        placement.setPlacedBy(placedBy);
        placement.setRemark(remark != null ? remark : "");
        placementRepo.save(placement);

        evidence.setSlotId(slotId);
        evidence.setLocation(slot.getCode());
        evidenceRepo.save(evidence);
    }

    @Transactional
    public void moveEvidence(Long evidenceId, Long fromSlotId, Long toSlotId, Long movedBy, String remark) {
        Evidence evidence = evidenceRepo.findById(evidenceId)
                .orElseThrow(() -> ApiException.notFound("物证不存在"));

        if (evidence.getSlotId() == null) {
            throw ApiException.conflict("物证不在任何库位中，无法移库");
        }
        if (!evidence.getSlotId().equals(fromSlotId)) {
            throw ApiException.conflict("物证所在库位与源库位不一致");
        }
        if (fromSlotId.equals(toSlotId)) {
            throw ApiException.badRequest("源库位与目标库位相同");
        }

        validatePlacement(evidence, toSlotId);

        WarehouseSlot fromSlot = slotRepo.findByIdWithLock(fromSlotId)
                .orElseThrow(() -> ApiException.notFound("源库位不存在"));
        WarehouseSlot toSlot = slotRepo.findByIdWithLock(toSlotId)
                .orElseThrow(() -> ApiException.notFound("目标库位不存在"));

        if (toSlot.getOccupiedCount() >= toSlot.getCapacity()) {
            throw ApiException.conflict("目标库位容量已满");
        }

        fromSlot.setOccupiedCount(fromSlot.getOccupiedCount() - 1);
        if ("FULL".equals(fromSlot.getStatus()) && fromSlot.getOccupiedCount() < fromSlot.getCapacity()) {
            fromSlot.setStatus("ACTIVE");
        }
        slotRepo.save(fromSlot);

        toSlot.setOccupiedCount(toSlot.getOccupiedCount() + 1);
        if (toSlot.getOccupiedCount() >= toSlot.getCapacity()) {
            toSlot.setStatus("FULL");
        }
        slotRepo.save(toSlot);

        SlotEvidencePlacement placement = placementRepo.findByEvidenceId(evidenceId)
                .orElseThrow(() -> ApiException.notFound("物证上架记录不存在"));
        placement.setSlotId(toSlotId);
        placement.setPlacedAt(LocalDateTime.now());
        placement.setPlacedBy(movedBy);
        placement.setRemark(remark != null ? remark : "移库");
        placementRepo.save(placement);

        evidence.setSlotId(toSlotId);
        evidence.setLocation(toSlot.getCode());
        evidenceRepo.save(evidence);
    }

    @Transactional
    public void removeEvidence(Long evidenceId, Long removedBy, String remark) {
        Evidence evidence = evidenceRepo.findById(evidenceId)
                .orElseThrow(() -> ApiException.notFound("物证不存在"));

        if (evidence.getSlotId() == null) {
            throw ApiException.conflict("物证不在任何库位中");
        }

        Long slotId = evidence.getSlotId();
        WarehouseSlot slot = slotRepo.findByIdWithLock(slotId)
                .orElseThrow(() -> ApiException.notFound("库位不存在"));

        slot.setOccupiedCount(Math.max(0, slot.getOccupiedCount() - 1));
        if ("FULL".equals(slot.getStatus()) && slot.getOccupiedCount() < slot.getCapacity()) {
            slot.setStatus("ACTIVE");
        }
        slotRepo.save(slot);

        placementRepo.deleteByEvidenceId(evidenceId);

        evidence.setSlotId(null);
        evidenceRepo.save(evidence);
    }

    private void validatePlacement(Evidence evidence, Long slotId) {
        WarehouseSlot slot = getSlot(slotId);
        WarehouseRack rack = getRack(slot.getRackId());
        WarehouseZone zone = getZone(rack.getZoneId());

        if ("DISABLED".equals(slot.getStatus())) {
            throw ApiException.conflict("库位未启用");
        }
        if ("FULL".equals(slot.getStatus()) || slot.getOccupiedCount() >= slot.getCapacity()) {
            throw ApiException.conflict("库位容量已满");
        }

        validateZoneCategoryRestriction(zone.getId(), evidence.getCategory());
        validateSlotCategoryRestriction(slotId, evidence.getCategory());
        validateIsolationRules(slotId, evidence.getCategory());
    }

    private void validateZoneCategoryRestriction(Long zoneId, String category) {
        List<ZoneCategoryRestriction> restrictions = zoneRestrictionRepo.findByZoneId(zoneId);
        if (restrictions.isEmpty()) {
            return;
        }

        List<ZoneCategoryRestriction> allows = restrictions.stream()
                .filter(r -> "ALLOW".equals(r.getRestrictionType()))
                .collect(Collectors.toList());
        List<ZoneCategoryRestriction> denies = restrictions.stream()
                .filter(r -> "DENY".equals(r.getRestrictionType()))
                .collect(Collectors.toList());

        for (ZoneCategoryRestriction deny : denies) {
            if (deny.getCategory().equals(category)) {
                throw ApiException.conflict("库区不允许存放该类物证: " + category);
            }
        }

        if (!allows.isEmpty()) {
            boolean allowed = allows.stream().anyMatch(a -> a.getCategory().equals(category));
            if (!allowed) {
                throw ApiException.conflict("库区仅允许存放指定类别物证，当前类别不允许: " + category);
            }
        }
    }

    private void validateSlotCategoryRestriction(Long slotId, String category) {
        List<SlotCategoryRestriction> restrictions = slotRestrictionRepo.findBySlotId(slotId);
        if (restrictions.isEmpty()) {
            return;
        }

        List<SlotCategoryRestriction> allows = restrictions.stream()
                .filter(r -> "ALLOW".equals(r.getRestrictionType()))
                .collect(Collectors.toList());
        List<SlotCategoryRestriction> denies = restrictions.stream()
                .filter(r -> "DENY".equals(r.getRestrictionType()))
                .collect(Collectors.toList());

        for (SlotCategoryRestriction deny : denies) {
            if (deny.getCategory().equals(category)) {
                throw ApiException.conflict("库位不允许存放该类物证: " + category);
            }
        }

        if (!allows.isEmpty()) {
            boolean allowed = allows.stream().anyMatch(a -> a.getCategory().equals(category));
            if (!allowed) {
                throw ApiException.conflict("库位仅允许存放指定类别物证，当前类别不允许: " + category);
            }
        }
    }

    private void validateIsolationRules(Long slotId, String newCategory) {
        List<String> existingCategories = placementRepo.findCategoriesInSlot(slotId);
        if (existingCategories.isEmpty()) {
            return;
        }

        List<CategoryIsolationRule> noMixRules = isolationRuleRepo.findByRuleType("NO_MIX");
        for (String existingCat : existingCategories) {
            for (CategoryIsolationRule rule : noMixRules) {
                if (rule.matches(existingCat, newCategory)) {
                    throw ApiException.conflict("违反隔离规则: " + rule.getDescription() + 
                            "，类别 " + existingCat + " 与 " + newCategory + " 不能混放");
                }
            }
        }
    }

    public List<WarehouseSlot> recommendSlots(String category, String caseNo, int limit) {
        List<WarehouseSlot> allAvailable = slotRepo.findAvailableSlotsOrdered();
        
        List<WarehouseSlot> filtered = allAvailable.stream()
                .filter(slot -> isSlotAllowedForCategory(slot, category))
                .collect(Collectors.toList());

        filtered.sort((s1, s2) -> {
            int score1 = calculateSlotScore(s1, category, caseNo);
            int score2 = calculateSlotScore(s2, category, caseNo);
            return Integer.compare(score2, score1);
        });

        return filtered.stream().limit(limit).collect(Collectors.toList());
    }

    private boolean isSlotAllowedForCategory(WarehouseSlot slot, String category) {
        try {
            WarehouseRack rack = getRack(slot.getRackId());
            validateZoneCategoryRestriction(rack.getZoneId(), category);
            validateSlotCategoryRestriction(slot.getId(), category);
            validateIsolationRules(slot.getId(), category);
            return true;
        } catch (ApiException e) {
            return false;
        }
    }

    private int calculateSlotScore(WarehouseSlot slot, String category, String caseNo) {
        int score = 0;

        if (caseNo != null && !caseNo.isBlank()) {
            int caseEvidenceCount = placementRepo.countCaseEvidenceInSlot(slot.getId(), caseNo);
            score += caseEvidenceCount * 100;
        }

        int availableCapacity = slot.getAvailableCapacity();
        if (availableCapacity == 1) {
            score += 50;
        } else if (availableCapacity <= 3) {
            score += 30;
        }

        score += slot.getId().intValue() % 10;

        return score;
    }

    public StorageCapacityDTO getWarehouseCapacity(Long warehouseId) {
        Warehouse warehouse = getWarehouse(warehouseId);
        List<WarehouseZone> zones = zoneRepo.findByWarehouseId(warehouseId);
        
        int totalCapacity = 0;
        int usedCapacity = 0;
        
        for (WarehouseZone zone : zones) {
            StorageCapacityDTO zoneCap = getZoneCapacity(zone.getId());
            totalCapacity += zoneCap.getTotalCapacity();
            usedCapacity += zoneCap.getUsedCapacity();
        }
        
        return new StorageCapacityDTO(warehouse.getId(), warehouse.getCode(), 
                warehouse.getName(), totalCapacity, usedCapacity);
    }

    public StorageCapacityDTO getZoneCapacity(Long zoneId) {
        WarehouseZone zone = getZone(zoneId);
        List<WarehouseRack> racks = rackRepo.findByZoneIdOrderBySortOrderAsc(zoneId);
        
        int totalCapacity = 0;
        int usedCapacity = 0;
        
        for (WarehouseRack rack : racks) {
            List<WarehouseSlot> slots = slotRepo.findByRackIdOrderByRowNumAscColNumAsc(rack.getId());
            for (WarehouseSlot slot : slots) {
                totalCapacity += slot.getCapacity();
                usedCapacity += slot.getOccupiedCount();
            }
        }
        
        return new StorageCapacityDTO(zone.getId(), zone.getCode(), 
                zone.getName(), totalCapacity, usedCapacity);
    }

    public List<StorageCapacityDTO> getAllZoneCapacities(Long warehouseId) {
        List<WarehouseZone> zones = zoneRepo.findByWarehouseId(warehouseId);
        return zones.stream()
                .map(zone -> getZoneCapacity(zone.getId()))
                .collect(Collectors.toList());
    }

    public List<StorageCapacityDTO> getWarningZones(Long warehouseId) {
        return getAllZoneCapacities(warehouseId).stream()
                .filter(StorageCapacityDTO::isWarning)
                .collect(Collectors.toList());
    }
}
