/* European Soccer Database */
/* Data Source: https://www.kaggle.com/datasets/hugomathien/soccer */
/* Project By: Isaiah Erb */

--Create database
IF NOT EXISTS (SELECT name FROM dbo.sysdatabases
	WHERE name = n'SoccerDB')
	
	CREATE DATABASE SoccerDB
	
GO 

USE SoccerDB
GO


--Drop tables if they exist
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Country')
	
	DROP TABLE Country;
	
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'League')
	
	DROP TABLE League;
	
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Match')
	
	DROP TABLE [Match];
	
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Player')
	
	DROP TABLE Player;
	
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'PlayerAttributes')
	
	DROP TABLE PlayerAttributes;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'Team')
	
	DROP TABLE Team;
	
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'TeamAttributes')
	
	DROP TABLE TeamAttributes;


--Create tables
CREATE TABLE Country (
	CountryID NVARCHAR(50) NOT NULL PRIMARY KEY,
	CountryName NVARCHAR(50) NOT NULL,
);

CREATE TABLE League (
	LeagueID NVARCHAR(50) NOT NULL PRIMARY KEY,
	LeagueName NVARCHAR(50) NOT NULL,
	CountryID NVARCHAR(50) CONSTRAINT FK_CountryID FOREIGN KEY (CountryID) REFERENCES Country(CountryID),
); 

CREATE TABLE [Match] (
	MatchID NVARCHAR(50) NOT NULL PRIMARY KEY,
	CountryID NVARCHAR(50) CONSTRAINT FK_CountryID FOREIGN KEY (CountryID) REFERENCES Country(CountryID),
	LeagueID NVARCHAR(50) CONSTRAINT FK_LEagueID FOREIGN KEY (LeagueID) REFERENCES League(LeagueID), 
	Season NVARCHAR(50) NOT NULL,
	Stage INT NOT NULL,
	[Date] DATE NOT NULL,
	HomeTeamGoal INT NOT NULL,
);
CREATE TABLE Player (
	PlayerID NVARCHAR(50) NOT NULL PRIMARY KEY,
	PlayerName NVARCHAR(100) NOT NULL,
	Birthday DATE NOT NULL,
	Height INT NOT NULL,
	Weight INT NOT NULL,
	TeamID NVARCHAR(50) CONSTRAINT FK_TeamID FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
);

CREATE TABLE PlayerAttributes ( 
	PlayerAttributesID NVARCHAR(50) NOT NULL PRIMARY KEY,
	[Date] DATE NOT NULL,
	OverallRating INT NOT NULL,
	Potential INT NOT NULL,
	PreferredFoot NVARCHAR(50) NOT NULL,
	AttackingWorkRate NVARCHAR(50) NOT NULL,
	DefensiveWorkRate NVARCHAR(50) NOT NULL,
	Crossing INT NOT NULL,
	PlayerID NVARCHAR(50) CONSTRAINT FK_PlayerID FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
);

CREATE TABLE Team (
	TeamID NVARCHAR(50) NOT NULL PRIMARY KEY,
	TeamLongName NVARCHAR(100) NOT NULL,
	TeamShortName NVARCHAR(10) NOT NULL,
	LeagueID NVARCHAR(50) CONSTRAINT FK_LeagueID FOREIGN KEY (LeagueID) REFERENCES League(LeagueID),
);
	
CREATE TABLE TeamAttributes (
	TeamAttributesID NVARCHAR(50) NOT NULL PRIMARY KEY,
	[Date] DATE NOT NULL,
	buildUpPlaySpeed INT NOT NULL,
	buildUpPlaySpeedClass NVARCHAR(50) NOT NULL,
	buildUpPlayDribbling INT NOT NULL,
	buildUpPlayDribblingClass NVARCHAR(50) NOT NULL,
	buildUpPlayPassing INT NOT NULL,
	buildUpPlayPassingClass NVARCHAR(50) NOT NULL,
	TeamID NVARCHAR(50) CONSTRAINT FK_TeamID FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
);

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

