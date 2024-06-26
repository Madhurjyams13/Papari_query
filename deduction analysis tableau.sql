
SELECT p.* ,CONCAT( p.GIS,'')gisf, CONCAT( p.Professional_Tax,'')ptaxf from

(SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, try.hierarchy_Code, try.hierarchy_Name tname, ddo.hierarchy_Code ddocode,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance bill_gross, a.total_deduction bill_deduction, a.total_net_amount,
SUM(com.amount) emp_deduction,a.pay_year, a.pay_month ,
ben.beneficiary_name, ben.beneficiary_code, 
SUM(CASE WHEN cm.component_code = 'TGIS' THEN com.amount ELSE 0 END) AS 'GIS',
SUM(CASE WHEN cm.component_code = 'TPT' THEN com.amount ELSE 0 END) AS 'Professional_Tax',
SUM(CASE WHEN cm.component_code = 'GPFR' THEN com.amount ELSE 0 END) AS 'Gpf Refund',
SUM(CASE WHEN cm.component_code = 'GPFS' THEN com.amount ELSE 0 END) AS 'GPF subscription',
SUM(CASE WHEN cm.component_code = 'NPSL' THEN com.amount ELSE 0 END) AS 'NPS Lite',
SUM(CASE WHEN cm.component_code = 'NPSR' THEN com.amount ELSE 0 END) AS 'Nps Refund',
SUM(CASE WHEN cm.component_code = 'NPSS' THEN com.amount ELSE 0 END) AS 'Nps Subscription',
SUM(CASE WHEN cm.component_code = 'TIT' THEN com.amount ELSE 0 END) AS 'Income Tax',
SUM(CASE WHEN cm.component_code = 'MMSLY' THEN com.amount ELSE 0 END) AS 'MMSLY',
SUM(CASE WHEN cm.component_code = 'AGFA' THEN com.amount ELSE 0 END) AS 'Ag Festival Advance',
SUM(CASE WHEN cm.component_code = 'AGHBA' THEN com.amount ELSE 0 END) AS 'HBA Principal (State)',
SUM(CASE WHEN cm.component_code = 'AGHBAH' THEN com.amount ELSE 0 END) AS 'HUDCO Principal',
SUM(CASE WHEN cm.component_code = 'AGIS' THEN com.amount ELSE 0 END) AS 'AIS GIS',
SUM(CASE WHEN cm.component_code = 'AGMCA' THEN com.amount ELSE 0 END) AS 'Motor Car advance1',
SUM(CASE WHEN cm.component_code = 'AGO' THEN com.amount ELSE 0 END) AS 'Ag Others',
SUM(CASE WHEN cm.component_code = 'AGOCA' THEN com.amount ELSE 0 END) AS 'Advance for Other Conveyance',
SUM(CASE WHEN cm.component_code = 'AIFS' THEN com.amount ELSE 0 END) AS 'AIF Refund',
SUM(CASE WHEN cm.component_code = 'AISR' THEN com.amount ELSE 0 END) AS 'AIS Refund',
SUM(CASE WHEN cm.component_code = 'AISS' THEN com.amount ELSE 0 END) AS 'AIS subscription',
SUM(CASE WHEN cm.component_code = 'DRO' THEN com.amount ELSE 0 END) AS 'Deduct Recoveries of Overpayments',
SUM(CASE WHEN cm.component_code = 'HBAI' THEN com.amount ELSE 0 END) AS 'HBA Interest',
SUM(CASE WHEN cm.component_code = 'OH' THEN com.amount ELSE 0 END) AS 'Other Housing',
SUM(CASE WHEN cm.component_code = 'THBA' THEN com.amount ELSE 0 END) AS 'Interest on House Building Advances',
SUM(CASE WHEN cm.component_code = 'THBAH' THEN com.amount ELSE 0 END) AS 'Interest on HBA (HUDCO)',
SUM(CASE WHEN cm.component_code = 'THR' THEN com.amount ELSE 0 END) AS 'License Fees/ House Rent',
SUM(CASE WHEN cm.component_code = 'TMCA' THEN com.amount ELSE 0 END) AS 'Motor Car advance',
SUM(CASE WHEN cm.component_code = 'TO' THEN com.amount ELSE 0 END) AS 'Treasury Others',
SUM(CASE WHEN cm.component_code = 'TOCA' THEN com.amount ELSE 0 END) AS 'Interest On Other Conveyance Advance',
SUM(CASE WHEN cm.component_code = 'TOD' THEN com.amount ELSE 0 END) AS 'Overdrawal'
#cm.component_code, cm.component_name, com.amount
#cm.*, ben.*, '----', com.* 
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id 
JOIN pfmaster.hierarchy_setup try
	ON a.treasury_id = try.hierarchy_Id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.bill_details_beneficiary ben
	ON a.id = ben.bill_base
LEFT JOIN ctmis_master.bill_details_component com
	ON a.id = com.bill_base
	AND ben.id = com.bill_beneficiary 
JOIN ctmis_dataset.bill_component_master cm
	ON com.component_master = cm.code
WHERE
a.pay_year = 2024
and a.pay_month = 3
AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.sub_type = 'SB_SB'
AND cm.component_type = 'D'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
#AND cm.component_code IN ('TGIS', 'TPT')
#16961213 bill details base id
#732731 stager id
#BILL/202425/DMJGAD001/00141(R1) bill number
GROUP BY a.pay_year, a.pay_month , try.hierarchy_Code, try.hierarchy_Name, ddo.hierarchy_Code,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance, a.total_deduction,
ben.beneficiary_name, ben.beneficiary_code,CONCAT(a.pay_month,'') , CONCAT(a.pay_year,'')


)p












# without pivot




SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, try.hierarchy_Code, try.hierarchy_Name tname, ddo.hierarchy_Code ddocode,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance bill_gross, a.total_deduction bill_deduction, a.total_net_amount,
SUM(com.amount) emp_deduction,a.pay_year, a.pay_month ,
ben.beneficiary_name, ben.beneficiary_code, cm.component_code, cm.component_name

#cm.component_code, cm.component_name, com.amount
#cm.*, ben.*, '----', com.* 
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id 
JOIN pfmaster.hierarchy_setup try
	ON a.treasury_id = try.hierarchy_Id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.bill_details_beneficiary ben
	ON a.id = ben.bill_base
LEFT JOIN ctmis_master.bill_details_component com
	ON a.id = com.bill_base
	AND ben.id = com.bill_beneficiary 
JOIN ctmis_dataset.bill_component_master cm
	ON com.component_master = cm.code
WHERE
a.pay_year = 2024
and a.pay_month >= 3
#AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.sub_type = 'SB_SB'
AND cm.component_type = 'D'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
#AND cm.component_code IN ('TGIS', 'TPT')
#16961213 bill details base id
#732731 stager id
#BILL/202425/DMJGAD001/00141(R1) bill number
GROUP BY a.pay_year, a.pay_month , try.hierarchy_Code, try.hierarchy_Name, ddo.hierarchy_Code,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance, a.total_deduction,
ben.beneficiary_name, ben.beneficiary_code,CONCAT(a.pay_month,'') , CONCAT(a.pay_year,''),cm.component_code, cm.component_name

