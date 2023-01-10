#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


raw_csv_data = pd.read_csv("Absenteeism_data.csv")


# In[3]:


type(raw_csv_data)


# In[4]:


raw_csv_data


# In[5]:


df = raw_csv_data.copy()


# In[6]:


df


# In[7]:


pd.options.display.max_columns = None
pd.options.display.max_rows = None


# In[8]:


display(df)


# In[9]:


df.info()


# ## Drop 'ID':

# In[10]:


df.drop(['ID'], axis = 1)


# In[11]:


df = df.drop(['ID'], axis = 1)


# In[12]:


df


# In[13]:


raw_csv_data


# ## 'Reason for Absence':

# In[14]:


df['Reason for Absence'].min()


# In[15]:


df['Reason for Absence'].max()


# In[16]:


pd.unique(df['Reason for Absence'])


# In[17]:


df['Reason for Absence'].unique()


# In[18]:


len(df['Reason for Absence'].unique())


# In[19]:


sorted(df['Reason for Absence'].unique())


# ### .get_dummies()

# In[20]:


reason_columns = pd.get_dummies(df['Reason for Absence'])


# In[21]:


reason_columns


# In[22]:


reason_columns['check'] = reason_columns.sum(axis=1)
reason_columns


# In[23]:


reason_columns['check'].sum(axis=0)


# In[24]:


reason_columns['check'].unique()


# In[25]:


reason_columns = reason_columns.drop(['check'], axis = 1)
reason_columns


# In[26]:


reason_columns = pd.get_dummies(df['Reason for Absence'], drop_first = True)


# In[27]:


reason_columns


# ## Group the Reasons for Absence:

# In[85]:


df.columns.values


# In[29]:


reason_columns.columns.values


# In[30]:


df = df.drop(['Reason for Absence'], axis = 1)


# In[31]:


df


# In[32]:


reason_columns.loc[:, 1:14].max(axis=1)


# In[33]:


reason_type_1 = reason_columns.loc[:, 1:14].max(axis=1)
reason_type_2 = reason_columns.loc[:, 15:17].max(axis=1)
reason_type_3 = reason_columns.loc[:, 18:21].max(axis=1)
reason_type_4 = reason_columns.loc[:, 22:].max(axis=1)


# In[34]:


reason_type_2


# ## Concatenate Column Values

# In[35]:


df


# In[36]:


df = pd.concat([df, reason_type_1, reason_type_2, reason_type_3, reason_type_4], axis = 1)
df


# In[37]:


df.columns.values


# In[38]:


column_names = ['Date', 'Transportation Expense', 'Distance to Work', 'Age',
       'Daily Work Load Average', 'Body Mass Index', 'Education',
       'Children', 'Pets', 'Absenteeism Time in Hours', 'Reason_1', 'Reason_2', 'Reason_3', 'Reason_4']


# In[39]:


df.columns = column_names


# In[40]:


df.head()


# ## Reorder Columns

# In[41]:


column_names_reordered = ['Reason_1', 'Reason_2', 'Reason_3', 'Reason_4', 
                          'Date', 'Transportation Expense', 'Distance to Work', 'Age',
       'Daily Work Load Average', 'Body Mass Index', 'Education',
       'Children', 'Pets', 'Absenteeism Time in Hours']


# In[42]:


df = df[column_names_reordered]


# In[43]:


df.head()


# ## Create a Checkpoint

# In[44]:


df_reason_mod = df.copy()


# In[45]:


df_reason_mod


# ## 'Date':

# In[46]:


type(df_reason_mod['Date'][0])


# In[47]:


df_reason_mod['Date'] = pd.to_datetime(df_reason_mod['Date'])


# In[48]:


df_reason_mod['Date']


# In[49]:


df_reason_mod['Date'] = pd.to_datetime(df_reason_mod['Date'], format = '%d/%m/%Y')


# In[50]:


type(df_reason_mod['Date'])


# In[51]:


df_reason_mod.info()


# ## Extract the Month Value:

# In[52]:


df_reason_mod['Date'][0]


# In[53]:


df_reason_mod['Date'][0].month


# In[54]:


list_months = []
list_months


# In[55]:


df_reason_mod.shape


# In[56]:


for i in range(df_reason_mod.shape[0]):
    list_months.append(df_reason_mod['Date'][i].month)


# In[57]:


list_months


# In[58]:


len(list_months)


# In[59]:


df_reason_mod['Month Value'] = list_months


# In[60]:


df_reason_mod.head(20)


# ## Extract the Day of the Week:

# In[61]:


df_reason_mod['Date'][699].weekday()


# In[62]:


df_reason_mod['Date'][699]


# In[63]:


def date_to_weekday(date_value):
    return date_value.weekday()


# In[64]:


df_reason_mod['Day of the Week'] = df_reason_mod['Date'].apply(date_to_weekday)


# In[65]:


df_reason_mod.head()


# ## Exercise:

# In[66]:


df_reason_mod = df_reason_mod.drop(['Date'], axis = 1)
df_reason_mod.head()


# In[67]:


df_reason_mod.columns.values


# In[68]:


column_names_upd = ['Reason_1', 'Reason_2', 'Reason_3', 'Reason_4', 'Month Value', 'Day of the Week',
       'Transportation Expense', 'Distance to Work', 'Age',
       'Daily Work Load Average', 'Body Mass Index', 'Education', 'Children',
       'Pets', 'Absenteeism Time in Hours']


# In[69]:


df_reason_mod = df_reason_mod[column_names_upd]
df_reason_mod.head()


# In[70]:


df_reason_date_mod = df_reason_mod.copy()
df_reason_date_mod


# In[71]:


type(df_reason_date_mod['Transportation Expense'][0])


# In[72]:


type(df_reason_date_mod['Distance to Work'][0])


# In[73]:


type(df_reason_date_mod['Age'][0])


# In[74]:


type(df_reason_date_mod['Daily Work Load Average'][0])


# In[75]:


type(df_reason_date_mod['Body Mass Index'][0])


# ## 'Education', 'Children', 'Pets'

# In[76]:


display(df_reason_date_mod)


# In[77]:


df_reason_date_mod['Education'].unique()


# In[78]:


df_reason_date_mod['Education'].value_counts()


# In[79]:


df_reason_date_mod['Education'] = df_reason_date_mod['Education'].map({1:0, 2:1, 3:1, 4:1})


# In[80]:


df_reason_date_mod['Education'].unique()


# In[81]:


df_reason_date_mod['Education'].value_counts()


# ## Final Checkpoint

# In[82]:


df_preprocessed = df_reason_date_mod.copy()
df_preprocessed.head(41)


# In[83]:


df_preprocessed.to_csv('Absenteeism_prepro.csv', index = False)


# In[ ]:




