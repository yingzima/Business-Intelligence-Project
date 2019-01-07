DROP VIEW IF EXISTS lead_view;
CREATE VIEW lead_view AS
SELECT
      lf.lead_create_fact_id,
      current_carrier, 
      coverage_tier,

      lead.city, lead.state, lead.gender, lead.age, lead.lead_status, lead.lead_sub_status,
      full_name_fl as agent,
      partner,
      lead.lead_source as lead_source1, source.lead_source, source.channel,
      dateCreate.time_id as dateCreated, dateBound.time_id as dateBound,
      Raw_score, IF(agent.agent_id = 17, null, 1) AS AssignedToAgent, IF(lf.date_policy_bound = '19000100' , null, 1) as Converted, datediff(date_policy_bound,create_date) as DaysToConvert, pf.premium_written, pf.premium_annualized

FROM  lead_create_fact lf
      LEFT JOIN lead_dim lead ON lf.lead_id = lead.lead_id
      LEFT JOIN applicant_dim app 
            ON lf.ezlynx_applicant_id = app.applicant_id
      LEFT JOIN agent_dim agent ON lf.agent_id = agent.agent_id
      LEFT JOIN app_source_dim source 
            ON lead.app_source_id = source.app_source_id
      LEFT JOIN time_dim dateBound 
            ON lf.date_policy_bound = dateBound.time_id
      LEFT JOIN time_dim dateCreate 
            ON lf.create_date = dateCreate.time_id
      LEFT JOIN policy_type_dim pt 
            ON lf.policy_type_id = pt.policy_type_id
      LEFT JOIN policy_writer_dim pw 
            ON lf.policy_writer_id = pw.policy_writer_id
      LEFT JOIN prior_coverage_dim pc 
            ON lf.prior_coverage_id = pc.prior_coverage_id 
      LEFT JOIN policy_create_fact pf 
            ON app.applicant_id = pf.applicant_id;
