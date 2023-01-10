-- Create the structure of our Database 
Drop Database if Exists predicted_outputs;

Create Database if Not Exists predicted_outputs;

USE predicted_outputs;

-- Connect My SQL and python jupiter using pymysql

-- Create a table call predicted_outputs
Drop table if exists predicted_outputs;
Create table predicted_outputs
(
Reason_1 BIT NOT NULL, 
Reason_2 BIT NOT NULL, 
Reason_3 BIT NOT NULL, 
Reason_4 BIT NOT NULL, 
Month_Value INT NOT NULL, 
Transportation_Expense INT NOT NULL, 
Age INT NOT NULL, 
Body_Mass_Index INT NOT NULL, 
Education INT NOT NULL, 
Children INT NOT NULL, 
Pets INT NOT NULL, 
Probability INT NOT NULL, 
Prediction INT NOT NULL
);

Select * from predicted_outputs;

-- use python to insert data into table predicted_outputs

-- Visualize table with inserted rows from python
Select * from predicted_outputs;






















