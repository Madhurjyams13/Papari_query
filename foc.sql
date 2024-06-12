SELECT m.* FROM 
(

SELECT cd.ceiling_acc_no foc, ch.addl_req famtl , cd.approved_on app_date , cd.ceiling_valid exp_date , 
try.hierarchy_Code try,
concat(try.hierarchy_Code,' -> ',try.hierarchy_Name) try_name,
hst.hierarchy_Code ddo,
bd.bill_number,
concat(mh.head_code,' -> ',mh.head_name) mh,
concat(dh.head_code,' -> ',dh.head_name) dh,
h.head, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme ,
case 
	when 
		bd.id IS null
		   then 'Untouched'
	when
		bd.approved_by IS NOT null
			then 'Approved by Treasury'
	when
		bd.rejected_by IS NOT null
			then 'Rejected by Treasury'
	when
		bd.approved_by IS NULL 
			then 'Processing at Treasury'
END status,
bd.total_allowance amt ,
dep.hierarchy_Name dep
FROM
probityfinancials.ceiling_distributed cd 
join probityfinancials.ceiling_distributed_heads ch 
	on ch.dis_id=cd.id
LEFT JOIN pfmaster.hierarchy_setup hst 
	ON hst.hierarchy_Id =  cd.office_id
JOIN probityfinancials.heads h 
	ON ch.head_id = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
LEFT JOIN ctmis_master.bill_details_base bd
	ON cd.ceiling_acc_no = bd.foc_number
	AND ch.head_id = bd.head_id
JOIN probityfinancials.ceiling_request_checklist cl
	ON cd.checklist_Id = cl.id
	and cl.fin_Year='2024-25'
	and cl.upload_approved_by is not null 
	and cl.manual='N'
	and cl.group_Id is null 
	and cl.rejected_by is null 
	and cl.fin_Approved_by is not null 
	and cl.fin_Approved_on between  date('2024-04-01') and date('2025-03-31') 
JOIN pfmaster.hierarchy_setup dep
	ON cl.office = dep.hierarchy_Id
JOIN pfmaster.hierarchy_mapping hm 
	ON cd.office_id = hm.mapped_Id
JOIN pfmaster.hierarchy_setup try
	ON hm.mapped_To = try.hierarchy_Id
WHERE 
cd.ceiling_valid >= DATE(NOW())

) m

WHERE m.status IN ('Untouched', 'Processing at Treasury','Approved by Treasury')

# Rejected Part starts here

UNION ALL 

SELECT m.* FROM 
(

SELECT cd.ceiling_acc_no foc, ch.addl_req famtl , cd.approved_on app_date , cd.ceiling_valid exp_date , 
try.hierarchy_Code try,
concat(try.hierarchy_Code,' -> ',try.hierarchy_Name) try_name,
hst.hierarchy_Code ddo,
bd.bill_number,
concat(mh.head_code,' -> ',mh.head_name) mh,
concat(dh.head_code,' -> ',dh.head_name) dh,
h.head, 
CASE
	WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
	WHEN h.plan_status = 'NP' THEN 'EE'
	ELSE 'Plan'
END AS scheme ,
case 
	when 
		bd.id IS null
		   then 'Untouched'
	when
		bd.approved_by IS NOT null
			then 'Approved by Treasury'
	when
		bd.rejected_by IS NOT null
			then 'Rejected by Treasury'
	when
		bd.approved_by IS NULL 
			then 'Processing at Treasury'
END status,
bd.total_allowance amt ,
dep.hierarchy_Name dep
FROM
probityfinancials.ceiling_distributed cd 
join probityfinancials.ceiling_distributed_heads ch 
	on ch.dis_id=cd.id
LEFT JOIN pfmaster.hierarchy_setup hst 
	ON hst.hierarchy_Id =  cd.office_id
JOIN probityfinancials.heads h 
	ON ch.head_id = h.head_id
LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
	ON	h.head_id = pchm.head_id
LEFT JOIN probityfinancials.plan_category pc 
	ON	pchm.pc_id = pc.pc_id
JOIN probityfinancials.head_setup mh
	ON h.major_head = mh.head_setup_id
JOIN probityfinancials.head_setup dh
	ON h.detailed_head = dh.head_setup_id
LEFT JOIN ctmis_master.bill_details_base bd
	ON cd.ceiling_acc_no = bd.foc_number
	AND ch.head_id = bd.head_id
JOIN probityfinancials.ceiling_request_checklist cl
	ON cd.checklist_Id = cl.id
	and cl.fin_Year='2024-25'
	and cl.upload_approved_by is not null 
	and cl.manual='N'
	and cl.group_Id is null 
	and cl.rejected_by is null 
	and cl.fin_Approved_by is not null 
	and cl.fin_Approved_on between  date('2024-04-01') and date('2025-03-31') 
JOIN pfmaster.hierarchy_setup dep
	ON cl.office = dep.hierarchy_Id
JOIN pfmaster.hierarchy_mapping hm 
	ON cd.office_id = hm.mapped_Id
JOIN pfmaster.hierarchy_setup try
	ON hm.mapped_To = try.hierarchy_Id
WHERE 
cd.ceiling_valid >= DATE(NOW())

) m

WHERE m.status = 'Rejected by Treasury'
AND NOT EXISTS 
(
	SELECT n.* FROM 		
	(
		SELECT cd.ceiling_acc_no foc, 
		case 
			when 
				bd.id IS null
				   then 'Untouched'
			when
				bd.approved_by IS NOT null
					then 'Approved by Treasury'
			when
				bd.rejected_by IS NOT null
					then 'Rejected by Treasury'
			when
				bd.approved_by IS NULL 
					then 'Processing at Treasury'
		END AS status
		FROM
		probityfinancials.ceiling_distributed cd 
		join probityfinancials.ceiling_distributed_heads ch 
			on ch.dis_id=cd.id
		LEFT JOIN ctmis_master.bill_details_base bd
			ON cd.ceiling_acc_no = bd.foc_number
			AND ch.head_id = bd.head_id
		WHERE 
		cd.ceiling_valid >= DATE(NOW())		
	) n	
	WHERE 
	m.foc = n.foc
	AND n.status IN ('Approved by Treasury','Processing at Treasury','Untouched')		
)

ORDER BY 1;









# foc pipeline summary

SELECT 
#nnn.scheme,
nnn.dep,
SUM(amount), ROUND( SUM(amount)/100000 ,2) Lakhs, ROUND( SUM(amount)/10000000 ,2) Cr
FROM 
(
	SELECT nn.*,  
	case 
		when nn.STATUS = 'Untouched' then (nn.famtl * 100000)
		ELSE amt
		END AS amount
	FROM 
	(
		SELECT m.* FROM 
		(
		
		SELECT cd.ceiling_acc_no foc, ch.addl_req famtl , cd.approved_on app_date , cd.ceiling_valid exp_date , 
		try.hierarchy_Code try,
		concat(try.hierarchy_Code,' -> ',try.hierarchy_Name) try_name,
		hst.hierarchy_Code ddo,
		bd.bill_number,
		concat(mh.head_code,' -> ',mh.head_name) mh,
		concat(dh.head_code,' -> ',dh.head_name) dh,
		h.head, 
		CASE
			WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
			WHEN h.plan_status = 'NP' THEN 'EE'
			ELSE 'Plan'
		END AS scheme ,
		case 
			when 
				bd.id IS null
				   then 'Untouched'
			when
				bd.approved_by IS NOT null
					then 'Approved by Treasury'
			when
				bd.rejected_by IS NOT null
					then 'Rejected by Treasury'
			when
				bd.approved_by IS NULL 
					then 'Processing at Treasury'
		END status,
		bd.total_allowance amt ,
		dep.hierarchy_Name dep
		FROM
		probityfinancials.ceiling_distributed cd 
		join probityfinancials.ceiling_distributed_heads ch 
			on ch.dis_id=cd.id
		LEFT JOIN pfmaster.hierarchy_setup hst 
			ON hst.hierarchy_Id =  cd.office_id
		JOIN probityfinancials.heads h 
			ON ch.head_id = h.head_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
			ON	h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc 
			ON	pchm.pc_id = pc.pc_id
		JOIN probityfinancials.head_setup mh
			ON h.major_head = mh.head_setup_id
		JOIN probityfinancials.head_setup dh
			ON h.detailed_head = dh.head_setup_id
		LEFT JOIN ctmis_master.bill_details_base bd
			ON cd.ceiling_acc_no = bd.foc_number
			AND ch.head_id = bd.head_id
		JOIN probityfinancials.ceiling_request_checklist cl
			ON cd.checklist_Id = cl.id
			and cl.fin_Year='2024-25'
			and cl.upload_approved_by is not null 
			and cl.manual='N'
			and cl.group_Id is null 
			and cl.rejected_by is null 
			and cl.fin_Approved_by is not null 
			and cl.fin_Approved_on between  date('2024-04-01') and date('2025-03-31') 
		JOIN pfmaster.hierarchy_setup dep
			ON cl.office = dep.hierarchy_Id
		JOIN pfmaster.hierarchy_mapping hm 
			ON cd.office_id = hm.mapped_Id
		JOIN pfmaster.hierarchy_setup try
			ON hm.mapped_To = try.hierarchy_Id
		WHERE 
		cd.ceiling_valid >= DATE(NOW())
		
		) m
		
		WHERE m.status IN ('Untouched', 'Processing at Treasury')
		
		# Rejected Part starts here
		
		UNION ALL 
		
		SELECT m.* FROM 
		(
		
		SELECT cd.ceiling_acc_no foc, ch.addl_req famtl , cd.approved_on app_date , cd.ceiling_valid exp_date , 
		try.hierarchy_Code try,
		concat(try.hierarchy_Code,' -> ',try.hierarchy_Name) try_name,
		hst.hierarchy_Code ddo,
		bd.bill_number,
		concat(mh.head_code,' -> ',mh.head_name) mh,
		concat(dh.head_code,' -> ',dh.head_name) dh,
		h.head, 
		CASE
			WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
			WHEN h.plan_status = 'NP' THEN 'EE'
			ELSE 'Plan'
		END AS scheme ,
		case 
			when 
				bd.id IS null
				   then 'Untouched'
			when
				bd.approved_by IS NOT null
					then 'Approved by Treasury'
			when
				bd.rejected_by IS NOT null
					then 'Rejected by Treasury'
			when
				bd.approved_by IS NULL 
					then 'Processing at Treasury'
		END status,
		bd.total_allowance amt ,
		dep.hierarchy_Name dep
		FROM
		probityfinancials.ceiling_distributed cd 
		join probityfinancials.ceiling_distributed_heads ch 
			on ch.dis_id=cd.id
		LEFT JOIN pfmaster.hierarchy_setup hst 
			ON hst.hierarchy_Id =  cd.office_id
		JOIN probityfinancials.heads h 
			ON ch.head_id = h.head_id
		LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
			ON	h.head_id = pchm.head_id
		LEFT JOIN probityfinancials.plan_category pc 
			ON	pchm.pc_id = pc.pc_id
		JOIN probityfinancials.head_setup mh
			ON h.major_head = mh.head_setup_id
		JOIN probityfinancials.head_setup dh
			ON h.detailed_head = dh.head_setup_id
		LEFT JOIN ctmis_master.bill_details_base bd
			ON cd.ceiling_acc_no = bd.foc_number
			AND ch.head_id = bd.head_id
		JOIN probityfinancials.ceiling_request_checklist cl
			ON cd.checklist_Id = cl.id
			and cl.fin_Year='2024-25'
			and cl.upload_approved_by is not null 
			and cl.manual='N'
			and cl.group_Id is null 
			and cl.rejected_by is null 
			and cl.fin_Approved_by is not null 
			and cl.fin_Approved_on between  date('2024-04-01') and date('2025-03-31') 
		JOIN pfmaster.hierarchy_setup dep
			ON cl.office = dep.hierarchy_Id
		JOIN pfmaster.hierarchy_mapping hm 
			ON cd.office_id = hm.mapped_Id
		JOIN pfmaster.hierarchy_setup try
			ON hm.mapped_To = try.hierarchy_Id
		WHERE 
		cd.ceiling_valid >= DATE(NOW())
		
		) m
		
		WHERE m.status = 'Rejected by Treasury'
		AND NOT EXISTS 
		(
			SELECT n.* FROM 		
			(
				SELECT cd.ceiling_acc_no foc, 
				case 
					when 
						bd.id IS null
						   then 'Untouched'
					when
						bd.approved_by IS NOT null
							then 'Approved by Treasury'
					when
						bd.rejected_by IS NOT null
							then 'Rejected by Treasury'
					when
						bd.approved_by IS NULL 
							then 'Processing at Treasury'
				END AS status
				FROM
				probityfinancials.ceiling_distributed cd 
				join probityfinancials.ceiling_distributed_heads ch 
					on ch.dis_id=cd.id
				LEFT JOIN ctmis_master.bill_details_base bd
					ON cd.ceiling_acc_no = bd.foc_number
					AND ch.head_id = bd.head_id
				WHERE 
				cd.ceiling_valid >= DATE(NOW())		
			) n	
			WHERE 
			m.foc = n.foc
			AND n.status IN ('Approved by Treasury','Processing at Treasury','Untouched','Rejected by Treasury')		
		)
	) nn
) nnn
GROUP BY 
nnn.dep
#nnn.scheme
ORDER BY 1,2