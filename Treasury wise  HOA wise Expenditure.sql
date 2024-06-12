
		SELECT hr.hierarchy_Code, hr.hierarchy_Name, h.head,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END AS Scheme,h.ga_ssa_status,
		h.voted_charged_status,date(le.expenditure_date) dt, SUM(le.amount) amt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h 
				ON le.head_of_account = h.head_id
		JOIN probityfinancials.head_setup dh 
			ON h.major_head = dh.head_setup_id
		JOIN ctmis_master.bill_details_base b
			ON le.source_reference = b.id
		JOIN pfmaster.hierarchy_setup hr
			ON le.treasury = hr.hierarchy_Id
			AND hr.category = 'T'
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
			ON	h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc 
			ON	pchm.pc_id = pc.pc_id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND h.head LIKE '2245%'
		AND SUBSTR(h.head,1,4) <> '2071'
		#AND b.bill_pension_type IS NULL
		#AND SUBSTR(h.head, 22,2)<>'21'
		
		GROUP BY hr.hierarchy_Code, hr.hierarchy_Name, h.head,
		CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'EE'
		END ,h.ga_ssa_status,
		h.voted_charged_status, date(le.expenditure_date)
		ORDER BY 3,4,5,6,1,7
		