SELECT *
  FROM (SELECT A.CHALLAN_DEPOSIT_DATE, A.BANK_CODE, sum(a.amount) AM
          FROM rct_challan_hdr A
         WHERE a.treasury_code = 'CYB'
           and to_char(a.challan_deposit_date, 'mm/yyyy') = '07/2023'
         GROUP BY A.CHALLAN_DEPOSIT_DATE, A.BANK_CODE) PIVOT(SUM(AM) AS AM FOR BANK_CODE IN('AXI ',
                                                                                            'EPY ',
                                                                                            'SBI ',
                                                                                            'PG1 ',
                                                                                            'HDF ',
                                                                                            'ICI ',
                                                                                            'RBI',
                                                                                            'SBI',
                                                                                            'YES ')) C
 ORDER BY C.CHALLAN_DEPOSIT_DATE
