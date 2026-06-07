package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.SlotCategoryRestriction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SlotCategoryRestrictionRepository extends JpaRepository<SlotCategoryRestriction, Long> {
    List<SlotCategoryRestriction> findBySlotId(Long slotId);
}
