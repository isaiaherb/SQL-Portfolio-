/* European Soccer Database */
/* Data Source: https://www.kaggle.com/datasets/hugomathien/soccer */
/* Project By: Isaiah Erb */

--Queries
-- 1. View the potential and overall rating by player, limit results to only include players from the England Premier League.
SELECT Potential, OverallRating, PlayerName
FROM PlayerAttributes
JOIN Player
	ON PlayerAttributes.PlayerID = Player.PlayerID
JOIN Team 
	ON Team.LeagueID = League.LeagueID
WHERE Potential >= 70 
AND LeagueID = '1729'
ORDER BY Potential DESC;

-- 2. Find all the lefties on Liverpool, matched with rating.
SELECT PlayerName, PreferredFoot, OverallRating 
FROM PlayerAttributes
INNER JOIN Player
	ON PlayerAttributes.PlayerID = Player.PlayerID
INNER JOIN Team
	ON Player.TeamID = Team.TeamID
WHERE TeamID = '3462'
ORDER BY OverallRating DESC;

-- 3. View work rates by player on Liverpool.
SELECT PlayerName, AttackingWorkRate, DefensiveWorkRate
FROM PlayerAttributes
JOIN Player
	ON PlayerAttributes.PlayerID = Player.PlayerID
JOIN Team
	ON Player.TeamID = Team.TeamID
WHERE TeamID = '3462';

-- 4. View play speed, dribbling, and passing for each team in Italy Serie A. 
SELECT buildUpPlaySpeed, buildUpPlayDribbling, buildUpPlayPassing
FROM TeamAttributes
JOIN Team
	ON TeamAttributes.TeamID = Team.TeamID
JOIN League
	ON Team.LeagueID = League.LeagueID
WHERE LeagueID = '10257';

-- 5. View basic information about the home team in a given match.
SELECT MatchID, 
	Season, 
	HomeTeamGoal,
	TeamAttributesID, 
	[Date], 
	buildUpPlaySpeed, 
	buildUpPlaySpeedClass, 
	buildUpPlayDribbling,
	buildUpPlayDribblingClass, 
	buildUpPlayPassing,
	buildUpPlayPassingClass,
	TeamID,
FROM [Match]
JOIN Team 
	ON [Match].HomeTeamID = Team.TeamID
JOIN TeamAttributes
	ON TeamAttributes.TeamID = Team.TeamID
WHERE MatchID = 6;

