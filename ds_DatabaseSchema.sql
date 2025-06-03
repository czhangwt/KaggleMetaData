-- Users table
CREATE TABLE Users (
    Id SERIAL PRIMARY KEY,
    UserName VARCHAR(255) NOT NULL,
    DisplayName VARCHAR(255) NOT NULL,
    RegisterDate TIMESTAMP NOT NULL,
    PerformanceTier INTEGER NOT NULL,
    Country VARCHAR(100),
    LocationSharingOptOut BOOLEAN NOT NULL
);

-- Organizations table
CREATE TABLE Organizations (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Slug VARCHAR(255) NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    Description TEXT NOT NULL
);

-- User Organizations (junction table)
CREATE TABLE UserOrganizations (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    OrganizationId INTEGER REFERENCES Organizations(Id),
    JoinDate TIMESTAMP NOT NULL
);

-- User Followers (junction table)
CREATE TABLE UserFollowers (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    FollowingUserId INTEGER REFERENCES Users(Id),
    CreationDate TIMESTAMP NOT NULL
);

-- Competitions table
CREATE TABLE Competitions (
    Id SERIAL PRIMARY KEY,
    Slug VARCHAR(255) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Subtitle TEXT NOT NULL,
    HostSegmentTitle VARCHAR(255) NOT NULL,
    ForumId INTEGER NOT NULL,
    OrganizationId INTEGER REFERENCES Organizations(Id),
    EnabledDate TIMESTAMP NOT NULL,
    DeadlineDate TIMESTAMP NOT NULL,
    ProhibitNewEntrantsDeadlineDate TIMESTAMP,
    TeamMergerDeadlineDate TIMESTAMP,
    TeamModelDeadlineDate TIMESTAMP,
    ModelSubmissionDeadlineDate TIMESTAMP,
    FinalLeaderboardHasBeenVerified BOOLEAN NOT NULL,
    HasKernels BOOLEAN NOT NULL,
    OnlyAllowKernelSubmissions BOOLEAN NOT NULL,
    HasLeaderboard BOOLEAN NOT NULL,
    LeaderboardPercentage INTEGER NOT NULL,
    ScoreTruncationNumDecimals INTEGER NOT NULL,
    EvaluationAlgorithmAbbreviation VARCHAR(100) NOT NULL,
    EvaluationAlgorithmName VARCHAR(255) NOT NULL,
    EvaluationAlgorithmDescription TEXT NOT NULL,
    EvaluationAlgorithmIsMax BOOLEAN NOT NULL,
    MaxDailySubmissions INTEGER NOT NULL,
    NumScoredSubmissions INTEGER NOT NULL,
    MaxTeamSize INTEGER NOT NULL,
    BanTeamMergers BOOLEAN NOT NULL,
    EnableTeamModels BOOLEAN NOT NULL,
    RewardType VARCHAR(100) NOT NULL,
    RewardQuantity NUMERIC(10,2) NOT NULL,
    NumPrizes INTEGER NOT NULL,
    UserRankMultiplier NUMERIC(10,2) NOT NULL,
    CanQualifyTiers BOOLEAN NOT NULL,
    TotalTeams INTEGER NOT NULL,
    TotalCompetitors INTEGER NOT NULL,
    TotalSubmissions INTEGER NOT NULL,
    LicenseName VARCHAR(255) NOT NULL,
    Overview TEXT NOT NULL,
    Rules TEXT NOT NULL,
    DatasetDescription TEXT NOT NULL,
    TotalCompressedBytes BIGINT,
    TotalUncompressedBytes BIGINT,
    ValidationSetName VARCHAR(255),
    ValidationSetValue NUMERIC(10,2),
    EnableSubmissionModelHashes BOOLEAN NOT NULL,
    EnableSubmissionModelAttachments BOOLEAN NOT NULL,
    HostName VARCHAR(255),
    CompetitionTypeId INTEGER NOT NULL
);

-- Teams table
CREATE TABLE Teams (
    Id SERIAL PRIMARY KEY,
    CompetitionId INTEGER REFERENCES Competitions(Id),
    TeamLeaderId INTEGER REFERENCES Users(Id),
    TeamName VARCHAR(255) NOT NULL,
    ScoreFirstSubmittedDate TIMESTAMP,
    LastSubmissionDate TIMESTAMP NOT NULL,
    PublicLeaderboardSubmissionId INTEGER NOT NULL,
    PrivateLeaderboardSubmissionId INTEGER NOT NULL,
    IsBenchmark BOOLEAN NOT NULL,
    Medal INTEGER,
    MedalAwardDate TIMESTAMP NOT NULL,
    PublicLeaderboardRank INTEGER NOT NULL,
    PrivateLeaderboardRank INTEGER NOT NULL,
    WriteUpForumTopicId INTEGER
);

-- Team Memberships (junction table)
CREATE TABLE TeamMemberships (
    Id SERIAL PRIMARY KEY,
    TeamId INTEGER REFERENCES Teams(Id),
    UserId INTEGER REFERENCES Users(Id),
    RequestDate TIMESTAMP
);

-- Submissions table
CREATE TABLE Submissions (
    Id SERIAL PRIMARY KEY,
    SubmittedUserId INTEGER REFERENCES Users(Id),
    TeamId INTEGER REFERENCES Teams(Id),
    SourceKernelVersionId INTEGER,
    SubmissionDate TIMESTAMP NOT NULL,
    ScoreDate TIMESTAMP,
    IsAfterDeadline BOOLEAN NOT NULL,
    IsSelected BOOLEAN NOT NULL,
    PublicScoreLeaderboardDisplay NUMERIC(10,6) NOT NULL,
    PublicScoreFullPrecision NUMERIC(10,6) NOT NULL,
    PrivateScoreLeaderboardDisplay NUMERIC(10,6) NOT NULL,
    PrivateScoreFullPrecision NUMERIC(10,6) NOT NULL
);

-- Kernel Languages table
CREATE TABLE KernelLanguages (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DisplayName VARCHAR(100) NOT NULL,
    IsNotebook BOOLEAN NOT NULL
);

-- Kernels table
CREATE TABLE Kernels (
    Id SERIAL PRIMARY KEY,
    AuthorUserId INTEGER REFERENCES Users(Id),
    CurrentKernelVersionId INTEGER NOT NULL,
    ForkParentKernelVersionId INTEGER,
    ForumTopicId INTEGER,
    FirstKernelVersionId INTEGER NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    EvaluationDate TIMESTAMP NOT NULL,
    MadePublicDate TIMESTAMP NOT NULL,
    IsProjectLanguageTemplate BOOLEAN NOT NULL,
    CurrentUrlSlug VARCHAR(255) NOT NULL,
    Medal INTEGER,
    MedalAwardDate TIMESTAMP,
    TotalViews INTEGER NOT NULL,
    TotalComments INTEGER NOT NULL,
    TotalVotes INTEGER NOT NULL
);

-- Kernel Versions table
CREATE TABLE KernelVersions (
    Id SERIAL PRIMARY KEY,
    ScriptId INTEGER REFERENCES Kernels(Id),
    ParentScriptVersionId INTEGER,
    ScriptLanguageId INTEGER REFERENCES KernelLanguages(Id),
    AuthorUserId INTEGER REFERENCES Users(Id),
    CreationDate TIMESTAMP NOT NULL,
    VersionNumber INTEGER NOT NULL,
    Title VARCHAR(255) NOT NULL,
    EvaluationDate TIMESTAMP NOT NULL,
    IsChange BOOLEAN NOT NULL,
    TotalLines INTEGER,
    LinesInsertedFromPrevious INTEGER NOT NULL,
    LinesChangedFromPrevious INTEGER NOT NULL,
    LinesUnchangedFromPrevious INTEGER NOT NULL,
    LinesInsertedFromFork INTEGER,
    LinesDeletedFromFork INTEGER,
    LinesChangedFromFork INTEGER,
    LinesUnchangedFromFork INTEGER,
    TotalVotes INTEGER NOT NULL,
    IsInternetEnabled BOOLEAN NOT NULL,
    RunningTimeInMilliseconds INTEGER NOT NULL,
    AcceleratorTypeId INTEGER REFERENCES KernelAcceleratorTypes(Id)
    DockerImage VARCHAR(255) NOT NULL
);

-- Kernel Votes table
CREATE TABLE KernelVotes (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    KernelVersionId INTEGER REFERENCES KernelVersions(Id),
    VoteDate TIMESTAMP NOT NULL
);

-- Kernel Accelerator Types table
CREATE TABLE KernelAcceleratorTypes (
    Id SERIAL PRIMARY KEY,
    Label VARCHAR(100)
);

-- Tags table
CREATE TABLE Tags (
    Id SERIAL PRIMARY KEY,
    ParentTagId INTEGER REFERENCES Tags(Id),
    Name VARCHAR(255) NOT NULL,
    Slug VARCHAR(255) NOT NULL,
    FullPath TEXT NOT NULL,
    Description TEXT,
    DatasetCount INTEGER NOT NULL,
    CompetitionCount INTEGER NOT NULL,
    KernelCount INTEGER NOT NULL
);

-- Kernel Tags (junction table)
CREATE TABLE KernelTags (
    Id SERIAL PRIMARY KEY,
    KernelId INTEGER REFERENCES Kernels(Id),
    TagId INTEGER REFERENCES Tags(Id)
);

-- Kernel Version Sources tables (multiple types)
CREATE TABLE KernelVersionCompetitionSources (
    Id SERIAL PRIMARY KEY,
    KernelVersionId INTEGER REFERENCES KernelVersions(Id),
    SourceCompetitionId INTEGER REFERENCES Competitions(Id)
);

CREATE TABLE KernelVersionKernelSources (
    Id SERIAL PRIMARY KEY,
    KernelVersionId INTEGER REFERENCES KernelVersions(Id),
    SourceKernelVersionId INTEGER REFERENCES KernelVersions(Id)
);

CREATE TABLE KernelVersionDatasetSources (
    Id SERIAL PRIMARY KEY,
    KernelVersionId INTEGER REFERENCES KernelVersions(Id),
    SourceDatasetVersionId INTEGER
);

CREATE TABLE KernelVersionModelSources (
    Id SERIAL PRIMARY KEY,
    KernelVersionId INTEGER REFERENCES KernelVersions(Id),
    SourceModelVariationVersionId INTEGER,
    SourceModelVariationId INTEGER
);

-- Datasources table
CREATE TABLE Datasources (
    Id SERIAL PRIMARY KEY,
    CreatorUserId INTEGER REFERENCES Users(Id),
    CreationDate TIMESTAMP NOT NULL,
    Type VARCHAR(100) NOT NULL,
    CurrentDatasourceVersionId INTEGER NOT NULL
);

-- Datasets table
CREATE TABLE Datasets (
    Id SERIAL PRIMARY KEY,
    CreatorUserId INTEGER REFERENCES Users(Id),
    OwnerUserId INTEGER REFERENCES Users(Id),
    OwnerOrganizationId INTEGER REFERENCES Organizations(Id),
    CurrentDatasetVersionId INTEGER NOT NULL,
    CurrentDatasourceVersionId INTEGER NOT NULL,
    ForumId INTEGER NOT NULL,
    Type VARCHAR(100) NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    LastActivityDate TIMESTAMP NOT NULL,
    TotalViews INTEGER NOT NULL,
    TotalDownloads INTEGER NOT NULL,
    TotalVotes INTEGER NOT NULL,
    TotalKernels INTEGER NOT NULL,
    Medal INTEGER,
    MedalAwardDate TIMESTAMP
);

-- Dataset Versions table
CREATE TABLE DatasetVersions (
    Id SERIAL PRIMARY KEY,
    DatasetId INTEGER REFERENCES Datasets(Id),
    DatasourceVersionId INTEGER NOT NULL,
    CreatorUserId INTEGER REFERENCES Users(Id),
    LicenseName VARCHAR(255) NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    VersionNumber INTEGER NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Slug VARCHAR(255) NOT NULL,
    Subtitle TEXT NOT NULL,
    Description TEXT NOT NULL,
    VersionNotes TEXT NOT NULL,
    TotalCompressedBytes BIGINT NOT NULL,
    TotalUncompressedBytes BIGINT NOT NULL
);

-- Dataset Votes table
CREATE TABLE DatasetVotes (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    DatasetVersionId INTEGER REFERENCES DatasetVersions(Id),
    VoteDate TIMESTAMP NOT NULL
);

-- Dataset Tags (junction table)
CREATE TABLE DatasetTags (
    Id SERIAL PRIMARY KEY,
    DatasetId INTEGER REFERENCES Datasets(Id),
    TagId INTEGER REFERENCES Tags(Id)
);

-- Dataset Tasks table
CREATE TABLE DatasetTasks (
    Id SERIAL PRIMARY KEY,
    DatasetId INTEGER REFERENCES Datasets(Id),
    OwnerUserId INTEGER REFERENCES Users(Id),
    CreationDate TIMESTAMP NOT NULL,
    Description TEXT NOT NULL,
    ForumId INTEGER,
    Title VARCHAR(255) NOT NULL,
    Subtitle TEXT,
    Deadline TIMESTAMP,
    TotalVotes INTEGER NOT NULL
);

-- Dataset Task Submissions table
CREATE TABLE DatasetTaskSubmissions (
    Id SERIAL PRIMARY KEY,
    DatasetTaskId INTEGER REFERENCES DatasetTasks(Id),
    SubmittedUserId INTEGER REFERENCES Users(Id),
    CreationDate TIMESTAMP NOT NULL,
    KernelId INTEGER REFERENCES Kernels(Id),
    DatasetId INTEGER REFERENCES Datasets(Id),
    AcceptedDate TIMESTAMP
);

-- Models table
CREATE TABLE Models (
    Id SERIAL PRIMARY KEY,
    OwnerUserId INTEGER REFERENCES Users(Id),
    OwnerOrganizationId INTEGER REFERENCES Organizations(Id),
    CurrentModelVersionId INTEGER NOT NULL,
    ForumId INTEGER NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    TotalViews INTEGER NOT NULL,
    TotalDownloads INTEGER NOT NULL,
    TotalVotes INTEGER NOT NULL,
    TotalKernels INTEGER NOT NULL,
    CurrentSlug VARCHAR(255) NOT NULL
);

-- Model Versions table
CREATE TABLE ModelVersions (
    Id SERIAL PRIMARY KEY,
    ModelId INTEGER REFERENCES Models(Id),
    Title VARCHAR(255) NOT NULL,
    Subtitle TEXT NOT NULL,
    ModelCard TEXT NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    OriginalPublishDate TIMESTAMP NOT NULL,
    CreatorUserId INTEGER REFERENCES Users(Id),
    ProvenanceSources TEXT NOT NULL
);

-- Model Variations table
CREATE TABLE ModelVariations (
    Id SERIAL PRIMARY KEY,
    ModelId INTEGER REFERENCES Models(Id),
    CurrentVariationSlug VARCHAR(255) NOT NULL,
    ModelFramework VARCHAR(255) NOT NULL,
    CurrentModelVariationVersionId INTEGER NOT NULL,
    LicenseName VARCHAR(255) NOT NULL,
    BaseModelVariationId INTEGER REFERENCES ModelVariations(Id),
    CurrentDatasourceVersionId INTEGER NOT NULL
);

-- Model Variation Versions table
CREATE TABLE ModelVariationVersions (
    Id SERIAL PRIMARY KEY,
    ModelVariationId INTEGER REFERENCES ModelVariations(Id),
    ModelVersionId INTEGER REFERENCES ModelVersions(Id),
    DatasourceVersionId INTEGER NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    VariationOverview TEXT,
    VariationUsage TEXT NOT NULL,
    FineTunable BOOLEAN NOT NULL,
    SourceUrl TEXT,
    SourceOrganizationName VARCHAR(255)
);

-- Model Votes table
CREATE TABLE ModelVotes (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    ModelId INTEGER REFERENCES Models(Id),
    VoteDate TIMESTAMP NOT NULL
);

-- Model Tags (junction table)
CREATE TABLE ModelTags (
    Id SERIAL PRIMARY KEY,
    ModelId INTEGER REFERENCES Models(Id),
    TagId INTEGER REFERENCES Tags(Id)
);

-- Competition Tags (junction table)
CREATE TABLE CompetitionTags (
    Id SERIAL PRIMARY KEY,
    CompetitionId INTEGER REFERENCES Competitions(Id),
    TagId INTEGER REFERENCES Tags(Id)
);

-- Forums table
CREATE TABLE Forums (
    Id SERIAL PRIMARY KEY,
    ParentForumId INTEGER REFERENCES Forums(Id),
    Title VARCHAR(255) NOT NULL
);

-- Forum Topics table
CREATE TABLE ForumTopics (
    Id SERIAL PRIMARY KEY,
    ForumId INTEGER REFERENCES Forums(Id),
    KernelId INTEGER REFERENCES Kernels(Id),
    LastForumMessageId INTEGER NOT NULL,
    FirstForumMessageId INTEGER NOT NULL,
    CreationDate TIMESTAMP NOT NULL,
    LastCommentDate TIMESTAMP NOT NULL,
    Title VARCHAR(255) NOT NULL,
    IsSticky BOOLEAN NOT NULL,
    TotalViews INTEGER NOT NULL,
    Score INTEGER NOT NULL,
    TotalMessages INTEGER NOT NULL,
    TotalReplies INTEGER NOT NULL
);

-- Forum Messages table
CREATE TABLE ForumMessages (
    Id SERIAL PRIMARY KEY,
    ForumTopicId INTEGER REFERENCES ForumTopics(Id),
    PostUserId INTEGER REFERENCES Users(Id),
    PostDate TIMESTAMP NOT NULL,
    ReplyToForumMessageId INTEGER REFERENCES ForumMessages(Id),
    Message TEXT NOT NULL,
    RawMarkdown TEXT,
    Medal INTEGER,
    MedalAwardDate TIMESTAMP
);

-- Forum Message Votes table
CREATE TABLE ForumMessageVotes (
    Id SERIAL PRIMARY KEY,
    ForumMessageId INTEGER REFERENCES ForumMessages(Id),
    FromUserId INTEGER REFERENCES Users(Id),
    ToUserId INTEGER REFERENCES Users(Id),
    VoteDate TIMESTAMP NOT NULL
);

-- Forum Message Reactions table
CREATE TABLE ForumMessageReactions (
    Id SERIAL PRIMARY KEY,
    ForumMessageId INTEGER REFERENCES ForumMessages(Id),
    FromUserId INTEGER REFERENCES Users(Id),
    ReactionType VARCHAR(100) NOT NULL,
    ReactionDate TIMESTAMP NOT NULL
);

-- User Achievements table
CREATE TABLE UserAchievements (
    Id SERIAL PRIMARY KEY,
    UserId INTEGER REFERENCES Users(Id),
    AchievementType VARCHAR(100) NOT NULL,
    Tier INTEGER NOT NULL,
    TierAchievementDate TIMESTAMP NOT NULL,
    Points INTEGER NOT NULL,
    CurrentRanking INTEGER,
    HighestRanking INTEGER,
    TotalGold INTEGER NOT NULL,
    TotalSilver INTEGER NOT NULL,
    TotalBronze INTEGER NOT NULL
);

-- Episodes table (for competition events)
CREATE TABLE Episodes (
    Id SERIAL PRIMARY KEY,
    Type INTEGER NOT NULL,
    CompetitionId INTEGER REFERENCES Competitions(Id),
    CreateTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL
);

-- Episode Agents table
CREATE TABLE EpisodeAgents (
    Id SERIAL PRIMARY KEY,
    EpisodeId INTEGER REFERENCES Episodes(Id),
    Index INTEGER NOT NULL,
    Reward INTEGER NOT NULL,
    State INTEGER NOT NULL,
    SubmissionId INTEGER NOT NULL,
    InitialConfidence NUMERIC(10,6) NOT NULL,
    InitialScore NUMERIC(10,6) NOT NULL,
    UpdatedConfidence NUMERIC(10,6) NOT NULL,
    UpdatedScore NUMERIC(10,6) NOT NULL
);
