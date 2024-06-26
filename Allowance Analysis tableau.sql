

SELECT p.* ,CONCAT( p.Grade_Pay,'')Gradpayf,CONCAT( p.Dearness_Allowance,'')DAf, CONCAT( p.House_Rent,'')Houserentf,CONCAT( p.Leave_Travel_Concession,'')LTCf,CONCAT( p.Medical_Allowance,'')Medicalf from

(SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, try.hierarchy_Code, try.hierarchy_Name tname, ddo.hierarchy_Code ddocode,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance bill_gross, a.total_deduction bill_deduction, a.total_net_amount,
SUM(com.amount) emp_allowance,
ben.beneficiary_name, ben.beneficiary_code, 
SUM(CASE WHEN cm.component_code = 'AD' THEN com.amount ELSE 0 END) AS 'Additional Dearness',
SUM(CASE WHEN cm.component_code = 'AISA' THEN com.amount ELSE 0 END) AS 'AIS Admissible Allowance',
SUM(CASE WHEN cm.component_code = 'AS' THEN com.amount ELSE 0 END) AS 'Arrear Salary',
SUM(CASE WHEN cm.component_code = 'BA' THEN com.amount ELSE 0 END) AS 'Batta Allowance',
SUM(CASE WHEN cm.component_code = 'CA' THEN com.amount ELSE 0 END) AS 'Commando Allowance',
SUM(CASE WHEN cm.component_code = 'CC' THEN com.amount ELSE 0 END) AS 'City Compensatary',
SUM(CASE WHEN cm.component_code = 'CCA' THEN com.amount ELSE 0 END) AS 'Child Care Allowance',
SUM(CASE WHEN cm.component_code = 'CE' THEN com.amount ELSE 0 END) AS 'Children Education',
SUM(CASE WHEN cm.component_code = 'CPA' THEN com.amount ELSE 0 END) AS 'Compensatory Allowance',
SUM(CASE WHEN cm.component_code = 'CSA' THEN com.amount ELSE 0 END) AS 'Constituency Allowance',
SUM(CASE WHEN cm.component_code = 'CTA' THEN com.amount ELSE 0 END) AS 'Contingency Allowance',
SUM(CASE WHEN cm.component_code = 'CVA' THEN com.amount ELSE 0 END) AS 'Conveyence Allowance',
SUM(CASE WHEN cm.component_code = 'DA' THEN com.amount ELSE 0 END) AS 'Dearness_Allowance',
SUM(CASE WHEN cm.component_code = 'DCA' THEN com.amount ELSE 0 END) AS 'Drivers Commuting Allowance',
SUM(CASE WHEN cm.component_code = 'DP' THEN com.amount ELSE 0 END) AS 'Dearness Pay',
SUM(CASE WHEN cm.component_code = 'EA' THEN com.amount ELSE 0 END) AS 'Equipment Allowance',
SUM(CASE WHEN cm.component_code = 'FA' THEN com.amount ELSE 0 END) AS 'Floating Allowance',
SUM(CASE WHEN cm.component_code = 'FP' THEN com.amount ELSE 0 END) AS 'Fixed Pay',
SUM(CASE WHEN cm.component_code = 'FPTA' THEN com.amount ELSE 0 END) AS 'Fixed or Permanent TA',
SUM(CASE WHEN cm.component_code = 'GP' THEN com.amount ELSE 0 END) AS 'Grade_Pay',
SUM(CASE WHEN cm.component_code = 'HA' THEN com.amount ELSE 0 END) AS 'Handicapped Allowance',
SUM(CASE WHEN cm.component_code = 'HLA' THEN com.amount ELSE 0 END) AS 'Hill Allowance',
SUM(CASE WHEN cm.component_code = 'HA' THEN com.amount ELSE 0 END) AS 'Helper allowance',
SUM(CASE WHEN cm.component_code = 'HR' THEN com.amount ELSE 0 END) AS 'House_Rent',
SUM(CASE WHEN cm.component_code = 'HRM' THEN com.amount ELSE 0 END) AS 'Honorarium',
SUM(CASE WHEN cm.component_code = 'HZA' THEN com.amount ELSE 0 END) AS 'Hazard Allowance',
SUM(CASE WHEN cm.component_code = 'IR' THEN com.amount ELSE 0 END) AS 'Interim Relief',
SUM(CASE WHEN cm.component_code = 'KA' THEN com.amount ELSE 0 END) AS 'Kit Allowance',
SUM(CASE WHEN cm.component_code = 'KMA' THEN com.amount ELSE 0 END) AS 'Kit Maintenance Allowance',
SUM(CASE WHEN cm.component_code = 'LA' THEN com.amount ELSE 0 END) AS 'Lodging Allowance',
SUM(CASE WHEN cm.component_code = 'LS' THEN com.amount ELSE 0 END) AS 'Leave Salary',
SUM(CASE WHEN cm.component_code = 'LTC' THEN com.amount ELSE 0 END) AS 'Leave_Travel_Concession',
SUM(CASE WHEN cm.component_code = 'MA' THEN com.amount ELSE 0 END) AS 'Medical_Allowance',
SUM(CASE WHEN cm.component_code = 'MDA' THEN com.amount ELSE 0 END) AS 'Machine and Dhobi Allowance',
SUM(CASE WHEN cm.component_code = 'MR' THEN com.amount ELSE 0 END) AS 'Medical Reimbursement',
SUM(CASE WHEN cm.component_code = 'NPA' THEN com.amount ELSE 0 END) AS 'Non Practising Allowance',
SUM(CASE WHEN cm.component_code = 'OA' THEN com.amount ELSE 0 END) AS 'Other Allowance',
SUM(CASE WHEN cm.component_code = 'OTA' THEN com.amount ELSE 0 END) AS 'Over Time Allowance',
SUM(CASE WHEN cm.component_code = 'OTS' THEN com.amount ELSE 0 END) AS 'Others',
SUM(CASE WHEN cm.component_code = 'PAY' THEN com.amount ELSE 0 END) AS 'Pay',
SUM(CASE WHEN cm.component_code = 'PP' THEN com.amount ELSE 0 END) AS 'Personal Pay',
SUM(CASE WHEN cm.component_code = 'PRA' THEN com.amount ELSE 0 END) AS 'Pay Revision Arrear',
SUM(CASE WHEN cm.component_code = 'PSP' THEN com.amount ELSE 0 END) AS 'Principal Seat Payment',
SUM(CASE WHEN cm.component_code = 'RA' THEN com.amount ELSE 0 END) AS 'Ration Allowance',
SUM(CASE WHEN cm.component_code = 'RAA' THEN com.amount ELSE 0 END) AS 'Remote Area Allowance',
SUM(CASE WHEN cm.component_code = 'RFA' THEN com.amount ELSE 0 END) AS 'Rifle Allowance',
SUM(CASE WHEN cm.component_code = 'RRI' THEN com.amount ELSE 0 END) AS 'Rural Incentive',
SUM(CASE WHEN cm.component_code = 'SA' THEN com.amount ELSE 0 END) AS 'Sumptuary Allowance',
SUM(CASE WHEN cm.component_code = 'SAA' THEN com.amount ELSE 0 END) AS 'Secretariat Assistance Allowance',
SUM(CASE WHEN cm.component_code = 'SCA' THEN com.amount ELSE 0 END) AS 'Special Compensatory Allowance',
SUM(CASE WHEN cm.component_code = 'SDA' THEN com.amount ELSE 0 END) AS 'Special Duty Allowance',
SUM(CASE WHEN cm.component_code = 'SP' THEN com.amount ELSE 0 END) AS 'Special Pay',
SUM(CASE WHEN cm.component_code = 'STA' THEN com.amount ELSE 0 END) AS 'Special Teaching Allowance',
SUM(CASE WHEN cm.component_code = 'TA' THEN com.amount ELSE 0 END) AS 'Technical Allowance',
SUM(CASE WHEN cm.component_code = 'TC' THEN com.amount ELSE 0 END) AS 'Telephone Charge',
SUM(CASE WHEN cm.component_code = 'TCC' THEN com.amount ELSE 0 END) AS 'Telephonic Charge',
SUM(CASE WHEN cm.component_code = 'TRA' THEN com.amount ELSE 0 END) AS 'Training Allowance',
SUM(CASE WHEN cm.component_code = 'WA' THEN com.amount ELSE 0 END) AS 'Winter Allowance'
#cm.component_code, cm.component_name, com.amount
#cm., ben., '----', com.* 
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
AND cm.component_type = 'A'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
#AND cm.component_code IN ('TGIS', 'TPT')
#16961213 bill details base id
#732731 stager id
#BILL/202425/DMJGAD001/00141(R1) bill number
GROUP BY try.hierarchy_Code, try.hierarchy_Name, ddo.hierarchy_Code,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance, a.total_deduction,
ben.beneficiary_name, ben.beneficiary_code,CONCAT(a.pay_month,'') , CONCAT(a.pay_year,'')


)p







#without pivot



SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, try.hierarchy_Code, try.hierarchy_Name tname, ddo.hierarchy_Code ddocode,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance bill_gross, a.total_deduction bill_deduction, a.total_net_amount,
SUM(com.amount) emp_allowance,
ben.beneficiary_name, ben.beneficiary_code, cm.component_code, cm.component_name

#cm.component_code, cm.component_name, com.amount
#cm., ben., '----', com.* 
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
AND cm.component_type = 'A'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
#AND cm.component_code IN ('TGIS', 'TPT')
#16961213 bill details base id
#732731 stager id
#BILL/202425/DMJGAD001/00141(R1) bill number
GROUP BY try.hierarchy_Code, try.hierarchy_Name, ddo.hierarchy_Code,
a.token_number, a.bill_number, a.bill_date, a.bill_pf_type,
a.total_allowance, a.total_deduction,
ben.beneficiary_name, ben.beneficiary_code,CONCAT(a.pay_month,'') , CONCAT(a.pay_year,''),cm.component_code, cm.component_name


