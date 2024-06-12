#correct

SELECT CONCAT(mh.head_code,'->',mh.head_name) mhead, try.hierarchy_Name, YEAR(a.receipt_date) yy, MONTHNAME(a.receipt_date)mm, SUM(a.amount) amt,

CASE 
    WHEN MONTH(a.receipt_date)>=4 
    THEN concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1) 
    ELSE concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END  AS financial_year1

FROM ctmis_accounts.ledger_receipts a 
JOIN probityfinancials.heads h 
	ON a.head_of_account = h.head_id
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury = try.hierarchy_Id
	AND try.category = 'T'
	
	JOIN probityfinancials.head_setup mh
	ON h.major_head=mh.head_setup_id
	
WHERE 
date(a.receipt_date )BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND a.financial_year ='2023-24'
AND mh.head_code<2000

GROUP BY CONCAT(mh.head_code,'->',mh.head_name), try.hierarchy_Name, MONTHNAME(a.receipt_date),year(a.receipt_date),

CASE 
    WHEN MONTH(a.receipt_date)>=4 
    THEN concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1) 
    ELSE concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END 


