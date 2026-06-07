package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.WarehouseRack;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WarehouseRackRepository extends JpaRepository<WarehouseRack, Long> {
    List<WarehouseRack> findByZoneIdOrderBySortOrderAsc(Long zoneId);
    Optional<WarehouseRack> findByZoneIdAndCode(Long zoneId, String code);
}
