IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142005_InitialCreateLogs'
)
BEGIN
    CREATE TABLE [TransferSessions] (
        [Id] int NOT NULL IDENTITY,
        [StartTime] datetime2 NOT NULL,
        [EndTime] datetime2 NULL,
        [TotalRows] int NOT NULL,
        [ProcessedRows] int NOT NULL,
        [Status] nvarchar(max) NOT NULL,
        [FileName] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_TransferSessions] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142005_InitialCreateLogs'
)
BEGIN
    CREATE TABLE [TransferLogs] (
        [Id] int NOT NULL IDENTITY,
        [TransferSessionId] int NOT NULL,
        [LogTime] datetime2 NOT NULL,
        [Message] nvarchar(max) NOT NULL,
        [LogType] nvarchar(max) NOT NULL,
        [SKU] nvarchar(max) NULL,
        [VariantId] nvarchar(max) NULL,
        CONSTRAINT [PK_TransferLogs] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_TransferLogs_TransferSessions_TransferSessionId] FOREIGN KEY ([TransferSessionId]) REFERENCES [TransferSessions] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142005_InitialCreateLogs'
)
BEGIN
    CREATE INDEX [IX_TransferLogs_TransferSessionId] ON [TransferLogs] ([TransferSessionId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142005_InitialCreateLogs'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260108142005_InitialCreateLogs', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142743_AddUserIdToTransferSession'
)
BEGIN
    ALTER TABLE [TransferSessions] ADD [UserId] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260108142743_AddUserIdToTransferSession'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260108142743_AddUserIdToTransferSession', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112055520_AddTicketTableToDb'
)
BEGIN
    CREATE TABLE [Tickets] (
        [Id] int NOT NULL IDENTITY,
        [Subject] nvarchar(max) NOT NULL,
        [Category] nvarchar(max) NOT NULL,
        [SubCategory] nvarchar(max) NOT NULL,
        [Priority] nvarchar(max) NOT NULL,
        [Description] nvarchar(max) NOT NULL,
        [AttachmentPath] nvarchar(max) NULL,
        [CreatedDate] datetime2 NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_Tickets] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_Tickets_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112055520_AddTicketTableToDb'
)
BEGIN
    CREATE INDEX [IX_Tickets_CreatedByUserId] ON [Tickets] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112055520_AddTicketTableToDb'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112055520_AddTicketTableToDb', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112060017_AddTicketCategory'
)
BEGIN
    CREATE TABLE [Categories] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112060017_AddTicketCategory'
)
BEGIN
    CREATE TABLE [SubCategories] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(max) NOT NULL,
        [CategoryId] int NOT NULL,
        CONSTRAINT [PK_SubCategories] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_SubCategories_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112060017_AddTicketCategory'
)
BEGIN
    CREATE INDEX [IX_SubCategories_CategoryId] ON [SubCategories] ([CategoryId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112060017_AddTicketCategory'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112060017_AddTicketCategory', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112070540_AddStatusToTicketTable'
)
BEGIN
    ALTER TABLE [Tickets] ADD [Status] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112070540_AddStatusToTicketTable'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112070540_AddStatusToTicketTable', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112071215_AddTicketMessage'
)
BEGIN
    CREATE TABLE [TicketMessages] (
        [Id] int NOT NULL IDENTITY,
        [TicketId] int NOT NULL,
        [MessageText] nvarchar(max) NOT NULL,
        [SentDate] datetime2 NOT NULL,
        [UserId] nvarchar(max) NOT NULL,
        [UserName] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_TicketMessages] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_TicketMessages_Tickets_TicketId] FOREIGN KEY ([TicketId]) REFERENCES [Tickets] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112071215_AddTicketMessage'
)
BEGIN
    CREATE INDEX [IX_TicketMessages_TicketId] ON [TicketMessages] ([TicketId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112071215_AddTicketMessage'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112071215_AddTicketMessage', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112072309_AddTicketMessagev1'
)
BEGIN
    ALTER TABLE [TicketMessages] ADD [AttachmentPath] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112072309_AddTicketMessagev1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112072309_AddTicketMessagev1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112082248_AddTicketMessagev2'
)
BEGIN
    ALTER TABLE [TicketMessages] ADD [ReadDate] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112082248_AddTicketMessagev2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112082248_AddTicketMessagev2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112083941_AddTicketHistory'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112083941_AddTicketHistory', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112084126_AddTicketHistoryv1'
)
BEGIN
    CREATE TABLE [TicketHistorys] (
        [Id] int NOT NULL IDENTITY,
        [TicketId] int NOT NULL,
        [OldStatus] int NOT NULL,
        [NewStatus] int NOT NULL,
        [ChangedDate] datetime2 NOT NULL,
        [ChangedByUserName] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_TicketHistorys] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_TicketHistorys_Tickets_TicketId] FOREIGN KEY ([TicketId]) REFERENCES [Tickets] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112084126_AddTicketHistoryv1'
)
BEGIN
    CREATE INDEX [IX_TicketHistorys_TicketId] ON [TicketHistorys] ([TicketId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112084126_AddTicketHistoryv1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112084126_AddTicketHistoryv1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112085736_AddTicketv2'
)
BEGIN
    ALTER TABLE [Tickets] ADD [AssignedToUserId] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112085736_AddTicketv2'
)
BEGIN
    ALTER TABLE [Tickets] ADD [AssignedToUserName] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112085736_AddTicketv2'
)
BEGIN
    ALTER TABLE [Tickets] ADD [EstimatedClosingDate] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112085736_AddTicketv2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112085736_AddTicketv2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112091024_AddTicketv3'
)
BEGIN
    ALTER TABLE [TicketHistorys] ADD [Desctiption] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112091024_AddTicketv3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112091024_AddTicketv3', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112091355_AddTicketv4'
)
BEGIN
    ALTER TABLE [TicketHistorys] ADD [NewAssignedUserName] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112091355_AddTicketv4'
)
BEGIN
    ALTER TABLE [TicketHistorys] ADD [OldAssignedUserName] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112091355_AddTicketv4'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112091355_AddTicketv4', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112092502_AddTicketv5'
)
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Tickets]') AND [c].[name] = N'AssignedToUserId');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Tickets] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [Tickets] ALTER COLUMN [AssignedToUserId] nvarchar(450) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112092502_AddTicketv5'
)
BEGIN
    CREATE INDEX [IX_Tickets_AssignedToUserId] ON [Tickets] ([AssignedToUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112092502_AddTicketv5'
)
BEGIN
    ALTER TABLE [Tickets] ADD CONSTRAINT [FK_Tickets_AspNetUsers_AssignedToUserId] FOREIGN KEY ([AssignedToUserId]) REFERENCES [AspNetUsers] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112092502_AddTicketv5'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112092502_AddTicketv5', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112104418_AddTicketv6'
)
BEGIN
    ALTER TABLE [AspNetUsers] ADD [Department] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112104418_AddTicketv6'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112104418_AddTicketv6', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260112111205_AddTicketv7'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260112111205_AddTicketv7', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260113050836_AddTicketv8'
)
BEGIN
    ALTER TABLE [TicketMessages] ADD [IsInternal] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260113050836_AddTicketv8'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260113050836_AddTicketv8', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260113062014_Versiyon_2_0_TopluGuncelleme'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260113062014_Versiyon_2_0_TopluGuncelleme', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260116133135_AddTicketv14'
)
BEGIN
    ALTER TABLE [Tickets] ADD [ConversationId] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260116133135_AddTicketv14'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260116133135_AddTicketv14', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260119085258_UserPasswordChange'
)
BEGIN
    ALTER TABLE [AspNetUsers] ADD [UpdatePassword] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260119085258_UserPasswordChange'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260119085258_UserPasswordChange', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120092024_TicketAccessToken'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260120092024_TicketAccessToken', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120092156_TicketAccessTokenv1'
)
BEGIN
    CREATE TABLE [TicketAccessTokens] (
        [Id] int NOT NULL IDENTITY,
        [TicketId] int NOT NULL,
        [Token] nvarchar(max) NOT NULL,
        [ExpiryDate] datetime2 NOT NULL,
        [IsUsed] bit NOT NULL,
        CONSTRAINT [PK_TicketAccessTokens] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120092156_TicketAccessTokenv1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260120092156_TicketAccessTokenv1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120100958_TicketAccessTokenv2'
)
BEGIN
    CREATE INDEX [IX_TicketAccessTokens_TicketId] ON [TicketAccessTokens] ([TicketId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120100958_TicketAccessTokenv2'
)
BEGIN
    ALTER TABLE [TicketAccessTokens] ADD CONSTRAINT [FK_TicketAccessTokens_Tickets_TicketId] FOREIGN KEY ([TicketId]) REFERENCES [Tickets] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260120100958_TicketAccessTokenv2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260120100958_TicketAccessTokenv2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082006_UretimHedefs'
)
BEGIN
    CREATE TABLE [UretimHedefs] (
        [Id] int NOT NULL IDENTITY,
        [HedefTarihi] datetime2 NOT NULL,
        [HedefMiktar] int NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        [CreatedDate] datetime2 NOT NULL,
        CONSTRAINT [PK_UretimHedefs] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_UretimHedefs_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082006_UretimHedefs'
)
BEGIN
    CREATE INDEX [IX_UretimHedefs_CreatedByUserId] ON [UretimHedefs] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082006_UretimHedefs'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260122082006_UretimHedefs', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UretimHedefs]') AND [c].[name] = N'HedefTarihi');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [UretimHedefs] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [UretimHedefs] DROP COLUMN [HedefTarihi];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    ALTER TABLE [UretimHedefs] ADD [HedefAyAdi] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    ALTER TABLE [UretimHedefs] ADD [HedefAyi] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    ALTER TABLE [UretimHedefs] ADD [HedefYili] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    ALTER TABLE [UretimHedefs] ADD [UretimHatti] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260122082151_UretimHedefsv1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260122082151_UretimHedefsv1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260123095607_YeniTabloEkleme'
)
BEGIN
    CREATE TABLE [Denemes] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(max) NOT NULL,
        [Description] nvarchar(max) NOT NULL,
        [Type] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_Denemes] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260123095607_YeniTabloEkleme'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260123095607_YeniTabloEkleme', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260123095901_TabloSilindi'
)
BEGIN
    DROP TABLE [Denemes];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260123095901_TabloSilindi'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260123095901_TabloSilindi', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260126092151_AddPazarlamaciKoduToUser'
)
BEGIN
    ALTER TABLE [AspNetUsers] ADD [PazarlamaciKodu] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260126092151_AddPazarlamaciKoduToUser'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260126092151_AddPazarlamaciKoduToUser', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260126100021_AddPazarlamaciKoduToUserv2'
)
BEGIN
    ALTER TABLE [AspNetUsers] ADD [BolgeId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260126100021_AddPazarlamaciKoduToUserv2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260126100021_AddPazarlamaciKoduToUserv2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260128124257_AddGrupToUser'
)
BEGIN
    ALTER TABLE [AspNetUsers] ADD [GrupKodu] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260128124257_AddGrupToUser'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260128124257_AddGrupToUser', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260130051449_AddKullaniciLops'
)
BEGIN
    CREATE TABLE [KullaniciLogs] (
        [Id] int NOT NULL IDENTITY,
        [KullaniciAdi] nvarchar(max) NOT NULL,
        [GirisTarihi] datetime2 NOT NULL,
        [IpAdresi] nvarchar(max) NOT NULL,
        [TarayiciBilgisi] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_KullaniciLogs] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260130051449_AddKullaniciLops'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260130051449_AddKullaniciLops', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260130134945_AddSiraNoUrunDetayBilgileri'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260130134945_AddSiraNoUrunDetayBilgileri', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260130135126_AddSiraNoUrunDetayBilgileriv2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260130135126_AddSiraNoUrunDetayBilgileriv2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202052432_AddProjeTakip'
)
BEGIN
    CREATE TABLE [KanbanProjeler] (
        [Id] int NOT NULL IDENTITY,
        [Baslik] nvarchar(max) NOT NULL,
        [Aciklama] nvarchar(max) NOT NULL,
        [Durum] int NOT NULL,
        [AtananKullanici] nvarchar(max) NOT NULL,
        [SiraNo] int NOT NULL,
        [Oncelik] nvarchar(max) NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_KanbanProjeler] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanProjeler_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202052432_AddProjeTakip'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_CreatedByUserId] ON [KanbanProjeler] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202052432_AddProjeTakip'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202052432_AddProjeTakip', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    EXEC sp_rename N'[KanbanProjeler].[Durum]', N'DurumId', N'COLUMN';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE TABLE [KanbanPanolar] (
        [Id] int NOT NULL IDENTITY,
        [Ad] nvarchar(max) NOT NULL,
        [Aciklama] nvarchar(max) NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_KanbanPanolar] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanPanolar_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE TABLE [KanbanGorevDurumlar] (
        [Id] int NOT NULL IDENTITY,
        [Ad] nvarchar(max) NOT NULL,
        [SiraNo] int NOT NULL,
        [RenkKodu] nvarchar(max) NULL,
        [PanoId] int NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_KanbanGorevDurumlar] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanGorevDurumlar_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_KanbanGorevDurumlar_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_DurumId] ON [KanbanProjeler] ([DurumId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevDurumlar_CreatedByUserId] ON [KanbanGorevDurumlar] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevDurumlar_PanoId] ON [KanbanGorevDurumlar] ([PanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    CREATE INDEX [IX_KanbanPanolar_CreatedByUserId] ON [KanbanPanolar] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_KanbanGorevDurumlar_DurumId] FOREIGN KEY ([DurumId]) REFERENCES [KanbanGorevDurumlar] ([Id]) ON DELETE NO ACTION;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202061406_AddProjeTakipv4'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202061406_AddProjeTakipv4', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202074216_AddGorevDosyalari'
)
BEGIN
    CREATE TABLE [GorevDosyalari] (
        [Id] int NOT NULL IDENTITY,
        [DosyaAdi] nvarchar(max) NOT NULL,
        [DosyaYolu] nvarchar(max) NOT NULL,
        [Uzanti] nvarchar(max) NOT NULL,
        [Boyut] bigint NOT NULL,
        [CreatedByDate] datetime2 NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        [ProjeHareketiId] int NOT NULL,
        CONSTRAINT [PK_GorevDosyalari] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_GorevDosyalari_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_GorevDosyalari_KanbanProjeler_ProjeHareketiId] FOREIGN KEY ([ProjeHareketiId]) REFERENCES [KanbanProjeler] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202074216_AddGorevDosyalari'
)
BEGIN
    CREATE INDEX [IX_GorevDosyalari_CreatedByUserId] ON [GorevDosyalari] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202074216_AddGorevDosyalari'
)
BEGIN
    CREATE INDEX [IX_GorevDosyalari_ProjeHareketiId] ON [GorevDosyalari] ([ProjeHareketiId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202074216_AddGorevDosyalari'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202074216_AddGorevDosyalari', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202084145_AddKanbanLogs'
)
BEGIN
    CREATE TABLE [KanbanGorevAktiviteler] (
        [Id] int NOT NULL IDENTITY,
        [ProjeHareketiId] int NOT NULL,
        [CreatedByUserId] nvarchar(450) NOT NULL,
        [Mesaj] nvarchar(max) NOT NULL,
        [Tarih] datetime2 NOT NULL,
        CONSTRAINT [PK_KanbanGorevAktiviteler] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanGorevAktiviteler_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_KanbanGorevAktiviteler_KanbanProjeler_ProjeHareketiId] FOREIGN KEY ([ProjeHareketiId]) REFERENCES [KanbanProjeler] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202084145_AddKanbanLogs'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevAktiviteler_CreatedByUserId] ON [KanbanGorevAktiviteler] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202084145_AddKanbanLogs'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevAktiviteler_ProjeHareketiId] ON [KanbanGorevAktiviteler] ([ProjeHareketiId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202084145_AddKanbanLogs'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202084145_AddKanbanLogs', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [FK_KanbanProjeler_AspNetUsers_CreatedByUserId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanProjeler]') AND [c].[name] = N'CreatedByUserId');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [KanbanProjeler] ALTER COLUMN [CreatedByUserId] nvarchar(450) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    DECLARE @var3 sysname;
    SELECT @var3 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanProjeler]') AND [c].[name] = N'AtananKullanici');
    IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [' + @var3 + '];');
    ALTER TABLE [KanbanProjeler] ALTER COLUMN [AtananKullanici] nvarchar(450) NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_AtananKullanici] ON [KanbanProjeler] ([AtananKullanici]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_AspNetUsers_AtananKullanici] FOREIGN KEY ([AtananKullanici]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202135158_AddChanges'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202135158_AddChanges', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202140403_AddChangesv1'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [BaslangicTarihi] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202140403_AddChangesv1'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [BitisTarihi] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202140403_AddChangesv1'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [CreatedDate] datetime2 NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260202140403_AddChangesv1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260202140403_AddChangesv1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203044206_AddChangesv2'
)
BEGIN
    CREATE TABLE [KanbanPanoOzelAlan] (
        [Id] int NOT NULL IDENTITY,
        [PanoId] int NOT NULL,
        [AlanAdi] nvarchar(max) NOT NULL,
        [AlanTipi] nvarchar(max) NOT NULL,
        [ZorunluMu] bit NOT NULL,
        [Sira] int NOT NULL,
        CONSTRAINT [PK_KanbanPanoOzelAlan] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203044206_AddChangesv2'
)
BEGIN
    CREATE TABLE [KanbanGorevOzelAlanDeger] (
        [Id] int NOT NULL IDENTITY,
        [GorevId] int NOT NULL,
        [OzelAlanId] int NOT NULL,
        [Deger] nvarchar(max) NOT NULL,
        [ProjeHareketiId] int NULL,
        CONSTRAINT [PK_KanbanGorevOzelAlanDeger] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanGorevOzelAlanDeger_KanbanPanoOzelAlan_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanPanoOzelAlan] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_KanbanGorevOzelAlanDeger_KanbanProjeler_ProjeHareketiId] FOREIGN KEY ([ProjeHareketiId]) REFERENCES [KanbanProjeler] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203044206_AddChangesv2'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDeger_OzelAlanId] ON [KanbanGorevOzelAlanDeger] ([OzelAlanId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203044206_AddChangesv2'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDeger_ProjeHareketiId] ON [KanbanGorevOzelAlanDeger] ([ProjeHareketiId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203044206_AddChangesv2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203044206_AddChangesv2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDeger] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDeger_KanbanPanoOzelAlan_OzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDeger] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDeger_KanbanProjeler_ProjeHareketiId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlan] DROP CONSTRAINT [PK_KanbanPanoOzelAlan];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDeger] DROP CONSTRAINT [PK_KanbanGorevOzelAlanDeger];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    EXEC sp_rename N'[KanbanPanoOzelAlan]', N'KanbanPanoOzelAlanlar';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    EXEC sp_rename N'[KanbanGorevOzelAlanDeger]', N'KanbanGorevOzelAlanDegerler';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    EXEC sp_rename N'[KanbanGorevOzelAlanDegerler].[IX_KanbanGorevOzelAlanDeger_ProjeHareketiId]', N'IX_KanbanGorevOzelAlanDegerler_ProjeHareketiId', N'INDEX';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    EXEC sp_rename N'[KanbanGorevOzelAlanDegerler].[IX_KanbanGorevOzelAlanDeger_OzelAlanId]', N'IX_KanbanGorevOzelAlanDegerler_OzelAlanId', N'INDEX';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlanlar] ADD CONSTRAINT [PK_KanbanPanoOzelAlanlar] PRIMARY KEY ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ADD CONSTRAINT [PK_KanbanGorevOzelAlanDegerler] PRIMARY KEY ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanPanoOzelAlanlar_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanProjeler_ProjeHareketiId] FOREIGN KEY ([ProjeHareketiId]) REFERENCES [KanbanProjeler] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203045149_AddChangesv3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203045149_AddChangesv3', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203052935_AddChangev4'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlanlar] ADD [Secenekler] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203052935_AddChangev4'
)
BEGIN
    DECLARE @var4 sysname;
    SELECT @var4 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanGorevOzelAlanDegerler]') AND [c].[name] = N'Deger');
    IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [KanbanGorevOzelAlanDegerler] DROP CONSTRAINT [' + @var4 + '];');
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ALTER COLUMN [Deger] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203052935_AddChangev4'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203052935_AddChangev4', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [PanoId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    CREATE TABLE [KanbanOtomasyonKurallari] (
        [Id] int NOT NULL IDENTITY,
        [KuralAdi] nvarchar(max) NOT NULL,
        [KaynakPanoId] int NOT NULL,
        [HedefPanoId] int NOT NULL,
        [TetikleyiciDurum] nvarchar(max) NOT NULL,
        [Aktif] bit NOT NULL,
        [CreatedByUserId] nvarchar(450) NULL,
        CONSTRAINT [PK_KanbanOtomasyonKurallari] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanOtomasyonKurallari_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    CREATE TABLE [KanbanOtomasyonMappingler] (
        [Id] int NOT NULL IDENTITY,
        [OtomasyonKuraliId] int NOT NULL,
        [KaynakAlan] nvarchar(max) NOT NULL,
        [HedefAlan] nvarchar(max) NOT NULL,
        [CreatedByUserId] nvarchar(450) NULL,
        [KanbanOtomasyonKuraliId] int NULL,
        CONSTRAINT [PK_KanbanOtomasyonMappingler] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanOtomasyonMappingler_AspNetUsers_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [AspNetUsers] ([Id]),
        CONSTRAINT [FK_KanbanOtomasyonMappingler_KanbanOtomasyonKurallari_KanbanOtomasyonKuraliId] FOREIGN KEY ([KanbanOtomasyonKuraliId]) REFERENCES [KanbanOtomasyonKurallari] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonKurallari_CreatedByUserId] ON [KanbanOtomasyonKurallari] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonMappingler_CreatedByUserId] ON [KanbanOtomasyonMappingler] ([CreatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonMappingler_KanbanOtomasyonKuraliId] ON [KanbanOtomasyonMappingler] ([KanbanOtomasyonKuraliId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203062925_AddChangev5'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203062925_AddChangev5', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072226_AddChangev6'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [HedefDurumId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072226_AddChangev6'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203072226_AddChangev6', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072744_AddChangev7'
)
BEGIN
    ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [FK_KanbanProjeler_AspNetUsers_AtananKullanici];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072744_AddChangev7'
)
BEGIN
    DECLARE @var5 sysname;
    SELECT @var5 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanProjeler]') AND [c].[name] = N'AtananKullanici');
    IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [' + @var5 + '];');
    ALTER TABLE [KanbanProjeler] ALTER COLUMN [AtananKullanici] nvarchar(450) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072744_AddChangev7'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_AspNetUsers_AtananKullanici] FOREIGN KEY ([AtananKullanici]) REFERENCES [AspNetUsers] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203072744_AddChangev7'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203072744_AddChangev7', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203075652_AddChangev8'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [TetikleyiciDurumId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203075652_AddChangev8'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonKurallari_HedefPanoId] ON [KanbanOtomasyonKurallari] ([HedefPanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203075652_AddChangev8'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD CONSTRAINT [FK_KanbanOtomasyonKurallari_KanbanPanolar_HedefPanoId] FOREIGN KEY ([HedefPanoId]) REFERENCES [KanbanPanolar] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203075652_AddChangev8'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203075652_AddChangev8', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203083710_AddChangev9'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [MailAlicilar] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203083710_AddChangev9'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [MailGonder] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203083710_AddChangev9'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [MailIcerik] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203083710_AddChangev9'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [MailKonu] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260203083710_AddChangev9'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260203083710_AddChangev9', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204045329_AddChangesv11'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlanlar] ADD [Konum] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204045329_AddChangesv11'
)
BEGIN
    CREATE TABLE [KanbanGorevOzelAlanAltAlanlari] (
        [Id] int NOT NULL IDENTITY,
        [OzelAlanId] int NOT NULL,
        [KolonAdi] nvarchar(max) NOT NULL,
        [VeriTipi] nvarchar(max) NOT NULL,
        [Sira] int NOT NULL,
        [CreatedDateTime] datetime2 NOT NULL,
        [CreatedByUserId] nvarchar(max) NOT NULL,
        [KanbanPanoOzelAlanId] int NULL,
        CONSTRAINT [PK_KanbanGorevOzelAlanAltAlanlari] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanlar_KanbanPanoOzelAlanId] FOREIGN KEY ([KanbanPanoOzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204045329_AddChangesv11'
)
BEGIN
    CREATE TABLE [KanbanGorevOzelAlanDetayVerileri] (
        [Id] int NOT NULL IDENTITY,
        [GorevId] int NOT NULL,
        [OzelAlanId] int NOT NULL,
        [SatirVerisiJson] nvarchar(max) NOT NULL,
        [CreatedDateTime] datetime2 NOT NULL,
        [CreatedByUserId] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_KanbanGorevOzelAlanDetayVerileri] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204045329_AddChangesv11'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanId] ON [KanbanGorevOzelAlanAltAlanlari] ([KanbanPanoOzelAlanId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204045329_AddChangesv11'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204045329_AddChangesv11', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204061151_AddChangesv12'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [OzetTipi] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204061151_AddChangesv12'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204061151_AddChangesv12', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204083713_AddChangesv13'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] DROP CONSTRAINT [FK_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanlar_KanbanPanoOzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204083713_AddChangesv13'
)
BEGIN
    DECLARE @var6 sysname;
    SELECT @var6 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanGorevOzelAlanAltAlanlari]') AND [c].[name] = N'OzelAlanId');
    IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] DROP CONSTRAINT [' + @var6 + '];');
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] DROP COLUMN [OzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204083713_AddChangesv13'
)
BEGIN
    DROP INDEX [IX_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanId] ON [KanbanGorevOzelAlanAltAlanlari];
    DECLARE @var7 sysname;
    SELECT @var7 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanGorevOzelAlanAltAlanlari]') AND [c].[name] = N'KanbanPanoOzelAlanId');
    IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] DROP CONSTRAINT [' + @var7 + '];');
    EXEC(N'UPDATE [KanbanGorevOzelAlanAltAlanlari] SET [KanbanPanoOzelAlanId] = 0 WHERE [KanbanPanoOzelAlanId] IS NULL');
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ALTER COLUMN [KanbanPanoOzelAlanId] int NOT NULL;
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD DEFAULT 0 FOR [KanbanPanoOzelAlanId];
    CREATE INDEX [IX_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanId] ON [KanbanGorevOzelAlanAltAlanlari] ([KanbanPanoOzelAlanId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204083713_AddChangesv13'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD CONSTRAINT [FK_KanbanGorevOzelAlanAltAlanlari_KanbanPanoOzelAlanlar_KanbanPanoOzelAlanId] FOREIGN KEY ([KanbanPanoOzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204083713_AddChangesv13'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204083713_AddChangesv13', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204084511_AddChangesv14'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [Format] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204084511_AddChangesv14'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204084511_AddChangesv14', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204090030_AddChangesv15'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [ZorunluMu] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204090030_AddChangesv15'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204090030_AddChangesv15', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204092345_AddChangesv16'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [Secenekler] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204092345_AddChangesv16'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204092345_AddChangesv16', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204100009_AddChangesv17'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [KodAdi] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204100009_AddChangesv17'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204100009_AddChangesv17', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204102510_AddChangesv18'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [Kaynak] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204102510_AddChangesv18'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [SqlSorgu] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204102510_AddChangesv18'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204102510_AddChangesv18', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204110730_AddChangesv19'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [DbConnectionName] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204110730_AddChangesv19'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204110730_AddChangesv19', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204113438_AddChangesv20'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [DisplayMember] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204113438_AddChangesv20'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [ValueMember] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260204113438_AddChangesv20'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260204113438_AddChangesv20', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260205083321_AddChanges1'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [GeldigiProjeId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260205083321_AddChanges1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260205083321_AddChanges1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_PanoId] ON [KanbanProjeler] ([PanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    CREATE INDEX [IX_KanbanPanoOzelAlanlar_PanoId] ON [KanbanPanoOzelAlanlar] ([PanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDetayVerileri_GorevId] ON [KanbanGorevOzelAlanDetayVerileri] ([GorevId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDetayVerileri_OzelAlanId] ON [KanbanGorevOzelAlanDetayVerileri] ([OzelAlanId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanGorevOzelAlanAltAlanlari_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanGorevOzelAlanAltAlanlari] ([Id]) ON DELETE NO ACTION;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanProjeler_GorevId] FOREIGN KEY ([GorevId]) REFERENCES [KanbanProjeler] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlanlar] ADD CONSTRAINT [FK_KanbanPanoOzelAlanlar_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206092420_AddRevison1'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260206092420_AddRevison1', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206101655_AddRevison2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260206101655_AddRevison2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanPanoOzelAlanlar_OzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanProjeler_ProjeHareketiId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanGorevOzelAlanAltAlanlari_OzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    DROP INDEX [IX_KanbanGorevOzelAlanDegerler_ProjeHareketiId] ON [KanbanGorevOzelAlanDegerler];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    DECLARE @var8 sysname;
    SELECT @var8 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanGorevOzelAlanDegerler]') AND [c].[name] = N'ProjeHareketiId');
    IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [KanbanGorevOzelAlanDegerler] DROP CONSTRAINT [' + @var8 + '];');
    ALTER TABLE [KanbanGorevOzelAlanDegerler] DROP COLUMN [ProjeHareketiId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDegerler_GorevId] ON [KanbanGorevOzelAlanDegerler] ([GorevId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanPanoOzelAlanlar_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDegerler] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDegerler_KanbanProjeler_GorevId] FOREIGN KEY ([GorevId]) REFERENCES [KanbanProjeler] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanGorevOzelAlanAltAlanlari_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanGorevOzelAlanAltAlanlari] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260206102931_AddRevison3'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260206102931_AddRevison3', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] DROP CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanGorevOzelAlanAltAlanlari_OzelAlanId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD [KanbanPanoOzelAlanId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevOzelAlanDetayVerileri_KanbanPanoOzelAlanId] ON [KanbanGorevOzelAlanDetayVerileri] ([KanbanPanoOzelAlanId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanPanoOzelAlanlar_KanbanPanoOzelAlanId] FOREIGN KEY ([KanbanPanoOzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanDetayVerileri] ADD CONSTRAINT [FK_KanbanGorevOzelAlanDetayVerileri_KanbanPanoOzelAlanlar_OzelAlanId] FOREIGN KEY ([OzelAlanId]) REFERENCES [KanbanPanoOzelAlanlar] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209072856_AddRvize12'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260209072856_AddRvize12', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209093656_AddRevize14'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [KaynakGridId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209093656_AddRevize14'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [KuralTipi] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209093656_AddRevize14'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260209093656_AddRevize14', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209124646_AddRvz15'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [EkGridEslesmeleri] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209124646_AddRvz15'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260209124646_AddRvz15', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209130348_AddRvz16'
)
BEGIN
    EXEC sp_rename N'[KanbanOtomasyonKurallari].[EkGridEslesmeleri]', N'EkGridEslesmeleriJson', N'COLUMN';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260209130348_AddRvz16'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260209130348_AddRvz16', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210045752_AddRvz17'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [IsDeleted] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210045752_AddRvz17'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210045752_AddRvz17', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210050828_AddRvz18'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [UpdatedByUserId] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210050828_AddRvz18'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [UptadetDate] datetime2 NOT NULL DEFAULT '0001-01-01T00:00:00.0000000';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210050828_AddRvz18'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210050828_AddRvz18', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210050856_AddRvz19'
)
BEGIN
    DECLARE @var9 sysname;
    SELECT @var9 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanProjeler]') AND [c].[name] = N'UptadetDate');
    IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [' + @var9 + '];');
    ALTER TABLE [KanbanProjeler] ALTER COLUMN [UptadetDate] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210050856_AddRvz19'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210050856_AddRvz19', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210055233_AddRvz20'
)
BEGIN
    EXEC sp_rename N'[KanbanProjeler].[UptadetDate]', N'UpdatetDate', N'COLUMN';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210055233_AddRvz20'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210055233_AddRvz20', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210061828_AddRvz21'
)
BEGIN
    EXEC sp_rename N'[KanbanProjeler].[UpdatetDate]', N'UpdatedDate', N'COLUMN';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210061828_AddRvz21'
)
BEGIN
    DECLARE @var10 sysname;
    SELECT @var10 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanProjeler]') AND [c].[name] = N'UpdatedByUserId');
    IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [KanbanProjeler] DROP CONSTRAINT [' + @var10 + '];');
    ALTER TABLE [KanbanProjeler] ALTER COLUMN [UpdatedByUserId] nvarchar(450) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210061828_AddRvz21'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_UpdatedByUserId] ON [KanbanProjeler] ([UpdatedByUserId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210061828_AddRvz21'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_AspNetUsers_UpdatedByUserId] FOREIGN KEY ([UpdatedByUserId]) REFERENCES [AspNetUsers] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210061828_AddRvz21'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210061828_AddRvz21', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210071224_AddRvz22'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [DosyaEklemePopupAcilsin] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210071224_AddRvz22'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210071224_AddRvz22', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210081006_AddRvz23'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [YeniKartOlussun] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210081006_AddRvz23'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210081006_AddRvz23', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210083605_AddRvz2'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [DosyaYuklemeZorunluMu] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260210083605_AddRvz2'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260210083605_AddRvz2', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211072346_AddRvz30'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [DuzenleyenKullaniciAd] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211072346_AddRvz30'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [KilitBaslangicTarihi] datetime2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211072346_AddRvz30'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260211072346_AddRvz30', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [EskiDurumId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [EskiVeriJson] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [GecenSureSaniye] bigint NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [Tip] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [YeniDurumId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    ALTER TABLE [KanbanGorevAktiviteler] ADD [YeniVeriJson] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260211105435_AddRvz31'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260211105435_AddRvz31', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212071454_AddRvz40'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212071454_AddRvz40', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212071931_AddRvz41'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [GorevTuruId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212071931_AddRvz41'
)
BEGIN
    CREATE TABLE [KanbanGorevTurleri] (
        [Id] int NOT NULL IDENTITY,
        [Ad] nvarchar(max) NOT NULL,
        [Aciklama] nvarchar(max) NULL,
        [Icon] nvarchar(max) NULL,
        [Renk] nvarchar(max) NULL,
        [PanoId] int NOT NULL,
        CONSTRAINT [PK_KanbanGorevTurleri] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanGorevTurleri_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212071931_AddRvz41'
)
BEGIN
    CREATE INDEX [IX_KanbanGorevTurleri_PanoId] ON [KanbanGorevTurleri] ([PanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212071931_AddRvz41'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212071931_AddRvz41', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    ALTER TABLE [KanbanGorevTurleri] DROP CONSTRAINT [FK_KanbanGorevTurleri_KanbanPanolar_PanoId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD [Not] nvarchar(max) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    CREATE INDEX [IX_KanbanProjeler_GorevTuruId] ON [KanbanProjeler] ([GorevTuruId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    ALTER TABLE [KanbanGorevTurleri] ADD CONSTRAINT [FK_KanbanGorevTurleri_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    ALTER TABLE [KanbanProjeler] ADD CONSTRAINT [FK_KanbanProjeler_KanbanGorevTurleri_GorevTuruId] FOREIGN KEY ([GorevTuruId]) REFERENCES [KanbanGorevTurleri] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212081607_AddRvz42'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212081607_AddRvz42', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212085859_AddRvz43'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [GorevTuruId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212085859_AddRvz43'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonKurallari_GorevTuruId] ON [KanbanOtomasyonKurallari] ([GorevTuruId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212085859_AddRvz43'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD CONSTRAINT [FK_KanbanOtomasyonKurallari_KanbanGorevTurleri_GorevTuruId] FOREIGN KEY ([GorevTuruId]) REFERENCES [KanbanGorevTurleri] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212085859_AddRvz43'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212085859_AddRvz43', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212094328_AddRvz44'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [HedefGorevTuruId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212094328_AddRvz44'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonKurallari_HedefGorevTuruId] ON [KanbanOtomasyonKurallari] ([HedefGorevTuruId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212094328_AddRvz44'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD CONSTRAINT [FK_KanbanOtomasyonKurallari_KanbanGorevTurleri_HedefGorevTuruId] FOREIGN KEY ([HedefGorevTuruId]) REFERENCES [KanbanGorevTurleri] ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212094328_AddRvz44'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212094328_AddRvz44', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212111233_AddRvz45'
)
BEGIN
    ALTER TABLE [KanbanGorevOzelAlanAltAlanlari] ADD [VarsayilanDeger] nvarchar(max) NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212111233_AddRvz45'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212111233_AddRvz45', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212122541_AddRvz46'
)
BEGIN
    CREATE TABLE [KanbanOtomasyonFiltre] (
        [Id] int NOT NULL IDENTITY,
        [OtomasyonKuraliId] int NOT NULL,
        [KolonKodu] nvarchar(max) NOT NULL,
        [Operator] nvarchar(max) NOT NULL,
        [Deger] nvarchar(max) NOT NULL,
        [CreatedByUserId] int NOT NULL,
        [CreatedByDate] datetime2 NOT NULL,
        CONSTRAINT [PK_KanbanOtomasyonFiltre] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanOtomasyonFiltre_KanbanOtomasyonKurallari_OtomasyonKuraliId] FOREIGN KEY ([OtomasyonKuraliId]) REFERENCES [KanbanOtomasyonKurallari] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212122541_AddRvz46'
)
BEGIN
    CREATE INDEX [IX_KanbanOtomasyonFiltre_OtomasyonKuraliId] ON [KanbanOtomasyonFiltre] ([OtomasyonKuraliId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212122541_AddRvz46'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212122541_AddRvz46', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212122600_AddRvz47'
)
BEGIN
    DECLARE @var11 sysname;
    SELECT @var11 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[KanbanOtomasyonFiltre]') AND [c].[name] = N'CreatedByUserId');
    IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [KanbanOtomasyonFiltre] DROP CONSTRAINT [' + @var11 + '];');
    ALTER TABLE [KanbanOtomasyonFiltre] ALTER COLUMN [CreatedByUserId] nvarchar(max) NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212122600_AddRvz47'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212122600_AddRvz47', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonFiltre] DROP CONSTRAINT [FK_KanbanOtomasyonFiltre_KanbanOtomasyonKurallari_OtomasyonKuraliId];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonFiltre] DROP CONSTRAINT [PK_KanbanOtomasyonFiltre];
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    EXEC sp_rename N'[KanbanOtomasyonFiltre]', N'KanbanOtomasyonFiltreleri';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    EXEC sp_rename N'[KanbanOtomasyonFiltreleri].[IX_KanbanOtomasyonFiltre_OtomasyonKuraliId]', N'IX_KanbanOtomasyonFiltreleri_OtomasyonKuraliId', N'INDEX';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonFiltreleri] ADD CONSTRAINT [PK_KanbanOtomasyonFiltreleri] PRIMARY KEY ([Id]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonFiltreleri] ADD CONSTRAINT [FK_KanbanOtomasyonFiltreleri_KanbanOtomasyonKurallari_OtomasyonKuraliId] FOREIGN KEY ([OtomasyonKuraliId]) REFERENCES [KanbanOtomasyonKurallari] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260212124757_AddRvz48'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260212124757_AddRvz48', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213062634_AddRvz49'
)
BEGIN
    ALTER TABLE [KanbanPanoOzelAlanlar] ADD [GorevTuruId] int NULL;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213062634_AddRvz49'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213062634_AddRvz49', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213070017_AddRvz50'
)
BEGIN
    CREATE TABLE [KanbanPanoGecisKurallari] (
        [Id] int NOT NULL IDENTITY,
        [PanoId] int NOT NULL,
        [KaynakSutunId] int NOT NULL,
        [HedefSutunId] int NOT NULL,
        [GecisYasakMi] bit NOT NULL,
        [CreatedByUserId] nvarchar(max) NOT NULL,
        [CreatedDate] datetime2 NOT NULL,
        CONSTRAINT [PK_KanbanPanoGecisKurallari] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_KanbanPanoGecisKurallari_KanbanPanolar_PanoId] FOREIGN KEY ([PanoId]) REFERENCES [KanbanPanolar] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213070017_AddRvz50'
)
BEGIN
    CREATE INDEX [IX_KanbanPanoGecisKurallari_PanoId] ON [KanbanPanoGecisKurallari] ([PanoId]);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213070017_AddRvz50'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213070017_AddRvz50', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213070719_AddRvz51'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213070719_AddRvz51', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213070825_AddRvz52'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213070825_AddRvz52', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213071037_AddRvz53'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213071037_AddRvz53', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213102851_AddRvz54'
)
BEGIN
    ALTER TABLE [KanbanOtomasyonKurallari] ADD [SatirlariKullaniciSecsin] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260213102851_AddRvz54'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260213102851_AddRvz54', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260216083443_AddRvz60'
)
BEGIN
    CREATE TABLE [KanbanPanoYetkileri] (
        [Id] int NOT NULL IDENTITY,
        [PanoId] int NOT NULL,
        [UserId] nvarchar(max) NOT NULL,
        [Role] nvarchar(max) NOT NULL,
        [CreatedByUserId] nvarchar(max) NOT NULL,
        [CreatedDate] datetime2 NOT NULL,
        CONSTRAINT [PK_KanbanPanoYetkileri] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260216083443_AddRvz60'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260216083443_AddRvz60', N'8.0.22');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260216092351_AddRvz61'
)
BEGIN
    EXEC sp_rename N'[KanbanPanoYetkileri].[Role]', N'UserFullName', N'COLUMN';
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260216092351_AddRvz61'
)
BEGIN
    ALTER TABLE [KanbanPanoYetkileri] ADD [Rol] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20260216092351_AddRvz61'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20260216092351_AddRvz61', N'8.0.22');
END;
GO

COMMIT;
GO

