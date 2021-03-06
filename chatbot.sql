USE [chatbot]
GO
/****** Object:  Table [dbo].[subjects]    Script Date: 31-Jul-16 12:27:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[subjects](
	[subjectid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
 CONSTRAINT [PK_subjects] PRIMARY KEY CLUSTERED 
(
	[subjectid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[user_subject]    Script Date: 31-Jul-16 12:27:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[user_subject](
	[userid] [varchar](30) NOT NULL,
	[subjectid] [int] NOT NULL,
 CONSTRAINT [PK_user_subject] PRIMARY KEY CLUSTERED 
(
	[userid] ASC,
	[subjectid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[user_word]    Script Date: 31-Jul-16 12:27:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[user_word](
	[wordid] [int] NOT NULL,
	[userid] [varchar](30) NOT NULL,
	[outdate] [datetime] NULL,
 CONSTRAINT [PK_user_word] PRIMARY KEY CLUSTERED 
(
	[wordid] ASC,
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[users]    Script Date: 31-Jul-16 12:27:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[users](
	[userid] [varchar](30) NOT NULL,
	[wordsperday] [int] NULL CONSTRAINT [DF_users_wordsperday]  DEFAULT ((5)),
	[remindtime] [time](7) NULL CONSTRAINT [DF_users_remindtime]  DEFAULT ('8:00:00'),
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[words]    Script Date: 31-Jul-16 12:27:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[words](
	[wordid] [int] IDENTITY(1,1) NOT NULL,
	[word] [varchar](50) NULL,
	[classified] [varchar](50) NULL,
	[meaning] [varchar](250) NULL,
	[subjectid] [int] NOT NULL,
 CONSTRAINT [PK_words] PRIMARY KEY CLUSTERED 
(
	[wordid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[subjects] ON 

INSERT [dbo].[subjects] ([subjectid], [name]) VALUES (1, N'People')
INSERT [dbo].[subjects] ([subjectid], [name]) VALUES (2, N'Economy')
INSERT [dbo].[subjects] ([subjectid], [name]) VALUES (3, N'Health')
SET IDENTITY_INSERT [dbo].[subjects] OFF
INSERT [dbo].[user_word] ([wordid], [userid], [outdate]) VALUES (1, N'123456', CAST(N'2016-07-30 00:00:00.000' AS DateTime))
INSERT [dbo].[user_word] ([wordid], [userid], [outdate]) VALUES (2, N'124576', CAST(N'2016-07-30 00:00:00.000' AS DateTime))
INSERT [dbo].[users] ([userid], [wordsperday], [remindtime]) VALUES (N'123456', 5, CAST(N'15:50:00' AS Time))
INSERT [dbo].[users] ([userid], [wordsperday], [remindtime]) VALUES (N'124576', 5, CAST(N'15:50:00' AS Time))
INSERT [dbo].[users] ([userid], [wordsperday], [remindtime]) VALUES (N'563762', 5, CAST(N'08:00:00' AS Time))
INSERT [dbo].[users] ([userid], [wordsperday], [remindtime]) VALUES (N'765432', 5, CAST(N'08:00:00' AS Time))
SET IDENTITY_INSERT [dbo].[words] ON 

INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (1, N'well-respected', N'adjective', N'strongly admired by many people for your qualities or achievements:', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (2, N'trustworthy', N'adjective', N'able to be trusted', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (3, N'set a good example of', N'verb', N'to be a person, who a lot of people want to become ', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (4, N'chill out', N'verb', N'to spend time relaxing', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (6, N'soulful eyse', N'noun', N'beautiful eyes ', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (7, N'smart', N'adjective', N'bright and fresh in appearance', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (8, N'rude', N'adjective', N'offensively impolite or bad-mannered', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (9, N'abuse', N'noun', N'use of something in a way that is wrong or harmful', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (10, N'abundant', N'adjective', N'more than enough', 1)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (11, N'competition', N'noun', N'the process of trying to get or win something', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (12, N'crash', N'noun', N'a sudden and extreme fall or drop in amount of value', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (13, N'currency', N'noun', N'the money that a country uses', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (14, N'deposit', N'verb', N'to put (money) in a bank account', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (15, N'depression', N'noun', N'a period of time in which there is little economic activity and many people do not have jobs', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (16, N'economy', N'noun', N'the process in which goods and services are produced, sold, and bought in a country or region', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (17, N'finance', N'noun', N'the way in which money is used and handled', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (18, N'inflation', N'noun', N'a continual increase in the price of goods and services', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (19, N'invest', N'verb', N'to use money to earn more money', 2)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (20, N'allergy', N'noun', N'a medical condition that causes someone to become sick after eating, touching or breathing something that is harmless to most people', 3)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (21, N'blood', N'noun', N'the red liquid that flows through the bodies of people and animals', 3)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (22, N'cold', N'noun', N'a common illness that affects the nose, throat, and eyes and that usually causes coughing, sneezing, etc', 3)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (23, N'headache', N'noun', N'an ache or pain in the head', 3)
INSERT [dbo].[words] ([wordid], [word], [classified], [meaning], [subjectid]) VALUES (24, N'fever', N'noun', N'a disease that causes an increase in body tempurature', 3)
SET IDENTITY_INSERT [dbo].[words] OFF
ALTER TABLE [dbo].[user_subject]  WITH CHECK ADD  CONSTRAINT [FK_USERSUBJECT_SUBJECTS] FOREIGN KEY([subjectid])
REFERENCES [dbo].[subjects] ([subjectid])
GO
ALTER TABLE [dbo].[user_subject] CHECK CONSTRAINT [FK_USERSUBJECT_SUBJECTS]
GO
ALTER TABLE [dbo].[user_subject]  WITH CHECK ADD  CONSTRAINT [FK_USERSUBJECT_USERS] FOREIGN KEY([userid])
REFERENCES [dbo].[users] ([userid])
GO
ALTER TABLE [dbo].[user_subject] CHECK CONSTRAINT [FK_USERSUBJECT_USERS]
GO
ALTER TABLE [dbo].[user_word]  WITH CHECK ADD  CONSTRAINT [FK_USERWORD_USERS] FOREIGN KEY([userid])
REFERENCES [dbo].[users] ([userid])
GO
ALTER TABLE [dbo].[user_word] CHECK CONSTRAINT [FK_USERWORD_USERS]
GO
ALTER TABLE [dbo].[user_word]  WITH CHECK ADD  CONSTRAINT [FK_USERWORD_WORDS] FOREIGN KEY([wordid])
REFERENCES [dbo].[words] ([wordid])
GO
ALTER TABLE [dbo].[user_word] CHECK CONSTRAINT [FK_USERWORD_WORDS]
GO
ALTER TABLE [dbo].[words]  WITH CHECK ADD  CONSTRAINT [FK_WORDS_SUBJECTS] FOREIGN KEY([subjectid])
REFERENCES [dbo].[subjects] ([subjectid])
GO
ALTER TABLE [dbo].[words] CHECK CONSTRAINT [FK_WORDS_SUBJECTS]
GO
