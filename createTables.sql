CREATE TABLE regions
(
    regionId   INT         NOT NULL AUTO_INCREMENT,
    regionName VARCHAR(50) NOT NULL,
    PRIMARY KEY (regionId)
);

CREATE TABLE countries
(
    countryId   VARCHAR(4)  NOT NULL,
    countryName VARCHAR(50) NOT NULL,
    regionId    INT         NOT NULL,
    FOREIGN KEY reg_fk (regionId) REFERENCES regions (regionId),
    PRIMARY KEY (countryId)
);

CREATE TABLE locations
(
    locationId    INT         NOT NULL,
    streetAddress VARCHAR(60) NOT NULL,
    postalCode    VARCHAR(10) NOT NULL,
    city          VARCHAR(50) NOT NULL,
    stateProvince VARCHAR(50) NOT NULL,
    countryId     VARCHAR(4)  NOT NULL,
    FOREIGN KEY countries_fk (countryId) REFERENCES countries (countryId),
);

ALTER TABLE locations
    ADD PRIMARY KEY (locationId);

ALTER TABLE locations MODIFY stateProvince VARCHAR(50) NULL ;
ALTER TABLE locations MODIFY postalCode VARCHAR(10) NULL ;


SELECT *
FROM locations;

CREATE TABLE departments
(
    departmentId   INT         NOT NULL,
    departmentName VARCHAR(50) NOT NULL,
    managerId      INT         NOT NULL,
    locationId     INT         NOT NULL,
    FOREIGN KEY loc_fk (locationId) REFERENCES locations (locationId),
    PRIMARY KEY (departmentId)
);

ALTER TABLE departments
    ADD FOREIGN KEY emp_fk (managerId) REFERENCES employees (employeeId);

SELECT *
FROM departments;

CREATE TABLE jobs
(
    jobId     VARCHAR(50)   NOT NULL,
    jobTitle  VARCHAR(50)   NOT NULL,
    minSalary DECIMAL(8, 2) NOT NULL,
    maxSalary DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (jobId)
);

CREATE TABLE employees
(
    employeeId    INT           NOT NULL,
    firstName     VARCHAR(30)   NOT NULL,
    lastName      VARCHAR(30)   NOT NULL,
    email         VARCHAR(50) UNIQUE,
    phoneNumber   VARCHAR(30)   NOT NULL,
    hireDate      DATE          NOT NULL,
    jobId         VARCHAR(30)   NOT NULL,
    salary        DECIMAL(8, 2) NOT NULL,
    commissionPCT DECIMAL(4, 2),
    managerId     INT,
    departmentId  INT           NOT NULL,
    FOREIGN KEY job_fk (jobId) REFERENCES jobs (jobId),
    FOREIGN KEY emp_fk (managerId) REFERENCES employees (employeeId),
    FOREIGN KEY dep_fk (departmentId) REFERENCES departments (departmentId),
    PRIMARY KEY (employeeId)
);

CREATE TABLE jobHistory
(
    employeeId   INT         NOT NULL,
    startDate    DATE        NOT NULL,
    endDate      DATE        NOT NULL,
    jobId        VARCHAR(30) NOT NULL,
    departmentId INT,
    FOREIGN KEY emp_fk (employeeId) REFERENCES employees (employeeId),
    FOREIGN KEY job_fk (jobId) REFERENCES jobs (jobId),
    FOREIGN KEY dep_fk (departmentId) REFERENCES departments (departmentId),
    PRIMARY KEY (employeeId, startDate)
);
SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;

ALTER TABLE departments MODIFY managerId INT;
ALTER TABLE employees MODIFY departmentId INT;
