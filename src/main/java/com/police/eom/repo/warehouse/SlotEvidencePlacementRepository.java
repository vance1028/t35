package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.SlotEvidencePlacement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SlotEvidencePlacementRepository extends JpaRepository<SlotEvidencePlacement, Long> {
    Optional<SlotEvidencePlacement> findByEvidenceId(Long evidenceId);
    List<SlotEvidencePlacement> findBySlotId(Long slotId);
    
    @Query("SELECT p FROM SlotEvidencePlacement p WHERE p.slotId = :slotId")
    List<SlotEvidencePlacement> findAllBySlotId(@Param("slotId") Long slotId);
    
    @Query("SELECT DISTINCT e.category FROM SlotEvidencePlacement p " +
           "JOIN Evidence e ON p.evidenceId = e.id WHERE p.slotId = :slotId")
    List<String> findCategoriesInSlot(@Param("slotId") Long slotId);
    
    @Query("SELECT COUNT(DISTINCT e.caseNo) FROM SlotEvidencePlacement p " +
           "JOIN Evidence e ON p.evidenceId = e.id WHERE p.slotId = :slotId AND e.caseNo = :caseNo")
    int countCaseEvidenceInSlot(@Param("slotId") Long slotId, @Param("caseNo") String caseNo);
    
    void deleteByEvidenceId(Long evidenceId);
}
