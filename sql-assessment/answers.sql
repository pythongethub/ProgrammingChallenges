/*query to get the sum of Impressions by day*/
SELECT date, SUM(impressions) AS total_impressions FROM   
marketing_data 
GROUP BY date;

/*query to get the top three revenue generating states*/
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;
/*the third best state generate  "OH  | 37577"*/

/*Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.*/
SELECT c.name AS campaign_name, 
       SUM(mp.cost) AS total_cost, 
       SUM(mp.impressions) AS total_impressions, 
       SUM(mp.clicks) AS total_clicks, 
       SUM(wr.revenue) AS total_revenue
FROM campaign_info AS c
JOIN marketing_data AS mp ON c.id = mp.campaign_id
JOIN website_revenue AS wr ON c.id = wr.campaign_id
GROUP BY c.name;

/*Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?*/
/*method1*/
SELECT md.geo, SUM(md.conversions) AS total_conversions
FROM campaign_info ci
INNER JOIN marketing_data md ON ci.id = md.campaign_id
WHERE ci.name = 'Campaign5'
GROUP BY md.geo
ORDER BY total_conversions DESC;
/*'GA state generated the most conversions for this campaign'*/

/*method2*/
select b.state, a.no from 
((select campaign_id , count(conversions) as no 
from marketing_data 
where campaign_id=(SELECT id FROM campaign_info WHERE name = 'Campaign5') group by campaign_id) a 
left join 
(select distinct campaign_id,state from website_revenue where campaign_id=(SELECT id FROM campaign_info WHERE name = 'Campaign5') ) as b on a.campaign_id=b.campaign_id) ;
/*reason: first table has no.of conversation by campaign id
second table has no.of states by campaign_id
joining both these tables with avail key col campaign_id will give only equal no.of conversations.*/



/*In your opinion, which campaign was the most efficient, and why?*/
SELECT ci.name, SUM(md.clicks) AS total_clicks,SUM(md.conversions) AS total_conversions,
sum(md.cost) as total_cost_per_campaign, sum(wr.revenue) as total_revenue_per_campaign, sum(wr.revenue) - sum(md.cost) as Net_profit, sum(wr.revenue)/SUM(md.clicks) as revenue_per_click,
sum(md.cost)/SUM(md.conversions) as cost_per_conversion,sum(wr.revenue)/sum(md.conversions)as revenue_per_conversion, sum(wr.revenue)/sum(md.cost)as revenue_by_cost
FROM marketing_data md
join website_revenue wr on md.campaign_id = wr.campaign_id
join campaign_info ci on md.campaign_id where ci.id = md.campaign_id
GROUP BY md.campaign_id
ORDER BY Net_profit DESC;
/*campaign3 has max clicks(which suggests max usage by users) and decent revenue based on the above stats.*/

/*Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.*/
SELECT 
    DAYNAME(STR_TO_DATE(date, '%Y-%m-%d %H:%i:%s')) AS 'day_of_week', 
    SUM(clicks) AS total_clicks, SUM(conversions) AS total_conversions,
    SUM(clicks) / SUM(conversions) AS clicks_per_conversion
FROM marketing_data
GROUP BY day_of_week
order by clicks_per_conversion desc;
/*
This information suggests that Saturday and Sunday had the highest number of clicks. Therefore, based on the data, Saturday and Sunday appears to be the day of the week with the most clicks, making it a potentially favorable day for running ads to maximize engagement*/


