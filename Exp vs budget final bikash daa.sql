SELECT mm.dep, mm.mhead, mm.scheme, SUM(mm.bud), SUM(mm.expen) FROM 
(

SELECT bud.*, expen.expen FROM 
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

LEFT JOIN 

(
	SELECT m.dep , m.mhead, m.scheme,  SUM(amt) expen 
	FROM
	(
		SELECT dep.hierarchy_Name dep,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND SUBSTR(h.head,1,4) <> '2071'
		AND b.bill_pension_type IS NULL
		AND SUBSTR(h.head, 22,2)<>'21'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
		
		UNION ALL
		
		SELECT 'Pension' dep,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		WHERE
		DATE(b.voucher_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL or SUBSTR(h.head, 22,2)='21' )
		GROUP BY #dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
		
		UNION ALL
		
		SELECT dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		#JOIN ctmis_master.bill_details_base b
		# ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'CHEQUE'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
	) m
	WHERE m.dep IS NOT NULL
	GROUP BY m.dep, m.mhead, m.scheme
) expen
ON bud.dep = expen.dep
AND bud.mhead = expen.mhead
AND bud.scheme = expen.scheme



UNION ALL 


SELECT expen.dep, expen.mhead, expen.scheme, bud.bud, expen.expen FROM 
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

RIGHT JOIN 

(
	SELECT m.dep , m.mhead, m.scheme,  SUM(amt) expen 
	FROM
	(
		SELECT dep.hierarchy_Name dep,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND SUBSTR(h.head,1,4) <> '2071'
		AND b.bill_pension_type IS NULL
		AND SUBSTR(h.head, 22,2)<>'21'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
		
		UNION ALL
		
		SELECT 'Pension' dep,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		LEFT JOIN ctmis_master.bill_details_base b
		ON le.source_reference = b.id
		WHERE
		DATE(b.voucher_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL or SUBSTR(h.head, 22,2)='21' )
		GROUP BY #dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
		
		UNION ALL
		
		SELECT dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name) mhead,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS scheme,
		ROUND ( SUM(le.amount)/100000 , 2) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h
		ON le.head_of_account = h.head_id
		LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
		JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc
		ON pchm.pc_id = pc.pc_id
		#JOIN ctmis_master.bill_details_base b
		# ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'CHEQUE'
		GROUP BY dep.hierarchy_Name,
		CONCAT( mh.head_code, '->', mh.head_name),
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END
	) m
	WHERE m.dep IS NOT NULL
	GROUP BY m.dep, m.mhead, m.scheme
) expen
ON bud.dep = expen.dep
AND bud.mhead = expen.mhead
AND bud.scheme = expen.scheme
WHERE 
bud.dep IS NULL AND bud.mhead IS NULL AND  bud.scheme IS NULL

) mm 

GROUP BY mm.dep, mm.mhead, mm.scheme

ORDER BY 1,2,3