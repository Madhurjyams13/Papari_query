

		SELECT CONCAT( dh.head_code, '->', dh.head_name) mh,  SUM(le.amount) amt,SUBSTR(h.head, 22,2)
		FROM ctmis_accounts.ledger_expenditure le
		LEFT JOIN probityfinancials.heads h 
				ON le.head_of_account = h.head_id
		JOIN probityfinancials.head_setup dh 
			ON h.major_head = dh.head_setup_id
		JOIN ctmis_master.bill_details_base b
			ON le.source_reference = b.id
		WHERE
		DATE(b.voucher_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
		AND le.financial_year = '2023-24'
		AND le.source_category = 'BILLS'
		AND SUBSTR(h.head,1,4) <> '2071'
		AND b.bill_pension_type IS NULL
		AND SUBSTR(h.head, 22,2)='31'
		
		GROUP BY CONCAT( dh.head_code, '->', dh.head_name),SUBSTR(h.head, 22,2)

