# ETL project with SSIS using Call Center Dataset

![image](https://github.com/TetianaShchudla/ETL-project_Call-Center/blob/main/Images/callcenter.png)

## Table of Contents

* [1. Introduction](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#1-introduction)  
* [2. ETL Processing - Pipeline Design](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#2-etl-processing---pipeline-design)
  -  [STA – Staging Database](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#sta--staging-database)
  -  [ODS – Operational Data Store](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#ods--operational-data-store)
  -  [DWH – Data Warehouse](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#dwh--data-warehouse)
  -  [ADM - Admin Database Management](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#adm---admin-database-management)
* [3. Conclusion](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#3-conclusion)

## 1. Introduction

Data must first be integrated into an IT system before it can be used and its value observed. This implies that all data from multiple sources must be standardized and unified in order for other programs to utilize them. Implementing a data warehouse is one approach to accomplish this. 
In this project, we are going to design and implement a Data Warehouse with calls data analysis of a call center. For this, we will use __SQL Server__ and __SSIS__. 


__DATA - Description for Call Center Analysis Project__
______________________________

In the project we proceed with an analysis of _call center operations, employee performance, call types,_ and _call charges_. To facilitate this analysis, we have organized a structured dataset that encompasses CSV files and lookup data, each with its specific role and relevance in uncovering insights and optimizing call center activities. 

___CSV Files (Data YYYY):___

These CSV files contain comprehensive call data for each respective year. The columns within these files provide critical information that forms the basis for our analysis. 

| Column Name      | Description                                           |
|------------------|-------------------------------------------------------|
| CallTimestamp     | Date & Time of call                                   |
| Call Type         | Type of call                                         |
| EmployeeID        | Employee unique ID                                   |
| CallDuration      | Duration of call, in seconds                        |
| WaitTime          | Wait time, in seconds                                |
| CallAbandoned     | Was the call abandoned by the customer? (1 = Yes, 0 = No) |

__Lookup Data:__

To enrich our analysis, we've included lookup data that pertains to employees and call types. These 
datasets are useful to understand the workforce and categorizing call scenarios. 

_Employees_

| Column Name    | Description                             |
|----------------|-----------------------------------------|
| EmployeeID     | Employee unique ID                      |
| EmployeeName   | Employee full name                     |
| Site           | Site name where the employee is working at |
| ManagerName    | Employee's Manager                     |

_Call Types_

| Column Name    | Description                        |
|----------------|------------------------------------|
| CallTypeID     | Unique ID for Call Type           |
| CallTypeLabel  | Call type label                   |

__US States:__

We've included a dataset containing information about U.S. states.

| Column Name | Description                      |
|-------------|----------------------------------|
| StateCD     | 2-letter state code             |
| Name        | Name of the state               |
| Region      | US region name (East, West, etc.) |

__Call Charges:__

This dataset captures call charges, specifying the amount of money charged to customers per minute
for each call type and year.

| Column Name                | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| Call Type Key              | Unique ID for Call Type                                                    |
| Call Type                  | Call type label                                                            |
| Call Charges / Min (YYYY)  | The amount charged to a customer for each minute spent on the phone, for a specific year (YYYY) |

## 2. ETL Processing - Pipeline Design

Three phases will be taken to complete the pipeline: 

- Loading data as-is or with minor adjustments is possible in the staging area (STA). 
- The Operational Data Store area (ODS) will enable data standardization and cleaning.*

The "Technical_Rejects" database will be used to store the data as technical rejections if they fail to meet the quality criteria. 
Data will be arranged in one fact table linked to numerous dimensions tables in the Data WareHouse area (DWH). Records that cannot be integrated into the schema are functionally rejected and placed in the "Functional_Rejects" table. Alternately, some fictitious relations could be made. 
Each file will have its own STA and ODS packages.

## STA – Staging Database

The Staging Area is responsible for extracting raw data from the source and storing all the data. We want to accept all available data. 
In all SSIS STA packages the important thing is to truncate the table when executing the package to avoid duplicates. This can be done in the _Control Flow Level_ creating a connection between Data Flow Task with an Execute SQL Task (used with corresponding database and TRUNCATE TABLE query). In additon to this there is a _Data Flow Level_, in which we can specify a Flat File Source (with a selected file), an OLE DB Destination (with the same STA database and a query to create a table) etc. 

__Five packages are created to load the data:__

1. *__STA CallCharges.__* Loaded all call charges from excel file using the Flat file source component without avoiding loading null values using a conditional split component (we will do this step in ODS).

_Control Flow for STA CallCharges:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Control%20Flow%20for%20STA%20CallCharges.jpg)

_Data Flow for STA CallCharges:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Data%20Flow%20for%20STA%20CallCharges.jpg)

2. *__STA CallData.__* We used a foreach loop container to iterate through the Calls Data folder provided with the csv files from different years but same headers. This video was followed to reach the results presented in the screenshots below.

_Control Flow for STA CallData:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Control%20Flow%20for%20STA%20CallData.jpg)

_Data Flow for STA CallData:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Data%20Flow%20for%20STA%20CallData.jpg)

3. *__STA CallTypes.__* Simply loading all call types from the excel file using the Flat file source component.

_Control Flow for STA CallType:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Control%20Flow%20for%20STA%20CallType.jpg)

_Data Flow for STA CallType:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Data%20Flow%20for%20STA%20CallType.jpg)

4. *__STA Employees.__* Simply loading all employees from the excel file using flat file source component. 

_Control Flow for STA Employees:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Control%20Flow%20for%20STA%20Employees.jpg)

_Data Flow for STA Employees:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Data%20Flow%20for%20STA%20Employees.jpg)

5. *__STA USStates.__* Simply loading all US states from the excel file using flat file source component. 

_Control Flow for STA USStates:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Control%20Flow%20for%20STA%20USStates.jpg)

_Data Flow for STA USStates:_

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Data%20Flow%20for%20STA%20USStates.jpg)

## ODS – Operational Data Store

The next phase in the pipeline involves importing practical (usable) data into the Operational Data Store (ODS). This necessitates converting the data into an accessible structure, along with the imperative tasks of refining and keeping consistency in the data by cleaning and standardize them. Any data that fails to meet the "quality criteria" will be excluded as a technical rejection. The output data must be consistent in data types and in values. Furthermore, we must guarantee that data can be effectively employed in queries, which could require restructuring and enhancing the 
dataset.

*__1. ODS_Calls__*
In this package we perform many transformations on the STA_CallData table. 

__STA_CallData__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/STA_CallData.jpg)

__ODS_Calls__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/ODS_Calls.jpg)

Using __Derived Column__ functions, we were able to: 

- Extract from CallTimestamp: CallDate, CallTime, CallYear. 
- Extract the column SLAStatus from WaitTime. 
- Create a ChangeID identifier that we used in the following DWH step as a key.
- 
Using __Data Conversions__ functions, we were able to adjust all the data types of all columns as needed. 
We proceeded also by creating a __TechnicalRejects__ Table in which register possible errors in the data 
conversions processes. 

*__2. ODS_Employees__* 

__STA_Employees__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/STA_Employees.jpg)

__STA_USStates__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/STA_USStates.jpg)

__ODS_Employees__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/ODS_Employees.jpg)

Using __Derived Column__ functions we were able to: 

- Split EmployeeName from STA_Employees into EmployeeFirstName and EmployeeLastName. 
- Split ManagerName from STA_Employees into ManagerFirstName and ManagerLastName. 
- Split EmployeeName from STA_Employees into StateCode and City.

Using __Lookup function__, we were able to join USStates table in order to get also the Region column. 
Using __Data Conversions__ functions, we were able to adjust all the data types of all columns as needed. 
We proceeded also by creating a __TechnicalRejects__ Table in which register possible errors in the data 
conversions processes. 

*__3. ODS_CallCharges__*

__STA_CallCharges__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/STA_CallCharges.jpg)

__STA_CallTypes__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/STA_CallTypes.jpg)

__ODS_CallCharges__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/ODS_CallCharges.jpg)

With __Conditional Split__ we cut off the NULL values in STA_CallCharges. 
With the __Lookup function__ we merged the STA_CallTypes to get the CallTypeID column. 
With __Unpivot transformation__ we were able to get the Call Charges of different years in a single column 
as needed. 

Using __Data Conversions__ functions, we were able to adjust all the data types of all columns as needed and to clean the data (using TRIM function and deleting useless information such as “/ min” in CallCharges column). 

We created a ChangeID identifier that we used in the following DWH step as a key.

We proceeded also by creating a __TechnicalRejects__ Table in which we register possible errors in the data conversions processes. 

## DWH – Data WareHouse

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/DWH%20%E2%80%93%20DATA%20WAREHOUSE.jpg)

At the DWH stage, three dimension tables were created, including creating technical keys in each table. DimCallCharge with CallChargeKey, Dim Employees with EmployeeKey and DimDate using SQL query with DateKey. In addition, a fact table FactCalls was created in the DWH FactCalls package. Within this package possible errors which could happen in the future were redirected and gathered in a new FunctionalRejects table in the ADM database. Examples of those tables are presented below.

__DWH_DimCallCharges__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/DWH_DimCallCharges.jpg)

__DWH_DimDate__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/DWH_DimDate.jpg))

__DWH_DimEmployees__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/DWH_DimEmployees.jpg)

__DWH_FactCalls__

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/DWH_FactCalls.jpg)

## ADM - Admin Database Management

As mentioned before, during the ODS and DWH stages we created two tables called TechnicalRejects and FunctionalRejects. The TechnicalRejects table was created to record any errors arising from the transformations applied in the ODS stage. Whereas the FunctionalRejects table was created to record any errors from the FactCalls DWH stage. 

Examples are presented below:

__ADM_Functional_Rejects__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/ADM_Functional_Rejects.jpg)

__ADM_TechnicalRejects__ 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/ADM_TechnicalRejects.jpg)

*__How to recreate every table?__*

You can find the SQL script file (.sql) in the project folder, which has to be executed in Microsoft SQL Server Management in order to recreate the tables. 

*__The tip to run the package__*

You can use Sequence Container components for running all the stages separately or one by one as 
shown below: 

![image](https://github.com/TetianaShchudla/ETL-project-Call-Center/blob/main/Images/Master.jpg)

## 3. Conclusion

The project successfully structured and filtered data from various sources, allowing for meaningful analysis of call center operations. By organizing the ETL process into clear stages and utilizing SSIS packages effectively, the team aimed to enhance decision-making and operational efficiency through insightful data analysis.
