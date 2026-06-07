package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.ZoneCategoryRestriction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ZoneCategoryRestrictionRepository extends JpaRepository<ZoneCategoryRestriction, Long> {
    List<ZoneCategoryRestriction> findByZoneId(Long zoneId);
}
