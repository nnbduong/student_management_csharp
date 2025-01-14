USE [master]
GO
/****** Object:  Database [QLHS]    Script Date: 11/19/2018 8:45:38 PM ******/
CREATE DATABASE [QLHS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLHS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QLHS.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QLHS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\QLHS_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [QLHS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLHS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLHS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLHS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLHS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLHS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLHS] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLHS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QLHS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QLHS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLHS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLHS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLHS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLHS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLHS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLHS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLHS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLHS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLHS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLHS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLHS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLHS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLHS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLHS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLHS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLHS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QLHS] SET  MULTI_USER 
GO
ALTER DATABASE [QLHS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLHS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLHS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLHS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QLHS]
GO
/****** Object:  StoredProcedure [dbo].[addStudent]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[addStudent]
    @fidstudent varchar(20) ,
    @ffullname nvarchar(100) ,
    @fbirthday varchar(20) ,
    @fgender varchar(2) ,
    @femail varchar(100) ='',
    @fphonenumber varchar(20) ='',
    @faddress nvarchar(500)
AS
    BEGIN

	DECLARE @query NVARCHAR(max)='';
	SET @query = 
	'INSERT INTO dbo.Students
	        ( StudentID ,
	          FullName ,
	          BirthDay ,
	          Gender ,
	          Email ,
	          PhoneNumber ,
	          Address
	        )
	VALUES  ( '+@fidstudent+' , 
	          '+'N'+''''+@ffullname+''''+', 
	          '+''''+@fbirthday+''''+' , 
	          '+@fgender+' , 
	          '+''''+@femail+''''+' , 
	          '+''''+@fphonenumber+''''+' , 
	          '+'N'+''''+@faddress+''''+' 
	        )'
		--SELECT @query
		EXEC(@query)
    END

GO
/****** Object:  StoredProcedure [dbo].[checklogin]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[checklogin]
    @fusername VARCHAR(20) ,
    @fpassword VARCHAR(20)
AS
    BEGIN
        SELECT  
                U.FullName ,
                U.Role	
        FROM    dbo.Users AS U
        WHERE   U.username = @fusername
                AND U.password = @fpassword 

    END
GO
/****** Object:  StoredProcedure [dbo].[getClassByLevel]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getClassByLevel] @iDLevel varchar(100)
AS
    BEGIN
        DECLARE @stridlv VARCHAR(100)= ''
        IF ( @iDLevel != '0' )
            SET @stridlv = ' AND C.ClassLevel = '+@iDLevel
        
		DECLARE @strQuery NVARCHAR(max) =''
		SET @strQuery='
		SELECT  *
        FROM    Classes C
        WHERE   1 = 1 '+ @stridlv

			EXEC sp_executesql @strQuery

		--SELECT @strQuery
    END

GO
/****** Object:  StoredProcedure [dbo].[GetClasses]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetClasses]
AS
    BEGIN
        SELECT  C.ID ,
                C.ClassName ,
                CL.LevelName
        FROM    dbo.Classes C
                JOIN dbo.ClassLevel CL ON C.ClassLevel = CL.ID
	
    END

GO
/****** Object:  StoredProcedure [dbo].[getClassLevel]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[getClassLevel]
as
begin
select * from ClassLevel
end


GO
/****** Object:  StoredProcedure [dbo].[getListSubject]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getListSubject]
AS
    BEGIN

       SELECT * FROM dbo.Subject AS S WHERE S.Flag= 0

    END

GO
/****** Object:  StoredProcedure [dbo].[getStudentByID]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getStudentByID] @id VARCHAR(20)
AS
    BEGIN
   	
	SELECT * FROM QLHS..Students S WHERE S.StudentID = @id
    END

	UPDATE Students SET ClassLevel = 1


GO
/****** Object:  StoredProcedure [dbo].[getStudentDetail]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getStudentDetail] @idname NVARCHAR(200)
AS
    BEGIN

        SELECT  S.StudentID ,
                S.FullName ,
                C.ClassName ,
                1 AS TBHK1 ,
                2 AS TBHK2
        FROM    dbo.Students S
                JOIN dbo.Classes AS C ON S.Class = C.ID
        WHERE   S.StudentID LIKE '%' + @idname + '%'
                OR S.FullName LIKE N'%' + @idname+'%'
    END

GO
/****** Object:  StoredProcedure [dbo].[getStudentPoint]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getStudentPoint] @fsubjectid VARCHAR(100),@fclassid VARCHAR(100)
AS
    BEGIN

        SELECT  S.StudentID,S.FullName,p.Test15Minutes,P.Test45Minutes,P.TestSemester
        FROM    dbo.Students AS S
                JOIN dbo.Point AS P ON S.StudentID = P.StudenID 
				WHERE P.SubjectID = @fsubjectid
				AND s.Class = @fclassid

    END
GO
/****** Object:  StoredProcedure [dbo].[getStudents]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getStudents]
AS
BEGIN
SELECT 
       S.StudentID ,
       S.FullName ,
       S.BirthDay ,
       S.Gender ,
       S.Email ,
       S.PhoneNumber ,
       S.Address FROM dbo.Students S
END


GO
/****** Object:  StoredProcedure [dbo].[getStudentsByClass]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[getStudentsByClass]
@fclass varchar(2)
as begin

select * from students where Class =@fclass

end
GO
/****** Object:  StoredProcedure [dbo].[getSubjects]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getSubjects]

AS

    BEGIN

        SELECT  ID,S.SubjectName,S.Type,S.Period

        FROM    dbo.Subject S

    END 

GO
/****** Object:  StoredProcedure [dbo].[UpdateStudentPoint]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[UpdateStudentPoint]
    @fids VARCHAR(10) ,
    @fp15 VARCHAR(10) ,
    @fp45 VARCHAR(10) ,
    @fpl VARCHAR(10)
AS
    BEGIN
        UPDATE  dbo.Point
        SET     Test15Minutes = @fp15 ,
                Test45Minutes = @fp45 ,
                TestSemester = @fpl
        WHERE   StudenID = @fids

    END
GO
/****** Object:  Table [dbo].[Classes]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [nvarchar](255) NULL,
	[ClassLevel] [int] NULL,
	[Total] [int] NULL,
	[Flag] [int] NULL,
	[MaxTotal] [int] NULL,
 CONSTRAINT [PK__Classes__3214EC27BA59D8BE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClassLevel]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassLevel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LevelName] [nvarchar](255) NULL,
	[MaxTotal] [int] NULL,
 CONSTRAINT [PK__ClassLev__3214EC2759373ABE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[CUSId] [int] IDENTITY(1,1) NOT NULL,
	[CUSKey]  AS ('Cus'+right('0000'+CONVERT([varchar](5),[CUSId]),(5))) PERSISTED,
	[CusName] [varchar](50) NULL,
	[mobileno] [int] NULL,
	[Gender] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[CUSId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Point]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Point](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudenID] [nvarchar](255) NOT NULL,
	[SubjectID] [nvarchar](255) NOT NULL,
	[Semester] [int] NULL,
	[Test15Minutes] [float] NULL,
	[Test45Minutes] [float] NULL,
	[TestSemester] [float] NULL,
	[Average] [float] NULL,
	[Flag] [int] NULL,
	[StudenJoinID] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RuleAge]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RuleAge](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MinAge] [int] NOT NULL,
	[MaxAge] [int] NOT NULL,
	[Flag] [nchar](10) NULL,
 CONSTRAINT [PK_RuleAge] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RuleStandardScore]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RuleStandardScore](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StandardScore] [float] NULL,
	[Flag] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RuleSubject]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RuleSubject](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDSubject] [int] NOT NULL,
	[MaxTotal] [int] NOT NULL,
	[Flag] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Students]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Students](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StudentID]  AS ('HS'+right('0000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[FullName] [nvarchar](255) NULL,
	[BirthDay] [datetime] NULL,
	[Gender] [int] NULL,
	[Email] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Address] [nvarchar](500) NULL,
	[ClassLevel] [int] NULL,
	[Class] [int] NULL,
	[State] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subject]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subject](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectID]  AS ('MH'+right('0000'+CONVERT([varchar](5),[ID]),(5))) PERSISTED,
	[SubjectName] [nvarchar](255) NULL,
	[Flag] [int] NULL,
	[Type] [int] NULL,
	[Level1] [int] NULL,
	[Level2] [int] NULL,
	[Level3] [int] NULL,
	[Period] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](200) NULL,
	[username] [varchar](20) NULL,
	[password] [varchar](50) NULL,
	[email] [varchar](100) NULL,
	[Role] [int] NULL,
	[address] [nvarchar](max) NULL,
	[phonenumber] [varchar](20) NULL,
	[flag] [int] NULL,
	[birthday] [datetime] NULL,
	[gender] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Classes] ON 

INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (1, N'10A1', 1, 25, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (2, N'10A2', 1, 31, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (3, N'10A3', 1, 31, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (4, N'10A4', 1, 30, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (5, N'11B1', 2, 31, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (6, N'11B2', 2, 31, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (7, N'12C1', 3, 31, 1, 40)
INSERT [dbo].[Classes] ([ID], [ClassName], [ClassLevel], [Total], [Flag], [MaxTotal]) VALUES (8, N'12C2', 3, 31, 1, 40)
SET IDENTITY_INSERT [dbo].[Classes] OFF
SET IDENTITY_INSERT [dbo].[ClassLevel] ON 

INSERT [dbo].[ClassLevel] ([ID], [LevelName], [MaxTotal]) VALUES (1, N'Khối 10', 4)
INSERT [dbo].[ClassLevel] ([ID], [LevelName], [MaxTotal]) VALUES (2, N'Khối 11', 4)
INSERT [dbo].[ClassLevel] ([ID], [LevelName], [MaxTotal]) VALUES (3, N'Khối 12', 3)
SET IDENTITY_INSERT [dbo].[ClassLevel] OFF
SET ANSI_PADDING ON
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (1, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (2, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (3, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (4, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (5, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (6, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (7, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (8, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (9, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (10, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (11, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (12, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (13, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (14, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (15, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (16, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (17, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (18, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (19, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (20, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (21, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (22, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (23, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (24, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (25, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (26, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (27, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (28, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (29, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (30, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (31, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (32, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (33, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (34, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (35, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (36, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (37, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (38, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (39, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (40, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (41, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (42, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (43, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (44, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (45, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (46, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (47, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (48, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (49, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (50, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (51, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (52, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (53, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (54, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (55, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (56, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (57, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (58, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (59, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (60, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (61, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (62, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (63, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (64, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (65, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (66, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (67, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (68, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (69, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (70, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (71, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (72, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (73, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (74, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (75, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (76, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (77, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (78, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (79, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (80, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (81, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (82, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (83, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (84, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (85, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (86, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (87, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (88, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (89, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (90, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (91, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (92, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (93, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (94, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (95, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (96, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (97, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (98, N'aaa', 0, N'bbb')
GO
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (99, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (100, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (101, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (102, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (103, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (104, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (105, N'aaa', 0, N'bbb')
INSERT [dbo].[Customer] ([CUSId], [CusName], [mobileno], [Gender]) VALUES (106, N'aaa', 0, N'bbb')
SET IDENTITY_INSERT [dbo].[Customer] OFF
SET ANSI_PADDING OFF
SET IDENTITY_INSERT [dbo].[Point] ON 

INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (1, N'HS00007', N'MH00002', 1, 3, 3, 5.4, 4.2, -1, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (6, N'HS00007', N'MH00002', 2, 3, 4, 5, 4.33, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (7, N'HS00008', N'MH00002', 1, 4.2, 7.7, 2, 4.27, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (8, N'HS00015', N'MH00002', 1, 9.3, 9.6, 9.4, 9.45, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (9, N'HS00012', N'MH00002', 1, NULL, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (10, N'HS00011', N'MH00002', 1, NULL, NULL, 6.2, NULL, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (11, N'HS00010', N'MH00002', 1, NULL, 7, NULL, NULL, NULL, NULL)
INSERT [dbo].[Point] ([ID], [StudenID], [SubjectID], [Semester], [Test15Minutes], [Test45Minutes], [TestSemester], [Average], [Flag], [StudenJoinID]) VALUES (12, N'HS00009', N'MH00002', 1, 1.5, 5.6, 1.1, 2.67, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Point] OFF
SET IDENTITY_INSERT [dbo].[RuleAge] ON 

INSERT [dbo].[RuleAge] ([ID], [MinAge], [MaxAge], [Flag]) VALUES (1, 12, 43, N'1         ')
SET IDENTITY_INSERT [dbo].[RuleAge] OFF
SET IDENTITY_INSERT [dbo].[RuleStandardScore] ON 

INSERT [dbo].[RuleStandardScore] ([ID], [StandardScore], [Flag]) VALUES (1, 7, N'1')
SET IDENTITY_INSERT [dbo].[RuleStandardScore] OFF
SET IDENTITY_INSERT [dbo].[RuleSubject] ON 

INSERT [dbo].[RuleSubject] ([ID], [IDSubject], [MaxTotal], [Flag]) VALUES (2, 1, 15, NULL)
SET IDENTITY_INSERT [dbo].[RuleSubject] OFF
SET ANSI_PADDING ON
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (1, N'Nguyễn Văn Nam', CAST(N'2003-01-01 00:00:00.000' AS DateTime), 2, N'HS00001@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (2, N'Nguyễn Quốc Tuyến', CAST(N'2003-01-02 00:00:00.000' AS DateTime), 1, N'HS00002@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (3, N'Đõ Dương Hải Phong', CAST(N'2003-01-03 00:00:00.000' AS DateTime), 2, N'HS00003@gmailcom', NULL, N'Hồ Chí Minh', 1, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (4, N'Hoàng Tiến Đạt', CAST(N'2003-01-04 00:00:00.000' AS DateTime), 1, N'HS00004@gmailcom', NULL, N'Hồ Chí Minh', 1, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (5, N'Vũ Quốc Phong', CAST(N'2003-01-05 00:00:00.000' AS DateTime), 2, N'HS00005@gmailcom', NULL, N'Hồ Chí Minh', 1, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (6, N'Nguyễn Thị Mỹ', CAST(N'2003-01-06 00:00:00.000' AS DateTime), 1, N'HS00006@gmailcom', NULL, N'Hồ Chí Minh', 1, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (7, N'Nguyễn Văn Toàn', CAST(N'2003-01-07 00:00:00.000' AS DateTime), 2, N'HS0007@gmail.com', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (8, N'Vũ Song Toàn', CAST(N'2003-01-08 00:00:00.000' AS DateTime), 1, N'HS00008@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (9, N'Võ Đỗ Nguyên Lan', CAST(N'2003-01-09 00:00:00.000' AS DateTime), 2, N'HS00009@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (10, N'Lâm Quốc Vũ', CAST(N'2003-01-10 00:00:00.000' AS DateTime), 1, N'HS00010@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (11, N'Nguyễn Tuyên Quân', CAST(N'2003-01-11 00:00:00.000' AS DateTime), 2, N'HS00011@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (12, N'Đỗ Thị Trúc Diễm', CAST(N'2003-01-12 00:00:00.000' AS DateTime), 1, N'HS00012@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (13, N'Nguyễn Hoàng Dương', CAST(N'2003-01-13 00:00:00.000' AS DateTime), 2, N'HS00013@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (14, N'Nguyễn Quân Trọng', CAST(N'2003-01-14 00:00:00.000' AS DateTime), 1, N'HS00014@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (15, N'Nguyên Hoàng Nhiên', CAST(N'2003-01-15 00:00:00.000' AS DateTime), 2, N'HS00015@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (16, N'Lê Hàn Lâm', CAST(N'2003-01-16 00:00:00.000' AS DateTime), 1, N'HS00016@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (17, N'Lê Nguyên Trác', CAST(N'2003-01-17 00:00:00.000' AS DateTime), 2, N'HS00017@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (18, N'Lưu Đình Hải', CAST(N'2003-01-18 00:00:00.000' AS DateTime), 1, N'HS00018@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (19, N'Mạc Diên Nhiên', CAST(N'2003-01-19 00:00:00.000' AS DateTime), 2, N'HS00019@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (20, N'Mai Trúc Nhi', CAST(N'2003-01-20 00:00:00.000' AS DateTime), 1, N'HS00020@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (21, N'Hoàng Thị Lệ', CAST(N'2003-01-21 00:00:00.000' AS DateTime), 2, N'HS00021@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (22, N'Nguyên Hải Nhiên', CAST(N'2003-01-22 00:00:00.000' AS DateTime), 1, N'HS00022@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (23, N'Nguyễn Công', CAST(N'2003-01-23 00:00:00.000' AS DateTime), 2, N'HS00023@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (24, N'Nguyễn Thành', CAST(N'2003-01-24 00:00:00.000' AS DateTime), 1, N'HS00024@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (25, N'Nguyễn Thị Nhã', CAST(N'2003-01-25 00:00:00.000' AS DateTime), 2, N'HS00025@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (26, N'Nguyễn Văn Ngôn', CAST(N'2003-01-26 00:00:00.000' AS DateTime), 1, N'HS00026@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (27, N'Hoàng Tôn', CAST(N'2003-01-27 00:00:00.000' AS DateTime), 2, N'HS00027@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (28, N'Vũ Ái', CAST(N'2003-01-28 00:00:00.000' AS DateTime), 1, N'HS00028@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (29, N'Đinh Công Hoàng', CAST(N'2003-01-29 00:00:00.000' AS DateTime), 2, N'HS00029@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (30, N'Nguyễn Thiên Trúc', CAST(N'2003-01-30 00:00:00.000' AS DateTime), 1, N'HS00030@gmailcom', NULL, N'Hồ Chí Minh', 1, 1, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (31, N'Đoàn Minh Dự', CAST(N'2003-01-31 00:00:00.000' AS DateTime), 2, N'HS00031@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (32, N'Nguyên Tôn Lang', CAST(N'2003-02-01 00:00:00.000' AS DateTime), 1, N'HS00032@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (33, N'Nguyễn Ái Liễu', CAST(N'2003-02-02 00:00:00.000' AS DateTime), 2, N'HS00033@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (34, N'Hoàng Vũ Song', CAST(N'2003-02-03 00:00:00.000' AS DateTime), 1, N'HS00034@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (35, N'Nguyễn Văn Thanh', CAST(N'2003-02-04 00:00:00.000' AS DateTime), 2, N'HS00035@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (36, N'Nguyễn Văn Lâm', CAST(N'2003-02-05 00:00:00.000' AS DateTime), 1, N'HS00036@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (37, N'Nguyễn Thị Minh', CAST(N'2003-02-06 00:00:00.000' AS DateTime), 2, N'HS00037@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (38, N'Nguyễn Thị Lan', CAST(N'2003-02-07 00:00:00.000' AS DateTime), 1, N'HS00038@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (39, N'Nguyễn Thị Liên', CAST(N'2003-02-08 00:00:00.000' AS DateTime), 2, N'HS00039@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (40, N'Nguyễn Thị Xuyên', CAST(N'2003-07-09 00:00:00.000' AS DateTime), 1, N'HS00040@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (41, N'Nguyễn Thị Chiến', CAST(N'2003-07-10 00:00:00.000' AS DateTime), 2, N'HS00041@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (42, N'Nguyễn Thị Múp', CAST(N'2003-07-11 00:00:00.000' AS DateTime), 1, N'HS00042@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (43, N'Nguyễn Thị Tuyết Nga', CAST(N'2003-07-12 00:00:00.000' AS DateTime), 2, N'HS00043@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (44, N'Nguyễn Thị Mụi', CAST(N'2003-07-13 00:00:00.000' AS DateTime), 1, N'HS00044@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (45, N'Đào Văn Cường', CAST(N'2003-07-14 00:00:00.000' AS DateTime), 2, N'HS00045@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (46, N'Hoàn Trọng Nhân', CAST(N'2003-07-15 00:00:00.000' AS DateTime), 1, N'HS00046@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (47, N'Đỗ Minh ', CAST(N'2003-07-16 00:00:00.000' AS DateTime), 2, N'HS00047@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (48, N'Vũ Chuyên', CAST(N'2003-02-17 00:00:00.000' AS DateTime), 1, N'HS00048@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (49, N'Hồ Tuyền Tiến', CAST(N'2003-02-18 00:00:00.000' AS DateTime), 2, N'HS00049@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (50, N'Lê Hải Hà', CAST(N'2003-02-19 00:00:00.000' AS DateTime), 1, N'HS00050@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (51, N'Đinh Hoàng Phương', CAST(N'2003-02-20 00:00:00.000' AS DateTime), 2, N'HS00051@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (52, N'Nguyễn Ngọc Oanh', CAST(N'2003-02-21 00:00:00.000' AS DateTime), 1, N'HS00052@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (53, N'Hoàng Vũ Kệt', CAST(N'2003-08-22 00:00:00.000' AS DateTime), 2, N'HS00053@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (54, N'Lý Liên Kệt', CAST(N'2003-08-23 00:00:00.000' AS DateTime), 1, N'HS00054@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (55, N'Nguyễn Trọng Nhân', CAST(N'2003-08-24 00:00:00.000' AS DateTime), 2, N'HS00055@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (56, N'Hoàng Lâm', CAST(N'2003-08-25 00:00:00.000' AS DateTime), 1, N'HS00056@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (57, N'Nguyễn Minh Toàn', CAST(N'2003-08-26 00:00:00.000' AS DateTime), 2, N'HS00057@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (58, N'Lê Công Toàn', CAST(N'2003-08-27 00:00:00.000' AS DateTime), 1, N'HS00058@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (59, N'Hà Minh Ninh', CAST(N'2003-08-28 00:00:00.000' AS DateTime), 2, N'HS00059@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (60, N'Hà Liên Khúc', CAST(N'2003-08-29 00:00:00.000' AS DateTime), 1, N'HS00060@gmailcom', NULL, N'Hồ Chí Minh', 1, 2, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (61, N'Nguyễn Đinh An', CAST(N'2003-08-30 00:00:00.000' AS DateTime), 2, N'HS00061@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (62, N'Nguyễn Đinh Duy', CAST(N'2003-08-31 00:00:00.000' AS DateTime), 1, N'HS00062@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (63, N'Trịnh Văn Thịnh', CAST(N'2003-03-04 00:00:00.000' AS DateTime), 2, N'HS00063@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (64, N'Nguyễn Ngọc Bình Dương', CAST(N'2003-09-05 00:00:00.000' AS DateTime), 1, N'HS00064@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (65, N'Vũ Kim Oanh', CAST(N'2003-09-06 00:00:00.000' AS DateTime), 2, N'HS00065@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (66, N'Hà Hồ', CAST(N'2003-09-07 00:00:00.000' AS DateTime), 1, N'HS00066@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (67, N'Hồ Hiền', CAST(N'2003-09-08 00:00:00.000' AS DateTime), 2, N'HS00067@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (68, N'Hà Nhiên Lai', CAST(N'2003-09-09 00:00:00.000' AS DateTime), 1, N'HS00068@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (69, N'Vũ Nguyên Nam', CAST(N'2003-09-10 00:00:00.000' AS DateTime), 2, N'HS00069@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (70, N'Nguyễn Văn Nam', CAST(N'2003-09-11 00:00:00.000' AS DateTime), 1, N'HS00070@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (71, N'Nguyễn Hoàng Nam', CAST(N'2003-09-12 00:00:00.000' AS DateTime), 2, N'HS00071@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (72, N'Nguyễn Nam Dương', CAST(N'2003-09-13 00:00:00.000' AS DateTime), 1, N'HS00072@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (73, N'Nguyễn Hoàng Hải', CAST(N'2003-09-14 00:00:00.000' AS DateTime), 2, N'HS00073@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (74, N'Nguyễn Văn Nam', CAST(N'2003-09-15 00:00:00.000' AS DateTime), 1, N'HS00074@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (75, N'Hà Thanh Trúc', CAST(N'2003-09-16 00:00:00.000' AS DateTime), 2, N'HS00075@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (76, N'Vũ Minh Tuyên', CAST(N'2003-09-17 00:00:00.000' AS DateTime), 1, N'HS00076@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (77, N'Nguyễn Văn Văn', CAST(N'2003-03-18 00:00:00.000' AS DateTime), 2, N'HS00077@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (78, N'Nguyễn Văn Kha', CAST(N'2003-03-19 00:00:00.000' AS DateTime), 1, N'HS00078@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (79, N'Nguyễn Văn Nhiên', CAST(N'2003-03-20 00:00:00.000' AS DateTime), 2, N'HS00079@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (80, N'Nguyễn Văn Kiệt', CAST(N'2003-03-21 00:00:00.000' AS DateTime), 1, N'HS00080@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (81, N'Nguyễn Văn Khải', CAST(N'2003-10-22 00:00:00.000' AS DateTime), 2, N'HS00081@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (82, N'Nguyễn Văn Tiến', CAST(N'2003-10-23 00:00:00.000' AS DateTime), 1, N'HS00082@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (83, N'Nguyễn Văn Lâm', CAST(N'2003-10-24 00:00:00.000' AS DateTime), 2, N'HS00083@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (84, N'Nguyễn Văn Nhân', CAST(N'2003-10-25 00:00:00.000' AS DateTime), 1, N'HS00084@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (85, N'Nguyễn Văn Hoàng', CAST(N'2003-10-26 00:00:00.000' AS DateTime), 2, N'HS00085@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (86, N'Nguyễn Văn Mạnh', CAST(N'2003-10-27 00:00:00.000' AS DateTime), 1, N'HS00086@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (87, N'Nguyễn Văn Vũ', CAST(N'2003-10-28 00:00:00.000' AS DateTime), 2, N'HS00087@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (88, N'Nguyễn Văn Thiện', CAST(N'2003-10-29 00:00:00.000' AS DateTime), 1, N'HS00088@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (89, N'Nguyễn Văn Dẽ', CAST(N'2003-10-30 00:00:00.000' AS DateTime), 2, N'HS00089@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (90, N'Nguyễn Văn Mậu', CAST(N'2003-10-31 00:00:00.000' AS DateTime), 1, N'HS00090@gmailcom', NULL, N'Hồ Chí Minh', 1, 3, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (91, N'Nguyễn Thị Mai', CAST(N'2003-04-01 00:00:00.000' AS DateTime), 2, N'HS00091@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (92, N'Nguyễn Văn Hồ', CAST(N'2003-04-02 00:00:00.000' AS DateTime), 1, N'HS00092@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (93, N'Nguyễn Thị Thúy', CAST(N'2003-04-03 00:00:00.000' AS DateTime), 2, N'HS00093@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (94, N'Nguyễn Văn Nam', CAST(N'2003-04-04 00:00:00.000' AS DateTime), 1, N'HS00094@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (95, N'Nguyễn Thị Ngọc', CAST(N'2003-11-05 00:00:00.000' AS DateTime), 2, N'HS00095@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (96, N'Nguyễn Văn Ba', CAST(N'2003-11-06 00:00:00.000' AS DateTime), 1, N'HS00096@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (97, N'Nguyễn Văn Hạt', CAST(N'2003-11-07 00:00:00.000' AS DateTime), 2, N'HS00097@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (98, N'Nguyễn Văn Lạc', CAST(N'2003-11-08 00:00:00.000' AS DateTime), 1, N'HS00098@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
GO
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (99, N'Nguyễn Thị Loan', CAST(N'2003-11-09 00:00:00.000' AS DateTime), 2, N'HS00099@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (100, N'Nguyễn Văn Hiển', CAST(N'2003-11-10 00:00:00.000' AS DateTime), 1, N'HS00100@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (101, N'Nguyễn Thị Linh', CAST(N'2002-01-23 00:00:00.000' AS DateTime), 2, N'HS00101@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (102, N'Nguyễn Văn Toàn', CAST(N'2002-01-24 00:00:00.000' AS DateTime), 1, N'HS00102@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (103, N'Nguyễn Thị Nga', CAST(N'2002-01-25 00:00:00.000' AS DateTime), 2, N'HS00103@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (104, N'Nguyễn Văn  Toán', CAST(N'2002-01-26 00:00:00.000' AS DateTime), 1, N'HS00104@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (105, N'Nguyễn Thị Truc', CAST(N'2002-01-27 00:00:00.000' AS DateTime), 2, N'HS00105@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (106, N'Nguyễn Văn Tuyển', CAST(N'2002-01-28 00:00:00.000' AS DateTime), 1, N'HS00106@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (107, N'Nguyễn Văn Viết', CAST(N'2002-01-29 00:00:00.000' AS DateTime), 2, N'HS00107@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (108, N'Nguyễn Văn Vượng', CAST(N'2002-01-30 00:00:00.000' AS DateTime), 1, N'HS00108@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (109, N'Nguyễn Thị Viên', CAST(N'2002-01-31 00:00:00.000' AS DateTime), 2, N'HS00109@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (110, N'Nguyễn Văn Tuyến', CAST(N'2002-02-01 00:00:00.000' AS DateTime), 1, N'HS00110@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (111, N'Nguyễn Văn Môn', CAST(N'2002-02-02 00:00:00.000' AS DateTime), 2, N'HS00111@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (112, N'Nguyễn Thị Mai', CAST(N'2002-02-03 00:00:00.000' AS DateTime), 1, N'HS00112@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (113, N'Nguyễn Văn Công', CAST(N'2002-02-04 00:00:00.000' AS DateTime), 2, N'HS00113@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (114, N'Nguyễn Thị Mai', CAST(N'2002-02-05 00:00:00.000' AS DateTime), 1, N'HS00114@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (115, N'Nguyễn Văn Thái', CAST(N'2002-02-06 00:00:00.000' AS DateTime), 2, N'HS00115@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (116, N'Nguyễn Văn Tiết', CAST(N'2002-02-07 00:00:00.000' AS DateTime), 1, N'HS00116@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (117, N'Nguyễn Văn Hòa', CAST(N'2002-02-08 00:00:00.000' AS DateTime), 2, N'HS00117@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (118, N'Nguyễn Thị Như', CAST(N'2002-02-09 00:00:00.000' AS DateTime), 1, N'HS00118@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (119, N'Nguyễn Văn ', CAST(N'2002-02-10 00:00:00.000' AS DateTime), 2, N'HS00119@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (120, N'Nguyễn Thị Mai Như', CAST(N'2002-02-11 00:00:00.000' AS DateTime), 1, N'HS00120@gmailcom', NULL, N'Hồ Chí Minh', 1, 4, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (121, N'Nguyễn Văn Hải', CAST(N'2002-03-12 00:00:00.000' AS DateTime), 2, N'HS00121@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (122, N'Nguyễn Văn Hoàng', CAST(N'2002-03-13 00:00:00.000' AS DateTime), 1, N'HS00122@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (123, N'Nguyễn Văn Sự', CAST(N'2002-03-14 00:00:00.000' AS DateTime), 2, N'HS00123@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (124, N'Nguyễn Thị Trúc Diễm', CAST(N'2002-03-15 00:00:00.000' AS DateTime), 1, N'HS00124@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (125, N'Nguyễn Văn Nam', CAST(N'2002-03-16 00:00:00.000' AS DateTime), 2, N'HS00125@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (126, N'Nguyễn Thị Ái Loan', CAST(N'2002-03-17 00:00:00.000' AS DateTime), 1, N'HS00126@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (127, N'Lê Trọng', CAST(N'2002-03-18 00:00:00.000' AS DateTime), 2, N'HS00127@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (128, N'Hoàng Việt', CAST(N'2002-03-19 00:00:00.000' AS DateTime), 1, N'HS00128@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (129, N'Vũ Tuyệt', CAST(N'2002-03-20 00:00:00.000' AS DateTime), 2, N'HS00129@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (130, N'Đoàn Minh', CAST(N'2002-03-21 00:00:00.000' AS DateTime), 1, N'HS00130@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (131, N'Lý Nhã Kỳ', CAST(N'2002-03-22 00:00:00.000' AS DateTime), 2, N'HS00131@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (132, N'Đoàn Quân Sơn', CAST(N'2002-03-23 00:00:00.000' AS DateTime), 1, N'HS00132@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (133, N'Võ Trọng', CAST(N'2002-02-24 00:00:00.000' AS DateTime), 2, N'HS00133@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (134, N'Hoàng Liệt Sơn', CAST(N'2002-02-25 00:00:00.000' AS DateTime), 1, N'HS00134@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (135, N'Tôn Hành', CAST(N'2002-02-26 00:00:00.000' AS DateTime), 2, N'HS00135@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (136, N'Vũ Tuyết', CAST(N'2002-02-27 00:00:00.000' AS DateTime), 1, N'HS00136@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (137, N'Vũ Thùy', CAST(N'2002-02-28 00:00:00.000' AS DateTime), 2, N'HS00137@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (138, N'Nguyễn Nhiên Sơn', CAST(N'2002-05-01 00:00:00.000' AS DateTime), 1, N'HS00138@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (139, N'Hà Hãi Lãng', CAST(N'2002-05-02 00:00:00.000' AS DateTime), 2, N'HS00139@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (140, N'Nguyễn Thị Điệp', CAST(N'2002-05-03 00:00:00.000' AS DateTime), 1, N'HS00140@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (141, N'Nguyễn Minh Tâm', CAST(N'2002-05-04 00:00:00.000' AS DateTime), 2, N'HS00141@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (142, N'Lê Công Toản', CAST(N'2002-05-05 00:00:00.000' AS DateTime), 1, N'HS00142@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (143, N'Kỳ Hưu Phát', CAST(N'2002-05-06 00:00:00.000' AS DateTime), 2, N'HS00143@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (144, N'Đỗ Nguyên Minh Hãi', CAST(N'2002-05-07 00:00:00.000' AS DateTime), 1, N'HS00144@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (145, N'Hoàn Ngọc Minh Luân', CAST(N'2002-05-08 00:00:00.000' AS DateTime), 2, N'HS00145@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (146, N'Đỗ Trọng Hà', CAST(N'2002-05-09 00:00:00.000' AS DateTime), 1, N'HS00146@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (147, N'Hoàng Quốc Bão', CAST(N'2002-05-10 00:00:00.000' AS DateTime), 2, N'HS00147@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (148, N'Vũ Minh Văn', CAST(N'2002-05-11 00:00:00.000' AS DateTime), 1, N'HS00148@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (149, N'Nguyễn Phát', CAST(N'2002-05-12 00:00:00.000' AS DateTime), 2, N'HS00149@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (150, N'Nguyễn Hữu Phát', CAST(N'2002-05-13 00:00:00.000' AS DateTime), 1, N'HS00150@gmailcom', NULL, N'Hồ Chí Minh', 2, 5, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (151, N'Toàn Thanh Trúc', CAST(N'2002-03-14 00:00:00.000' AS DateTime), 2, N'HS00151@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (152, N'Vương Hãi ', CAST(N'2002-03-15 00:00:00.000' AS DateTime), 1, N'HS00152@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (153, N'Vương Triều', CAST(N'2002-03-16 00:00:00.000' AS DateTime), 2, N'HS00153@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (154, N'Hoàng Tiến', CAST(N'2002-03-17 00:00:00.000' AS DateTime), 1, N'HS00154@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (155, N'Lê Văn Hậu', CAST(N'2002-03-18 00:00:00.000' AS DateTime), 2, N'HS00155@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (156, N'Lê Văn Hoàng', CAST(N'2002-08-19 00:00:00.000' AS DateTime), 1, N'HS00156@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (157, N'Lê Văn Tiến', CAST(N'2002-08-20 00:00:00.000' AS DateTime), 2, N'HS00157@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (158, N'Lê Văn Toàn', CAST(N'2002-08-21 00:00:00.000' AS DateTime), 1, N'HS00158@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (159, N'Lê Văn Vũ', CAST(N'2002-08-22 00:00:00.000' AS DateTime), 2, N'HS00159@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (160, N'Lê Văn Hậu', CAST(N'2002-08-23 00:00:00.000' AS DateTime), 1, N'HS00160@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (161, N'Lê Văn Mậu', CAST(N'2002-08-24 00:00:00.000' AS DateTime), 2, N'HS00161@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (162, N'Lê Văn  Khải', CAST(N'2002-08-25 00:00:00.000' AS DateTime), 1, N'HS00162@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (163, N'Lê Văn Minh', CAST(N'2002-08-26 00:00:00.000' AS DateTime), 2, N'HS00163@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (164, N'Lê Văn Quốc', CAST(N'2002-08-27 00:00:00.000' AS DateTime), 1, N'HS00164@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (165, N'Lê Văn Chiến', CAST(N'2002-08-28 00:00:00.000' AS DateTime), 2, N'HS00165@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (166, N'Lê Văn Ý', CAST(N'2002-08-29 00:00:00.000' AS DateTime), 1, N'HS00166@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (167, N'Lê Văn Nhân', CAST(N'2002-08-30 00:00:00.000' AS DateTime), 2, N'HS00167@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (168, N'Lê Văn Vũ Linh', CAST(N'2002-08-31 00:00:00.000' AS DateTime), 1, N'HS00168@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (169, N'Lê Văn Hiền Triết', CAST(N'2002-09-01 00:00:00.000' AS DateTime), 2, N'HS00169@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (170, N'Lê Văn Ngọc', CAST(N'2002-09-02 00:00:00.000' AS DateTime), 1, N'HS00170@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (171, N'Lê Văn Hậu Viễn', CAST(N'2002-09-03 00:00:00.000' AS DateTime), 2, N'HS00171@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (172, N'Trần Công Toàn', CAST(N'2002-09-04 00:00:00.000' AS DateTime), 1, N'HS00172@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (173, N'Trần Văn Vũ', CAST(N'2002-09-05 00:00:00.000' AS DateTime), 2, N'HS00173@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (174, N'Trần Văn Hà', CAST(N'2002-09-06 00:00:00.000' AS DateTime), 1, N'HS00174@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (175, N'Trần Văn Linh', CAST(N'2002-09-07 00:00:00.000' AS DateTime), 2, N'HS00175@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (176, N'Trần Văn An', CAST(N'2002-09-08 00:00:00.000' AS DateTime), 1, N'HS00176@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (177, N'Trần Văn Anh', CAST(N'2002-09-09 00:00:00.000' AS DateTime), 2, N'HS00177@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (178, N'Trần Văn Hoàng', CAST(N'2002-09-10 00:00:00.000' AS DateTime), 1, N'HS00178@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (179, N'Trần Văn Tiến', CAST(N'2002-09-11 00:00:00.000' AS DateTime), 2, N'HS00179@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (180, N'Trần Văn Dũng', CAST(N'2002-09-12 00:00:00.000' AS DateTime), 1, N'HS00180@gmailcom', NULL, N'Hồ Chí Minh', 2, 6, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (181, N'Trần Văn Nam', CAST(N'2002-04-13 00:00:00.000' AS DateTime), 2, N'HS00181@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (182, N'Trần Văn Dương', CAST(N'2002-04-14 00:00:00.000' AS DateTime), 1, N'HS00182@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (183, N'Trần Văn Đoàn', CAST(N'2002-04-15 00:00:00.000' AS DateTime), 2, N'HS00183@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (184, N'Trần Văn Thiết', CAST(N'2002-04-16 00:00:00.000' AS DateTime), 1, N'HS00184@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (185, N'Trần Văn Nam', CAST(N'2002-04-17 00:00:00.000' AS DateTime), 2, N'HS00185@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (186, N'Trần Văn Diễn', CAST(N'2002-04-18 00:00:00.000' AS DateTime), 1, N'HS00186@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (187, N'Trần Văn Lâm', CAST(N'2002-04-19 00:00:00.000' AS DateTime), 2, N'HS00187@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (188, N'Trần Văn Dương', CAST(N'2002-04-20 00:00:00.000' AS DateTime), 1, N'HS00188@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (189, N'Trần Văn Trúc', CAST(N'2002-12-21 00:00:00.000' AS DateTime), 2, N'HS00189@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (190, N'Trần Văn Hảo', CAST(N'2002-12-22 00:00:00.000' AS DateTime), 1, N'HS00190@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (191, N'Trần Thị Thảo', CAST(N'2002-12-23 00:00:00.000' AS DateTime), 2, N'HS00191@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (192, N'Trần Thị Thanh', CAST(N'2002-12-24 00:00:00.000' AS DateTime), 1, N'HS00192@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (193, N'Trần Thị Trúc', CAST(N'2002-12-25 00:00:00.000' AS DateTime), 2, N'HS00193@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (194, N'Trần Thị Lan', CAST(N'2002-12-26 00:00:00.000' AS DateTime), 1, N'HS00194@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (195, N'Trần Thị Liên', CAST(N'2002-12-27 00:00:00.000' AS DateTime), 2, N'HS00195@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (196, N'Trần Thị Nhã', CAST(N'2002-12-28 00:00:00.000' AS DateTime), 1, N'HS00196@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (197, N'Trần Thị Nhi', CAST(N'2002-12-29 00:00:00.000' AS DateTime), 2, N'HS00197@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (198, N'Trần Thị Vỹ', CAST(N'2002-12-30 00:00:00.000' AS DateTime), 1, N'HS00198@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
GO
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (199, N'Trần Thị  Vy', CAST(N'2002-12-31 00:00:00.000' AS DateTime), 2, N'HS00199@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (200, N'Trần Thị Vàng', CAST(N'2002-05-02 00:00:00.000' AS DateTime), 1, N'HS00200@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (201, N'Trần Thị Nhân', CAST(N'2001-05-02 00:00:00.000' AS DateTime), 2, N'HS00201@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (202, N'Trần Thị Mai', CAST(N'2001-05-03 00:00:00.000' AS DateTime), 1, N'HS00202@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (203, N'Trần Thị Bạch', CAST(N'2001-05-04 00:00:00.000' AS DateTime), 2, N'HS00203@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (204, N'Trần Thị Tuyết', CAST(N'2001-05-05 00:00:00.000' AS DateTime), 1, N'HS00204@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (205, N'Trần Thị Phương', CAST(N'2001-05-06 00:00:00.000' AS DateTime), 2, N'HS00205@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (206, N'Trần Thị Hiền', CAST(N'2001-05-07 00:00:00.000' AS DateTime), 1, N'HS00206@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (207, N'Trần Thị Hòa', CAST(N'2001-05-08 00:00:00.000' AS DateTime), 2, N'HS00207@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (208, N'Đinh Công Toàn', CAST(N'2001-05-09 00:00:00.000' AS DateTime), 1, N'HS00208@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (209, N'Đinh Văn Vũ', CAST(N'2001-05-10 00:00:00.000' AS DateTime), 2, N'HS00209@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (210, N'Đinh Văn Hà', CAST(N'2001-05-11 00:00:00.000' AS DateTime), 1, N'HS00210@gmailcom', NULL, N'Hồ Chí Minh', 3, 7, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (211, N'Đinh Văn Linh', CAST(N'2001-05-12 00:00:00.000' AS DateTime), 2, N'HS00211@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (212, N'Đinh Văn An', CAST(N'2001-05-13 00:00:00.000' AS DateTime), 1, N'HS00212@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (213, N'Đinh Văn Anh', CAST(N'2001-05-14 00:00:00.000' AS DateTime), 2, N'HS00213@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (214, N'Đinh Văn Hoàng', CAST(N'2001-05-15 00:00:00.000' AS DateTime), 1, N'HS00214@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (215, N'Đinh Văn Tiến', CAST(N'2001-05-16 00:00:00.000' AS DateTime), 2, N'HS00215@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (216, N'Đinh Văn Dũng', CAST(N'2001-05-17 00:00:00.000' AS DateTime), 1, N'HS00216@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (217, N'Đinh Văn Nam', CAST(N'2001-05-18 00:00:00.000' AS DateTime), 2, N'HS00217@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (218, N'Đinh Văn Dương', CAST(N'2001-05-19 00:00:00.000' AS DateTime), 1, N'HS00218@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (219, N'Đinh Văn Đoàn', CAST(N'2001-05-20 00:00:00.000' AS DateTime), 2, N'HS00219@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (220, N'Đinh Văn Thiết', CAST(N'2001-05-21 00:00:00.000' AS DateTime), 1, N'HS00220@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (221, N'Đinh Văn Nam', CAST(N'2001-05-22 00:00:00.000' AS DateTime), 2, N'HS00221@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (222, N'Đinh Văn Diễn', CAST(N'2001-05-23 00:00:00.000' AS DateTime), 1, N'HS00222@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (223, N'Đinh Văn Lâm', CAST(N'2001-05-24 00:00:00.000' AS DateTime), 2, N'HS00223@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (224, N'Đinh Văn Dương', CAST(N'2001-05-25 00:00:00.000' AS DateTime), 1, N'HS00224@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (225, N'Lê Thị Thảo', CAST(N'2001-05-26 00:00:00.000' AS DateTime), 2, N'HS00225@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (226, N'Lê Thị Thanh', CAST(N'2001-05-27 00:00:00.000' AS DateTime), 1, N'HS00226@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (227, N'Lê Thị Trúc', CAST(N'2001-05-28 00:00:00.000' AS DateTime), 2, N'HS00227@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (228, N'Lê Thị Lan', CAST(N'2001-05-29 00:00:00.000' AS DateTime), 1, N'HS00228@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (229, N'Lê Thị Liên', CAST(N'2001-03-29 00:00:00.000' AS DateTime), 2, N'HS00229@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (230, N'Lê Thị Nhã', CAST(N'2001-03-30 00:00:00.000' AS DateTime), 1, N'HS00230@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (231, N'Lê Thị Nhi', CAST(N'2001-03-31 00:00:00.000' AS DateTime), 2, N'HS00231@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (232, N'Lê Thị Vỹ', CAST(N'2001-04-01 00:00:00.000' AS DateTime), 1, N'HS00232@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (233, N'Lê Thị  Vy', CAST(N'2001-04-02 00:00:00.000' AS DateTime), 2, N'HS00233@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (234, N'Lê Thị Vàng', CAST(N'2001-04-03 00:00:00.000' AS DateTime), 1, N'HS00234@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (235, N'Lê Thị Nhân', CAST(N'2001-04-04 00:00:00.000' AS DateTime), 2, N'HS00235@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (236, N'Lê Thị Mai', CAST(N'2001-04-05 00:00:00.000' AS DateTime), 1, N'HS00236@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (237, N'Lê Thị Bạch', CAST(N'2001-04-06 00:00:00.000' AS DateTime), 2, N'HS00237@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (238, N'Trần Thị Tuyết', CAST(N'2001-04-07 00:00:00.000' AS DateTime), 1, N'HS00238@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (239, N'Lê Thị Phương', CAST(N'2001-04-08 00:00:00.000' AS DateTime), 2, N'HS00239@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (240, N'Võ Văn Văn', CAST(N'2001-04-09 00:00:00.000' AS DateTime), 1, N'HS00240@gmailcom', NULL, N'Hồ Chí Minh', 3, 8, NULL)
INSERT [dbo].[Students] ([ID], [FullName], [BirthDay], [Gender], [Email], [PhoneNumber], [Address], [ClassLevel], [Class], [State]) VALUES (241, N'test thêm', CAST(N'1990-06-19 00:00:00.000' AS DateTime), 1, N'email@amam.dbvcv', NULL, N'địa chỉ', 1, 1, NULL)
SET IDENTITY_INSERT [dbo].[Students] OFF
SET ANSI_PADDING OFF
SET ANSI_PADDING ON
SET IDENTITY_INSERT [dbo].[Subject] ON 

INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (1, N'Văn', 0, 1, 0, 0, 0, 60)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (2, N'Sử', 0, 1, 0, 0, 0, 45)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (3, N'Địa', 0, 1, 0, 0, 0, 45)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (4, N'Toán', 0, 2, 0, 0, 0, 60)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (5, N'Lý', 0, 0, 0, 0, 0, 60)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (6, N'Hóa', NULL, 2, NULL, NULL, NULL, 45)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (7, N'Sinh', NULL, 1, NULL, NULL, NULL, 45)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (8, N'Thể dục', NULL, 1, NULL, NULL, NULL, 45)
INSERT [dbo].[Subject] ([ID], [SubjectName], [Flag], [Type], [Level1], [Level2], [Level3], [Period]) VALUES (9, N'Đạo đức', NULL, 12, NULL, NULL, NULL, 45)
SET IDENTITY_INSERT [dbo].[Subject] OFF
SET ANSI_PADDING OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([id], [FullName], [username], [password], [email], [Role], [address], [phonenumber], [flag], [birthday], [gender]) VALUES (1, N'administrator', N'admin', N'21232F297A57A5A743894A0E4A801FC3', N'admin@email.com', NULL, N'địa chỉ nào đó', N'0123456782', NULL, CAST(N'2018-11-18 00:00:00.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
/****** Object:  Trigger [dbo].[after_modify]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[after_modify] ON [dbo].[Point]
    AFTER INSERT, UPDATE
AS
    BEGIN
        DECLARE @id INT ,
            @t1 FLOAT ,
            @t2 FLOAT ,
            @t3 FLOAT;

        SELECT  @id = Inserted.ID ,
                @t1 = Inserted.Test15Minutes ,
                @t2 = Inserted.Test45Minutes ,
                @t3 = Inserted.TestSemester
        FROM    inserted

        IF ( ISNULL(@t1, '') != ''
             AND ISNULL(@t2, '') != ''
             AND ISNULL(@t2, '') != ''
           )
            BEGIN
                UPDATE  dbo.Point
                SET     Average =  cast(round((@t1 + @t2*2 + @t3*3)/6,2) as numeric(36,2))
                WHERE   ID = @id
            END 
        ELSE
            BEGIN
                UPDATE  dbo.Point
                SET     Average = NULL
                WHERE   ID = @id
            END
    END
GO
/****** Object:  Trigger [dbo].[after_modify_student]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[after_modify_student] ON [dbo].[Students]
    AFTER INSERT, DELETE
AS
    BEGIN
        DECLARE @id INT ,
            @total INT  

        SELECT  @id = Inserted.Class
        FROM    inserted

        SELECT  @total = COUNT(*)
        FROM    dbo.Students AS S
        WHERE   S.Class = @id

        UPDATE  dbo.Classes
        SET     Total = @total
        WHERE   ID = @id
         
    END
GO
/****** Object:  Trigger [dbo].[after_UPDATE_student]    Script Date: 11/19/2018 8:45:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[after_UPDATE_student] ON [dbo].[Students]
    AFTER UPDATE
AS
    BEGIN
        DECLARE @idclass_old INT ,
            @idclass_new INT ,
            @total_new INT ,
            @total_old INT  


        SELECT  @idclass_new = i.Class ,
                @idclass_old = d.Class
        FROM    inserted i
                JOIN deleted d ON ( i.ID = d.ID )
        IF ( @idclass_new != @idclass_old )
            BEGIN 
                SELECT  @total_new = COUNT(*)
                FROM    dbo.Students AS S
                WHERE   S.Class = @idclass_new
				
                SELECT  @total_old = COUNT(*)
                FROM    dbo.Students AS S
                WHERE   S.Class = @idclass_old

                UPDATE  dbo.Classes
                SET     Total = @total_old
                WHERE   ID = @idclass_old
				
                UPDATE  dbo.Classes
                SET     Total = @total_new
                WHERE   ID = @idclass_new

            END 
    END
GO
USE [master]
GO
ALTER DATABASE [QLHS] SET  READ_WRITE 
GO
