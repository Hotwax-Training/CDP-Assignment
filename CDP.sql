CREATE DATABASE CDP;
USE CDP;

-------------------------------------------------------
-- PARTY TYPE
-------------------------------------------------------
CREATE TABLE party_type (
    party_type_id VARCHAR(40) PRIMARY KEY,
    parent_type_id VARCHAR(40) NULL,
    description VARCHAR(255),
    FOREIGN KEY (parent_type_id) REFERENCES party_type(party_type_id)
);

-------------------------------------------------------
-- PARTY
-------------------------------------------------------
CREATE TABLE party (
    party_id VARCHAR(40) PRIMARY KEY,
    party_type_id VARCHAR(40) NOT NULL,
    external_id VARCHAR(40) UNIQUE,
    description TEXT,
    status_id VARCHAR(40),
    created_date DATETIME(3) DEFAULT CURRENT_TIMESTAMP(3),
    created_by_user_login VARCHAR(20),
    FOREIGN KEY (party_type_id) REFERENCES party_type(party_type_id)
);

-------------------------------------------------------
-- PERSON
-------------------------------------------------------
CREATE TABLE person (
    party_id VARCHAR(40) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    birth_date DATE,
    gender CHAR(20),
    comments VARCHAR(255),
    occupation VARCHAR(100),
    FOREIGN KEY (party_id) REFERENCES party(party_id)
);

-------------------------------------------------------
-- PARTY GROUP
-------------------------------------------------------
CREATE TABLE party_group (
    party_id VARCHAR(40) PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL,
    group_name_local VARCHAR(100),
    office_site_name VARCHAR(100),
    annual_revenue DECIMAL(18,2),
    num_employees DECIMAL(20,0),
    ticker_symbol VARCHAR(10),
    comments VARCHAR(255),
    logo_image_url VARCHAR(2000),
    FOREIGN KEY (party_id) REFERENCES party(party_id)
);

-------------------------------------------------------
-- ROLE TYPE + PARTY ROLE
-------------------------------------------------------
CREATE TABLE role_type (
    role_type_id VARCHAR(40) PRIMARY KEY,
    parent_type_id VARCHAR(40) NULL,
    description VARCHAR(255),
    FOREIGN KEY (parent_type_id) REFERENCES role_type(role_type_id)
);

CREATE TABLE party_role (
    party_id VARCHAR(40),
    role_type_id VARCHAR(40),
    PRIMARY KEY (party_id, role_type_id),
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (role_type_id) REFERENCES role_type(role_type_id)
);

-------------------------------------------------------
-- PARTY STATUS
-------------------------------------------------------
CREATE TABLE party_status (
    status_id VARCHAR(40),
    party_id VARCHAR(40),
    status_date DATETIME(3) NOT NULL,
    change_by_user_login_id VARCHAR(250),
    PRIMARY KEY (status_id, party_id, status_date),
    FOREIGN KEY (party_id) REFERENCES party(party_id)
);

-------------------------------------------------------
-- CONTACT MECHANISM TYPE
-------------------------------------------------------
CREATE TABLE contact_mech_type (
    contact_mech_type_id VARCHAR(40) PRIMARY KEY,
    parent_type_id VARCHAR(40) NULL,
    description VARCHAR(255),
    FOREIGN KEY (parent_type_id) REFERENCES contact_mech_type(contact_mech_type_id)
);

-------------------------------------------------------
-- CONTACT MECHANISM 
-------------------------------------------------------
CREATE TABLE contact_mech (
    contact_mech_id VARCHAR(40) PRIMARY KEY,
    contact_mech_type_id VARCHAR(40) NOT NULL,
    info_string VARCHAR(255),
    FOREIGN KEY (contact_mech_type_id) REFERENCES contact_mech_type(contact_mech_type_id)
);

-------------------------------------------------------
-- TELECOM NUMBER 
-------------------------------------------------------
CREATE TABLE telecom_number (
    contact_mech_id VARCHAR(40) PRIMARY KEY,
    country_code VARCHAR(10),
    area_code VARCHAR(10),
    contact_number VARCHAR(60),
    ask_for_name VARCHAR(100),
    FOREIGN KEY (contact_mech_id) REFERENCES contact_mech(contact_mech_id)
);

-------------------------------------------------------
-- POSTAL ADDRESS 
-------------------------------------------------------
CREATE TABLE postal_address (
    contact_mech_id VARCHAR(40) PRIMARY KEY,
    to_name VARCHAR(100),
    attn_name VARCHAR(100),
    address1 VARCHAR(255),
    city VARCHAR(100),
    city_geo_id VARCHAR(40),
    postal_code VARCHAR(60),
    country_geo_id VARCHAR(40),
    state_province_geo_id VARCHAR(40),
    postal_code_geo_id VARCHAR(40),
    FOREIGN KEY (contact_mech_id) REFERENCES contact_mech(contact_mech_id)
);

-------------------------------------------------------
-- PARTY CONTACT MECH ASSOCIATION
-------------------------------------------------------
CREATE TABLE party_contact_mech (
    party_id VARCHAR(40),
    contact_mech_id VARCHAR(40),
    from_date DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    thru_date DATETIME(3),
    role_type_id VARCHAR(40),
    PRIMARY KEY (party_id, contact_mech_id, from_date),
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (contact_mech_id) REFERENCES contact_mech(contact_mech_id),
    FOREIGN KEY (role_type_id) REFERENCES role_type(role_type_id)
);

-------------------------------------------------------
-- CONTACT MECH PURPOSE TYPE
-------------------------------------------------------
CREATE TABLE contact_mech_purpose_type (
    contact_mech_purpose_type_id VARCHAR(40) PRIMARY KEY,
    parent_type_id VARCHAR(40) NULL,
    description VARCHAR(255),
    FOREIGN KEY (parent_type_id) REFERENCES contact_mech_purpose_type(contact_mech_purpose_type_id)
);

-------------------------------------------------------
-- PARTY CONTACT MECH PURPOSE
-------------------------------------------------------
CREATE TABLE party_contact_mech_purpose (
    party_id VARCHAR(40),
    contact_mech_id VARCHAR(40),
    contact_mech_purpose_type_id VARCHAR(40),
    from_date DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    thru_date DATETIME(3),
    PRIMARY KEY (party_id, contact_mech_id, contact_mech_purpose_type_id, from_date),
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (contact_mech_id) REFERENCES contact_mech(contact_mech_id),
    FOREIGN KEY (contact_mech_purpose_type_id) REFERENCES contact_mech_purpose_type(contact_mech_purpose_type_id)
);
