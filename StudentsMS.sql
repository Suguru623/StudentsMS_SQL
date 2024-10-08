USE [master]
GO
/****** Object:  Database [StudentsMS]    Script Date: 2024/9/11 上午 11:56:10 ******/
CREATE DATABASE [StudentsMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StudentsMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\StudentsMS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'StudentsMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\StudentsMS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [StudentsMS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StudentsMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StudentsMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StudentsMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StudentsMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StudentsMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StudentsMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [StudentsMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StudentsMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StudentsMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StudentsMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StudentsMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StudentsMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StudentsMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StudentsMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StudentsMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StudentsMS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [StudentsMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StudentsMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StudentsMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StudentsMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StudentsMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StudentsMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StudentsMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StudentsMS] SET RECOVERY FULL 
GO
ALTER DATABASE [StudentsMS] SET  MULTI_USER 
GO
ALTER DATABASE [StudentsMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StudentsMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StudentsMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StudentsMS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [StudentsMS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [StudentsMS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'StudentsMS', N'ON'
GO
ALTER DATABASE [StudentsMS] SET QUERY_STORE = ON
GO
ALTER DATABASE [StudentsMS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [StudentsMS]
GO
/****** Object:  UserDefinedFunction [dbo].[getLDID]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getLDID]()
	returns char(12)
as
begin
	--抓今天的日期
	
	declare @lastID char(12),@newID char(12)

	--抓今天的最後一張訂單編號
	select top 1 @lastID=LDID from LeaveDetail
	where Convert(varchar,LDDate,112)=Convert(varchar,getdate(),112)
	order by LDDate desc

	--有找到=>流水號為n+1

	--沒找到=>流水號為0001
	if @lastID is null
	begin
		set @newID=Convert(varchar,getdate(),112)+'0001'
	end
	else
		set @newID =cast(cast(@lastID as bigint)+1 as varchar)

	return @newID
end
GO
/****** Object:  UserDefinedFunction [dbo].[getRCID]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[getRCID]()
	returns char(12)
as
begin
	--抓今天的日期
	
	declare @lastID char(12),@newID char(12)

	--抓今天的最後一張訂單編號
	select top 1 @lastID=RCID from RollCall
	where Convert(varchar,ArrivalTime,112)=Convert(varchar,getdate(),112)
	order by ArrivalTime desc

	--有找到=>流水號為n+1

	--沒找到=>流水號為0001
	if @lastID is null
	begin
		set @newID=Convert(varchar,getdate(),112)+'0001'
	end
	else
		set @newID =cast(cast(@lastID as bigint)+1 as varchar)

	return @newID
end
GO
/****** Object:  Table [dbo].[ClassTime]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassTime](
	[CTID] [char](3) NOT NULL,
	[CTWeek] [char](1) NOT NULL,
	[CTPeriod] [char](1) NOT NULL,
	[StartTime] [char](5) NOT NULL,
	[EndTime] [char](5) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [char](3) NOT NULL,
	[CName] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Curriculum]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Curriculum](
	[CourseID] [char](3) NOT NULL,
	[DeptID] [char](3) NOT NULL,
	[CTID] [char](3) NOT NULL,
	[CTHours] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC,
	[DeptID] ASC,
	[CTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DeptID] [char](3) NOT NULL,
	[DName] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Leave]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Leave](
	[LeaveID] [char](3) NOT NULL,
	[LName] [nvarchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LeaveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LeaveDetail]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeaveDetail](
	[LDID] [varchar](15) NOT NULL,
	[StuID] [char](9) NOT NULL,
	[LeaveID] [char](3) NOT NULL,
	[LDDate] [datetime] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
 CONSTRAINT [PK__LeaveDet__61F2580E45528DC2] PRIMARY KEY CLUSTERED 
(
	[LDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[Account] [nvarchar](10) NOT NULL,
	[Password] [nchar](12) NOT NULL,
	[Type] [int] NULL,
 CONSTRAINT [PK_Login] PRIMARY KEY CLUSTERED 
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RollCall]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RollCall](
	[RCID] [char](12) NOT NULL,
	[StuID] [char](9) NOT NULL,
	[CourseID] [char](3) NOT NULL,
	[DeptID] [char](3) NOT NULL,
	[CTID] [char](3) NOT NULL,
	[RCDate] [date] NOT NULL,
	[ArrivalTime] [datetime] NOT NULL,
 CONSTRAINT [PK_RollCall] PRIMARY KEY CLUSTERED 
(
	[RCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SelectCourse]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SelectCourse](
	[StuID] [char](9) NOT NULL,
	[CourseID] [char](3) NOT NULL,
	[DeptID] [char](3) NOT NULL,
	[CTID] [char](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StuID] ASC,
	[CourseID] ASC,
	[DeptID] ASC,
	[CTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 2024/9/11 上午 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[StuID] [char](9) NOT NULL,
	[SName] [nvarchar](20) NOT NULL,
	[Grade] [char](1) NOT NULL,
	[Class] [char](1) NOT NULL,
	[Number] [char](2) NOT NULL,
	[DeptID] [char](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T11', N'1', N'1', N'08:00', N'08:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T12', N'1', N'2', N'09:00', N'09:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T13', N'1', N'3', N'10:00', N'10:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T14', N'1', N'4', N'11:00', N'11:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T15', N'1', N'5', N'13:00', N'13:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T16', N'1', N'6', N'14:00', N'14:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T17', N'1', N'7', N'15:00', N'15:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T18', N'1', N'8', N'16:00', N'16:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T21', N'2', N'1', N'08:00', N'08:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T22', N'2', N'2', N'09:00', N'09:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T23', N'2', N'3', N'10:00', N'10:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T24', N'2', N'4', N'11:00', N'11:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T25', N'2', N'5', N'13:00', N'13:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T26', N'2', N'6', N'14:00', N'14:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T27', N'2', N'7', N'15:00', N'15:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T28', N'2', N'8', N'16:00', N'16:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T31', N'3', N'1', N'08:00', N'08:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T32', N'3', N'2', N'09:00', N'09:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T33', N'3', N'3', N'10:00', N'10:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T34', N'3', N'4', N'11:00', N'11:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T35', N'3', N'5', N'13:00', N'13:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T36', N'3', N'6', N'14:00', N'14:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T37', N'3', N'7', N'15:00', N'15:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T38', N'3', N'8', N'16:00', N'16:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T41', N'4', N'1', N'08:00', N'08:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T42', N'4', N'2', N'09:00', N'09:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T43', N'4', N'3', N'10:00', N'10:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T44', N'4', N'4', N'11:00', N'11:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T45', N'4', N'5', N'13:00', N'13:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T46', N'4', N'6', N'14:00', N'14:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T47', N'4', N'7', N'15:00', N'15:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T48', N'4', N'8', N'16:00', N'16:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T51', N'5', N'1', N'08:00', N'08:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T52', N'5', N'2', N'09:00', N'09:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T53', N'5', N'3', N'10:00', N'10:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T54', N'5', N'4', N'11:00', N'11:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T55', N'5', N'5', N'13:00', N'13:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T56', N'5', N'6', N'14:00', N'14:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T57', N'5', N'7', N'15:00', N'15:50')
INSERT [dbo].[ClassTime] ([CTID], [CTWeek], [CTPeriod], [StartTime], [EndTime]) VALUES (N'T58', N'5', N'8', N'16:00', N'16:50')
GO
INSERT [dbo].[Course] ([CourseID], [CName]) VALUES (N'C01', N'微積分')
INSERT [dbo].[Course] ([CourseID], [CName]) VALUES (N'C02', N'資料結構')
INSERT [dbo].[Course] ([CourseID], [CName]) VALUES (N'C03', N'演算法')
INSERT [dbo].[Course] ([CourseID], [CName]) VALUES (N'C04', N'線性代數')
INSERT [dbo].[Course] ([CourseID], [CName]) VALUES (N'C05', N'系統程式設計')
GO
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C01', N'D01', N'T12', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C01', N'D02', N'T12', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C01', N'D03', N'T12', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C01', N'D04', N'T12', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C02', N'D01', N'T15', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C02', N'D02', N'T15', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C02', N'D03', N'T15', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C02', N'D04', N'T15', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C03', N'D01', N'T22', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C03', N'D02', N'T22', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C03', N'D03', N'T22', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C03', N'D04', N'T22', N'3')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C04', N'D01', N'T27', N'2')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C04', N'D02', N'T27', N'2')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C04', N'D03', N'T27', N'2')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C04', N'D04', N'T27', N'2')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C05', N'D01', N'T35', N'4')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C05', N'D02', N'T35', N'4')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C05', N'D03', N'T35', N'4')
INSERT [dbo].[Curriculum] ([CourseID], [DeptID], [CTID], [CTHours]) VALUES (N'C05', N'D04', N'T35', N'4')
GO
INSERT [dbo].[Department] ([DeptID], [DName]) VALUES (N'D01', N'資訊科學系')
INSERT [dbo].[Department] ([DeptID], [DName]) VALUES (N'D02', N'資訊工程系')
INSERT [dbo].[Department] ([DeptID], [DName]) VALUES (N'D03', N'資訊管理系')
INSERT [dbo].[Department] ([DeptID], [DName]) VALUES (N'D04', N'電腦與通訊學系')
GO
INSERT [dbo].[Leave] ([LeaveID], [LName]) VALUES (N'L01', N'事假')
INSERT [dbo].[Leave] ([LeaveID], [LName]) VALUES (N'L02', N'病假')
INSERT [dbo].[Leave] ([LeaveID], [LName]) VALUES (N'L03', N'公假')
INSERT [dbo].[Leave] ([LeaveID], [LName]) VALUES (N'L04', N'婚假')
INSERT [dbo].[Leave] ([LeaveID], [LName]) VALUES (N'L05', N'喪假')
GO
INSERT [dbo].[LeaveDetail] ([LDID], [StuID], [LeaveID], [LDDate], [StartTime], [EndTime]) VALUES (N'202408260001', N'113D01101', N'L01', CAST(N'2024-08-26T15:33:16.113' AS DateTime), CAST(N'2024-08-26T17:33:00.000' AS DateTime), CAST(N'2024-08-26T19:33:00.000' AS DateTime))
INSERT [dbo].[LeaveDetail] ([LDID], [StuID], [LeaveID], [LDDate], [StartTime], [EndTime]) VALUES (N'202408290001', N'113D01101', N'L01', CAST(N'2024-08-29T15:48:59.547' AS DateTime), CAST(N'2024-08-30T15:48:00.000' AS DateTime), CAST(N'2024-08-30T17:52:00.000' AS DateTime))
INSERT [dbo].[LeaveDetail] ([LDID], [StuID], [LeaveID], [LDDate], [StartTime], [EndTime]) VALUES (N'202409060001', N'113D01101', N'L02', CAST(N'2024-09-06T10:14:25.903' AS DateTime), CAST(N'2024-09-09T10:00:00.000' AS DateTime), CAST(N'2024-09-09T11:00:00.000' AS DateTime))
GO
INSERT [dbo].[Login] ([Account], [Password], [Type]) VALUES (N'113D01101', N'04305202    ', 2)
INSERT [dbo].[Login] ([Account], [Password], [Type]) VALUES (N'113D01102', N'04305202    ', 0)
INSERT [dbo].[Login] ([Account], [Password], [Type]) VALUES (N'admin', N'12345678    ', 1)
GO
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408230003', N'113D01102', N'C02', N'D01', N'T22', CAST(N'2024-08-23' AS Date), CAST(N'2024-08-23T16:01:35.177' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408260001', N'113D01101', N'C03', N'D01', N'T32', CAST(N'2024-08-26' AS Date), CAST(N'2024-08-26T08:21:32.087' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408260004', N'113D01101', N'C01', N'D01', N'T12', CAST(N'2024-08-26' AS Date), CAST(N'2024-08-26T09:33:00.057' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408260005', N'113D01101', N'C03', N'D01', N'T11', CAST(N'2024-08-26' AS Date), CAST(N'2024-08-26T09:56:25.050' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408290001', N'113D01101', N'C04', N'D01', N'T27', CAST(N'2024-08-29' AS Date), CAST(N'2024-08-29T14:18:01.363' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202408300001', N'113D01101', N'C01', N'D01', N'T12', CAST(N'2024-08-30' AS Date), CAST(N'2024-08-30T16:31:07.733' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202409050001', N'113D01102', N'C01', N'D01', N'T12', CAST(N'2024-09-05' AS Date), CAST(N'2024-09-05T11:05:01.237' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202409060001', N'113D01101', N'C02', N'D01', N'T22', CAST(N'2024-09-06' AS Date), CAST(N'2024-09-06T10:13:45.803' AS DateTime))
INSERT [dbo].[RollCall] ([RCID], [StuID], [CourseID], [DeptID], [CTID], [RCDate], [ArrivalTime]) VALUES (N'202409060004', N'113D01101', N'C03', N'D01', N'T22', CAST(N'2024-09-06' AS Date), CAST(N'2024-09-06T11:25:08.437' AS DateTime))
GO
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01101', N'C01', N'D01', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01101', N'C02', N'D01', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01101', N'C03', N'D01', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01101', N'C04', N'D01', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01101', N'C05', N'D01', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01102', N'C02', N'D01', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01103', N'C03', N'D01', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01104', N'C04', N'D01', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01105', N'C05', N'D01', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01201', N'C01', N'D01', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01202', N'C02', N'D01', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01203', N'C03', N'D01', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01204', N'C04', N'D01', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D01205', N'C05', N'D01', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02101', N'C01', N'D02', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02102', N'C02', N'D02', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02103', N'C03', N'D02', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02104', N'C04', N'D02', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02105', N'C05', N'D02', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02201', N'C01', N'D02', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02202', N'C02', N'D02', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02203', N'C03', N'D02', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02204', N'C04', N'D02', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D02205', N'C05', N'D02', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03101', N'C01', N'D03', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03102', N'C02', N'D03', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03103', N'C03', N'D03', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03104', N'C04', N'D03', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03105', N'C05', N'D03', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03201', N'C01', N'D03', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03202', N'C02', N'D03', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03203', N'C03', N'D03', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03204', N'C04', N'D03', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D03205', N'C05', N'D03', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04101', N'C01', N'D04', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04102', N'C02', N'D04', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04103', N'C03', N'D04', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04104', N'C04', N'D04', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04105', N'C05', N'D04', N'T35')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04201', N'C01', N'D04', N'T12')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04202', N'C02', N'D04', N'T15')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04203', N'C03', N'D04', N'T22')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04204', N'C04', N'D04', N'T27')
INSERT [dbo].[SelectCourse] ([StuID], [CourseID], [DeptID], [CTID]) VALUES (N'113D04205', N'C05', N'D04', N'T35')
GO
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01101', N'陳耀德', N'1', N'1', N'01', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01102', N'黃萱希', N'1', N'1', N'02', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01103', N'蔡登輝', N'1', N'1', N'03', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01104', N'黃亭音', N'1', N'1', N'04', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01105', N'李定佩', N'1', N'1', N'05', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01201', N'黃怡君', N'1', N'2', N'01', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01202', N'林怡希', N'1', N'2', N'02', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01203', N'宋世柏', N'1', N'2', N'03', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01204', N'陳建宏', N'1', N'2', N'04', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D01205', N'郭佩如', N'1', N'2', N'05', N'D01')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02101', N'賴亞薇', N'1', N'1', N'01', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02102', N'謝詩雅', N'1', N'1', N'02', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02103', N'盧維哲', N'1', N'1', N'03', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02104', N'劉羿山', N'1', N'1', N'04', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02105', N'林佳燕', N'1', N'1', N'05', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02201', N'楊淑真', N'1', N'2', N'01', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02202', N'翁孟璇', N'1', N'2', N'02', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02203', N'柯孟儒', N'1', N'2', N'03', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02204', N'蔡宛蓉', N'1', N'2', N'04', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D02205', N'鄭志鴻', N'1', N'2', N'05', N'D02')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03101', N'陳士哲', N'1', N'1', N'01', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03102', N'陳品信', N'1', N'1', N'02', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03103', N'許淑婷', N'1', N'1', N'03', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03104', N'陳靜怡', N'1', N'1', N'04', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03105', N'蔡怡萱', N'1', N'1', N'05', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03201', N'鐘慧如', N'1', N'2', N'01', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03202', N'林乃文', N'1', N'2', N'02', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03203', N'李姿宣', N'1', N'2', N'03', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03204', N'王筱涵', N'1', N'2', N'04', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D03205', N'陳偉翔', N'1', N'2', N'05', N'D03')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04101', N'張智翔', N'1', N'1', N'01', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04102', N'陳欣怡', N'1', N'1', N'02', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04103', N'馬怡如', N'1', N'1', N'03', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04104', N'黃皓倫', N'1', N'1', N'04', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04105', N'王佳欣', N'1', N'1', N'05', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04201', N'林宜芳', N'1', N'2', N'01', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04202', N'王惠敏', N'1', N'2', N'02', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04203', N'丁子豪', N'1', N'2', N'03', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04204', N'陳彥其', N'1', N'2', N'04', N'D04')
INSERT [dbo].[Student] ([StuID], [SName], [Grade], [Class], [Number], [DeptID]) VALUES (N'113D04205', N'胡雅筑', N'1', N'2', N'05', N'D04')
GO
ALTER TABLE [dbo].[LeaveDetail] ADD  CONSTRAINT [DF_LeaveDetail_LDID]  DEFAULT ([dbo].[getLDID]()) FOR [LDID]
GO
ALTER TABLE [dbo].[RollCall] ADD  CONSTRAINT [DF_RollCall_RCID]  DEFAULT ([dbo].[getRCID]()) FOR [RCID]
GO
ALTER TABLE [dbo].[Curriculum]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Curriculum]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department] ([DeptID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Curriculum]  WITH CHECK ADD FOREIGN KEY([CTID])
REFERENCES [dbo].[ClassTime] ([CTID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LeaveDetail]  WITH CHECK ADD  CONSTRAINT [FK__LeaveDeta__Leave__571DF1D5] FOREIGN KEY([LeaveID])
REFERENCES [dbo].[Leave] ([LeaveID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LeaveDetail] CHECK CONSTRAINT [FK__LeaveDeta__Leave__571DF1D5]
GO
ALTER TABLE [dbo].[LeaveDetail]  WITH CHECK ADD  CONSTRAINT [FK__LeaveDeta__StuID__5629CD9C] FOREIGN KEY([StuID])
REFERENCES [dbo].[Student] ([StuID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LeaveDetail] CHECK CONSTRAINT [FK__LeaveDeta__StuID__5629CD9C]
GO
ALTER TABLE [dbo].[RollCall]  WITH CHECK ADD  CONSTRAINT [FK__RollCall__Course__4BAC3F29] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[RollCall] CHECK CONSTRAINT [FK__RollCall__Course__4BAC3F29]
GO
ALTER TABLE [dbo].[RollCall]  WITH CHECK ADD  CONSTRAINT [FK__RollCall__CTID__4D94879B] FOREIGN KEY([CTID])
REFERENCES [dbo].[ClassTime] ([CTID])
GO
ALTER TABLE [dbo].[RollCall] CHECK CONSTRAINT [FK__RollCall__CTID__4D94879B]
GO
ALTER TABLE [dbo].[RollCall]  WITH CHECK ADD  CONSTRAINT [FK__RollCall__DeptID__4CA06362] FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department] ([DeptID])
GO
ALTER TABLE [dbo].[RollCall] CHECK CONSTRAINT [FK__RollCall__DeptID__4CA06362]
GO
ALTER TABLE [dbo].[RollCall]  WITH CHECK ADD  CONSTRAINT [FK__RollCall__StuID__4AB81AF0] FOREIGN KEY([StuID])
REFERENCES [dbo].[Student] ([StuID])
GO
ALTER TABLE [dbo].[RollCall] CHECK CONSTRAINT [FK__RollCall__StuID__4AB81AF0]
GO
ALTER TABLE [dbo].[SelectCourse]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[SelectCourse]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department] ([DeptID])
GO
ALTER TABLE [dbo].[SelectCourse]  WITH CHECK ADD FOREIGN KEY([StuID])
REFERENCES [dbo].[Student] ([StuID])
GO
ALTER TABLE [dbo].[SelectCourse]  WITH CHECK ADD FOREIGN KEY([CTID])
REFERENCES [dbo].[ClassTime] ([CTID])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([DeptID])
REFERENCES [dbo].[Department] ([DeptID])
ON DELETE CASCADE
GO
USE [master]
GO
ALTER DATABASE [StudentsMS] SET  READ_WRITE 
GO
