SELECT 
    h.head,
    try.hierarchy_Name ,# year(a.receipt_date),
   
    
    SUM(CASE WHEN MONTH(a.receipt_date) = 4 THEN a.amount ELSE 0 END) AS April,
    SUM(CASE WHEN MONTH(a.receipt_date) = 5 THEN a.amount ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(a.receipt_date) = 6 THEN a.amount ELSE 0 END) AS June,
    SUM(CASE WHEN MONTH(a.receipt_date) = 7 THEN a.amount ELSE 0 END) AS July,
    SUM(CASE WHEN MONTH(a.receipt_date) = 8 THEN a.amount ELSE 0 END) AS August,
    SUM(CASE WHEN MONTH(a.receipt_date) = 9 THEN a.amount ELSE 0 END) AS September,
    SUM(CASE WHEN MONTH(a.receipt_date) = 10 THEN a.amount ELSE 0 END) AS October,
    SUM(CASE WHEN MONTH(a.receipt_date) = 11 THEN a.amount ELSE 0 END) AS November,
    SUM(CASE WHEN MONTH(a.receipt_date) = 12 THEN a.amount ELSE 0 END) AS December,
    SUM(CASE WHEN MONTH(a.receipt_date) = 1 THEN a.amount ELSE 0 END) AS January,
    SUM(CASE WHEN MONTH(a.receipt_date) = 2 THEN a.amount ELSE 0 END) AS February,
    SUM(CASE WHEN MONTH(a.receipt_date) = 3 THEN a.amount ELSE 0 END) AS March,
    
    
    CASE 
    WHEN MONTH(a.receipt_date)>=4 
    THEN concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1) 
    ELSE concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END  AS financial_year1


FROM 
    ctmis_accounts.ledger_receipts a 
JOIN 
    probityfinancials.heads h 
	 ON a.head_of_account = h.head_id
JOIN 
    pfmaster.hierarchy_setup try
	  ON a.treasury = try.hierarchy_Id
   
WHERE 
    DATE(a.receipt_date) BETWEEN '2024-04-01' AND '2025-03-31'
    AND h.head LIKE '0406%'
     AND try.category = 'T'
     AND a.financial_year='2024-25'
GROUP BY  
    h.head, 
    try.hierarchy_Name,
      CASE 
    WHEN MONTH(a.receipt_date)>=4 
    THEN concat(YEAR(a.receipt_date), '-',YEAR(a.receipt_date)+1) 
    ELSE concat(YEAR(a.receipt_date)-1,'-', YEAR(a.receipt_date)) 
END  #,year(a.receipt_date)
    
ORDER BY 1,2
   