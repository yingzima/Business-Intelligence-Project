drop database if exists CS753;
create database CS753;
use CS753;

CREATE TABLE POLICY_TYPE_DIM(
policy_type_id int (8) PRIMARY KEY, 
line_of_business varchar(50), 
policy_term varchar(15), 
current_policy_status varchar(50), 
bundle varchar(15), 
bundle_desc varchar(100));
        
        CREATE TABLE PRIOR_COVERAGE_DIM(
			prior_coverage_id int (8) PRIMARY KEY,
			auto_coverage_level varchar(20), 
			current_carrier varchar(50),
			coverage_tier varchar(20), 
			prior_liability varchar(20),
			ai_current_bi_limits varchar(20));
            
			CREATE TABLE APP_SOURCE_DIM(
				app_source_id int (8) PRIMARY KEY, 
				lead_source varchar(50), 
				channel varchar(50), 
				sub_channel varchar(50));		
            
	CREATE TABLE LEAD_DIM(
			lead_id int (8) PRIMARY KEY,
			app_source_id int(8), 
			lead_email varchar(100),
			lead_status varchar(50),
			lead_sub_status varchar(50), 
			gender varchar(15), 
			dob date,
			age int(3),
			street varchar(100), 
			city varchar(100), 
			state varchar(3), 
			zip varchar(8), 
			phone varchar(15), 
			mobile varchar(15), 
			lead_source varchar(50), 
			partner varchar(100), 	
			sdip varchar(3),
			ai_driver_violations varchar(3),
				CONSTRAINT FK_LEAD_SOURCE FOREIGN KEY(app_source_id) REFERENCES APP_SOURCE_DIM(app_source_id));
            
			CREATE TABLE APPLICANT_DIM(
				applicant_id int (10) PRIMARY KEY, 
				app_source_id int(8), 
				primary_email varchar(100),
				city varchar(100), 
				state varchar(3), 
				zip varchar(8), 
				applicant_type varchar(20),
					CONSTRAINT FK_APP_APP_SOURCE FOREIGN KEY(app_source_id) REFERENCES APP_SOURCE_DIM(app_source_id));
            
            CREATE TABLE POLICY_WRITER_DIM(
				policy_writer_id int (8) PRIMARY KEY, 
				master_company varchar(50), 
				writing_company varchar(50));			
            
            CREATE TABLE AGENT_DIM(
				agent_id int (8) PRIMARY KEY,
				full_name_fl varchar(100), 
				full_name_lf varchar(100),
				last_name varchar(50), 
				first_name varchar(50));		
            
            CREATE TABLE TIME_DIM(
				time_id int PRIMARY KEY, 
                day_of_month int, 
				month_num int, 
				month_name varchar(20), 
				year int(4), 
				day_of_week varchar(15));
                
	#drop table policy_create_fact;
                
	CREATE TABLE policy_create_fact(
		policy_number varchar(20) PRIMARY KEY, 
		applicant_id int (10), 
		policy_writer_id int(8), 
		policy_type_id int(8), 
		agent_id int(8), 
		premium_annualized numeric(7,2), 
		premium_written numeric(7,2),
		premium_change_amount numeric(7,2), 
		premium_change_percent numeric(7,2), 
		change_date int(8), 
        download_date int, 
		effective_date int,
        expiration_date int, 
		cancellation_date int, 
		cancelled_ind varchar(15), 
		policy_duration int (8), 
			CONSTRAINT FK_POLICY_APPLICANT FOREIGN KEY (applicant_id) REFERENCES APPLICANT_DIM(applicant_id),
			CONSTRAINT FK_POLICY_PW FOREIGN KEY (policy_writer_id) REFERENCES POLICY_WRITER_DIM(policy_writer_id),
			CONSTRAINT FK_POLICY_PT FOREIGN KEY (policy_type_id) REFERENCES POLICY_TYPE_DIM(policy_type_id),
			CONSTRAINT FK_POLICY_AGENT FOREIGN KEY (agent_id) REFERENCES AGENT_DIM(agent_id),
			CONSTRAINT FK_POLICY_CHANGE_DATE FOREIGN KEY (change_date) REFERENCES TIME_DIM(time_id),
			CONSTRAINT FK_POLICY_DL_DATE FOREIGN KEY (download_date) REFERENCES TIME_DIM(time_id),
			CONSTRAINT FK_POLICY_EFF_DATE FOREIGN KEY (effective_date) REFERENCES TIME_DIM(time_id),
			CONSTRAINT FK_POLICY_EXP_DATE FOREIGN KEY (expiration_date) REFERENCES TIME_DIM(time_id),
			CONSTRAINT FK_POLICY_CANC_DATE FOREIGN KEY (cancellation_date) REFERENCES TIME_DIM(time_id)
);
                
#drop table lead_create_fact;
CREATE TABLE lead_create_fact(
		lead_create_fact_id int PRIMARY KEY AUTO_INCREMENT,
		lead_id  int(8),
		ezlynx_applicant_id int (8),
		create_date int, 
		agent_id int(8),
		policy_writer_id int(8),
		policy_type_id int(8),
		prior_coverage_id int(8), 
		date_policy_bound int, 
		auto_policy_effective_date int, 
		last_modified int, 
		raw_score int, 
		accidents int, 
		violations int,
		loss int, 
		completed_web_start int(1),
			CONSTRAINT FK_LEAD FOREIGN KEY (lead_id) REFERENCES LEAD_DIM(lead_id),
            CONSTRAINT FK_LEAD_APPLICANT FOREIGN KEY (ezlynx_applicant_id) REFERENCES APPLICANT_DIM(applicant_id),
            CONSTRAINT FK_LEAD_CREATE_DATE FOREIGN KEY (create_date) REFERENCES TIME_DIM(time_id),
            CONSTRAINT FK_LEAD_AGENT FOREIGN KEY (agent_id) REFERENCES AGENT_DIM(agent_id),
            CONSTRAINT FK_LEAD_PW FOREIGN KEY (policy_writer_id) REFERENCES POLICY_WRITER_DIM(policy_writer_id),
            CONSTRAINT FK_LEAD_PT FOREIGN KEY (policy_type_id) REFERENCES POLICY_TYPE_DIM(policy_type_id),
            CONSTRAINT FK_LEAD_PC FOREIGN KEY (create_date) REFERENCES TIME_DIM(time_id),
            CONSTRAINT FK_LEAD_DATE_BOUND FOREIGN KEY (date_policy_bound) REFERENCES TIME_DIM(time_id),
            CONSTRAINT FK_LEAD_EFFECTIVE_DATE FOREIGN KEY (auto_policy_effective_date) REFERENCES TIME_DIM(time_id),
            CONSTRAINT FK_LEAD_LAST_MODIFIED FOREIGN KEY (last_modified) REFERENCES TIME_DIM(time_id)
            ) ;

            
            /*
            17:05:08	CREATE TABLE lead_create_fact(   lead_create_fact_id int PRIMARY KEY AUTO_INCREMENT,   lead_id  int(8),   ezlynx_applicant_id int (8),   create_date date,    agent_id int(8),    policy_writer_id int(8),   policy_type_id int(8),   prior_coverage_id int(8),    date_policy_bound date,    auto_policy_effective_date date,    last_modified date,    raw_score int,    accidents int,    violations int,   loss int,    completed_web_start int(1),    CONSTRAINT FK_LEAD FOREIGN KEY (lead_id) REFERENCES LEAD_DIM(lead_id),             CONSTRAINT FK_LEAD_CREATE_DATE FOREIGN KEY (create_date) REFERENCES TIME_DIM(time_id)             CONSTRAINT FK_LEAD_AGENT FOREIGN KEY (agent_id) REFERENCES AGENT_DIM(agent_id)             CONSTRAINT FK_LEAD_PW FOREIGN KEY (policy_writer_id) REFERENCES POLICY_WRITER_DIM(policy_writer_id)             CONSTRAINT FK_LEAD_PT FOREIGN KEY (policy_type_id) REFERENCES POLICY_TYPE_DIM(policy_type_id)             CONSTRAINT FK_LEAD_PC FOREIGN KEY (create_date) REFERENCES TIME_DIM(time_id)             CONSTRAINT FK_LEAD_DATE_BOUND FOREIGN KEY (date_policy_bound) REFERENCES TIME_DIM(time_id)             CONSTRAINT FK_LEAD_EFFECTIVE_DATE FOREIGN KEY (auto_policy_effective_date) REFERENCES TIME_DIM(time_id)             CONSTRAINT FK_LEAD_LAST_MODIFIED FOREIGN KEY (last_modified) REFERENCES TIME_DIM(time_id)             )	Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'CONSTRAINT FK_LEAD_AGENT FOREIGN KEY (agent_id) REFERENCES AGENT_DIM(agent_id)  ' at line 20	0.00015 sec

             
