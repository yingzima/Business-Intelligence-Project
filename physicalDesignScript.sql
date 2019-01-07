-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: CS753
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.26-MariaDB


--
-- Table structure for table `AGENT_DIM`
--

DROP TABLE IF EXISTS `AGENT_DIM`;

CREATE TABLE `AGENT_DIM` (
  `agent_id` int(8) NOT NULL,
  `full_name_fl` varchar(100) DEFAULT NULL,
  `full_name_lf` varchar(100) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `APPLICANT_DIM`
--

DROP TABLE IF EXISTS `APPLICANT_DIM`;

CREATE TABLE `APPLICANT_DIM` (
  `applicant_id` int(10) NOT NULL,
  `app_source_id` int(8) DEFAULT NULL,
  `primary_email` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(3) DEFAULT NULL,
  `zip` varchar(8) DEFAULT NULL,
  `applicant_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`applicant_id`),
  KEY `FK_APP_APP_SOURCE` (`app_source_id`),
  CONSTRAINT `FK_APP_APP_SOURCE` FOREIGN KEY (`app_source_id`) REFERENCES `APP_SOURCE_DIM` (`app_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `APP_SOURCE_DIM`
--

DROP TABLE IF EXISTS `APP_SOURCE_DIM`;

CREATE TABLE `APP_SOURCE_DIM` (
  `app_source_id` int(8) NOT NULL,
  `lead_source` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `sub_channel` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`app_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `LEAD_DIM`
--

DROP TABLE IF EXISTS `LEAD_DIM`;

CREATE TABLE `LEAD_DIM` (
  `lead_id` int(8) NOT NULL,
  `app_source_id` int(8) DEFAULT NULL,
  `lead_email` varchar(100) DEFAULT NULL,
  `lead_status` varchar(50) DEFAULT NULL,
  `lead_sub_status` varchar(50) DEFAULT NULL,
  `gender` varchar(15) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `age` int(3) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(3) DEFAULT NULL,
  `zip` varchar(8) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `lead_source` varchar(50) DEFAULT NULL,
  `partner` varchar(100) DEFAULT NULL,
  `sdip` varchar(3) DEFAULT NULL,
  `ai_driver_violations` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`lead_id`),
  KEY `FK_LEAD_SOURCE` (`app_source_id`),
  CONSTRAINT `FK_LEAD_SOURCE` FOREIGN KEY (`app_source_id`) REFERENCES `APP_SOURCE_DIM` (`app_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `POLICY_TYPE_DIM`
--

DROP TABLE IF EXISTS `POLICY_TYPE_DIM`;

CREATE TABLE `POLICY_TYPE_DIM` (
  `policy_type_id` int(8) NOT NULL,
  `line_of_business` varchar(50) DEFAULT NULL,
  `policy_term` varchar(15) DEFAULT NULL,
  `current_policy_status` varchar(50) DEFAULT NULL,
  `bundle` varchar(15) DEFAULT NULL,
  `bundle_desc` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`policy_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `POLICY_WRITER_DIM`
--

DROP TABLE IF EXISTS `POLICY_WRITER_DIM`;

CREATE TABLE `POLICY_WRITER_DIM` (
  `policy_writer_id` int(8) NOT NULL,
  `master_company` varchar(50) DEFAULT NULL,
  `writing_company` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`policy_writer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `PRIOR_COVERAGE_DIM`
--

DROP TABLE IF EXISTS `PRIOR_COVERAGE_DIM`;

CREATE TABLE `PRIOR_COVERAGE_DIM` (
  `prior_coverage_id` int(8) NOT NULL,
  `auto_coverage_level` varchar(20) DEFAULT NULL,
  `current_carrier` varchar(50) DEFAULT NULL,
  `coverage_tier` varchar(20) DEFAULT NULL,
  `prior_liability` varchar(20) DEFAULT NULL,
  `ai_current_bi_limits` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`prior_coverage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `TIME_DIM`
--

DROP TABLE IF EXISTS `TIME_DIM`;

CREATE TABLE `TIME_DIM` (
  `time_id` int(11) NOT NULL,
  `day_of_month` int(11) DEFAULT NULL,
  `month_num` int(11) DEFAULT NULL,
  `month_name` varchar(20) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `day_of_week` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`time_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `lead_create_fact`
--

DROP TABLE IF EXISTS `lead_create_fact`;

CREATE TABLE `lead_create_fact` (
  `lead_create_fact_id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` int(8) DEFAULT NULL,
  `ezlynx_applicant_id` int(8) DEFAULT NULL,
  `create_date` int(11) DEFAULT NULL,
  `agent_id` int(8) DEFAULT NULL,
  `policy_writer_id` int(8) DEFAULT NULL,
  `policy_type_id` int(8) DEFAULT NULL,
  `prior_coverage_id` int(8) DEFAULT NULL,
  `date_policy_bound` int(11) DEFAULT NULL,
  `auto_policy_effective_date` int(11) DEFAULT NULL,
  `last_modified` int(11) DEFAULT NULL,
  `raw_score` int(11) DEFAULT NULL,
  `accidents` int(11) DEFAULT NULL,
  `violations` int(11) DEFAULT NULL,
  `loss` int(11) DEFAULT NULL,
  `completed_web_start` int(1) DEFAULT NULL,
  PRIMARY KEY (`lead_create_fact_id`),
  KEY `FK_LEAD` (`lead_id`),
  KEY `FK_LEAD_APPLICANT` (`ezlynx_applicant_id`),
  KEY `FK_LEAD_AGENT` (`agent_id`),
  KEY `FK_LEAD_PW` (`policy_writer_id`),
  KEY `FK_LEAD_PT` (`policy_type_id`),
  KEY `FK_LEAD_PC` (`create_date`),
  KEY `FK_LEAD_DATE_BOUND` (`date_policy_bound`),
  KEY `FK_LEAD_EFFECTIVE_DATE` (`auto_policy_effective_date`),
  KEY `FK_LEAD_LAST_MODIFIED` (`last_modified`),
  CONSTRAINT `FK_LEAD` FOREIGN KEY (`lead_id`) REFERENCES `LEAD_DIM` (`lead_id`),
  CONSTRAINT `FK_LEAD_AGENT` FOREIGN KEY (`agent_id`) REFERENCES `AGENT_DIM` (`agent_id`),
  CONSTRAINT `FK_LEAD_APPLICANT` FOREIGN KEY (`ezlynx_applicant_id`) REFERENCES `APPLICANT_DIM` (`applicant_id`),
  CONSTRAINT `FK_LEAD_CREATE_DATE` FOREIGN KEY (`create_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_LEAD_DATE_BOUND` FOREIGN KEY (`date_policy_bound`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_LEAD_EFFECTIVE_DATE` FOREIGN KEY (`auto_policy_effective_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_LEAD_LAST_MODIFIED` FOREIGN KEY (`last_modified`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_LEAD_PC` FOREIGN KEY (`create_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_LEAD_PT` FOREIGN KEY (`policy_type_id`) REFERENCES `POLICY_TYPE_DIM` (`policy_type_id`),
  CONSTRAINT `FK_LEAD_PW` FOREIGN KEY (`policy_writer_id`) REFERENCES `POLICY_WRITER_DIM` (`policy_writer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3788 DEFAULT CHARSET=latin1;


--
-- Table structure for table `policy_create_fact`
--

DROP TABLE IF EXISTS `policy_create_fact`;

CREATE TABLE `policy_create_fact` (
  `policy_number` varchar(20) NOT NULL,
  `applicant_id` int(10) DEFAULT NULL,
  `policy_writer_id` int(8) DEFAULT NULL,
  `policy_type_id` int(8) DEFAULT NULL,
  `agent_id` int(8) DEFAULT NULL,
  `premium_annualized` decimal(7,2) DEFAULT NULL,
  `premium_written` decimal(7,2) DEFAULT NULL,
  `premium_change_amount` decimal(7,2) DEFAULT NULL,
  `premium_change_percent` decimal(7,2) DEFAULT NULL,
  `change_date` int(8) DEFAULT NULL,
  `download_date` int(11) DEFAULT NULL,
  `effective_date` int(11) DEFAULT NULL,
  `expiration_date` int(11) DEFAULT NULL,
  `cancellation_date` int(11) DEFAULT NULL,
  `cancelled_ind` varchar(15) DEFAULT NULL,
  `policy_duration` int(8) DEFAULT NULL,
  PRIMARY KEY (`policy_number`),
  KEY `FK_POLICY_APPLICANT` (`applicant_id`),
  KEY `FK_POLICY_PW` (`policy_writer_id`),
  KEY `FK_POLICY_PT` (`policy_type_id`),
  KEY `FK_POLICY_AGENT` (`agent_id`),
  KEY `FK_POLICY_CHANGE_DATE` (`change_date`),
  KEY `FK_POLICY_DL_DATE` (`download_date`),
  KEY `FK_POLICY_EFF_DATE` (`effective_date`),
  KEY `FK_POLICY_EXP_DATE` (`expiration_date`),
  KEY `FK_POLICY_CANC_DATE` (`cancellation_date`),
  CONSTRAINT `FK_POLICY_AGENT` FOREIGN KEY (`agent_id`) REFERENCES `AGENT_DIM` (`agent_id`),
  CONSTRAINT `FK_POLICY_APPLICANT` FOREIGN KEY (`applicant_id`) REFERENCES `APPLICANT_DIM` (`applicant_id`),
  CONSTRAINT `FK_POLICY_CANC_DATE` FOREIGN KEY (`cancellation_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_POLICY_CHANGE_DATE` FOREIGN KEY (`change_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_POLICY_DL_DATE` FOREIGN KEY (`download_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_POLICY_EFF_DATE` FOREIGN KEY (`effective_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_POLICY_EXP_DATE` FOREIGN KEY (`expiration_date`) REFERENCES `TIME_DIM` (`time_id`),
  CONSTRAINT `FK_POLICY_PT` FOREIGN KEY (`policy_type_id`) REFERENCES `POLICY_TYPE_DIM` (`policy_type_id`),
  CONSTRAINT `FK_POLICY_PW` FOREIGN KEY (`policy_writer_id`) REFERENCES `POLICY_WRITER_DIM` (`policy_writer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
