SELECT bud.* FROM 
(
	SELECT 
	    hs.hierarchy_Name dep,
	    CONCAT( mh.head_code, '->', mh.head_name) mhead,
	    CASE
			WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
			WHEN h.plan_status = 'NP' THEN 'EE'
			ELSE 'EE'
		END AS scheme,
	    SUM(IFNULL(d.allotted_amount, 0)) bud
	FROM probityfinancials.budget_allocation_details d
	JOIN probityfinancials.budget_allocation_base b 
		ON b.id = d.base_id
	JOIN pfmaster.hierarchy_setup hs 
		ON hs.hierarchy_Id = b.parent
	JOIN probityfinancials.heads h 
		ON d.head_id = h.head_id
	JOIN probityfinancials.head_setup mh 
		ON h.major_head = mh.head_setup_id
	LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
		ON	h.head_id = pchm.head_id
	LEFT JOIN probityfinancials.plan_category pc 
		ON	pchm.pc_id = pc.pc_id
	WHERE
	    b.year = '2023-24'
	GROUP BY  hs.hierarchy_Id, CONCAT( mh.head_code, '->', mh.head_name),
	CASE
			WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
			WHEN h.plan_status = 'NP' THEN 'EE'
			ELSE 'EE'
		END
) bud
ORDER BY 1,2,3