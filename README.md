# Olist Data Warehouse
[Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_geolocation_dataset.csv)
## Requirement Gathering

During discussion with the stakeholders, we asked them what variable histories that they want to record, and how they want to record it. From the discussion, we concluded that the stakeholders don't actually need all histories to be recorded. The stakeholders only want to know when the data is created and when the latest changes happened.

## SCD Strategies

From the previous process, we concluded that the SCD strategy we needed is Type 1, which is overwriting data in the data warehouse and recorded the timestamp of the data creation and data update. We implemented this strategy to all dimension table.

## ELT with Python & SQL
This data warehouse is created to help stakeholders to do these analyses:
1. Customer Satisfaction and Review Analysis
2. Customer Sentiment Clustering
3. Sales Prediction
4. Delivery Performance Optimization

Thus, we designed an ERD of the Final Data Warehouse.
![erd drawio](https://github.com/user-attachments/assets/2ae03aae-9f81-4984-a34d-850823eac0ba)

In the data warehouse, there will be 3 schemas, which are
- Public, containing the raw data from the data source
- Staging, which only contain columns that are going to be used in the final DWH
- Final

We orchestrated the pipeline using Luigi.
