SELECT hs.hierarchy_Code tryc,hs.hierarchy_Name tryn,  date(x.payment_processed_on),
hs1.hierarchy_Code,hs1.hierarchy_Name,hs2.office_Name ,us.user_Name, COUNT(*) , SUM(bdb2.allowance)   FROM
ctmis_master.payment_base x
join ctmis_master.payment_bills pb on x.id=pb.payment_base_id
join ctmis_master.bill_details_base bdb on pb.bill_details_base_id=bdb.id
join ctmis_master.bill_details_beneficiary bdb2 on bdb2.bill_base=bdb.id
join pfmaster.hierarchy_setup hs on bdb.treasury_id=hs.hierarchy_Id
JOIN  pfmaster.hierarchy_setup hs1 on bdb.ddo_id =hs1.hierarchy_Id
join pfmaster.seat_user_alloted sua on hs1.hierarchy_Id=sua.seat_Id
join pfmaster.user_setup us on us.user_Id=sua.user_Id  
join pfmaster.hierarchy_setup hs2 on hs1.parent_hierarchy=hs2.hierarchy_Id  
where bdb.financial_year='2024-25' 
and DATE(x.payment_processed_on )BETWEEN DATE('2024-04-01') AND DATE(NOW())
#AND  DATE_FORMAT(x.payment_processed_on,'%Y-%m') ='2024-06'
and bdb.type='SB' and bdb.sub_type='SB_SB' and sua.active_Status='Y'   group by hs.hierarchy_Code,hs.hierarchy_Name,
date(x.payment_processed_on), hs1.hierarchy_Code,hs1.hierarchy_Name;




# pay Month wise
SELECT hs.hierarchy_Code tryc,hs.hierarchy_Name tryn, CONCAT(bdb.pay_month,'') , CONCAT(bdb.pay_year,'')pyr,bdb.pay_year, 
hs1.hierarchy_Code,hs1.hierarchy_Name,hs2.office_Name ,us.user_Name, COUNT(*) , SUM(bdb2.allowance), date(x.payment_processed_on) 
FROM
ctmis_master.payment_base x
join ctmis_master.payment_bills pb on x.id=pb.payment_base_id
join ctmis_master.bill_details_base bdb on pb.bill_details_base_id=bdb.id
join ctmis_master.bill_details_beneficiary bdb2 on bdb2.bill_base=bdb.id
join pfmaster.hierarchy_setup hs on bdb.treasury_id=hs.hierarchy_Id
JOIN  pfmaster.hierarchy_setup hs1 on bdb.ddo_id =hs1.hierarchy_Id
join pfmaster.seat_user_alloted sua on hs1.hierarchy_Id=sua.seat_Id
join pfmaster.user_setup us on us.user_Id=sua.user_Id  
join pfmaster.hierarchy_setup hs2 on hs1.parent_hierarchy=hs2.hierarchy_Id  
where bdb.financial_year='2024-25' 
AND  date(x.payment_processed_on) BETWEEN DATE('2024-04-01') AND DATE (NOW())
and bdb.type='SB' 
AND bdb.sub_type='SB_SB' 
and sua.active_Status='Y'  

 group by hs.hierarchy_Code,hs.hierarchy_Name, 
CONCAT(bdb.pay_month,'') , CONCAT(bdb.pay_year,''),bdb.pay_year, hs1.hierarchy_Code,hs1.hierarchy_Name, date(x.payment_processed_on)