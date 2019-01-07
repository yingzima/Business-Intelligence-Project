DROP VIEW IF EXISTS policy_view;
CREATE VIEW policy_view AS 
SELECT
Pf.policy_number, pf.applicant_id,
App.city, app.state, app.applicant_type,
full_name_fl as agent,
Master_company, writing_company,
Pt.line_of_business, pt.policy_term, pt.current_policy_status,
Source.lead_source, source.channel, source.sub_channel,
Pc.auto_coverage_level, pc.current_carrier AS PriorCarrier, pc.coverage_tier AS PriorCoverageTier, pc.prior_liability,
downloadDate.time_id AS downloadDate, effectiveDate.time_id AS effectiveDate, cancellationDate.time_id AS cancellationDate, expirationDate.time_id AS expirationDate, changeDate.time_id AS changeDate,
Pf.policy_duration, raw_score, IF(lf.lead_create_fact_id is null, null, 1) as ConvertedLead, IF(cancellationDate.time_id <> '19000100',1,0) as Cancelled, pf.premium_written, pf.premium_annualized

FROM  policy_create_fact pf
LEFT JOIN applicant_dim app 
ON pf.applicant_id = app.applicant_id
LEFT JOIN agent_dim agent 
ON pf.agent_id = agent.agent_id
LEFT JOIN app_source_dim source 
ON app.app_source_id = source.app_source_id
LEFT JOIN time_dim downloadDate 
ON pf.download_date = downloadDate.time_id
LEFT JOIN time_dim effectiveDate 
ON pf.effective_date = effectiveDate.time_id
LEFT JOIN time_dim cancellationDate 
ON pf.cancellation_date = cancellationDate.time_id
LEFT JOIN time_dim expirationDate 
ON pf.expiration_date = expirationDate.time_id
LEFT JOIN time_dim changeDate 
ON pf.change_date = changeDate.time_id
LEFT JOIN policy_type_dim pt 
ON pf.policy_type_id = pt.policy_type_id
LEFT JOIN policy_writer_dim pw 
ON pf.policy_writer_id = pw.policy_writer_id
LEFT JOIN lead_create_fact lf 
ON pf.applicant_id = lf.ezlynx_applicant_id
LEFT JOIN prior_coverage_dim pc 
ON lf.prior_coverage_id = pc.prior_coverage_id;
