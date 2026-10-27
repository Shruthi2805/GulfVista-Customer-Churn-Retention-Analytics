-- SQL Server portfolio analysis examples. Execute after CSV import.
-- Current churn by contract type
SELECT ContractType,COUNT(*) AS Customers,SUM(CASE WHEN CurrentStatus='Churned' THEN 1 ELSE 0 END) AS Churned,
 CAST(100.0*SUM(CASE WHEN CurrentStatus='Churned' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0) AS decimal(6,2)) AS LifetimeChurnPct
FROM FactSubscription GROUP BY ContractType ORDER BY LifetimeChurnPct DESC;
-- Monthly recognized revenue trend
SELECT RevenueMonth,SUM(RevenueAED) AS RevenueAED,SUM(EstimatedGrossProfitAED) AS GrossProfitAED
FROM FactMonthlyRevenue GROUP BY RevenueMonth ORDER BY RevenueMonth;
-- CRM ticket intensity per customer (including zero tickets)
SELECT c.CustomerID,c.Region,s.CurrentStatus,COUNT(t.TicketID) AS Tickets
FROM DimCustomer c JOIN FactSubscription s ON s.CustomerID=c.CustomerID
LEFT JOIN FactSupportTicket t ON t.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.Region,s.CurrentStatus ORDER BY Tickets DESC;
-- Current MRR by region
SELECT c.Region,SUM(s.MonthlyRecurringRevenueAED) AS CurrentMRR_AED
FROM FactSubscription s JOIN DimCustomer c ON c.CustomerID=s.CustomerID
WHERE s.CurrentStatus='Active' GROUP BY c.Region ORDER BY CurrentMRR_AED DESC;
