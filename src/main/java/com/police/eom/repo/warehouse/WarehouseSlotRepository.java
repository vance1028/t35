package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.WarehouseSlot;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface WarehouseSlotRepository extends JpaRepository<WarehouseSlot, Long> {
    Optional<WarehouseSlot> findByCode(String code);
    List<WarehouseSlot> findByRackIdOrderByRowNumAscColNumAsc(Long rackId);
    
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT s FROM WarehouseSlot s WHERE s.id = :id")
    Optional<WarehouseSlot> findByIdWithLock(@Param("id") Long id);
    
    @Query("SELECT s FROM WarehouseSlot s WHERE s.status = 'ACTIVE' AND s.occupiedCount < s.capacity")
    List<WarehouseSlot> findAvailableSlots();
    
    @Query("SELECT s FROM WarehouseSlot s WHERE s.status = 'ACTIVE' AND s.occupiedCount < s.capacity ORDER BY s.id")
    List<WarehouseSlot> findAvailableSlotsOrdered();
    
    @Query(value = "SELECT s.* FROM warehouse_slots s " +
                   "JOIN warehouse_racks r ON s.rack_id = r.id " +
                   "JOIN warehouse_zones z ON r.zone_id = z.id " +
                   "WHERE s.status = 'ACTIVE' AND s.occupied_count < s.capacity " +
                   "AND z.id = :zoneId " +
                   "ORDER BY s.id", nativeQuery = true)
    List<WarehouseSlot> findAvailableSlotsByZoneId(@Param("zoneId") Long zoneId);
}
