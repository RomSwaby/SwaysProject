#!/usr/bin/env python
# coding: utf-8

# In[1]:


from Module import *


# In[2]:


pd.read_csv('Absenteeism_new_data.csv')


# In[3]:


model = absenteeism_model('model', 'scaler')


# In[4]:


model.load_and_clean_data('Absenteeism_new_data.csv')


# In[5]:


model.predicted_outputs()


# In[6]:


import pymysql


# In[7]:


#set up a connection to the predicted_outputs database in mysql workbench 
#open a connection to mysql
conn = pymysql.connect(database = 'predicted_outputs', user = 'root', password = '@Caution31')


# In[8]:


#create cursor
cursor = conn.cursor()


# # Checkpoint 'df_obs'

# In[9]:


df_obs = model.predicted_outputs()
df_obs


# In[10]:


df_obs.columns.values


# # .execute()

# In[11]:


cursor.execute('Select * from predicted_outputs;')


# In[12]:


insert_query = 'INSERT INTO predicted_outputs values '


# In[13]:


insert_query


# In[14]:


df_obs.shape


# In[15]:


#grabs age column 
df_obs.columns.values[6]


# In[16]:


#grabs the first observation of the age column
df_obs[df_obs.columns.values[6]][0]


# In[17]:


#outter loop - go through every row of df_obs
#start the code of every record with `(`
#seperate each row with a `,` that relates to specific column and add into the insert statment 
#inner loop turns each column into a string + `,`
#final code ends each row with a `)` using reverse indexing 
for i in range(df_obs.shape[0]):
    insert_query += '('
    for j in range(df_obs.shape[1]):
        insert_query += str(df_obs[df_obs.columns.values[j]][i]) + ', '
        
    insert_query = insert_query[:-2] + '), '


# In[18]:


insert_query


# In[19]:


#editing statment terminater 
insert_query = insert_query[:-2] + ';'
insert_query


# In[20]:


cursor.execute(insert_query)


# In[21]:


conn.commit()


# In[23]:


conn.close()


# In[ ]:




