SELECT CONCAT(mh.head_code, '->', mh.head_name) AS mhead,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'April' THEN a.amount ELSE 0 END) AS April,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'May' THEN a.amount ELSE 0 END) AS May,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'June' THEN a.amount ELSE 0 END) AS June,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'July' THEN a.amount ELSE 0 END) AS July,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'August' THEN a.amount ELSE 0 END) AS August,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'September' THEN a.amount ELSE 0 END) AS September,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'October' THEN a.amount ELSE 0 END) AS October,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'November' THEN a.amount ELSE 0 END) AS November,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'December' THEN a.amount ELSE 0 END) AS December,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'January' THEN a.amount ELSE 0 END) AS January,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'February' THEN a.amount ELSE 0 END) AS February,
       SUM(CASE WHEN MONTHNAME(a.receipt_date) = 'March' THEN a.amount ELSE 0 END) AS March
FROM ctmis_accounts.ledger_receipts a
JOIN probityfinancials.heads h ON a.head_of_account = h.head_id
JOIN pfmaster.hierarchy_setup try ON a.treasury = try.hierarchy_Id AND try.category = 'T'
JOIN probityfinancials.head_setup mh ON h.major_head = mh.head_setup_id
WHERE DATE(a.receipt_date) BETWEEN DATE('2024-04-01') AND DATE('2024-05-31')
  AND a.financial_year = '2024-25'
  AND mh.head_code < 2000
GROUP BY CONCAT(mh.head_code, '->', mh.head_name);

