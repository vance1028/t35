package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.WarehouseZone;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WarehouseZoneRepository extends JpaRepository<WarehouseZone, Long> {
    List<WarehouseZone> findByWarehouseId(Long warehouseId);
    Optional<WarehouseZone> findByWarehouseIdAndCode(Long warehouseId, String code);
}
