#compile
SELECT sum(p.amt) from(
SELECT h.head, try.hierarchy_Name, a.financial_year, YEAR(a.receipt_date), MONTHNAME(a.receipt_date), SUM(a.amount) amt,

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
WHERE 
date(a.receipt_date )BETWEEN DATE('2024-04-01') AND DATE(NOW())
#AND a.financial_year = '2023-24'
AND h.head LIKE '0406%'
GROUP BY h.head, try.hierarchy_Name, MONTHNAME(a.receipt_date),year(a.receipt_date),a.financial_year,

CASE 
    WHEN MONTH(a.receipt_date)>=4 
    THEN concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1) 
    ELSE concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END 

ORDER BY 1,2,3,4,5
)p
























# not compile
SELECT h.head, try.hierarchy_Name, YEAR(a.challan_deposit_date) yr, monthname(a.challan_deposit_date) mn, sum(hoa.amount) amt,

CASE 
    WHEN MONTH(a.challan_deposit_date)>=4 
    THEN concat(YEAR(a.challan_deposit_date), '-',YEAR(a.challan_deposit_date)+1) 
    ELSE concat(YEAR(a.challan_deposit_date)-1,'-', YEAR(a.challan_deposit_date)) 
END AS financial_year

FROM ctmis_egras.receipt_base a
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
JOIN ctmis_egras.receipt_hoa_details hoa
	ON a.id = hoa.receipt_base
JOIN probityfinancials.heads h 
	ON hoa.head_id = h.head_id 
WHERE 
date(a.challan_deposit_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
#AND a.financial_year = '2023-24'
AND h.head LIKE '0406%'
GROUP BY h.head, try.hierarchy_Name, MONTH(a.challan_deposit_date), YEAR(a.challan_deposit_date),
CASE 
    WHEN MONTH(a.challan_deposit_date)>=4 
    THEN concat(YEAR(a.challan_deposit_date), '-',YEAR(a.challan_deposit_date)+1) 
    ELSE concat(YEAR(a.challan_deposit_date)-1,'-', YEAR(a.challan_deposit_date)) 
END
   

ORDER BY 1,2,3,4
#LIMIT 0,10