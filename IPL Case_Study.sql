select * from matches
select * from deliveries

-- 1-WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?

select player_of_match,count(*) as Total_awards from matches
group by player_of_match
order by Total_awards desc
limit 5

-- 2 HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?

select season ,winner ,count(*) as  total_win from  matches
group by season ,winner

-- 3 WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

with cte as (select batsman, (sum(total_runs)/count(ball)*100) as avg_strike_rate from deliveries
group by batsman)
select avg(avg_strike_rate) avg_strike_rates from cte

-- 4 WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?
select batting_first as team,count(*) as matches_won
from(
select case when win_by_runs>0 then team1
else team2
end as batting_first
from matches
where winner!="Tie") as batting_first_teams
group by batting_first;

-- 5 WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?

select batsman,(sum(batsman_runs)/count(ball)*100)
as strike_rate
from deliveries group by batsman
having sum(batsman_runs)>=200
order by strike_rate desc
limit 1;

-- 6 HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?

select batsman,count(*) as total_dismissals
from deliveries 
where player_dismissed is not null 
and bowler='SL Malinga'
group by batsman;

-- 7 WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN

select batsman, 
avg((case when total_runs = 4 or total_runs = 6 then 1 else 0 end )*100) as boundaries
from deliveries
group by batsman

-- 8 WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

select team1,season,  avg(total_boundary) as avg_boundaries_per_match
from matches m
inner join
(select match_id, sum(case
when total_runs = 4 or total_runs =6 then 1 else 0 end )  as total_boundary 
from deliveries
group by match_id) boundary 
on m.id = boundary.match_id 
group by team1 , season


-- 9 HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?

select m.id as match_no,d.bowling_team,
sum(d.extra_runs) as extras
from matches as m
join deliveries as d on d.match_id=m.id
where extra_runs>0
group by m.id,d.bowling_team;


-- 10 WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLEMATCH

select m.id as match_no,d.bowler,count(*) as wickets_taken
from matches as m
join deliveries as d on d.match_id=m.id
where d.player_dismissed is not null
group by m.id,d.bowler
order by wickets_taken desc
limit 1


-- 11 HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?

select season,toss_winner, count(*) as total_wins from matches
group by season,toss_winner

-- 12 HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD ?

select player_of_match ,count(*) as total_award from matches
group by player_of_match 
order by total_award desc

-- 13 WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?

select m.id,d.inning,d.over,
avg(d.total_runs) as average_runs_per_over
from matches as m
join deliveries as d on d.match_id=m.id
group by m.id,d.inning,d.over;

-- 14 WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

select m.season,m.id as match_no,d.batting_team,
sum(d.total_runs) as total_score
from matches as m
join deliveries as d on d.match_id=m.id
group by m.season,m.id,d.batting_team
order by total_score desc
limit 1;

 
-- 15 WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
select m.season,m.id as match_no,d.batsman,
sum(d.batsman_runs) as total_runs
from matches as m
join deliveries as d on d.match_id=m.id
group by m.season,m.id,d.batsman
order by total_runs desc
limit 1;










