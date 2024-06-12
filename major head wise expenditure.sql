SELECT m.mh, m.dt,ROUND ( SUM(m.amt)/10000000 ,2) Amount FROM 
(

		SELECT CONCAT( dh.head_code, '->', dh.head_name) mh,  SUM(le.amount) amt, date(le.expenditure_date) dt
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h 
				ON le.head_of_account = h.head_id
		JOIN probityfinancials.head_setup dh 
			ON h.major_head = dh.head_setup_id
		JOIN ctmis_master.bill_details_base b
			ON le.source_reference = b.id
		WHERE
		date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
		AND le.financial_year = '2024-25'
		AND le.source_category = 'BILLS'
		AND SUBSTR(h.head,1,4) <> '2071'
		AND b.bill_pension_type IS NULL
		AND SUBSTR(h.head, 22,2)<>'21'
		
		GROUP BY CONCAT( dh.head_code, '->', dh.head_name), date(le.expenditure_date)
		
		UNION ALL 
		
		SELECT 'Pension', SUM(b.total_allowance), DATE(b.voucher_date)
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h 
				ON le.head_of_account = h.head_id
		JOIN ctmis_master.bill_details_base b
			ON le.source_reference = b.id 
		WHERE
		DATE(b.voucher_date) BETWEEN DATE('2024-04-01') AND DATE(NOW())
		AND le.financial_year = '2024-25'
		AND le.source_category = 'BILLS'
		AND ( SUBSTR(h.head,1,4) = '2071' OR b.bill_pension_type IS NOT NULL or SUBSTR(h.head, 22,2)='21' )
		GROUP BY DATE(b.voucher_date)
		
		UNION ALL 
		
		SELECT CONCAT( dh.head_code, '->', dh.head_name), SUM(le.amount), date(le.expenditure_date) 
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN ctmis_master.pay_cheque_base b
				ON le.source_reference = b.id 
				AND le.source_category = 'CHEQUE'
		LEFT JOIN probityfinancials.heads h 
				ON le.head_of_account = h.head_id
		JOIN probityfinancials.head_setup dh 
			ON h.major_head = dh.head_setup_id
		WHERE
		date(le.expenditure_date)  BETWEEN DATE('2024-04-01') AND DATE(NOW())
		AND le.financial_year = '2024-25'
		AND le.source_category <> 'BILLS'
		
		GROUP BY CONCAT( dh.head_code, '->', dh.head_name),date(le.expenditure_date)
		
) m
GROUP BY m.mh,m.dt
ORDER BY 1,2

