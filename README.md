# Developing an ETL project with SSIS using Call Center Dataset

![image](https://github.com/TetianaShchudla/CallCenterProject/blob/main/callcenter.png)

__Table of Contents__

* [1. Introduction](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#1-introduction)  
* [2. ETL Processing - Pipeline Design](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#2-etl-processing---pipeline-design)
  - [STA – Staging Database](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#sta--staging-database)
  - [ODS – Operational Data Store](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#ods--operational-data-store)
  - [DWH – Data WareHouse](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#dwh--data-warehouse)
  - [ADM - Admin Database Management](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#adm---admin-database-management)
* [3. Conclusion](https://github.com/TetianaShchudla/CallCenterProject/blob/main/README.md#3-conclusion)

## 1. Introduction

Data must first be integrated into an IT system before it can be used and its value observed. This 
implies that all data from multiple sources must be standardized and unified in order for other 
programs to utilize them. Implementing a data warehouse is one approach to accomplish this. 
In this project, we are going to design and implement a Data Warehouse with calls data analysis of a 
call center. For this, we will use __SQL Server__ and __SSIS__. 


__DATA - Description for Call Center Analysis Project__
______________________________

In the project we proceed with an analysis of _call center operations, employee performance, call types,_ 
and _call charges_. To facilitate this analysis, we have organized a structured dataset that encompasses 
CSV files and lookup data, each with its specific role and relevance in uncovering insights and 
optimizing call center activities. 

___CSV Files (Data YYYY):___

These CSV files contain comprehensive call data for each respective year. The columns within these 
files provide critical information that forms the basis for our analysis. 

__Lookup Data:__

To enrich our analysis, we've included lookup data that pertains to employees and call types. These 
datasets are useful to understand the workforce and categorizing call scenarios. 

Employees 

## 2. ETL Processing - Pipeline Design

Three phases will be taken to complete the pipeline: 

- Loading data as-is or with minor adjustments is possible in the staging area (STA). 
- The Operational Data Store area (ODS) will enable data standardization and cleaning.*

The "Technical_Rejects" database will be used to store the data as technical rejections if they fail to 
meet the quality criteria. 
Data will be arranged in one fact table linked to numerous dimensions tables in the Data WareHouse 
area (DWH). Records that cannot be integrated into the schema are functionally rejected and placed 
in the "Functional_Rejects" table. Alternately, some fictitious relations could be made. 
Each file will have its own STA and ODS packages.

### STA – Staging Database

The Staging Area is responsible for extracting raw data from the source and storing all the data. We 
want to accept all available data. 
In all SSIS STA packages the important thing is to truncate the table when executing the package to 
avoid duplicates. This can be done in the _Control Flow Level_ creating a connection between Data Flow 
Task with an Execute SQL Task (used with corresponding database and TRUNCATE TABLE query). In 
additon to this there is a _Data Flow Level_, in which we can specify a Flat File Source (with a selected 
file), an OLE DB Destination (with the same STA database and a query to create a table) etc. 

__Five packages are created to load the data:__

1. _STA CallCharges._ Loaded all call charges from excel file using the Flat file source component 
without avoiding loading null values using a conditional split component (we will do this step 
in ODS).

_Control Flow for STA CallCharges:_



### ODS – Operational Data Store


### DWH – Data WareHouse



### ADM - Admin Database Management





## 3. Conclusion



  
