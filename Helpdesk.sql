SELECT mo.module_Name, smo.name sub_module, r.page_Title page_title, r.ticket_No , 
r.controlling_Office, r.hierarchy_Code, r.seat_Name,
r.category, r.severity, r.priority, r.request_Type,
r.status,
case 
	when  r.status = 'N' then 'Not submitted'
	when  r.status = 'S' then 'Submitted'
	when  r.status = 'V' then 'Verified'
	when  r.status = 'A' then 'Accepted'
	when  r.status = 'C' then 'Closed'
	when  r.status = 'R' then 'Rejected'
	ELSE  r.status
END AS STATUS1,
r.submitted_On, 
CONCAT(acceptu.user_Name, ' ', acceptu.last_Name) accepted_by,
TIMESTAMPDIFF(Hour, r.submitted_On, ifnull(r.accept_Or_Reject_On, now()) ) accept_time_hour,
r.accept_Or_Reject_On,
CONCAT(assignu.user_Name, ' ', assignu.last_Name) assigned_to, 
tsk.completedDate,
TIMESTAMPDIFF(Hour, ifnull(r.accept_Or_Reject_On, now()), ifnull(r.closed_On, now() ) ) closed_time_hour,
r.closed_On,
CONCAT(closedu.user_Name, ' ', closedu.last_Name) closed_by,
case 
	when CONCAT(acceptu.user_Name, ' ', acceptu.last_Name) IS NULL then 'Yet to be Accepted' 
	when CONCAT(closedu.user_Name, ' ', closedu.last_Name) IS NULL then CONCAT(assignu.user_Name, ' ', assignu.last_Name)
	ELSE 'Closed'
END AS user_status

FROM helpdesk.request r
JOIN helpdesk.module mo
	ON r.module_Id = mo.id
LEFT JOIN helpdesk.sub_module_setup smo
	ON r.sub_module_id = smo.id
LEFT JOIN helpdesk.task tsk
	ON r.id = tsk.request_Id
	
LEFT JOIN helpdesk.ts_km_mapping accept
	ON r.accept_Or_Reject_By = accept.id 
LEFT JOIN pfmaster.seat_user_alloted accepts
	ON accept.pfmaster_Allot_Id = accepts.allot_Id
LEFT JOIN pfmaster.user_setup acceptu
	ON accepts.user_Id = acceptu.user_Id	
	
LEFT JOIN helpdesk.ts_km_mapping assign
	ON r.assigned_To = assign.id 
LEFT JOIN pfmaster.seat_user_alloted assigns
	ON assign.pfmaster_Allot_Id = assigns.allot_Id
LEFT JOIN pfmaster.user_setup assignu
	ON assigns.user_Id = assignu.user_Id
	
LEFT JOIN helpdesk.ts_km_mapping closed
	ON r.closed_By = closed.id 
LEFT JOIN pfmaster.seat_user_alloted closeds
	ON closed.pfmaster_Allot_Id = closeds.allot_Id
LEFT JOIN pfmaster.user_setup closedu
	ON closeds.user_Id = closedu.user_Id
WHERE r.fin_Year = '2024-25'
AND r.submitted_On IS NOT NULL 

ORDER BY 7# r.submitted_On #LIMIT 0,20