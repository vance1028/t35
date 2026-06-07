package com.police.eom.repo.warehouse;

import com.police.eom.domain.warehouse.CategoryIsolationRule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CategoryIsolationRuleRepository extends JpaRepository<CategoryIsolationRule, Long> {
    
    @Query("SELECT r FROM CategoryIsolationRule r WHERE r.ruleType = :ruleType " +
           "AND ((r.categoryA = :cat1 AND r.categoryB = :cat2) OR (r.categoryA = :cat2 AND r.categoryB = :cat1))")
    List<CategoryIsolationRule> findMatchingRules(@Param("cat1") String cat1, 
                                                   @Param("cat2") String cat2,
                                                   @Param("ruleType") String ruleType);
    
    List<CategoryIsolationRule> findByRuleType(String ruleType);
}
