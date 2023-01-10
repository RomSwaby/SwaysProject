#!/usr/bin/env python
# coding: utf-8

# # Creating a logistic regression to predict absenteeism

# ## Import the relevant libraries

# In[1]:


import pandas as pd
import numpy as np


# ## Load the data

# In[2]:


data_preprocessed = pd.read_csv('Absenteeism_prepro.csv')


# In[3]:


data_preprocessed.head()


# ## Create the targets

# In[4]:


#everything above the mean us excessive and below is normal.
data_preprocessed['Absenteeism Time in Hours'].median()


# In[5]:


targets = np.where(data_preprocessed['Absenteeism Time in Hours'] > 
                   data_preprocessed['Absenteeism Time in Hours'].median(), 1, 0)


# In[6]:


#true or falls 
targets


# In[7]:


data_preprocessed['Excessive Absenteeism'] = targets


# In[8]:


data_preprocessed.head()


# ## A comment on the targets

# In[9]:


targets.sum() / targets.shape[0]


# In[10]:


#Check point
data_with_targets = data_preprocessed.drop(['Absenteeism Time in Hours', 'Day of the Week', 
                                            'Daily Work Load Average', 'Distance to Work'],
                                           axis=1)
#Removed Days of the week, Daily work load, Distance because they diddnt add mouch


# In[11]:


#checking to see if the variables are the same 
data_with_targets is data_preprocessed


# In[12]:


data_with_targets.head()


# ## Select the inputs for the regression

# In[13]:


data_with_targets.shape


# In[14]:


#selecting the inputs and selecting all the variables/columns 
data_with_targets.iloc[:,:14]


# In[15]:


#practicing selecting all variables minus last column 
data_with_targets.iloc[:,:-1]


# In[16]:


unscaled_inputs = data_with_targets.iloc[:,:-1]


# ## Standardize the data

# In[17]:


from sklearn.base import BaseEstimator, TransformerMixin

from sklearn.preprocessing import StandardScaler



# create the Custom Scaler class

class CustomScaler(BaseEstimator,TransformerMixin):

   

    # init or what information we need to declare a CustomScaler object

    # and what is calculated/declared as we do

   

    def __init__(self,columns):   

        # scaler is nothing but a Standard Scaler object

        self.scaler = StandardScaler()

        # with some columns 'twist'

        self.columns = columns

       

   

    # the fit method, which, again based on StandardScale

    def fit(self, X, y=None):

        self.scaler.fit(X[self.columns], y)

        self.mean_ = np.mean(X[self.columns])

        self.var_ = np.var(X[self.columns])

        return self

   

    # the transform method which does the actual scaling

    def transform(self, X, y=None):

        # record the initial order of the columns

        init_col_order = X.columns

       

        # scale all features that you chose when creating the instance of the class

        X_scaled = pd.DataFrame(self.scaler.transform(X[self.columns]), columns=self.columns)

       

        # declare a variable containing all information that was not scaled

        X_not_scaled = X.loc[:,~X.columns.isin(self.columns)]

       

        # return a data frame which contains all scaled features and all 'not scaled' features

        # use the original order (that you recorded in the beginning)

        return pd.concat([X_not_scaled, X_scaled], axis=1)[init_col_order]


# In[18]:


unscaled_inputs.columns.values


# In[19]:


columns_to_scale = ['Month Value', 'Transportation Expense',
                    'Age', 'Body Mass Index','Children', 'Pets']


# In[20]:


absenteeism_scaler = CustomScaler(columns_to_scale)


# In[21]:


absenteeism_scaler.fit(unscaled_inputs)


# In[22]:


scaled_inputs = absenteeism_scaler.transform(unscaled_inputs)


# In[23]:


scaled_inputs


# ## Split the data into train & test and shuffle

# ### Import the relevant module

# In[24]:


from sklearn.model_selection import train_test_split


# ### Split

# In[25]:


train_test_split(scaled_inputs, targets)


# In[26]:


x_train, x_test, y_train, y_test = train_test_split(scaled_inputs, targets, #train_size = 0.8, 
                                                                            test_size = 0.2, random_state = 20)


# In[27]:


print (x_train.shape, y_train.shape)


# In[28]:


print (x_test.shape, y_test.shape)


# ## Logistic regression with sklearn

# In[29]:


from sklearn.linear_model import LogisticRegression
from sklearn import metrics


# ### Training the model

# In[30]:


reg = LogisticRegression()


# In[31]:


reg.fit(x_train,y_train)


# In[32]:


reg.score(x_train,y_train)


# ### Manually check the accuracy

# In[33]:


model_outputs = reg.predict(x_train)
model_outputs


# In[34]:


y_train


# In[35]:


model_outputs == y_train


# In[36]:


np.sum((model_outputs==y_train))


# In[37]:


model_outputs.shape[0]


# In[38]:


np.sum((model_outputs==y_train)) / model_outputs.shape[0]


# ### Finding the intercept and coefficients

# In[39]:


reg.intercept_


# In[40]:


reg.coef_


# In[41]:


unscaled_inputs.columns.values


# In[42]:


feature_name = unscaled_inputs.columns.values


# In[43]:


summary_table = pd.DataFrame (columns=['Feature name'], data = feature_name)

summary_table['Coefficient'] = np.transpose(reg.coef_)

summary_table


# In[44]:


summary_table.index = summary_table.index + 1
summary_table.loc[0] = ['Intercept', reg.intercept_[0]]
summary_table = summary_table.sort_index()
summary_table


# ## Interpreting the coefficients

# In[45]:


summary_table['Odds_ratio'] = np.exp(summary_table.Coefficient)


# In[46]:


summary_table


# In[47]:


#Resasoning 3 Poisoning
#Resaoning 1 Various Diseases
#Resaoning 2 Preganancy and giving birth 
#Resaoning 4 Light Diseases 
summary_table.sort_values('Odds_ratio', ascending=False)


# ## Testing the model

# In[48]:


reg.score(x_test,y_test)


# In[49]:


predicted_proba = reg.predict_proba(x_test)
predicted_proba


# In[50]:


predicted_proba.shape


# In[51]:


predicted_proba[:,1] #probability of excessive absentiesim 


# ## Save the model

# In[52]:


import pickle


# In[53]:


with open('model', 'wb') as file:
    pickle.dump(reg, file)


# In[54]:


with open('scaler','wb') as file:
    pickle.dump(absenteeism_scaler, file)

