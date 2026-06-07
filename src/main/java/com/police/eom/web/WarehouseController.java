package com.police.eom.web;

import com.police.eom.domain.Evidence;
import com.police.eom.domain.warehouse.*;
import com.police.eom.service.WarehouseService;
import com.police.eom.web.dto.SlotMoveRequest;
import com.police.eom.web.dto.SlotPlacementRequest;
import com.police.eom.web.dto.SlotRecommendationRequest;
import com.police.eom.web.dto.StorageCapacityDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/warehouse")
public class WarehouseController {

    private final WarehouseService service;

    public WarehouseController(WarehouseService service) {
        this.service = service;
    }

    @GetMapping("/warehouses")
    public List<Warehouse> listWarehouses() {
        return service.listWarehouses();
    }

    @GetMapping("/warehouses/{id}")
    public Warehouse getWarehouse(@PathVariable Long id) {
        return service.getWarehouse(id);
    }

    @GetMapping("/warehouses/{warehouseId}/zones")
    public List<WarehouseZone> listZones(@PathVariable Long warehouseId) {
        return service.listZones(warehouseId);
    }

    @GetMapping("/zones/{id}")
    public WarehouseZone getZone(@PathVariable Long id) {
        return service.getZone(id);
    }

    @GetMapping("/zones/{zoneId}/racks")
    public List<WarehouseRack> listRacks(@PathVariable Long zoneId) {
        return service.listRacks(zoneId);
    }

    @GetMapping("/racks/{id}")
    public WarehouseRack getRack(@PathVariable Long id) {
        return service.getRack(id);
    }

    @GetMapping("/racks/{rackId}/slots")
    public List<WarehouseSlot> listSlots(@PathVariable Long rackId) {
        return service.listSlots(rackId);
    }

    @GetMapping("/slots/{id}")
    public WarehouseSlot getSlot(@PathVariable Long id) {
        return service.getSlot(id);
    }

    @GetMapping("/slots/code/{code}")
    public WarehouseSlot getSlotByCode(@PathVariable String code) {
        return service.getSlotByCode(code);
    }

    @GetMapping("/slots/{slotId}/evidence")
    public List<Evidence> getEvidenceInSlot(@PathVariable Long slotId) {
        return service.getEvidenceInSlot(slotId);
    }

    @PostMapping("/slots/place")
    public void placeEvidence(@RequestBody SlotPlacementRequest req) {
        service.placeEvidence(req.getEvidenceId(), req.getSlotId(), 
                req.getPlacedBy(), req.getRemark());
    }

    @PostMapping("/slots/move")
    public void moveEvidence(@RequestBody SlotMoveRequest req) {
        service.moveEvidence(req.getEvidenceId(), req.getFromSlotId(), 
                req.getToSlotId(), req.getMovedBy(), req.getRemark());
    }

    @PostMapping("/slots/{slotId}/evidence/{evidenceId}/remove")
    public void removeEvidence(@PathVariable Long slotId, @PathVariable Long evidenceId,
                               @RequestParam(required = false) Long removedBy,
                               @RequestParam(required = false) String remark) {
        service.removeEvidence(evidenceId, removedBy, remark);
    }

    @PostMapping("/slots/recommend")
    public List<WarehouseSlot> recommendSlots(@RequestBody SlotRecommendationRequest req) {
        return service.recommendSlots(req.getCategory(), req.getCaseNo(), req.getLimit());
    }

    @GetMapping("/warehouses/{warehouseId}/capacity")
    public StorageCapacityDTO getWarehouseCapacity(@PathVariable Long warehouseId) {
        return service.getWarehouseCapacity(warehouseId);
    }

    @GetMapping("/zones/{zoneId}/capacity")
    public StorageCapacityDTO getZoneCapacity(@PathVariable Long zoneId) {
        return service.getZoneCapacity(zoneId);
    }

    @GetMapping("/warehouses/{warehouseId}/zones/capacity")
    public List<StorageCapacityDTO> getAllZoneCapacities(@PathVariable Long warehouseId) {
        return service.getAllZoneCapacities(warehouseId);
    }

    @GetMapping("/warehouses/{warehouseId}/warnings")
    public List<StorageCapacityDTO> getWarningZones(@PathVariable Long warehouseId) {
        return service.getWarningZones(warehouseId);
    }
}
