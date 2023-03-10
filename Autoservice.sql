USE [master]
GO
/****** Object:  Database [Autoservice]    Script Date: 31/01/2023 20:40:48 ******/
CREATE DATABASE [Autoservice]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Autoservice', FILENAME = N'C:\SQL2019\Data\Autoservice.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Autoservice_log', FILENAME = N'C:\SQL2019\Data\Autoservice_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Autoservice] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Autoservice].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Autoservice] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Autoservice] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Autoservice] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Autoservice] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Autoservice] SET ARITHABORT OFF 
GO
ALTER DATABASE [Autoservice] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Autoservice] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Autoservice] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Autoservice] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Autoservice] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Autoservice] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Autoservice] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Autoservice] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Autoservice] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Autoservice] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Autoservice] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Autoservice] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Autoservice] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Autoservice] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Autoservice] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Autoservice] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Autoservice] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Autoservice] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Autoservice] SET  MULTI_USER 
GO
ALTER DATABASE [Autoservice] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Autoservice] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Autoservice] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Autoservice] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Autoservice] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Autoservice] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Autoservice] SET QUERY_STORE = OFF
GO
USE [Autoservice]
GO
/****** Object:  UserDefinedFunction [dbo].[split]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[split] ( @stringToSplit NVARCHAR(MAX), @char NVarCHAR)

RETURNS
 @returnList TABLE ([value] [nvarchar] (max), num int)
AS
BEGIN

Declare  @r1 TABLE ([value] [nvarchar] (max), num int)

 DECLARE @name NVARCHAR(max)
 DECLARE @pos INT
 declare  @index int = 1

 WHILE CHARINDEX(@char, @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(@char, @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @r1 
  SELECT @name, @index

  set @index = @index  + 1

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @r1
 SELECT @stringToSplit, @index


 insert into @returnList 
 select [Value], num from  @r1 order by num

 RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[uftReadfileAsTable]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[uftReadfileAsTable]
(
@Path VARCHAR(255),
@Filename VARCHAR(100)
)
RETURNS 
@File TABLE
(
[LineNo] int identity(1,1), 
line varchar(8000)) 

AS
BEGIN

DECLARE  @objFileSystem int
        ,@objTextStream int,
		@objErrorObject int,
		@strErrorMessage Varchar(1000),
	    @Command varchar(1000),
	    @hr int,
		@String VARCHAR(8000),
		@YesOrNo INT

select @strErrorMessage='opening the File System Object'
EXECUTE @hr = sp_OACreate  'Scripting.FileSystemObject' , @objFileSystem OUT


if @HR=0 Select @objErrorObject=@objFileSystem, @strErrorMessage='Opening file "'+@path+'\'+@filename+'"',@command=@path+'\'+@filename

if @HR=0 execute @hr = sp_OAMethod   @objFileSystem  , 'OpenTextFile'
	, @objTextStream OUT, @command,1,false,0--for reading, FormatASCII

WHILE @hr=0
	BEGIN
	if @HR=0 Select @objErrorObject=@objTextStream, 
		@strErrorMessage='finding out if there is more to read in "'+@filename+'"'
	if @HR=0 execute @hr = sp_OAGetProperty @objTextStream, 'AtEndOfStream', @YesOrNo OUTPUT

	IF @YesOrNo<>0  break
	if @HR=0 Select @objErrorObject=@objTextStream, 
		@strErrorMessage='reading from the output file "'+@filename+'"'
	if @HR=0 execute @hr = sp_OAMethod  @objTextStream, 'Readline', @String OUTPUT
	INSERT INTO @file(line) SELECT @String
	END

if @HR=0 Select @objErrorObject=@objTextStream, 
	@strErrorMessage='closing the output file "'+@filename+'"'
if @HR=0 execute @hr = sp_OAMethod  @objTextStream, 'Close'


if @hr<>0
	begin
	Declare 
		@Source varchar(255),
		@Description Varchar(255),
		@Helpfile Varchar(255),
		@HelpID int
	
	EXECUTE sp_OAGetErrorInfo  @objErrorObject, 
		@source output,@Description output,@Helpfile output,@HelpID output
	Select @strErrorMessage='Error whilst '
			+coalesce(@strErrorMessage,'doing something')
			+', '+coalesce(@Description,'')
	insert into @File(line) select @strErrorMessage
	end
EXECUTE  sp_OADestroy @objTextStream
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END
GO
/****** Object:  Table [dbo].[Аналог]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Аналог](
	[НомерДетали] [int] NOT NULL,
	[НомерАналога] [int] NOT NULL,
 CONSTRAINT [PK__Аналог__6474646213D9F6D1] PRIMARY KEY CLUSTERED 
(
	[НомерДетали] ASC,
	[НомерАналога] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[День]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[День](
	[Дата] [date] NOT NULL,
	[ЧасыРаботы] [nchar](50) NOT NULL,
 CONSTRAINT [PK__День__838AAF46C6BBDD84] PRIMARY KEY CLUSTERED 
(
	[Дата] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Деталь]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Деталь](
	[Номер] [int] NOT NULL,
	[Производитель] [varchar](50) NULL,
	[Серийный номер] [varchar](50) NULL,
	[Описание] [varchar](50) NOT NULL,
	[Количество] [int] NOT NULL,
	[ЕдИзм] [varchar](5) NOT NULL,
	[Стоимость] [money] NULL,
 CONSTRAINT [PK__Деталь__063C4BF6D32A3BC1] PRIMARY KEY CLUSTERED 
(
	[Номер] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ЗаказНаряд]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ЗаказНаряд](
	[Номер] [int] NOT NULL,
	[Механик] [varchar](50) NOT NULL,
	[WINномер] [varchar](50) NOT NULL,
	[СостояниеЗаказа] [varchar](50) NOT NULL,
	[Стоимость] [money] NOT NULL,
	[ДатаОформления] [date] NOT NULL,
	[ДатаОкончания] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Номер] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Запись]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Запись](
	[idЗаписи] [int] NOT NULL,
	[ФИОклиент] [varchar](50) NOT NULL,
	[Дата] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idЗаписи] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Клиент]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Клиент](
	[ФИО] [varchar](50) NOT NULL,
	[ДатаРождения] [date] NOT NULL,
	[Пол] [char](1) NULL,
	[Телефон] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ФИО] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Работник]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Работник](
	[ФИО] [varchar](50) NOT NULL,
	[ДатаРождения] [date] NULL,
	[Должность] [varchar](50) NOT NULL,
	[Зарплата] [money] NULL,
	[Стаж] [int] NOT NULL,
	[Телефон] [bigint] NULL,
	[Логин] [varchar](10) NOT NULL,
	[Пароль] [varchar](10) NOT NULL,
 CONSTRAINT [PK__Работник__A9F75A153731B43E] PRIMARY KEY CLUSTERED 
(
	[ФИО] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Расход]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Расход](
	[НомерДетали] [int] NOT NULL,
	[НомерНаряда] [int] NOT NULL,
	[Количество] [int] NOT NULL,
	[ЕдИзм] [varchar](5) NOT NULL,
 CONSTRAINT [PK_Расход] PRIMARY KEY CLUSTERED 
(
	[НомерДетали] ASC,
	[НомерНаряда] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Смена]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Смена](
	[ФИОраб] [varchar](50) NOT NULL,
	[ДатаСмены] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ФИОраб] ASC,
	[ДатаСмены] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ТранспортноеСредство]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ТранспортноеСредство](
	[WINномер] [varchar](50) NOT NULL,
	[ФИОдиагност] [varchar](50) NOT NULL,
	[ФИОклиента] [varchar](50) NOT NULL,
	[Марка] [varchar](50) NULL,
	[Модель] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[WINномер] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Услуга]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Услуга](
	[Название] [varchar](50) NOT NULL,
	[Описание] [varchar](50) NOT NULL,
	[Стоимость] [money] NOT NULL,
 CONSTRAINT [PK_Услуга] PRIMARY KEY CLUSTERED 
(
	[Название] ASC,
	[Описание] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[УслугиЗН]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[УслугиЗН](
	[НомерНаряда] [int] NOT NULL,
	[НазваниеУслуги] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[НомерНаряда] ASC,
	[НазваниеУслуги] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (2, 3)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (2, 5)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (3, 3)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (3, 5)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (4, 3)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (4, 5)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (5, 3)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (5, 5)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (6, 3)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (6, 5)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (7, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (7, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (7, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (7, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (8, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (8, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (8, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (8, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (9, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (9, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (9, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (9, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (10, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (10, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (10, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (10, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (11, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (11, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (11, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (11, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (12, 7)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (12, 9)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (12, 10)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (12, 11)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (13, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (13, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (13, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (14, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (14, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (14, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (15, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (15, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (15, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (16, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (16, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (16, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (17, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (17, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (17, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (18, 13)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (18, 15)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (18, 17)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (19, 19)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (19, 20)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (20, 19)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (20, 20)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (21, 19)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (21, 20)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (22, 22)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (22, 24)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (23, 22)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (23, 24)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (24, 22)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (24, 24)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (25, 26)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (25, 28)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (26, 26)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (26, 28)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (27, 26)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (27, 28)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (28, 26)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (28, 28)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (30, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (30, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (30, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (31, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (31, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (31, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (32, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (32, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (32, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (33, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (33, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (33, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (34, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (34, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (34, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (35, 31)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (35, 33)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (35, 35)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (36, 37)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (36, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (36, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (37, 37)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (37, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (37, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (38, 37)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (38, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (38, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (39, 37)
GO
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (39, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (39, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (40, 37)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (40, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (40, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (41, 37)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (41, 39)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (41, 40)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (42, 42)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (42, 44)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (43, 42)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (43, 44)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (44, 42)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (44, 44)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (45, 42)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (45, 44)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (46, 46)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (46, 48)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (47, 46)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (47, 48)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (48, 46)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (48, 48)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (49, 46)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (49, 48)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (51, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (51, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (51, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (51, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (51, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (52, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (52, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (52, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (52, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (52, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (53, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (53, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (53, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (53, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (53, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (54, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (54, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (54, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (54, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (54, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (55, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (55, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (55, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (55, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (55, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (56, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (56, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (56, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (56, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (56, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (57, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (57, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (57, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (57, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (57, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (58, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (58, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (58, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (58, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (58, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (59, 51)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (59, 53)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (59, 55)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (59, 57)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (59, 59)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (60, 60)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (61, 60)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (62, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (62, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (62, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (62, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (62, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (63, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (63, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (63, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (63, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (63, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (64, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (64, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (64, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (64, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (64, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (65, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (65, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (65, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (65, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (65, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (66, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (66, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (66, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (66, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (66, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (67, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (67, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (67, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (67, 68)
GO
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (67, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (68, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (68, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (68, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (68, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (68, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (69, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (69, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (69, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (69, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (69, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (70, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (70, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (70, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (70, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (70, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (71, 62)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (71, 64)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (71, 66)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (71, 68)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (71, 71)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (72, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (72, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (72, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (72, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (72, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (73, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (73, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (73, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (73, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (73, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (74, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (74, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (74, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (74, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (74, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (75, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (75, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (75, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (75, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (75, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (76, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (76, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (76, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (76, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (76, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (77, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (77, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (77, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (77, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (77, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (78, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (78, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (78, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (78, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (78, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (79, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (79, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (79, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (79, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (79, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (80, 73)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (80, 75)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (80, 77)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (80, 79)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (80, 80)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (81, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (81, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (81, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (81, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (82, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (82, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (82, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (82, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (83, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (83, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (83, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (83, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (84, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (84, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (84, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (84, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (85, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (85, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (85, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (85, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (86, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (86, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (86, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (86, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (87, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (87, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (87, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (87, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (88, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (88, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (88, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (88, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (89, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (89, 84)
GO
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (89, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (89, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (90, 82)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (90, 84)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (90, 86)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (90, 88)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (91, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (91, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (91, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (91, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (91, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (92, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (92, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (92, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (92, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (92, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (93, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (93, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (93, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (93, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (93, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (94, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (94, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (94, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (94, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (94, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (95, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (95, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (95, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (95, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (95, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (96, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (96, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (96, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (96, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (96, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (97, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (97, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (97, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (97, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (97, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (98, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (98, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (98, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (98, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (98, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (99, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (99, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (99, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (99, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (99, 99)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (100, 91)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (100, 93)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (100, 95)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (100, 97)
INSERT [dbo].[Аналог] ([НомерДетали], [НомерАналога]) VALUES (100, 99)
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-01-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-02-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-03-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-04-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-10' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-05-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-06-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-07-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-18' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-08-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-09-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-10-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-26' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-11-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2020-12-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-01-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-02-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-02-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-02-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2021-02-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-10-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-10-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-10-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-11-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-07' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2022-12-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-01-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-02-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-17' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-03-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-04-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-05-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-25' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-06-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-07-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-08-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-09-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-03' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-10' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-11' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-12' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-13' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-14' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-15' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-16' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-17' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-18' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-19' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-20' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-21' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-22' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-23' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-24' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-25' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-26' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-27' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-28' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-29' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-30' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-10-31' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-01' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-02' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-03' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-04' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-05' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-06' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-07' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-08' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-09' AS Date), N'8:00-20:00                                        ')
INSERT [dbo].[День] ([Дата], [ЧасыРаботы]) VALUES (CAST(N'2023-11-10' AS Date), N'8:00-20:00                                        ')
GO
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (2, N'HENGST-FILTER', N'H97W06', N'Масляный фильтр', 0, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (3, N'MANN-FILTER', N'W-7023', N'Масляный фильтр', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (4, N'BOSCH', N'F-026-407-142', N'Масляный фильтр', 16, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (5, N'KNECHT/MAHLE', N'OC-1566', N'Масляный фильтр', 8, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (6, N'PURFLUX', N'LS301', N'Масляный фильтр', 14, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (7, N'KNECHT/MAHLE', N'LX-4567', N'Воздушный фильтр', 14, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (8, N'MANN-FILTER', N'C-24-054', N'Воздушный фильтр', 20, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (9, N'HENGST-FILTER', N'E1533L', N'Воздушный фильтр', 9, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (10, N'HERTH+BUSS-JAKOPARTS', N'J1320563', N'Воздушный фильтр', 19, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (11, N'MEYLE', N'37-12-321-0037', N'Воздушный фильтр', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (12, N'AMC-Filter', N'HA-744', N'Воздушный фильтр', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (13, N'KNECHT/MAHLE', N'LA-1526', N'Фильтр, воздух во внутренном пространстве', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (14, N'MANN-FILTER', N'CU-24-013', N'Фильтр, воздух во внутренном пространстве', 17, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (15, N'MANN-FILTER', N'CUK-24-013', N'Фильтр, воздух во внутренном пространстве', 25, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (16, N'BOSCH', N'1-987-435-097', N'Фильтр, воздух во внутренном пространстве', 21, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (17, N'PURFLUX', N'AH537', N'Фильтр, воздух во внутренном пространстве', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (18, N'HERTH+BUSS-JAKOPARTS', N'J1340519', N'Фильтр, воздух во внутренном пространстве', 19, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (19, N'ATE', N'13.0460-5650.2', N'Комплект тормозных колодок, дисковый тормоз', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (20, N'HELLA', N'8DB-355-037-881', N'Комплект тормозных колодок, дисковый тормоз', 12, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (21, N'HELLA', N'8DB-355-037-891', N'Комплект тормозных колодок, дисковый тормоз', 9, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (22, N'HELLA', N'8DD-355-126-431', N'Тормозной диск', 23, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (23, N'HELLA', N'8DD-355-126-501', N'Тормозной диск', 9, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (24, N'HELLA', N'8DD-355-126-541', N'Тормозной диск', 13, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (25, N'HELLA', N'9XW-178-878', N'Щетка стеклоочистителя', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (26, N'HELLA', N'9XW-358-053', N'Щетка стеклоочистителя', 20, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (27, N'HELLA', N'9XW-358-053', N'Щетка стеклоочистителя', 19, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (28, N'HELLA', N'9XW-358-061', N'Щетка стеклоочистителя', 12, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (29, N'BOSCH', N'0-242-145-510', N'Свеча зажигания', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (30, N'AL-KO', N'214263', N'Амортизатор', 205, N'Штука', 3000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (31, N'AL-KO', N'313044', N'Амортизатор', 100, N'Штука', 1100.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (32, N'AL-KO', N'313045', N'Амортизатор', 99, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (33, N'MANDO', N'EX54651G3NA0', N'Амортизатор', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (34, N'MANDO', N'EX54661G3NA0', N'Амортизатор', 20, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (35, N'MANDO', N'EX55310G3EA0', N'Амортизатор', 12, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (36, N'MOTUL', N'17010', N'Моторное масло', 0, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (37, N'LIQUI-MOLY', N'P000314', N'Моторное масло', 11, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (38, N'LIQUI-MOLY', N'P000329', N'Моторное масло', 24, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (39, N'LIQUI-MOLY', N'P003545', N'Моторное масло', 12, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (40, N'LIQUI-MOLY', N'P003590', N'Моторное масло', 18, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (41, N'LIQUI-MOLY', N'P003750', N'Моторное масло', 15, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (42, N'ATE', N'24.0110-0398.1', N'Тормозной диск', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (43, N'ATE', N'24.0122-0313.1', N'Тормозной диск', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (44, N'HELLA', N'8DD-355-117-981', N'Тормозной диск', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (45, N'HELLA', N'8DD-355-118-501', N'Тормозной диск', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (46, N'BOSCH', N'0-242-129-515', N'Свеча зажигания', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (47, N'NGK', N'1578', N'Свеча зажигания', 22, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (48, N'NGK', N'91450', N'Свеча зажигания', 25, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (49, N'HELLA', N'8EH-188-705-291', N'Свеча зажигания', 21, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (50, N'ARDECA-LUBRICANTS', N'P81011-ARD', N'Антифриз', 7, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (51, N'ARDECA-LUBRICANTS', N'P81031-ARD', N'Антифриз', 18, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (52, N'CHAMPION-LUBRICANTS', N'50001', N'Антифриз', 12, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (53, N'CHAMPION-LUBRICANTS', N'50101', N'Антифриз', 25, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (54, N'DYNAMAX-COOL-ULTRA', N'G12', N'Антифриз', 11, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (55, N'DYNAMAX-COOL-ULTRA', N'12-READY-37', N'Антифриз', 18, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (56, N'EUROL', N'E504140', N'Антифриз', 9, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (57, N'EUROL', N'E504144', N'Антифриз', 15, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (58, N'ISOTECH', N'LP9248', N'Антифриз', 22, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (59, N'ISOTECH', N'LP0017', N'Антифриз', 11, N'Литр', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (60, N'ET-ENGINETEAM', N'HK0190', N'Коленчатый вал', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (61, N'IPSA', N'CK008700', N'Коленчатый вал', 13, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (62, N'ZZVF', N'ZV2791HY', N'Вентилятор салона', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (63, N'VEMO/VAICO', N'V53-03-0008', N'Вентилятор салона', 13, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (64, N'VEMO/VAICO', N'V52-79-0012-1', N'Вентилятор салона', 15, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (65, N'VEMO/VAICO', N'V52-79-0013', N'Вентилятор салона', 14, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (66, N'VEMO/VAICO', N'V52-79-0012', N'Вентилятор салона', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (67, N'MEAT&DORIA', N'K109187', N'Вентилятор салона', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (68, N'OSSCA', N'22320', N'Вентилятор салона', 10, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (69, N'AKS-DASIS', N'568125N', N'Вентилятор салона', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (70, N'CASCO', N'CRS78036GS', N'Вентилятор салона', 19, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (71, N'CASCO', N'CRS78018GS', N'Вентилятор салона', 14, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (72, N'KNECHT/MAHLE', N'ACP1177000P', N'Компрессор кондиционера', 17, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (73, N'HELLA', N'8FK351-272-111', N'Компрессор кондиционера', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (74, N'NISSENS', N'89533', N'Компрессор кондиционера', 25, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (75, N'NISSENS', N'890621', N'Компрессор кондиционера', 20, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (76, N'OSSCA', N'46804', N'Компрессор кондиционера', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (77, N'ACR', N'134430', N'Компрессор кондиционера', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (78, N'AIRSTAL', N'10-3837', N'Компрессор кондиционера', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (79, N'AKS-DASIS', N'852668N', N'Компрессор кондиционера', 9, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (80, N'ALANKO', N'10553730', N'Компрессор кондиционера', 25, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (81, N'KAYABA', N'RG1000', N'Пружина ходовой части', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (82, N'KAYABA', N'RG1001', N'Пружина ходовой части', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (83, N'KAYABA', N'RG5002', N'Пружина ходовой части', 13, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (84, N'KILEN', N'14870', N'Пружина ходовой части', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (85, N'KILEN', N'14869', N'Пружина ходовой части', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (86, N'KILEN', N'54846', N'Пружина ходовой части', 15, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (87, N'KILEN', N'54847', N'Пружина ходовой части', 24, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (88, N'GKN-SPIDAN', N'88122', N'Пружина ходовой части', 16, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (89, N'GKN-SPIDAN', N'88120', N'Пружина ходовой части', 17, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (90, N'GKN-SPIDAN', N'88123', N'Пружина ходовой части', 22, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (91, N'VALEO', N'600206', N'Стартер', 18, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (92, N'VALEO', N'455964', N'Стартер', 9, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (93, N'VALEO', N'600258', N'Стартер', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (94, N'VALEO', N'600084', N'Стартер', 20, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (95, N'TRW', N'LRS02571', N'Стартер', 8, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (96, N'BOSCH', N'0986025720', N'Стартер', 7, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (97, N'BOSCH', N'0986UR1808', N'Стартер', 11, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (98, N'MANDO', N'EX361002B600', N'Стартер', 10, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (99, N'MANDO', N'EX3610003601', N'Стартер', 19, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (100, N'MANDO', N'BN361002B500', N'Стартер', 22, N'Штука', 1000.0000)
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (101, N'Bosch', N'123', N'Масло', 10, N'Литр', 100.0000)
GO
INSERT [dbo].[Деталь] ([Номер], [Производитель], [Серийный номер], [Описание], [Количество], [ЕдИзм], [Стоимость]) VALUES (102, N'Bost', N'8765', N'Резинка', 10, N'Штука', 100.0000)
GO
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (1, N'Вихров Бехруз Герасимович', N'2HMBF12F0N0016245', N'В процесссе', 10000.0000, CAST(N'2020-02-07' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (2, N'Залупкин Валентин Асафьевич', N'2HMBF32F4NB073208', N'Завершён', 15000.0000, CAST(N'2020-02-08' AS Date), CAST(N'2020-02-22' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (3, N'Пупкин Венцеслав Зигмундович', N'5NMSG13D47HD05166', N'Создан', 2500.0000, CAST(N'2020-02-09' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (4, N'Пикаев Вильгельм Периклович', N'5NMSG13E27H102248', N'В процесссе', 10000.0000, CAST(N'2020-02-10' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (5, N'Агапов Владимир Сергеевич', N'5NMSG4AG1AH358958', N'Завершён', 15000.0000, CAST(N'2020-02-11' AS Date), CAST(N'2020-02-25' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (6, N'Мирзалиев Вальдемар Агниеевич', N'5NMSGCAB0A0019427', N'Создан', 2500.0000, CAST(N'2020-02-12' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (7, N'Вихров Бехруз Герасимович', N'5NMSH13E29H320884', N'В процесссе', 10000.0000, CAST(N'2020-02-13' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (8, N'Минаев Бехруз Зигмундович', N'5NMSH13EX8Y151227', N'Завершён', 15000.0000, CAST(N'2020-02-14' AS Date), CAST(N'2020-02-28' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (9, N'Минаев Бехруз Зигмундович', N'5NMSH4AG6AH339478', N'Создан', 2500.0000, CAST(N'2020-02-15' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (10, N'Вихров Бехруз Герасимович', N'5NMSHDDG0A0017736', N'В процесссе', 10000.0000, CAST(N'2020-02-16' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (11, N'Вихров Бехруз Герасимович', N'5NPE24AF0GH338926', N'Завершён', 15000.0000, CAST(N'2020-02-17' AS Date), CAST(N'2020-03-02' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (12, N'Мирзалиев Вальдемар Агниеевич', N'5NPEB4AC0B1106821', N'Создан', 2500.0000, CAST(N'2020-02-18' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (13, N'Пупкин Венцеслав Зигмундович', N'5NPEB4AC1D1234567', N'В процесссе', 10000.0000, CAST(N'2020-02-19' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (14, N'Жмышенко Валерий Альбертович', N'5NPEBUAC3CH481966', N'Завершён', 15000.0000, CAST(N'2020-02-20' AS Date), CAST(N'2020-03-05' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (15, N'Сергеев Афанасий Денисович', N'5NPEC4AC9C9CH4357', N'Создан', 2500.0000, CAST(N'2020-02-21' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (16, N'Минаев Бехруз Зигмундович', N'5NPEC4AC9CH403303', N'В процесссе', 10000.0000, CAST(N'2020-02-22' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (17, N'Залупкин Валентин Асафьевич', N'5NPET46C56H085211', N'Завершён', 15000.0000, CAST(N'2020-02-23' AS Date), CAST(N'2020-03-08' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (18, N'Мирзалиев Вальдемар Агниеевич', N'5NPET46FX8H402946', N'Создан', 2500.0000, CAST(N'2020-02-24' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (19, N'Вихров Бехруз Герасимович', N'5NPEU46C568128006', N'В процесссе', 10000.0000, CAST(N'2020-02-25' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (20, N'Пупкин Венцеслав Зигмундович', N'5NPEU46C76H059559', N'Завершён', 15000.0000, CAST(N'2020-02-26' AS Date), CAST(N'2020-03-11' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (21, N'Вихров Бехруз Герасимович', N'5NPEU46FX98430308', N'Создан', 2500.0000, CAST(N'2020-02-27' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (22, N'Роганов Валентино Денисович', N'5NPEU4AC1AH588764', N'В процесссе', 10000.0000, CAST(N'2020-02-28' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (23, N'Пикаев Вильгельм Периклович', N'5NPEU4BF0A0013823', N'Завершён', 15000.0000, CAST(N'2020-02-29' AS Date), CAST(N'2020-03-14' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (24, N'Сергеев Афанасий Денисович', N'5NPSJ13E070010686', N'Создан', 2500.0000, CAST(N'2020-03-01' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (25, N'Мирзалиев Вальдемар Агниеевич', N'5XYZG4AG3CG119018', N'В процесссе', 10000.0000, CAST(N'2020-03-02' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (26, N'Мошенин Вангьял Денисович', N'5XYZT3CB8EG146063', N'Завершён', 15000.0000, CAST(N'2020-03-03' AS Date), CAST(N'2020-03-17' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (27, N'Мирзалиев Вальдемар Агниеевич', N'5XYZU3LB6DGQ57359', N'Создан', 2500.0000, CAST(N'2020-03-04' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (28, N'Жмышенко Валерий Альбертович', N'5XYZUDLA0FG248761', N'В процесссе', 10000.0000, CAST(N'2020-03-05' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (29, N'Сергеев Афанасий Денисович', N'5XYZUDLB8HG417999', N'Завершён', 15000.0000, CAST(N'2020-03-06' AS Date), CAST(N'2020-03-20' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (30, N'Вихров Бехруз Герасимович', N'5XYZWDLA1DG100710', N'Создан', 2500.0000, CAST(N'2020-03-07' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (31, N'Залупкин Валентин Асафьевич', N'5XYZWDLA7EG152263', N'В процесссе', 10000.0000, CAST(N'2020-03-08' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (32, N'Вихров Бехруз Герасимович', N'KM8J33A48GU205711', N'Завершён', 15000.0000, CAST(N'2020-03-09' AS Date), CAST(N'2020-03-23' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (33, N'Мирзалиев Вальдемар Агниеевич', N'KM8JM12B18U909944', N'Создан', 2500.0000, CAST(N'2020-03-10' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (34, N'Агапов Владимир Сергеевич', N'KM8JM12B47U625366', N'Завершён', 10000.0000, CAST(N'2020-03-11' AS Date), CAST(N'2022-10-19' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (35, N'Агапов Владимир Сергеевич', N'KM8JM12D75U093366', N'Завершён', 15000.0000, CAST(N'2020-03-12' AS Date), CAST(N'2020-03-26' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (36, N'Мирзалиев Вальдемар Агниеевич', N'KM8JM72D95U050618', N'Создан', 2500.0000, CAST(N'2020-03-13' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (37, N'Минаев Бехруз Зигмундович', N'KM8JN72D16U329737', N'В процесссе', 10000.0000, CAST(N'2020-03-14' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (38, N'Агапов Владимир Сергеевич', N'KM8JT3AB2CU404259', N'Завершён', 15000.0000, CAST(N'2020-03-15' AS Date), CAST(N'2020-03-29' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (39, N'Роганов Валентино Денисович', N'KM8JT3AC9BU217088', N'Создан', 2500.0000, CAST(N'2020-03-16' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (40, N'Залупкин Валентин Асафьевич', N'KM8JTCDC0A0011241', N'В процесссе', 10000.0000, CAST(N'2020-03-17' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (41, N'Вихров Бехруз Герасимович', N'KM8JU3AC5DU399999', N'Завершён', 15000.0000, CAST(N'2020-03-18' AS Date), CAST(N'2020-04-01' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (42, N'Мирзалиев Вальдемар Агниеевич', N'KM8JU3AC8DU611522', N'Создан', 2500.0000, CAST(N'2020-03-19' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (43, N'Вихров Бехруз Герасимович', N'KM8JU3AG7FU954182', N'В процесссе', 10000.0000, CAST(N'2020-03-20' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (44, N'Мошенин Вангьял Денисович', N'KM8JU3AG8FU115447', N'Завершён', 15000.0000, CAST(N'2020-03-21' AS Date), CAST(N'2020-04-04' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (45, N'Вихров Бехруз Герасимович', N'KM8NU4CC2B4143532', N'Создан', 2500.0000, CAST(N'2020-03-22' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (46, N'Пупкин Венцеслав Зигмундович', N'KM8NU4CC3CUA98427', N'В процесссе', 10000.0000, CAST(N'2020-03-23' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (47, N'Жмышенко Валерий Альбертович', N'KM8NU73C89U081484', N'Завершён', 15000.0000, CAST(N'2020-03-24' AS Date), CAST(N'2020-04-07' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (48, N'Сергеев Афанасий Денисович', N'KM8NU73C974015488', N'Создан', 2500.0000, CAST(N'2020-03-25' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (49, N'Мирзалиев Вальдемар Агниеевич', N'KM8SB73D06U039470', N'В процесссе', 10000.0000, CAST(N'2020-03-26' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (50, N'Пупкин Венцеслав Зигмундович', N'KM8SB73E06U086362', N'Завершён', 15000.0000, CAST(N'2020-03-27' AS Date), CAST(N'2020-04-10' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (51, N'Вихров Бехруз Герасимович', N'KM8SC12B42U136420', N'Создан', 2500.0000, CAST(N'2020-03-28' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (52, N'Вихров Бехруз Герасимович', N'KM8SC13D764047866', N'В процесссе', 10000.0000, CAST(N'2020-03-29' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (53, N'Роганов Валентино Денисович', N'KM8SC13E234549432', N'Завершён', 15000.0000, CAST(N'2020-03-30' AS Date), CAST(N'2020-04-13' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (54, N'Сергеев Афанасий Денисович', N'KM8SC73D25U872179', N'Создан', 2500.0000, CAST(N'2020-03-31' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (55, N'Вихров Бехруз Герасимович', N'KM8SC73D73M560064', N'В процесссе', 10000.0000, CAST(N'2020-04-01' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (56, N'Пикаев Вильгельм Периклович', N'KM8SC73D82U137248', N'Завершён', 15000.0000, CAST(N'2020-04-02' AS Date), CAST(N'2020-04-16' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (57, N'Жмышенко Валерий Альбертович', N'KM8SC73E15U984562', N'Создан', 2500.0000, CAST(N'2020-04-03' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (58, N'Жмышенко Валерий Альбертович', N'KM8SC83D71U132417', N'В процесссе', 10000.0000, CAST(N'2020-04-04' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (59, N'Сергеев Афанасий Денисович', N'KM8SG13D27U108692', N'Завершён', 15000.0000, CAST(N'2020-04-05' AS Date), CAST(N'2020-04-19' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (60, N'Залупкин Валентин Асафьевич', N'KM8SG73D67U131959', N'Создан', 2500.0000, CAST(N'2020-04-06' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (61, N'Пикаев Вильгельм Периклович', N'KM8SH73E070018523', N'В процесссе', 10000.0000, CAST(N'2020-04-07' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (62, N'Вихров Бехруз Герасимович', N'KM8SM4HF4GU149152', N'Завершён', 15000.0000, CAST(N'2020-04-08' AS Date), CAST(N'2020-04-22' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (63, N'Пикаев Вильгельм Периклович', N'KM8SR4HF8GU163234', N'Создан', 2500.0000, CAST(N'2020-04-09' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (64, N'Роганов Валентино Денисович', N'KMHBT31G38U189577', N'В процесссе', 10000.0000, CAST(N'2020-04-10' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (65, N'Вихров Бехруз Герасимович', N'KMHCF21F5SU364562', N'Завершён', 15000.0000, CAST(N'2020-04-11' AS Date), CAST(N'2020-04-25' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (66, N'Вихров Бехруз Герасимович', N'KMHCF24F4TU643403', N'Создан', 2500.0000, CAST(N'2020-04-12' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (67, N'Вихров Бехруз Герасимович', N'KMHCF24T2SU378498', N'В процесссе', 10000.0000, CAST(N'2020-04-13' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (68, N'Пупкин Венцеслав Зигмундович', N'KMHCF24T4SU413431', N'Завершён', 15000.0000, CAST(N'2020-04-14' AS Date), CAST(N'2020-04-28' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (69, N'Агапов Владимир Сергеевич', N'KMHCF24T6TU555569', N'Завершён', 2500.0000, CAST(N'2020-04-15' AS Date), CAST(N'2022-10-20' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (70, N'Жмышенко Валерий Альбертович', N'KMHCF31T2SU125837', N'В процесссе', 10000.0000, CAST(N'2020-04-16' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (71, N'Пупкин Венцеслав Зигмундович', N'KMHCF34T2WU915995', N'Завершён', 15000.0000, CAST(N'2020-04-17' AS Date), CAST(N'2020-05-01' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (72, N'Вихров Бехруз Герасимович', N'KMHCF35G71U069373', N'Создан', 2500.0000, CAST(N'2020-04-18' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (73, N'Вихров Бехруз Герасимович', N'KMHCF35G72U197646', N'В процесссе', 10000.0000, CAST(N'2020-04-19' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (74, N'Вихров Бехруз Герасимович', N'KMHCF45G15U584428', N'Завершён', 15000.0000, CAST(N'2020-04-20' AS Date), CAST(N'2020-05-04' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (75, N'Вихров Бехруз Герасимович', N'KMHCG35C21U088925', N'Создан', 2500.0000, CAST(N'2020-04-21' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (76, N'Вихров Бехруз Герасимович', N'KMHCG35C914144987', N'В процесссе', 10000.0000, CAST(N'2020-04-22' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (77, N'Мирзалиев Вальдемар Агниеевич', N'KMHCG45C444539587', N'Завершён', 15000.0000, CAST(N'2020-04-23' AS Date), CAST(N'2020-05-07' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (78, N'Мирзалиев Вальдемар Агниеевич', N'KMHCG45C92U299742', N'Создан', 2500.0000, CAST(N'2020-04-24' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (79, N'Вихров Бехруз Герасимович', N'KMHCG45LX1U190687', N'В процесссе', 10000.0000, CAST(N'2020-04-25' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (80, N'Вихров Бехруз Герасимович', N'KMHCH41C85U635775', N'Завершён', 15000.0000, CAST(N'2020-04-26' AS Date), CAST(N'2020-05-10' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (81, N'Мошенин Вангьял Денисович', N'KMHCM36C08U077357', N'Создан', 2500.0000, CAST(N'2020-04-27' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (82, N'Роганов Валентино Денисович', N'KMHCM36C08U104055', N'В процесссе', 10000.0000, CAST(N'2020-04-28' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (83, N'Пикаев Вильгельм Периклович', N'KMHCM3BC1BU198072', N'Завершён', 15000.0000, CAST(N'2020-04-29' AS Date), CAST(N'2020-05-13' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (84, N'Жмышенко Валерий Альбертович', N'KMHCM41C56U073802', N'Создан', 2500.0000, CAST(N'2020-04-30' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (85, N'Роганов Валентино Денисович', N'KMHCM46C07U067819', N'В процесссе', 10000.0000, CAST(N'2020-05-01' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (86, N'Вихров Бехруз Герасимович', N'KMHCN35C074008777', N'Завершён', 15000.0000, CAST(N'2020-05-02' AS Date), CAST(N'2020-05-16' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (87, N'Вихров Бехруз Герасимович', N'KMHCN45C86U034709', N'Создан', 2500.0000, CAST(N'2020-05-03' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (88, N'Минаев Бехруз Зигмундович', N'KMHCT4AE3CU167404', N'В процесссе', 10000.0000, CAST(N'2020-05-04' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (89, N'Вихров Бехруз Герасимович', N'KMHCT4AE8CU046657', N'Завершён', 15000.0000, CAST(N'2020-05-05' AS Date), CAST(N'2020-05-19' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (90, N'Вихров Бехруз Герасимович', N'KMHCT6AE2EU193135', N'Создан', 2500.0000, CAST(N'2020-05-06' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (91, N'Вихров Бехруз Герасимович', N'KMHDC8AE0BH045134', N'В процесссе', 10000.0000, CAST(N'2020-05-07' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (92, N'Вихров Бехруз Герасимович', N'KMHDH4AE3BU080168', N'Завершён', 15000.0000, CAST(N'2020-05-08' AS Date), CAST(N'2020-05-22' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (93, N'Мошенин Вангьял Денисович', N'KMHDH4AE7FU301308', N'Создан', 2500.0000, CAST(N'2020-05-09' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (95, N'Мошенин Вангьял Денисович', N'KMHDM41D16U348725', N'Завершён', 15000.0000, CAST(N'2020-05-11' AS Date), CAST(N'2020-05-25' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (96, N'Жмышенко Валерий Альбертович', N'KMHDM41D66U159844', N'Создан', 2500.0000, CAST(N'2020-05-12' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (97, N'Пикаев Вильгельм Периклович', N'KMHDM45D72U388182', N'В процесссе', 10000.0000, CAST(N'2020-05-13' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (98, N'Сергеев Афанасий Денисович', N'KMHDM46D44U735601', N'Завершён', 15000.0000, CAST(N'2020-05-14' AS Date), CAST(N'2020-05-28' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (99, N'Агапов Владимир Сергеевич', N'KMHDM55D72U048875', N'Создан', 21879.0000, CAST(N'2020-05-15' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (100, N'Вихров Бехруз Герасимович', N'KMHDN45D03U661719', N'В процесссе', 10000.0000, CAST(N'2020-05-16' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (101, N'Пикаев Вильгельм Периклович', N'KMHDN45D9YU000195', N'Завершён', 15000.0000, CAST(N'2020-05-17' AS Date), CAST(N'2020-05-31' AS Date))
GO
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (102, N'Пикаев Вильгельм Периклович', N'KMHDN55D734101489', N'Создан', 2500.0000, CAST(N'2020-05-18' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (103, N'Мошенин Вангьял Денисович', N'KMHDT41D08U238724', N'В процесссе', 10000.0000, CAST(N'2020-05-19' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (104, N'Залупкин Валентин Асафьевич', N'KMHDT45D08U284855', N'Завершён', 15000.0000, CAST(N'2020-05-20' AS Date), CAST(N'2020-06-03' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (105, N'Залупкин Валентин Асафьевич', N'KMHDU45D77U034766', N'Создан', 2500.0000, CAST(N'2020-05-21' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (106, N'Вихров Бехруз Герасимович', N'KMHDU4AD4AU955646', N'В процесссе', 10000.0000, CAST(N'2020-05-22' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (107, N'Роганов Валентино Денисович', N'KMHDU4AU5AU021480', N'Завершён', 15000.0000, CAST(N'2020-05-23' AS Date), CAST(N'2020-06-06' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (108, N'Пупкин Венцеслав Зигмундович', N'KMHEC4AU5CA026397', N'Создан', 2500.0000, CAST(N'2020-05-24' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (109, N'Вихров Бехруз Герасимович', N'KMHFC45F060018217', N'В процесссе', 10000.0000, CAST(N'2020-05-25' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (110, N'Мирзалиев Вальдемар Агниеевич', N'KMHFC46F2XA222821', N'Завершён', 15000.0000, CAST(N'2020-05-26' AS Date), CAST(N'2020-06-09' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (111, N'Вихров Бехруз Герасимович', N'KMHGC4DD0D4216841', N'Создан', 2500.0000, CAST(N'2020-05-27' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (112, N'Сергеев Афанасий Денисович', N'KMHGC4DE6AU073561', N'В процесссе', 10000.0000, CAST(N'2020-05-28' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (113, N'Минаев Бехруз Зигмундович', N'KMHGC4DH1C4208507', N'Завершён', 15000.0000, CAST(N'2020-05-29' AS Date), CAST(N'2020-06-12' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (114, N'Вихров Бехруз Герасимович', N'KMHGH4JH8E4080789', N'Создан', 2500.0000, CAST(N'2020-05-30' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (115, N'Сергеев Афанасий Денисович', N'KMHGN4JE0FU101148', N'В процесссе', 10000.0000, CAST(N'2020-05-31' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (116, N'Мирзалиев Вальдемар Агниеевич', N'KMHGN4JE6FU016833', N'Завершён', 15000.0000, CAST(N'2020-06-01' AS Date), CAST(N'2020-06-15' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (117, N'Мошенин Вангьял Денисович', N'KMHGV11D58U114311', N'Создан', 2500.0000, CAST(N'2020-06-02' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (118, N'Вихров Бехруз Герасимович', N'KMHHM65D25U163122', N'В процесссе', 10000.0000, CAST(N'2020-06-03' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (119, N'Пикаев Вильгельм Периклович', N'KMHHM65D964226881', N'Завершён', 15000.0000, CAST(N'2020-06-04' AS Date), CAST(N'2020-06-18' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (120, N'Вихров Бехруз Герасимович', N'KMHHM66D550151701', N'Создан', 2500.0000, CAST(N'2020-06-05' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (121, N'Залупкин Валентин Асафьевич', N'KMHHN65D76U189598', N'В процесссе', 10000.0000, CAST(N'2020-06-06' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (122, N'Вихров Бехруз Герасимович', N'KMHHN65D85U159623', N'Завершён', 15000.0000, CAST(N'2020-06-07' AS Date), CAST(N'2020-06-21' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (123, N'Вихров Бехруз Герасимович', N'KMHHU6KH8C4065877', N'Создан', 2500.0000, CAST(N'2020-06-08' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (124, N'Минаев Бехруз Зигмундович', N'KMHJF21M6SU904426', N'В процесссе', 10000.0000, CAST(N'2020-06-09' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (125, N'Залупкин Валентин Асафьевич', N'KMHJF24M9VU555164', N'Завершён', 15000.0000, CAST(N'2020-06-10' AS Date), CAST(N'2020-06-24' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (126, N'Сергеев Афанасий Денисович', N'KMHJF32M9RU521773', N'Создан', 2500.0000, CAST(N'2020-06-11' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (127, N'Сергеев Афанасий Денисович', N'KMHJG24F3WU105106', N'В процесссе', 10000.0000, CAST(N'2020-06-12' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (128, N'Сергеев Афанасий Денисович', N'KMHJM81D06U249193', N'Завершён', 15000.0000, CAST(N'2020-06-13' AS Date), CAST(N'2020-06-27' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (129, N'Жмышенко Валерий Альбертович', N'KMHLA21J3HU153646', N'Создан', 2500.0000, CAST(N'2020-06-14' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (130, N'Мирзалиев Вальдемар Агниеевич', N'KMHLA31J1HU180141', N'В процесссе', 10000.0000, CAST(N'2020-06-15' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (131, N'Вихров Бехруз Герасимович', N'KMHLF11J6KU651908', N'Завершён', 15000.0000, CAST(N'2020-06-16' AS Date), CAST(N'2020-06-30' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (132, N'Вихров Бехруз Герасимович', N'KMHLF31J4KU629658', N'Создан', 2500.0000, CAST(N'2020-06-17' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (133, N'Залупкин Валентин Асафьевич', N'KMHLF32J8JU310258', N'В процесссе', 10000.0000, CAST(N'2020-06-18' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (134, N'Пикаев Вильгельм Периклович', N'KMHNU81C28U064588', N'Завершён', 15000.0000, CAST(N'2020-06-19' AS Date), CAST(N'2020-07-03' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (135, N'Роганов Валентино Денисович', N'KMHSB81B26U039946', N'Создан', 2500.0000, CAST(N'2020-06-20' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (136, N'Сергеев Афанасий Денисович', N'KMHSB81DX5U971960', N'В процесссе', 10000.0000, CAST(N'2020-06-21' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (137, N'Минаев Бехруз Зигмундович', N'KMHSB81E65U930282', N'Завершён', 15000.0000, CAST(N'2020-06-22' AS Date), CAST(N'2020-07-06' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (138, N'Мирзалиев Вальдемар Агниеевич', N'KMHSC72E060014843', N'Создан', 2500.0000, CAST(N'2020-06-23' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (139, N'Роганов Валентино Денисович', N'KMHSK13E070014065', N'В процесссе', 10000.0000, CAST(N'2020-06-24' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (140, N'Пупкин Венцеслав Зигмундович', N'KMHTC5AE6EU141047', N'Завершён', 15000.0000, CAST(N'2020-06-25' AS Date), CAST(N'2020-07-09' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (141, N'Залупкин Валентин Асафьевич', N'KMHVD14N0TU186704', N'Создан', 2500.0000, CAST(N'2020-06-26' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (142, N'Агапов Владимир Сергеевич', N'KMHVD14N0X4441874', N'В процессе', 20273.0000, CAST(N'2020-06-27' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (143, N'Жмышенко Валерий Альбертович', N'KMHVD21N4WU292250', N'Завершён', 15000.0000, CAST(N'2020-06-28' AS Date), CAST(N'2020-07-12' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (144, N'Минаев Бехруз Зигмундович', N'KMHVE12J0M0015117', N'Создан', 2500.0000, CAST(N'2020-06-29' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (145, N'Вихров Бехруз Герасимович', N'KMHVE21J9MU015052', N'В процесссе', 10000.0000, CAST(N'2020-06-30' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (146, N'Минаев Бехруз Зигмундович', N'KMHVE22J0NU075348', N'Завершён', 15000.0000, CAST(N'2020-07-01' AS Date), CAST(N'2020-07-15' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (147, N'Минаев Бехруз Зигмундович', N'KMHVE32N4PU127088', N'Создан', 2500.0000, CAST(N'2020-07-02' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (148, N'Вихров Бехруз Герасимович', N'KMHVF11N1TU287510', N'В процесссе', 10000.0000, CAST(N'2020-07-03' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (149, N'Залупкин Валентин Асафьевич', N'KMHVF12J5PU804972', N'Завершён', 15000.0000, CAST(N'2020-07-04' AS Date), CAST(N'2020-07-18' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (150, N'Вихров Бехруз Герасимович', N'KMHVF22J4PU698410', N'Создан', 2500.0000, CAST(N'2020-07-05' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (151, N'Роганов Валентино Денисович', N'KMHVF22J9MU382822', N'В процесссе', 10000.0000, CAST(N'2020-07-06' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (152, N'Роганов Валентино Денисович', N'KMHVF24N6VD356891', N'Завершён', 15000.0000, CAST(N'2020-07-07' AS Date), CAST(N'2020-07-21' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (153, N'Мирзалиев Вальдемар Агниеевич', N'KMHVF24N6WU438380', N'Создан', 2500.0000, CAST(N'2020-07-08' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (154, N'Вихров Бехруз Герасимович', N'KMHWF25244A967947', N'В процесссе', 10000.0000, CAST(N'2020-07-09' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (155, N'Вихров Бехруз Герасимович', N'KMHWF25S62A668814', N'Завершён', 15000.0000, CAST(N'2020-07-10' AS Date), CAST(N'2020-07-24' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (156, N'Агапов Владимир Сергеевич', N'KMHWF25S85A132516', N'Создан', 36615.0000, CAST(N'2020-07-11' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (157, N'Пупкин Венцеслав Зигмундович', N'KMHWH81R09U098771', N'В процесссе', 10000.0000, CAST(N'2020-07-12' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (158, N'Роганов Валентино Денисович', N'KNDMC223070018147', N'Завершён', 15000.0000, CAST(N'2020-07-13' AS Date), CAST(N'2020-07-27' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (159, N'Агапов Владимир Сергеевич', N'5NMSG4AG1AH358958', N'Создан', 112106.0000, CAST(N'2022-10-23' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (161, N'Агапов Владимир Сергеевич', N'2HMBF12F0N0016245', N'Создан', 100.0000, CAST(N'2023-02-07' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (162, N'Агапов Владимир Сергеевич', N'2HMBF12F0N0016245', N'Создан', 3550.0000, CAST(N'2022-11-17' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (163, N'Агапов Владимир Сергеевич', N'2HMBF12F0N0016245', N'Завершён', 6550.0000, CAST(N'2022-11-18' AS Date), CAST(N'2022-11-20' AS Date))
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (164, N'Агапов Владимир Сергеевич', N'2HMBF12F0N0016245', N'Завершён', 2550.0000, CAST(N'2022-11-19' AS Date), NULL)
INSERT [dbo].[ЗаказНаряд] ([Номер], [Механик], [WINномер], [СостояниеЗаказа], [Стоимость], [ДатаОформления], [ДатаОкончания]) VALUES (165, N'Агапов Владимир Сергеевич', N'2HMBF12F0N0016245', N'Создан', 2550.0000, CAST(N'2022-11-22' AS Date), NULL)
GO
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (3, N'Сергеев Азамат Абалкин', CAST(N'2020-02-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (4, N'Петрова Агафоклия Сергеевна', CAST(N'2020-02-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (5, N'Абрамов Автандил Абашкин', CAST(N'2020-02-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (6, N'Мошенина Аглаида Павловна', CAST(N'2020-02-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (7, N'Зеленин Агафодор Абалаков', CAST(N'2020-02-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (8, N'Мирзалиев Агапит Абакшин', CAST(N'2020-02-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (9, N'Манюк Агапит Абдулла', CAST(N'2020-02-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (10, N'Ильин Агриппа Абакулов', CAST(N'2020-02-16' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (11, N'Зеленина Августина Павловна', CAST(N'2020-02-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (12, N'Никитин Агапит Абабков', CAST(N'2020-02-18' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (13, N'Сергеев Автандил Абашуров', CAST(N'2020-02-19' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (14, N'Комарова Аделия Михайловна', CAST(N'2020-02-20' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (15, N'Сидорова Адина Анатольевна', CAST(N'2020-02-21' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (16, N'Мирзалиев Аба Аблеух', CAST(N'2020-02-22' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (17, N'Лаврова Адельфина Анатольевна', CAST(N'2020-02-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (18, N'Мошенин Аббас Абашкин', CAST(N'2020-02-24' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (19, N'Ильин Агапит Абалкин', CAST(N'2020-02-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (20, N'Сергеев Авирмэд Абалкин', CAST(N'2020-02-26' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (21, N'Зеленина Агапа Сергеевна', CAST(N'2020-02-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (22, N'Сергеева Ада Евгеньевна', CAST(N'2020-02-28' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (23, N'Петров Аверкий Абашин', CAST(N'2020-02-29' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (24, N'Сидорова Агнесса Дмитриевна', CAST(N'2020-03-01' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (25, N'Мирзалиев Азиз Абалкин', CAST(N'2020-03-02' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (26, N'Петров Август Абаянцев', CAST(N'2020-03-03' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (27, N'Мошенин Агафангел Аблакатов', CAST(N'2020-03-04' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (28, N'Комаров Авель Абакумов', CAST(N'2020-03-05' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (29, N'Смирнов Абд аль-Узза Абдулин', CAST(N'2020-03-06' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (30, N'Зеленина Агафия Анатольевна', CAST(N'2020-03-07' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (31, N'Лаврова Агриппина Платоновна', CAST(N'2020-03-08' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (32, N'Иванов Аба Абашенко', CAST(N'2020-03-09' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (33, N'Мирзалиев Адар Абатуров', CAST(N'2020-03-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (34, N'Абрамов Абид Абалакин', CAST(N'2020-03-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (35, N'Абрамов Абид Абакумкин', CAST(N'2020-03-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (36, N'Никитин Адар Абашин', CAST(N'2020-03-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (37, N'Манюк Аботур Абаимов', CAST(N'2020-03-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (38, N'Вихров Абдуллах Абалдуев', CAST(N'2020-03-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (39, N'Сидоров Аввакум Абакулин', CAST(N'2020-03-16' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (40, N'Лавров Аба Абаянцев', CAST(N'2020-03-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (41, N'Ильин Агафон Абашенко', CAST(N'2020-03-18' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (42, N'Мошенина Аглаида Михайловна', CAST(N'2020-03-19' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (43, N'Зарипов Адонирам Абашичев', CAST(N'2020-03-20' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (44, N'Петров Август Абаянцев', CAST(N'2020-03-21' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (45, N'Козачок Аарон Абалаков', CAST(N'2020-03-22' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (46, N'Сергеев Аввакум Абашков', CAST(N'2020-03-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (47, N'Комаров Авнер Абдулов', CAST(N'2020-03-24' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (48, N'Смирнов Адонирам Абакишин', CAST(N'2020-03-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (49, N'Мирзалиев Агриппа Абашин', CAST(N'2020-03-26' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (50, N'Сергеев Аввакум Абашков', CAST(N'2020-03-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (51, N'Иванов Автандил Абашенко', CAST(N'2020-03-28' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (52, N'Козачок Автандил Абалдуев', CAST(N'2020-03-29' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (53, N'Сидоров Авдей Абдулин', CAST(N'2020-03-30' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (54, N'Смирнов Абдуллах Абабков', CAST(N'2020-03-31' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (55, N'Ильин Авнер Аблакатов', CAST(N'2020-04-01' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (56, N'Петров Азамат Абатуров', CAST(N'2020-04-02' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (57, N'Комаров Агафангел Абалаков', CAST(N'2020-04-03' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (58, N'Комаров Агафангел Абаимов', CAST(N'2020-04-04' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (59, N'Сидорова Агафия Сергеевна', CAST(N'2020-04-05' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (60, N'Лавров Агафон Абаянцев', CAST(N'2020-04-06' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (61, N'Петров Азамат Абакушин', CAST(N'2020-04-07' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (62, N'Козачок Агафья Михайловна', CAST(N'2020-04-08' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (63, N'Петрова Аделла Платоновна', CAST(N'2020-04-09' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (64, N'Сергеева Агафа Андреевна', CAST(N'2020-04-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (65, N'Вихров Адонирам Абашуров', CAST(N'2020-04-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (66, N'Зеленин Абдуллах Абаянцев', CAST(N'2020-04-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (67, N'Козачок Агафа Петровна', CAST(N'2020-04-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (68, N'Петрова Адельфина Михайловна', CAST(N'2020-04-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (69, N'Абрамова Азал Ивановна', CAST(N'2020-04-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (70, N'Комаров Автандил Абалдуев', CAST(N'2020-04-16' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (71, N'Петухов Павел Андреевич', CAST(N'2020-04-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (72, N'Зарипов Авель Абаимов', CAST(N'2020-04-18' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (73, N'Иванова Аза Павловна', CAST(N'2020-04-19' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (74, N'Иванов Абдуллах Абашенко', CAST(N'2020-04-20' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (75, N'Иванов Адар Абашенко', CAST(N'2020-04-21' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (76, N'Иванов Адам Абаянцев', CAST(N'2020-04-22' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (77, N'Мошенин Абд аль-Узза Абакулин', CAST(N'2020-04-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (78, N'Мошенин Абд аль-Узза Абалакин', CAST(N'2020-04-24' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (79, N'Зарипов Авигдор Абабков', CAST(N'2020-04-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (80, N'Зарипов Авирмэд Абашенко', CAST(N'2020-04-26' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (81, N'Никитин Адриан Абаимов', CAST(N'2020-04-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (82, N'Сергеев Азиз Абдулла', CAST(N'2020-04-28' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (83, N'Петров Авл Абашин', CAST(N'2020-04-29' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (84, N'Комаров Авксентий Абаимов', CAST(N'2020-04-30' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (85, N'Сергеева Адель Ивановна', CAST(N'2020-05-01' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (86, N'Иванов Агафон Абаянцев', CAST(N'2020-05-02' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (87, N'Иванов Аз Абакулин', CAST(N'2020-05-03' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (88, N'Мирзалиев Аверкий Абдулла', CAST(N'2020-05-04' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (89, N'Зарипов Адам Абдулла', CAST(N'2020-05-05' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (90, N'Зеленин Абид Абабков', CAST(N'2020-05-06' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (91, N'Ильин Агафон Абабков', CAST(N'2020-05-07' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (92, N'Вихрова Азал Дмитриевна', CAST(N'2020-05-08' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (93, N'Никитин Адриан Абаимов', CAST(N'2020-05-09' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (94, N'Абдурозиков Валерий Альбертович', CAST(N'2020-05-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (95, N'Петров Абд аль-Узза Аблакатов', CAST(N'2020-05-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (96, N'Комаров Агафодор Абакулов', CAST(N'2020-05-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (97, N'Петрова Адельфина Ивановна', CAST(N'2020-05-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (98, N'Сидоров Агафангел Аббакумов', CAST(N'2020-05-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (99, N'Абрамов Авигдор Абдулла', CAST(N'2020-05-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (100, N'Вихров Август Абашеев', CAST(N'2020-05-16' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (101, N'Петров Агафон Абашичев', CAST(N'2020-05-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (102, N'Петрова Агриппина Платоновна', CAST(N'2020-05-18' AS Date))
GO
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (103, N'Петров Авдей Аблеух', CAST(N'2020-05-19' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (104, N'Лавров Август Абакушин', CAST(N'2020-05-20' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (105, N'Лавров Адольф Абашков', CAST(N'2020-05-21' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (106, N'Зарипова Авдотья Павловна', CAST(N'2020-05-22' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (107, N'Сидоров Абдуллах Абдулин', CAST(N'2020-05-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (108, N'Сергеев Адиль Абашеев', CAST(N'2020-05-24' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (109, N'Зеленин Агафодор Абалкин', CAST(N'2020-05-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (110, N'Мирзалиев Аги Абалкин', CAST(N'2020-05-26' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (111, N'Зарипов Адольф Абдулин', CAST(N'2020-05-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (112, N'Смирнова Агния Платоновна', CAST(N'2020-05-28' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (113, N'Манюк Аглая Павловна', CAST(N'2020-05-29' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (114, N'Зарипов Агапит Абашуров', CAST(N'2020-05-30' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (115, N'Смирнов Адольф Абалакин', CAST(N'2020-05-31' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (116, N'Мошенин Автоном Абатурин', CAST(N'2020-06-01' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (117, N'Никитина Адина Ивановна', CAST(N'2020-06-02' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (118, N'Вихров Аз Абакишин', CAST(N'2020-06-03' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (119, N'Петрова Адельфина Михайловна', CAST(N'2020-06-04' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (120, N'Вихрова Адельфина Анатольевна', CAST(N'2020-06-05' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (121, N'Манюк Аботур Абаимов', CAST(N'2020-06-06' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (122, N'Зеленина Аделия Павловна', CAST(N'2020-06-07' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (123, N'Ильин Агапит Абалдуев', CAST(N'2020-06-08' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (124, N'Манюк Аврора Андреевна', CAST(N'2020-06-09' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (125, N'Лавров Абдуллах Абашичев', CAST(N'2020-06-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (126, N'Сидорова Агафа Дмитриевна', CAST(N'2020-06-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (127, N'Смирнов Адриан Абакулин', CAST(N'2020-06-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (128, N'Смирнов Адриан Абалаков', CAST(N'2020-06-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (129, N'Комаров Азамат Абатуров', CAST(N'2020-06-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (130, N'Никитин Аарон Абашенко', CAST(N'2020-06-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (131, N'Зарипова Агапия Евгеньевна', CAST(N'2020-06-16' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (132, N'Козачок Автоном Абакумкин', CAST(N'2020-06-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (133, N'Лавров Аббас Абакшин', CAST(N'2020-06-18' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (134, N'Петров Агафон Абашичев', CAST(N'2020-06-19' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (135, N'Сидоров Аботур Абалдуев', CAST(N'2020-06-20' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (136, N'Сидоров Агафангел Абатуров', CAST(N'2020-06-21' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (137, N'Манюк Автандил Абалакин', CAST(N'2020-06-22' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (138, N'Мирзалиев Аги Аблакатов', CAST(N'2020-06-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (139, N'Сергеева Агапа Евгеньевна', CAST(N'2020-06-24' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (140, N'Сергеев Адриан Абабков', CAST(N'2020-06-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (141, N'Лавров Абид Абаимов', CAST(N'2020-06-26' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (142, N'Абрамов Автоном Абашеев', CAST(N'2020-06-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (143, N'Комаров Агриппа Абашуров', CAST(N'2020-06-28' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (144, N'Манюк Агафия Андреевна', CAST(N'2020-06-29' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (145, N'Вихров Азиз Абашкин', CAST(N'2020-06-30' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (146, N'Мирзалиев Авирмэд Абалкин', CAST(N'2020-07-01' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (147, N'Мирзалиев Аботур Абдулла', CAST(N'2020-07-02' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (148, N'Ильин Абдуллах Абакумов', CAST(N'2020-07-03' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (149, N'Лавров Агафон Абатурин', CAST(N'2020-07-04' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (150, N'Зарипов Авксентий Абалакин', CAST(N'2020-07-05' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (151, N'Сергеева Агапа Павловна', CAST(N'2020-07-06' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (152, N'Сергеева Адина Ивановна', CAST(N'2020-07-07' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (153, N'Мирзалиев Адонирам Абашкин', CAST(N'2020-07-08' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (154, N'Козачок Адар Абдулов', CAST(N'2020-07-09' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (155, N'Зарипов Агафодор Абашенко', CAST(N'2020-07-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (156, N'Вихров Аба Абакумкин', CAST(N'2020-07-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (157, N'Сергеев Аввакум Абдулов', CAST(N'2020-07-12' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (158, N'Сидоров Авнер Абаянцев', CAST(N'2020-07-13' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (159, N'Абрамов Азат Абалаков', CAST(N'2020-07-14' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (160, N'Абрамов Азат Абалаков', CAST(N'2020-07-15' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (161, N'Иванов Абид Абакшин', CAST(N'2022-10-27' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (162, N'Сергеев Азамат Абалкин', CAST(N'2020-11-10' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (163, N'Сергеев Азамат Абалкин', CAST(N'2022-11-11' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (164, N'Сергеев Азамат Абалкин', CAST(N'2022-11-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (165, N'Сергеев Азамат Абалкин', CAST(N'2022-11-17' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (166, N'Сергеев Азамат Абалкин', CAST(N'2022-11-18' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (168, N'Петров Азамат Абатуров', CAST(N'2000-11-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (169, N'Иванов Автандил Абашенко', CAST(N'2022-11-30' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (170, N'Мирзалиев Агриппа Абашин', CAST(N'2022-11-23' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (171, N'Никитин Адриан Абаимов', CAST(N'2022-11-25' AS Date))
INSERT [dbo].[Запись] ([idЗаписи], [ФИОклиент], [Дата]) VALUES (172, N'Сергеев Азамат Абалкин', CAST(N'2022-11-23' AS Date))
GO
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абдурозиков Валерий Альбертович', CAST(N'2000-07-14' AS Date), N'м', 89016818620)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абдурозикова Валерия Альбертовна', CAST(N'2000-07-11' AS Date), N'ж', 56787654)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Абид Абакумкин', CAST(N'1982-02-24' AS Date), N'м', 89168456666)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Абид Абалакин', CAST(N'1981-04-15' AS Date), N'м', 89994543421)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Авигдор Абдулла', CAST(N'1981-08-18' AS Date), N'м', 89676656534)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Автандил Абашкин', CAST(N'1981-09-27' AS Date), N'м', 89917689019)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Автоном Абашеев', CAST(N'1981-06-29' AS Date), N'м', 89167900808)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамов Азат Абалаков', CAST(N'1982-01-05' AS Date), N'м', 89668312309)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Абрамова Азал Ивановна', CAST(N'1981-04-20' AS Date), N'ж', 89650001018)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Аба Абакумкин', CAST(N'1981-07-04' AS Date), N'м', 89657773737)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Абдуллах Абалдуев', CAST(N'1982-06-04' AS Date), N'м', 89167474747)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Август Абашеев', CAST(N'1981-05-10' AS Date), N'м', 89765543106)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Адонирам Абашуров', CAST(N'1982-01-15' AS Date), N'м', 89458971032)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Аз Абакишин', CAST(N'1982-06-14' AS Date), N'м', 89163456345)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихров Азиз Абашкин', CAST(N'1981-10-12' AS Date), N'м', 89168765456)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихрова Адельфина Анатольевна', CAST(N'1981-09-07' AS Date), N'ж', 89165432345)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Вихрова Азал Дмитриевна', CAST(N'1981-03-16' AS Date), N'ж', 89165342563)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Авель Абаимов', CAST(N'1981-11-26' AS Date), N'м', 89162457555)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Авигдор Абабков', CAST(N'1982-03-26' AS Date), N'м', 89675643235)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Авирмэд Абашенко', CAST(N'1981-05-20' AS Date), N'м', 89162432543)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Авксентий Абалакин', CAST(N'1981-03-21' AS Date), N'м', 89606743764)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Агапит Абашуров', CAST(N'1982-06-19' AS Date), N'м', 87654345678)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Агафодор Абашенко', CAST(N'1982-05-20' AS Date), N'м', 87534566665)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Адам Абдулла', CAST(N'1982-01-20' AS Date), N'м', 89554616362)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Адольф Абдулин', CAST(N'1981-11-21' AS Date), N'м', 89163234234)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипов Адонирам Абашичев', CAST(N'1981-07-09' AS Date), N'м', 89162343434)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипова Авдотья Павловна', CAST(N'1981-07-29' AS Date), N'ж', 89167352091)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зарипова Агапия Евгеньевна', CAST(N'1981-05-05' AS Date), N'ж', 89153254271)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленин Абдуллах Абаянцев', CAST(N'1982-09-22' AS Date), N'м', 89165345234)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленин Абид Абабков', CAST(N'1982-04-10' AS Date), N'м', 89160432000)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленин Агафодор Абалаков', CAST(N'1982-10-12' AS Date), N'м', 89143456669)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленин Агафодор Абалкин', CAST(N'1982-07-04' AS Date), N'м', 89654323457)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленина Августина Павловна', CAST(N'1981-08-13' AS Date), N'ж', 89234560000)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленина Агапа Сергеевна', CAST(N'1981-05-15' AS Date), N'ж', 12456254141)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленина Агафия Анатольевна', CAST(N'1981-05-25' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Зеленина Аделия Павловна', CAST(N'1981-04-10' AS Date), N'ж', 89763456789)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Аба Абашенко', CAST(N'1981-03-16' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Абдуллах Абашенко', CAST(N'1981-11-11' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Абид Абакшин', CAST(N'1981-10-22' AS Date), N'м', 89168887654)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Автандил Абашенко', CAST(N'1981-09-22' AS Date), N'м', 89169863432)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Агафон Абаянцев', CAST(N'1982-03-06' AS Date), N'м', 89675432345)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Адам Абаянцев', CAST(N'1981-10-02' AS Date), N'м', 89345678765)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Адар Абашенко', CAST(N'1982-07-19' AS Date), N'м', 89123454322)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Адольф Аббакумов', CAST(N'1981-09-17' AS Date), N'м', 89010101012)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванов Аз Абакулин', CAST(N'1981-12-11' AS Date), N'м', 89623454323)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Иванова Аза Павловна', CAST(N'1981-08-28' AS Date), N'ж', 89734361275)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Абдуллах Абакумов', CAST(N'1982-07-24' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Авнер Аблакатов', CAST(N'1982-08-08' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Автандил Абатуров', CAST(N'1982-02-14' AS Date), N'м', 89532543256)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Агапит Абалдуев', CAST(N'1981-03-11' AS Date), N'м', 89444444543)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Агапит Абалкин', CAST(N'1981-06-14' AS Date), N'м', 89534334131)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Агафон Абабков', CAST(N'1982-08-03' AS Date), N'м', 76543546787)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Агафон Абашенко', CAST(N'1981-09-02' AS Date), N'м', 76543456789)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Ильин Агриппа Абакулов', CAST(N'1982-03-16' AS Date), N'м', 43567898765)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Аарон Абалаков', CAST(N'1981-08-08' AS Date), N'м', 34567645654)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Автандил Абалдуев', CAST(N'1982-07-29' AS Date), N'м', 89878888878)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Автоном Абакумкин', CAST(N'1982-04-30' AS Date), N'м', 65434567888)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Агафа Петровна', CAST(N'1981-03-31' AS Date), N'ж', 89165456545)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Агафья Михайловна', CAST(N'1981-07-14' AS Date), N'ж', 89715566475)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Адар Абдулов', CAST(N'1982-04-05' AS Date), N'м', 89612465365)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Козачок Аз Абашкин', CAST(N'1981-08-03' AS Date), N'м', 89134144133)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Авель Абакумов', CAST(N'1981-04-05' AS Date), N'м', 89167644442)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Авксентий Абаимов', CAST(N'1981-08-23' AS Date), N'м', 89654345611)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Авнер Абдулов', CAST(N'1981-12-21' AS Date), N'м', 89654345671)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Автандил Абалдуев', CAST(N'1982-02-09' AS Date), N'м', 89654312531)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Агафангел Абаимов', CAST(N'1982-09-12' AS Date), N'м', 89012042354)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Агафангел Абалаков', CAST(N'1981-05-05' AS Date), N'м', 89754412001)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Агафодор Абакулов', CAST(N'1982-08-13' AS Date), N'м', 89065345412)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Агриппа Абашуров', CAST(N'1981-03-01' AS Date), N'м', 89012541231)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комаров Азамат Абатуров', CAST(N'1982-03-31' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Комарова Аделия Михайловна', CAST(N'1981-06-09' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Аба Абаянцев', CAST(N'1981-03-26' AS Date), N'м', 14235123411)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Аббас Абакшин', CAST(N'1982-08-23' AS Date), N'м', 13514354356)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Абдуллах Абашичев', CAST(N'1981-04-30' AS Date), N'м', 89876621534)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Абид Абаимов', CAST(N'1982-03-01' AS Date), N'м', 89813223444)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Аботур Абакушин', CAST(N'1982-01-10' AS Date), N'м', 89612341123)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Август Абакушин', CAST(N'1981-10-07' AS Date), N'м', 89234123451)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Агафон Абатурин', CAST(N'1981-07-29' AS Date), N'м', 89123451234)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Агафон Абаянцев', CAST(N'1981-12-01' AS Date), N'м', 89132401241)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Адольф Абашков', CAST(N'1981-11-06' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лавров Аз Абакишин', CAST(N'1982-04-20' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лаврова Агапия Дмитриевна', CAST(N'1981-05-20' AS Date), N'ж', 89821342312)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лаврова Агриппина Платоновна', CAST(N'1981-03-26' AS Date), N'ж', 87664551223)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Лаврова Адельфина Анатольевна', CAST(N'1981-03-06' AS Date), N'ж', 89876547545)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Аботур Абаимов', CAST(N'1982-07-09' AS Date), N'м', 89543454232)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Аврора Анатольевна', CAST(N'1981-08-03' AS Date), N'ж', 89413241632)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Аврора Андреевна', CAST(N'1981-08-23' AS Date), N'ж', 89544324621)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Автандил Абалакин', CAST(N'1981-06-04' AS Date), N'м', 89512453211)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Агапит Абдулла', CAST(N'1981-12-26' AS Date), N'м', 89532543254)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Агафия Андреевна', CAST(N'1981-04-15' AS Date), N'ж', 89561234561)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Манюк Аглая Павловна', CAST(N'1981-06-04' AS Date), N'ж', 89007644533)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Аба Аблеух', CAST(N'1981-06-09' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Аботур Абдулла', CAST(N'1982-08-28' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Аверкий Абдулла', CAST(N'1981-12-06' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Авирмэд Абалкин', CAST(N'1981-12-16' AS Date), N'м', 89561254132)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Агапит Абакшин', CAST(N'1982-01-30' AS Date), N'м', 89103141432)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Аги Абалкин', CAST(N'1982-10-07' AS Date), N'м', 89995321265)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Аги Аблакатов', CAST(N'1981-08-13' AS Date), N'м', 89655513241)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Агриппа Абашин', CAST(N'1982-05-05' AS Date), N'м', 89643253423)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Адар Абатуров', CAST(N'1981-03-06' AS Date), N'м', NULL)
GO
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Адонирам Абашкин', CAST(N'1981-04-25' AS Date), N'м', 32461324124)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мирзалиев Азиз Абалкин', CAST(N'1982-07-14' AS Date), N'м', 98765112434)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенин Аббас Абашкин', CAST(N'1981-05-25' AS Date), N'м', 87897678771)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенин Абд аль-Узза Абакулин', CAST(N'1982-05-15' AS Date), N'м', 98765481110)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенин Абд аль-Узза Абалакин', CAST(N'1981-06-24' AS Date), N'м', 78647383111)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенин Автоном Абатурин', CAST(N'1982-10-02' AS Date), N'м', 98765435673)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенин Агафангел Аблакатов', CAST(N'1981-10-17' AS Date), N'м', 98765678987)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенина Аглаида Михайловна', CAST(N'1981-04-30' AS Date), N'ж', 89543450001)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Мошенина Аглаида Павловна', CAST(N'1981-06-14' AS Date), N'ж', 42134124441)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитин Аарон Абашенко', CAST(N'1981-09-12' AS Date), N'м', 78987676888)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитин Авксентий Абакумов', CAST(N'1982-05-10' AS Date), N'м', 87655676545)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитин Агапит Абабков', CAST(N'1981-12-31' AS Date), N'м', 89764457656)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитин Адар Абашин', CAST(N'1982-05-30' AS Date), N'м', 89645132713)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитин Адриан Абаимов', CAST(N'1982-03-21' AS Date), N'м', 89653465451)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Никитина Адина Ивановна', CAST(N'1981-03-21' AS Date), N'ж', 89763013413)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Абд аль-Узза Аблакатов', CAST(N'1982-02-04' AS Date), N'м', 89134132400)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Август Абаянцев', CAST(N'1982-09-02' AS Date), N'м', 89612543200)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Авдей Аблеух', CAST(N'1982-06-29' AS Date), N'м', 76834276432)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Аверкий Абашин', CAST(N'1981-07-14' AS Date), N'м', 87654345671)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Авл Абашин', CAST(N'1981-11-01' AS Date), N'м', 88998889766)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Агафон Абашичев', CAST(N'1982-04-15' AS Date), N'м', 89876433111)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Азамат Абакушин', CAST(N'1981-06-19' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петров Азамат Абатуров', CAST(N'1982-01-25' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петрова Агафоклия Сергеевна', CAST(N'1981-08-08' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петрова Агриппина Платоновна', CAST(N'1981-06-19' AS Date), N'ж', 43113244334)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петрова Аделла Платоновна', CAST(N'1981-06-24' AS Date), N'ж', 98789898090)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петрова Адельфина Ивановна', CAST(N'1981-06-29' AS Date), N'ж', 89765434541)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петрова Адельфина Михайловна', CAST(N'1981-09-02' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Петухов Павел Андреевич', CAST(N'1967-03-18' AS Date), N'м', 89167472527)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Пупырчикова Антонина Евгеньева', CAST(N'1999-08-29' AS Date), N'ж', 89164567134)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Аввакум Абашков', CAST(N'1982-04-25' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Аввакум Абдулов', CAST(N'1981-11-16' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Авирмэд Абалкин', CAST(N'1982-09-17' AS Date), N'м', 54324398439)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Автандил Абашуров', CAST(N'1982-08-18' AS Date), N'м', 98767898767)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Адиль Абашеев', CAST(N'1981-07-19' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Адриан Абабков', CAST(N'1982-09-27' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Азамат Абалкин', CAST(N'1981-05-30' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеев Азиз Абдулла', CAST(N'1981-04-10' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Агапа Евгеньевна', CAST(N'1981-05-10' AS Date), N'ж', 78134761437)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Агапа Павловна', CAST(N'1981-04-25' AS Date), N'ж', 87688899991)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Агафа Андреевна', CAST(N'1981-03-01' AS Date), N'ж', 99898766611)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Ада Евгеньевна', CAST(N'1981-03-11' AS Date), N'ж', 89912635123)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Адель Ивановна', CAST(N'1981-08-18' AS Date), N'ж', 89614235611)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сергеева Адина Ивановна', CAST(N'1981-07-24' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Абдуллах Абдулин', CAST(N'1982-03-11' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Аботур Абалдуев', CAST(N'1981-10-27' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Аввакум Абакулин', CAST(N'1981-05-15' AS Date), N'м', 76243764327)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Авдей Абдулин', CAST(N'1981-09-07' AS Date), N'м', 89878612311)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Авнер Абаянцев', CAST(N'1981-04-20' AS Date), N'м', 89812731231)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Агафангел Абатуров', CAST(N'1982-06-09' AS Date), N'м', 89987123612)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидоров Агафангел Аббакумов', CAST(N'1982-09-07' AS Date), N'м', 89817231233)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидорова Агафа Дмитриевна', CAST(N'1981-05-30' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидорова Агафия Сергеевна', CAST(N'1981-07-19' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидорова Агнесса Дмитриевна', CAST(N'1981-07-04' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Сидорова Адина Анатольевна', CAST(N'1981-04-05' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Абд аль-Узза Абдулин', CAST(N'1981-03-31' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Абдуллах Абабков', CAST(N'1981-07-24' AS Date), N'м', 98543278432)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Адольф Абалакин', CAST(N'1982-05-25' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Адонирам Абакишин', CAST(N'1981-08-28' AS Date), N'м', 99812365121)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Адриан Абакулин', CAST(N'1982-06-24' AS Date), N'м', 89888123112)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнов Адриан Абалаков', CAST(N'1982-02-19' AS Date), N'м', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Смирнова Агния Платоновна', CAST(N'1981-07-09' AS Date), N'ж', NULL)
INSERT [dbo].[Клиент] ([ФИО], [ДатаРождения], [Пол], [Телефон]) VALUES (N'Тернов', CAST(N'2000-11-23' AS Date), N'м', 7656766661)
GO
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Абрамов', CAST(N'2000-11-18' AS Date), N'Менеджер', 500.0000, 1, 9876545678, N'апро', N'апро')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'1985-09-12' AS Date), N'Механик', 10000.0000, 9, 89876545532, N'agap', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Виницкая Динара Ильинишна', CAST(N'2002-08-09' AS Date), N'Менеджер', 50000.0000, 2, 87654567877, N'win', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'1987-09-12' AS Date), N'Механик', 45000.0000, 5, 89167472527, N'vih', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Власов', CAST(N'2000-11-23' AS Date), N'Механик', 10000.0000, 1, 89168334356, N'vla', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Глухарева Павел Анатольевич', CAST(N'2003-04-30' AS Date), N'Менеджер', 50000.0000, 1, 89165556545, N'gly', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'1990-03-02' AS Date), N'Механик', 45000.0000, 4, 89608771666, N'gmu', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'1987-03-03' AS Date), N'Механик', 45000.0000, 10, 89168456671, N'zal', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Захаров', CAST(N'2000-11-20' AS Date), N'Механик', 1.0000, 1, 1, N'лорп', N'123123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Иванова Ботогоз Семеновна', CAST(N'1990-07-02' AS Date), N'Менеджер', 50000.0000, 3, 89163453432, N'iva', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Комарова Багдагуль Петровна', CAST(N'1990-01-02' AS Date), N'Менеджер', 12333.0000, 4, 89608765422, N'kom', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'1989-01-12' AS Date), N'Механик', 45000.0000, 5, 89163254632, N'min', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'1985-01-12' AS Date), N'Механик', 45000.0000, 11, 89766666633, N'mir', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'1989-09-12' AS Date), N'Механик', 45000.0000, 5, 89652141211, N'mosh', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'1986-05-12' AS Date), N'Механик', 45000.0000, 5, 89654345611, N'pik', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Прохоров Вадим Константинович', CAST(N'2000-01-01' AS Date), N'Директор', 1000000.0000, 20, 89618774425, N'pro', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'1988-05-12' AS Date), N'Механик', 45000.0000, 1, 89654333221, N'pyp', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Роганов Валентино Денисович', CAST(N'1987-01-12' AS Date), N'Механик', 45000.0000, 15, 89326452341, N'rog', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'1990-05-12' AS Date), N'Механик', 45000.0000, 5, 89654143123, N'ser', N'123')
INSERT [dbo].[Работник] ([ФИО], [ДатаРождения], [Должность], [Зарплата], [Стаж], [Телефон], [Логин], [Пароль]) VALUES (N'Смирнова Бернадетта Кирилловна', CAST(N'1991-01-02' AS Date), N'Менеджер', 50000.0000, 3, 89263411231, N'smi', N'123')
GO
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (2, 12, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (3, 23, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (4, 34, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (5, 45, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (5, 156, 2, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (6, 56, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (6, 156, 2, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (7, 67, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (8, 78, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (9, 89, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (10, 1, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (10, 5, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (11, 3, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (12, 4, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (13, 5, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (14, 6, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (15, 7, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (16, 8, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (17, 9, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (18, 10, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (19, 11, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (20, 13, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (21, 14, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (22, 15, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (23, 16, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (24, 17, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (25, 18, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (26, 19, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (27, 20, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (28, 21, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (29, 22, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 24, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 99, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 142, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 156, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 159, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (30, 163, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (31, 25, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (31, 142, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (32, 26, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (32, 162, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (33, 27, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (34, 28, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (35, 29, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (35, 163, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (36, 30, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (37, 31, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (37, 99, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (37, 142, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (37, 156, 10, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (38, 32, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (39, 33, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (40, 35, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (41, 36, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (42, 37, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (43, 38, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (44, 39, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (45, 40, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (46, 41, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (47, 42, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (48, 43, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (49, 44, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (50, 46, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (51, 47, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (52, 48, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (53, 49, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (54, 50, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (55, 51, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (56, 52, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (57, 53, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (58, 54, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (59, 55, 1, N'Литр')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (60, 57, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (60, 60, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (60, 156, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (61, 58, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (61, 142, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (62, 59, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (63, 60, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (64, 61, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (65, 62, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (66, 63, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (67, 64, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (68, 65, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (69, 66, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (70, 68, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (71, 69, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (72, 70, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (73, 71, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (74, 72, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (75, 73, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (76, 74, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (77, 75, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (78, 76, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (79, 77, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (80, 79, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (81, 80, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (82, 81, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (83, 82, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (84, 83, 1, N'Штука')
GO
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (85, 84, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (86, 85, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (87, 86, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (88, 87, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (89, 88, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (90, 90, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (91, 91, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (92, 92, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (93, 93, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (95, 95, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (96, 96, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (97, 97, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (98, 98, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (98, 131, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 99, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 100, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 101, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 102, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 103, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 104, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 105, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 106, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 107, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 108, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 109, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 110, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 111, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 112, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 113, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 114, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 115, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 116, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 117, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 118, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 119, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 120, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 121, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 122, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 123, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 124, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 125, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 126, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 127, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 128, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 129, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 130, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 131, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 132, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 133, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 134, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 135, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 136, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 137, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 138, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 139, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 140, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 141, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 142, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 143, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 144, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 145, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 146, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 147, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 148, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 149, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 150, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 151, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 152, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 153, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 154, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 155, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 157, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (99, 158, 1, N'Штука')
INSERT [dbo].[Расход] ([НомерДетали], [НомерНаряда], [Количество], [ЕдИзм]) VALUES (100, 2, 1, N'Штука')
GO
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-02-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-03-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-03-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-03-15' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-04-15' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-05-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-05-15' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-06-27' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Агапов Владимир Сергеевич', CAST(N'2020-07-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-16' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-17' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-25' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-02-27' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-18' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-20' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-22' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-28' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-03-29' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-01' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-18' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-19' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-20' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-21' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-22' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-25' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-04-26' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-02' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-03' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-05' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-06' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-16' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-22' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-25' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-27' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-05-30' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-03' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-05' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-16' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-17' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-06-30' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-07-03' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-07-05' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-07-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Вихров Бехруз Герасимович', CAST(N'2020-07-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-02-20' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-03-05' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-03-24' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-04-03' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-04-04' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-04-16' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-04-30' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-05-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-06-14' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Жмышенко Валерий Альбертович', CAST(N'2020-06-28' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-02-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-02-23' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-03-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-03-17' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-04-06' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-05-20' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-05-21' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-06-06' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-06-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-06-18' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-06-26' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Залупкин Валентин Асафьевич', CAST(N'2020-07-04' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-02-14' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-02-15' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-02-22' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-03-14' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-05-04' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-05-29' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-06-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-06-22' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-06-29' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-07-01' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Минаев Бехруз Зигмундович', CAST(N'2020-07-02' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-02-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-02-18' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-02-24' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-02' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-04' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-19' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-03-26' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-04-23' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-04-24' AS Date))
GO
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-05-26' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-06-01' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-06-15' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-06-23' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мирзалиев Вальдемар Агниеевич', CAST(N'2020-07-08' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-03-03' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-03-21' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-04-27' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-05-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-05-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-05-19' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Мошенин Вангьял Денисович', CAST(N'2020-06-02' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-02-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-02-29' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-04-02' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-04-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-04-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-04-29' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-05-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-05-17' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-05-18' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-06-04' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пикаев Вильгельм Периклович', CAST(N'2020-06-19' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-02-09' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-02-19' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-02-26' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-03-23' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-03-27' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-04-14' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-04-17' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-05-24' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-06-25' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Пупкин Венцеслав Зигмундович', CAST(N'2020-07-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-02-28' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-03-16' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-03-30' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-04-10' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-04-28' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-05-01' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-05-23' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-06-20' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-06-24' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-07-06' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-07-07' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Роганов Валентино Денисович', CAST(N'2020-07-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-02-21' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-03-01' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-03-06' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-03-25' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-03-31' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-04-05' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-05-14' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-05-28' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-05-31' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-06-11' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-06-12' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-06-13' AS Date))
INSERT [dbo].[Смена] ([ФИОраб], [ДатаСмены]) VALUES (N'Сергеев Афанасий Денисович', CAST(N'2020-06-21' AS Date))
GO
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'2HMBF12F0N0016245', N'Вихров Бехруз Герасимович', N'Иванов Абид Абакшин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'2HMBF32F4NB073208', N'Залупкин Валентин Асафьевич', N'Лавров Аз Абакишин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSG13D47HD05166', N'Пупкин Венцеслав Зигмундович', N'Сергеев Азамат Абалкин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSG13E27H102248', N'Пикаев Вильгельм Периклович', N'Петрова Агафоклия Сергеевна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSG4AG1AH358958', N'Агапов Владимир Сергеевич', N'Абрамов Автандил Абашкин', N'Hyundai ', N'Santa Fe

')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSGCAB0A0019427', N'Мирзалиев Вальдемар Агниеевич', N'Мошенина Аглаида Павловна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSH13E29H320884', N'Вихров Бехруз Герасимович', N'Зеленин Агафодор Абалаков', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSH13EX8Y151227', N'Минаев Бехруз Зигмундович', N'Мирзалиев Агапит Абакшин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSH4AG6AH339478', N'Минаев Бехруз Зигмундович', N'Манюк Агапит Абдулла', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NMSHDDG0A0017736', N'Вихров Бехруз Герасимович', N'Ильин Агриппа Абакулов', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPE24AF0GH338926', N'Вихров Бехруз Герасимович', N'Зеленина Августина Павловна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEB4AC0B1106821', N'Мирзалиев Вальдемар Агниеевич', N'Никитин Агапит Абабков', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEB4AC1D1234567', N'Пупкин Венцеслав Зигмундович', N'Сергеев Автандил Абашуров', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEBUAC3CH481966', N'Жмышенко Валерий Альбертович', N'Комарова Аделия Михайловна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEC4AC9C9CH4357', N'Сергеев Афанасий Денисович', N'Сидорова Адина Анатольевна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEC4AC9CH403303', N'Минаев Бехруз Зигмундович', N'Мирзалиев Аба Аблеух', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPET46C56H085211', N'Залупкин Валентин Асафьевич', N'Лаврова Адельфина Анатольевна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPET46FX8H402946', N'Мирзалиев Вальдемар Агниеевич', N'Мошенин Аббас Абашкин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEU46C568128006', N'Вихров Бехруз Герасимович', N'Ильин Агапит Абалкин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEU46C76H059559', N'Пупкин Венцеслав Зигмундович', N'Сергеев Авирмэд Абалкин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEU46FX98430308', N'Вихров Бехруз Герасимович', N'Зеленина Агапа Сергеевна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEU4AC1AH588764', N'Роганов Валентино Денисович', N'Сергеева Ада Евгеньевна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPEU4BF0A0013823', N'Пикаев Вильгельм Периклович', N'Петров Аверкий Абашин', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5NPSJ13E070010686', N'Сергеев Афанасий Денисович', N'Сидорова Агнесса Дмитриевна', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZG4AG3CG119018', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Азиз Абалкин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZT3CB8EG146063', N'Мошенин Вангьял Денисович', N'Петров Август Абаянцев', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZU3LB6DGQ57359', N'Мирзалиев Вальдемар Агниеевич', N'Мошенин Агафангел Аблакатов', N'Hyundai', N'Santa Fe Sport')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZUDLA0FG248761', N'Жмышенко Валерий Альбертович', N'Комаров Авель Абакумов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZUDLB8HG417999', N'Сергеев Афанасий Денисович', N'Смирнов Абд аль-Узза Абдулин', N'Hyundai', N'Santa Fe Sport')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZWDLA1DG100710', N'Вихров Бехруз Герасимович', N'Зеленина Агафия Анатольевна', N'Hyundai', N'Santa Fe Sport')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'5XYZWDLA7EG152263', N'Залупкин Валентин Асафьевич', N'Лаврова Агриппина Платоновна', N'Hyundai', N'Santa Fe Sport')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8J33A48GU205711', N'Вихров Бехруз Герасимович', N'Иванов Аба Абашенко', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JM12B18U909944', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Адар Абатуров', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JM12B47U625366', N'Агапов Владимир Сергеевич', N'Абрамов Абид Абалакин', N'Hyundai ', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JM12D75U093366', N'Агапов Владимир Сергеевич', N'Абрамов Абид Абакумкин', N'Hyundai ', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JM72D95U050618', N'Мирзалиев Вальдемар Агниеевич', N'Никитин Адар Абашин', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JN72D16U329737', N'Минаев Бехруз Зигмундович', N'Манюк Аботур Абаимов', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JT3AB2CU404259', N'Агапов Владимир Сергеевич', N'Вихров Абдуллах Абалдуев', N'Hyundai ', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JT3AC9BU217088', N'Роганов Валентино Денисович', N'Сидоров Аввакум Абакулин', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JTCDC0A0011241', N'Залупкин Валентин Асафьевич', N'Лавров Аба Абаянцев', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JU3AC5DU399999', N'Вихров Бехруз Герасимович', N'Ильин Агафон Абашенко', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JU3AC8DU611522', N'Мирзалиев Вальдемар Агниеевич', N'Мошенина Аглаида Михайловна', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JU3AG7FU954182', N'Вихров Бехруз Герасимович', N'Зарипов Адонирам Абашичев', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8JU3AG8FU115447', N'Мошенин Вангьял Денисович', N'Петров Август Абаянцев', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8NU4CC2B4143532', N'Вихров Бехруз Герасимович', N'Козачок Аарон Абалаков', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8NU4CC3CUA98427', N'Пупкин Венцеслав Зигмундович', N'Сергеев Аввакум Абашков', N'Hyundai', N'Veracruz')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8NU73C89U081484', N'Жмышенко Валерий Альбертович', N'Комаров Авнер Абдулов', N'Hyundai', N'Veracruz')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8NU73C974015488', N'Сергеев Афанасий Денисович', N'Смирнов Адонирам Абакишин', N'Hyundai', N'Veracruz')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SB73D06U039470', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Агриппа Абашин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SB73E06U086362', N'Пупкин Венцеслав Зигмундович', N'Сергеев Аввакум Абашков', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC12B42U136420', N'Вихров Бехруз Герасимович', N'Иванов Автандил Абашенко', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC13D764047866', N'Вихров Бехруз Герасимович', N'Козачок Автандил Абалдуев', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC13E234549432', N'Роганов Валентино Денисович', N'Сидоров Авдей Абдулин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC73D25U872179', N'Сергеев Афанасий Денисович', N'Смирнов Абдуллах Абабков', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC73D73M560064', N'Вихров Бехруз Герасимович', N'Ильин Авнер Аблакатов', N'Hyundai', N'Santa FE')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC73D82U137248', N'Пикаев Вильгельм Периклович', N'Петров Азамат Абатуров', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC73E15U984562', N'Жмышенко Валерий Альбертович', N'Комаров Агафангел Абалаков', N'Hyundai', N'Azera')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SC83D71U132417', N'Жмышенко Валерий Альбертович', N'Комаров Агафангел Абаимов', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SG13D27U108692', N'Сергеев Афанасий Денисович', N'Сидорова Агафия Сергеевна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SG73D67U131959', N'Залупкин Валентин Асафьевич', N'Лавров Агафон Абаянцев', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SH73E070018523', N'Пикаев Вильгельм Периклович', N'Петров Азамат Абакушин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SM4HF4GU149152', N'Вихров Бехруз Герасимович', N'Козачок Агафья Михайловна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KM8SR4HF8GU163234', N'Пикаев Вильгельм Периклович', N'Петрова Аделла Платоновна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHBT31G38U189577', N'Роганов Валентино Денисович', N'Сергеева Агафа Андреевна', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF21F5SU364562', N'Вихров Бехруз Герасимович', N'Вихров Адонирам Абашуров', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF24F4TU643403', N'Вихров Бехруз Герасимович', N'Зеленин Абдуллах Абаянцев', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF24T2SU378498', N'Вихров Бехруз Герасимович', N'Козачок Агафа Петровна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF24T4SU413431', N'Пупкин Венцеслав Зигмундович', N'Петрова Адельфина Михайловна', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF24T6TU555569', N'Агапов Владимир Сергеевич', N'Абрамова Азал Ивановна', N'Hyundai ', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF31T2SU125837', N'Жмышенко Валерий Альбертович', N'Комаров Автандил Абалдуев', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF34T2WU915995', N'Пупкин Венцеслав Зигмундович', N'Петухов Павел Андреевич', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF35G71U069373', N'Вихров Бехруз Герасимович', N'Зарипов Авель Абаимов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF35G72U197646', N'Вихров Бехруз Герасимович', N'Иванова Аза Павловна', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCF45G15U584428', N'Вихров Бехруз Герасимович', N'Иванов Абдуллах Абашенко', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCG35C21U088925', N'Вихров Бехруз Герасимович', N'Иванов Адар Абашенко', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCG35C914144987', N'Вихров Бехруз Герасимович', N'Иванов Адам Абаянцев', N'Hyundai', N'ACCENT GS')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCG45C444539587', N'Мирзалиев Вальдемар Агниеевич', N'Мошенин Абд аль-Узза Абакулин', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCG45C92U299742', N'Мирзалиев Вальдемар Агниеевич', N'Мошенин Абд аль-Узза Абалакин', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCG45LX1U190687', N'Вихров Бехруз Герасимович', N'Зарипов Авигдор Абабков', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCH41C85U635775', N'Вихров Бехруз Герасимович', N'Зарипов Авирмэд Абашенко', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCM36C08U077357', N'Мошенин Вангьял Денисович', N'Никитин Адриан Абаимов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCM36C08U104055', N'Роганов Валентино Денисович', N'Сергеев Азиз Абдулла', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCM3BC1BU198072', N'Пикаев Вильгельм Периклович', N'Петров Авл Абашин', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCM41C56U073802', N'Жмышенко Валерий Альбертович', N'Комаров Авксентий Абаимов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCM46C07U067819', N'Роганов Валентино Денисович', N'Сергеева Адель Ивановна', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCN35C074008777', N'Вихров Бехруз Герасимович', N'Иванов Агафон Абаянцев', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCN45C86U034709', N'Вихров Бехруз Герасимович', N'Иванов Аз Абакулин', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCT4AE3CU167404', N'Минаев Бехруз Зигмундович', N'Мирзалиев Аверкий Абдулла', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCT4AE8CU046657', N'Вихров Бехруз Герасимович', N'Зарипов Адам Абдулла', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHCT6AE2EU193135', N'Вихров Бехруз Герасимович', N'Зеленин Абид Абабков', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDC8AE0BH045134', N'Вихров Бехруз Герасимович', N'Ильин Агафон Абабков', N'Hyundai', N'ELANTRA TOURING GLS SE')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDH4AE3BU080168', N'Вихров Бехруз Герасимович', N'Вихрова Азал Дмитриевна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDH4AE7FU301308', N'Мошенин Вангьял Денисович', N'Никитин Адриан Абаимов', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDH4AH1FU306093', N'Агапов Владимир Сергеевич', N'Абдурозиков Валерий Альбертович', N'Hyundai ', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDM41D16U348725', N'Мошенин Вангьял Денисович', N'Петров Абд аль-Узза Аблакатов', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDM41D66U159844', N'Жмышенко Валерий Альбертович', N'Комаров Агафодор Абакулов', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDM45D72U388182', N'Пикаев Вильгельм Периклович', N'Петрова Адельфина Ивановна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDM46D44U735601', N'Сергеев Афанасий Денисович', N'Сидоров Агафангел Аббакумов', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDM55D72U048875', N'Агапов Владимир Сергеевич', N'Абрамов Авигдор Абдулла', N'Hyundai ', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDN45D03U661719', N'Вихров Бехруз Герасимович', N'Вихров Август Абашеев', N'Hyundai ', N'Elantra')
GO
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDN45D9YU000195', N'Пикаев Вильгельм Периклович', N'Петров Агафон Абашичев', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDN55D734101489', N'Пикаев Вильгельм Периклович', N'Петрова Агриппина Платоновна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDT41D08U238724', N'Мошенин Вангьял Денисович', N'Петров Авдей Аблеух', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDT45D08U284855', N'Залупкин Валентин Асафьевич', N'Лавров Август Абакушин', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDU45D77U034766', N'Залупкин Валентин Асафьевич', N'Лавров Адольф Абашков', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDU4AD4AU955646', N'Вихров Бехруз Герасимович', N'Зарипова Авдотья Павловна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHDU4AU5AU021480', N'Роганов Валентино Денисович', N'Сидоров Абдуллах Абдулин', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHEC4AU5CA026397', N'Пупкин Венцеслав Зигмундович', N'Сергеев Адиль Абашеев', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHFC45F060018217', N'Вихров Бехруз Герасимович', N'Зеленин Агафодор Абалкин', N'Hyundai', N'Azera')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHFC46F2XA222821', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Аги Абалкин', N'Hyundai', N'Azera')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGC4DD0D4216841', N'Вихров Бехруз Герасимович', N'Зарипов Адольф Абдулин', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGC4DE6AU073561', N'Сергеев Афанасий Денисович', N'Смирнова Агния Платоновна', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGC4DH1C4208507', N'Минаев Бехруз Зигмундович', N'Манюк Аглая Павловна', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGH4JH8E4080789', N'Вихров Бехруз Герасимович', N'Зарипов Агапит Абашуров', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGN4JE0FU101148', N'Сергеев Афанасий Денисович', N'Смирнов Адольф Абалакин', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGN4JE6FU016833', N'Мирзалиев Вальдемар Агниеевич', N'Мошенин Автоном Абатурин', N'Hyundai', N'Genesis')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHGV11D58U114311', N'Мошенин Вангьял Денисович', N'Никитина Адина Ивановна', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHM65D25U163122', N'Вихров Бехруз Герасимович', N'Вихров Аз Абакишин', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHM65D964226881', N'Пикаев Вильгельм Периклович', N'Петрова Адельфина Михайловна', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHM66D550151701', N'Вихров Бехруз Герасимович', N'Вихрова Адельфина Анатольевна', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHN65D76U189598', N'Залупкин Валентин Асафьевич', N'Манюк Аботур Абаимов', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHN65D85U159623', N'Вихров Бехруз Герасимович', N'Зеленина Аделия Павловна', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHHU6KH8C4065877', N'Вихров Бехруз Герасимович', N'Ильин Агапит Абалдуев', N'Hyundai', N'Genesis Coupe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHJF21M6SU904426', N'Минаев Бехруз Зигмундович', N'Манюк Аврора Андреевна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHJF24M9VU555164', N'Залупкин Валентин Асафьевич', N'Лавров Абдуллах Абашичев', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHJF32M9RU521773', N'Сергеев Афанасий Денисович', N'Сидорова Агафа Дмитриевна', N'Hyundai', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHJG24F3WU105106', N'Сергеев Афанасий Денисович', N'Смирнов Адриан Абакулин', N'Hyundai', N'Tiburon')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHJM81D06U249193', N'Сергеев Афанасий Денисович', N'Смирнов Адриан Абалаков', N'Hyundai', N'Tucson')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHLA21J3HU153646', N'Жмышенко Валерий Альбертович', N'Комаров Азамат Абатуров', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHLA31J1HU180141', N'Мирзалиев Вальдемар Агниеевич', N'Никитин Аарон Абашенко', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHLF11J6KU651908', N'Вихров Бехруз Герасимович', N'Зарипова Агапия Евгеньевна', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHLF31J4KU629658', N'Вихров Бехруз Герасимович', N'Козачок Автоном Абакумкин', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHLF32J8JU310258', N'Залупкин Валентин Асафьевич', N'Лавров Аббас Абакшин', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHNU81C28U064588', N'Пикаев Вильгельм Периклович', N'Петров Агафон Абашичев', N'Hyundai', N'Veracruz')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHSB81B26U039946', N'Роганов Валентино Денисович', N'Сидоров Аботур Абалдуев', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHSB81DX5U971960', N'Сергеев Афанасий Денисович', N'Сидоров Агафангел Абатуров', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHSB81E65U930282', N'Минаев Бехруз Зигмундович', N'Манюк Автандил Абалакин', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHSC72E060014843', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Аги Аблакатов', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHSK13E070014065', N'Роганов Валентино Денисович', N'Сергеева Агапа Евгеньевна', N'Hyundai', N'Santa Fe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHTC5AE6EU141047', N'Пупкин Венцеслав Зигмундович', N'Сергеев Адриан Абабков', N'Hyundai', N'Veloster')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVD14N0TU186704', N'Залупкин Валентин Асафьевич', N'Лавров Абид Абаимов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVD14N0X4441874', N'Агапов Владимир Сергеевич', N'Абрамов Автоном Абашеев', N'Hyundai ', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVD21N4WU292250', N'Жмышенко Валерий Альбертович', N'Комаров Агриппа Абашуров', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVE12J0M0015117', N'Минаев Бехруз Зигмундович', N'Манюк Агафия Андреевна', N'Hyundai', N'Scoupe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVE21J9MU015052', N'Вихров Бехруз Герасимович', N'Вихров Азиз Абашкин', N'Hyundai', N'Scoupe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVE22J0NU075348', N'Минаев Бехруз Зигмундович', N'Мирзалиев Авирмэд Абалкин', N'Hyundai', N'Scoupe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVE32N4PU127088', N'Минаев Бехруз Зигмундович', N'Мирзалиев Аботур Абдулла', N'Hyundai', N'Scoupe')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF11N1TU287510', N'Вихров Бехруз Герасимович', N'Ильин Абдуллах Абакумов', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF12J5PU804972', N'Залупкин Валентин Асафьевич', N'Лавров Агафон Абатурин', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF22J4PU698410', N'Вихров Бехруз Герасимович', N'Зарипов Авксентий Абалакин', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF22J9MU382822', N'Роганов Валентино Денисович', N'Сергеева Агапа Павловна', N'Hyundai', N'Excel')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF24N6VD356891', N'Роганов Валентино Денисович', N'Сергеева Адина Ивановна', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHVF24N6WU438380', N'Мирзалиев Вальдемар Агниеевич', N'Мирзалиев Адонирам Абашкин', N'Hyundai', N'Accent')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHWF25244A967947', N'Вихров Бехруз Герасимович', N'Козачок Адар Абдулов', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHWF25S62A668814', N'Вихров Бехруз Герасимович', N'Зарипов Агафодор Абашенко', N'Hyundai', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHWF25S85A132516', N'Агапов Владимир Сергеевич', N'Вихров Аба Абакумкин', N'Hyundai ', N'Sonata')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KMHWH81R09U098771', N'Пупкин Венцеслав Зигмундович', N'Сергеев Аввакум Абдулов', N'Hyundai', N'Hyundai')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'KNDMC223070018147', N'Роганов Валентино Денисович', N'Сидоров Авнер Абаянцев', N'Hyundai', N'Entourage')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'NULKMHDN46D94U676073L', N'Агапов Владимир Сергеевич', N'Абрамов Азат Абалаков', N'Hyundai ', N'Elantra')
INSERT [dbo].[ТранспортноеСредство] ([WINномер], [ФИОдиагност], [ФИОклиента], [Марка], [Модель]) VALUES (N'а', N'Агапов Владимир Сергеевич', N'Абдурозикова Валерия Альбертовна', N'Hyundai', N'а')
GO
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Антибактериальная обработка кондиционера', N'Кондиционеры и отопление', 10000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Аппаратная замена масла', N'Замена жидкостей', 5000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Аппаратная замена масла в АКПП', N'Замена жидкостей', 8120.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Балансировка', N'Ходовая', 3000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика', N'Комплексная', 2550.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика DSG', N'Диагностика', 8186.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика АБС', N'Диагностика', 7511.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика автомобиля перед покупкой', N'Диагностика', 7966.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика АКПП', N'Диагностика', 6921.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика вариатора', N'Диагностика', 5928.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика выхлопной системы', N'Диагностика', 7699.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика генератора', N'Диагностика', 7746.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика ГРМ', N'Диагностика', 4989.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика гур', N'Диагностика', 4263.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика двигателя', N'Диагностика', 6275.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика дизельного двигателя', N'Диагностика', 9106.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика климат контроля', N'Диагностика', 6127.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика кондиционера автомобиля', N'Диагностика', 8732.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика кондиционера автомобиля', N'Кондиционеры и отопление', 9499.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика лямбда зонда', N'Диагностика', 1573.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика МКПП', N'Диагностика', 5178.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика подвески', N'Диагностика', 6749.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика рулевого управления', N'Диагностика', 5165.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика рулевой рейки', N'Диагностика', 5508.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика системы охлаждения', N'Диагностика', 9570.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика стартера', N'Диагностика', 9308.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика сцепления', N'Диагностика', 3624.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика топливной системы', N'Диагностика', 3179.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика тормозной системы', N'Диагностика', 4260.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика турбины', N'Диагностика', 5382.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика фар', N'Диагностика', 1061.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика ходовой', N'Диагностика', 9511.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика шруса', N'Диагностика', 7897.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика эбу', N'Диагностика', 8152.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Диагностика электрооборудования автомобиля', N'Диагностика', 6007.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена антифриза', N'Замена жидкостей', 8848.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена бензинового двигателя', N'Двигатель', 7612.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена блока цилиндров', N'Двигатель', 7928.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена впускного коллектора', N'Выхлоп', 4000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена выпускного коллектора', N'Выхлоп', 4000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена гбц', N'Двигатель', 1667.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена глушителя', N'Выхлоп', 3000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена гофры глушителя', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена дизельного двигателя', N'Двигатель', 5453.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена жидкости ГУР', N'Замена жидкостей', 1479.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена испарителя', N'Кондиционеры и отопление', 4493.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена катализатора', N'Выхлоп', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена компрессора кондиционера автомобиля', N'Кондиционеры и отопление', 6060.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена лямбда зонда', N'Выхлоп', 2000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла', N'Двигатель', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла', N'Коробка', 2000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в DSG', N'Замена жидкостей', 3175.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в АКПП', N'Замена жидкостей', 5176.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в АКПП с промывкой', N'Замена жидкостей', 9186.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в вариаторе', N'Замена жидкостей', 9584.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в двигателе', N'Замена жидкостей', 6963.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в дифференциале', N'Замена жидкостей', 8016.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в МКПП', N'Замена жидкостей', 3349.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в мостах', N'Замена жидкостей', 7276.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в раздаточной коробке', N'Замена жидкостей', 9942.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена масла в редукторе', N'Замена жидкостей', 4145.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена маслосъемных колпачков', N'Двигатель', 1560.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена натяжителя приводного ремня', N'Кондиционеры и отопление', 9798.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена опоры двигателя', N'Двигатель', 1814.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена патрубков системы охлаждения', N'Кондиционеры и отопление', 7617.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена переднего сальника коленвала', N'Двигатель', 4523.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена пламегасителя', N'Выхлоп', 2000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена подушек двигателя', N'Двигатель', 9545.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена подшипника первичного вала', N'Двигатель', 3529.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена поршневых колец', N'Двигатель', 5452.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена приемной трубы глушителя', N'Выхлоп', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена прокладки клапанной крышки', N'Двигатель', 1506.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена радиатора кондиционера автомобиля', N'Кондиционеры и отопление', 8724.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена радиатора охлаждения', N'Кондиционеры и отопление', 3917.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена радиатора печки автомобиля', N'Кондиционеры и отопление', 7017.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена резонатора', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена ремня ГРМ', N'Двигатель', 7007.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена свечей накаливания', N'Двигатель', 7036.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена термостата', N'Кондиционеры и отопление', 7955.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена тормозной жидкости', N'Замена жидкостей', 8375.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена турбины', N'Двигатель', 5997.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена форсунки', N'Двигатель', 3418.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена цепи ГРМ', N'Двигатель', 2048.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена цепи ГРМ на 1.2 tsi', N'Двигатель', 2763.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена цепи ГРМ на 1.4 tsi', N'Двигатель', 1455.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена цепи ГРМ на 1.8 tsi', N'Двигатель', 8134.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замена цепи ГРМ на 2.0 tsi', N'Двигатель', 6918.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Замер компрессии в двигателе', N'Двигатель', 7048.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Заправка кондиционера в авто', N'Кондиционеры и отопление', 1635.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Капитальный ремонт бензинового двигателя', N'Двигатель', 6329.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Капитальный ремонт двигателя', N'Двигатель', 8424.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Капитальный ремонт дизельного двигателя', N'Двигатель', 6993.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Комплексная диагностика автомобиля', N'Диагностика', 5556.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Компьютерная диагностика автомобиля', N'Диагностика', 8490.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Кузовной ремонт', N'Комплекс', 10000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Опрессовка кондиционера автомобиля', N'Кондиционеры и отопление', 7557.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Подготовка к продаже', N'Комплекс', 5000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Промывка инжектора', N'Двигатель', 5873.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Промывка радиатора автомобиля', N'Кондиционеры и отопление', 4329.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Промывка форсунок', N'Двигатель', 5450.0000)
GO
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Развах-схождение', N'Ходовая', 1500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Регламентное ТО', N'Комлекс', 5000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Регулировка клапанов двигателя', N'Двигатель', 6108.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт автомобильных кондиционеров', N'Кондиционеры и отопление', 2528.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт бензиновых двигателей', N'Двигатель', 5197.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт блока цилиндров', N'Двигатель', 4860.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт вентилятора охлаждения двигателя', N'Кондиционеры и отопление', 4812.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт выхлопной системы', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт ГБЦ двигателя', N'Двигатель', 3601.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт глушителя', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт гофры глушителя', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт двигателя', N'Двигатель', 5000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт дизельных двигателей', N'Двигатель', 4035.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт дизельных турбин', N'Двигатель', 8438.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт дизельных форсунок', N'Двигатель', 9835.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт инжектора', N'Двигатель', 8320.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт карбюратора', N'Двигатель', 8409.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт катализаторов', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт климат контроля автомобиля', N'Кондиционеры и отопление', 2956.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт компрессора автомобиля', N'Кондиционеры и отопление', 9827.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт коробки', N'Коробка', 5000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт лямбда зонда', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт муфты компрессора автокондиционера', N'Кондиционеры и отопление', 4341.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт радиатора автомобиля', N'Кондиционеры и отопление', 4477.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт радиаторов охлаждения', N'Кондиционеры и отопление', 1395.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт распредвала', N'Двигатель', 2716.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт резонатора', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт тнвд бензинового двигателя', N'Двигатель', 1094.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт тнвд дизельного двигателя', N'Двигатель', 1856.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт турбин', N'Двигатель', 3740.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт форсунок', N'Двигатель', 2492.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт форсунок common rail', N'Двигатель', 8047.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Ремонт электрики', N'Салон', 1500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Сварка выпускных коллекторов', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Сварка глушителя
', N'Выхлоп', 500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Снятие/установка ГБЦ двигателя', N'Двигатель', 3456.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Тюнинг выхлопной системы', N'Выхлоп', 50000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Удаление катализатора', N'Выхлоп', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Удаление сажевого фильтра
', N'Выхлоп', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Установка пламегасителя', N'Выхлоп', 1000.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Химчистка', N'Химчистка салона', 2500.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Чистка дроссельной заслонки', N'Двигатель', 8930.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Чистка кондиционеров автомобиля', N'Кондиционеры и отопление', 2304.0000)
INSERT [dbo].[Услуга] ([Название], [Описание], [Стоимость]) VALUES (N'Экспресс замена масла в двигателе', N'Замена жидкостей', 6065.0000)
GO
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (1, N'Антибактериальная обработка кондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (2, N'Аппаратная замена масла')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (3, N'Аппаратная замена масла в АКПП')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (4, N'Балансировка')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (5, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (6, N'Диагностика DSG')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (7, N'Диагностика АБС')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (8, N'Диагностика автомобиля перед покупкой')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (9, N'Диагностика АКПП')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (10, N'Диагностика вариатора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (11, N'Диагностика выхлопной системы')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (12, N'Диагностика генератора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (13, N'Диагностика ГРМ')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (14, N'Диагностика гур')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (15, N'Диагностика двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (16, N'Диагностика дизельного двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (17, N'Диагностика климат контроля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (18, N'Диагностика кондиционера автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (19, N'Диагностика кондиционера автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (20, N'Диагностика лямбда зонда')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (21, N'Диагностика МКПП')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (22, N'Диагностика подвески')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (23, N'Диагностика рулевого управления')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (24, N'Диагностика рулевой рейки')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (25, N'Диагностика системы охлаждения')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (26, N'Диагностика стартера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (27, N'Диагностика сцепления')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (28, N'Диагностика топливной системы')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (29, N'Диагностика тормозной системы')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (30, N'Диагностика турбины')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (31, N'Диагностика фар')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (32, N'Диагностика ходовой')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (33, N'Диагностика шруса')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (34, N'Диагностика эбу')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (35, N'Диагностика электрооборудования автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (36, N'Замена антифриза')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (37, N'Замена бензинового двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (38, N'Замена блока цилиндров')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (39, N'Замена впускного коллектора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (40, N'Замена выпускного коллектора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (41, N'Замена гбц')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (42, N'Замена глушителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (43, N'Замена гофры глушителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (44, N'Замена дизельного двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (45, N'Замена жидкости ГУР')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (46, N'Замена испарителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (47, N'Замена катализатора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (48, N'Замена компрессора кондиционера автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (49, N'Замена лямбда зонда')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (50, N'Замена масла')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (51, N'Замена масла')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (52, N'Замена масла в DSG')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (53, N'Замена масла в АКПП')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (54, N'Замена масла в АКПП с промывкой')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (55, N'Замена масла в вариаторе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (56, N'Замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (57, N'Замена масла в дифференциале')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (58, N'Замена масла в МКПП')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (59, N'Замена масла в мостах')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (60, N'Замена масла в раздаточной коробке')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (61, N'Замена масла в редукторе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (62, N'Замена маслосъемных колпачков')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (63, N'Замена натяжителя приводного ремня')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (64, N'Замена опоры двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (65, N'Замена патрубков системы охлаждения')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (66, N'Замена переднего сальника коленвала')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (67, N'Замена пламегасителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (68, N'Замена подушек двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (69, N'Замена подшипника первичного вала')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (70, N'Замена поршневых колец')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (71, N'Замена приемной трубы глушителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (72, N'Замена прокладки клапанной крышки')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (73, N'Замена радиатора кондиционера автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (74, N'Замена радиатора охлаждения')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (75, N'Замена радиатора печки автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (76, N'Замена резонатора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (77, N'Замена ремня ГРМ')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (78, N'Замена свечей накаливания')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (79, N'Замена термостата')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (80, N'Замена тормозной жидкости')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (81, N'Замена турбины')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (82, N'Замена форсунки')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (83, N'Замена цепи ГРМ')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (84, N'Замена цепи ГРМ на 1.2 tsi')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (85, N'Замена цепи ГРМ на 1.4 tsi')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (86, N'Замена цепи ГРМ на 1.8 tsi')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (87, N'Замена цепи ГРМ на 2.0 tsi')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (88, N'Замер компрессии в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (89, N'Заправка кондиционера в авто')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (90, N'Капитальный ремонт бензинового двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (91, N'Капитальный ремонт двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (92, N'Капитальный ремонт дизельного двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (93, N'Комплексная диагностика автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (95, N'Кузовной ремонт')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (96, N'Опрессовка кондиционера автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (97, N'Подготовка к продаже')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (98, N'Промывка инжектора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (99, N'Антибактериальная обработка кондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (99, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (99, N'Промывка радиатора автомобиля')
GO
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (100, N'Промывка форсунок')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (101, N'Развах-схождение')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (102, N'Регламентное ТО')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (103, N'Регулировка клапанов двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (104, N'Ремонт автомобильных кондиционеров')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (105, N'Ремонт бензиновых двигателей')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (106, N'Ремонт блока цилиндров')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (107, N'Ремонт вентилятора охлаждения двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (108, N'Ремонт выхлопной системы')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (109, N'Ремонт ГБЦ двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (110, N'Ремонт глушителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (111, N'Ремонт гофры глушителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (112, N'Ремонт двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (113, N'Ремонт дизельных двигателей')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (114, N'Ремонт дизельных турбин')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (115, N'Ремонт дизельных форсунок')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (116, N'Ремонт инжектора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (117, N'Ремонт карбюратора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (118, N'Ремонт катализаторов')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (119, N'Ремонт климат контроля автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (120, N'Ремонт компрессора автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (121, N'Ремонт коробки')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (122, N'Ремонт лямбда зонда')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (123, N'Ремонт муфты компрессора автокондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (124, N'Ремонт радиатора автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (125, N'Ремонт радиаторов охлаждения')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (126, N'Ремонт распредвала')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (127, N'Ремонт резонатора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (128, N'Ремонт тнвд бензинового двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (129, N'Ремонт тнвд дизельного двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (130, N'Ремонт турбин')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (131, N'Ремонт форсунок')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (132, N'Ремонт форсунок common rail')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (133, N'Ремонт электрики')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (134, N'Сварка выпускных коллекторов')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (135, N'Сварка глушителя
')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (136, N'Снятие/установка ГБЦ двигателя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (137, N'Тюнинг выхлопной системы')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (138, N'Удаление катализатора')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (139, N'Удаление сажевого фильтра
')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (140, N'Установка пламегасителя')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (141, N'Чистка дроссельной заслонки')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (142, N'Антибактериальная обработка кондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (142, N'Диагностика гур')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (142, N'Чистка кондиционеров автомобиля')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (143, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (144, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (145, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (146, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (147, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (148, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (149, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (150, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (151, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (152, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (153, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (154, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (155, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (156, N'Антибактериальная обработка кондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (156, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (156, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (157, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (158, N'Экспресс замена масла в двигателе')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (159, N'Антибактериальная обработка кондиционера')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (159, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (162, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (163, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (164, N'Диагностика')
INSERT [dbo].[УслугиЗН] ([НомерНаряда], [НазваниеУслуги]) VALUES (165, N'Диагностика')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20221110-225430]    Script Date: 31/01/2023 20:40:49 ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20221110-225430] ON [dbo].[Работник]
(
	[Логин] ASC,
	[Пароль] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ЗаказНаряд] ADD  DEFAULT (getdate()) FOR [ДатаОформления]
GO
ALTER TABLE [dbo].[Запись] ADD  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Клиент] ADD  DEFAULT ('м') FOR [Пол]
GO
ALTER TABLE [dbo].[Работник] ADD  CONSTRAINT [DF__Работник__Стаж__267ABA7A]  DEFAULT ((1)) FOR [Стаж]
GO
ALTER TABLE [dbo].[Аналог]  WITH CHECK ADD  CONSTRAINT [FK__Аналог__НомерАна__3C69FB99] FOREIGN KEY([НомерАналога])
REFERENCES [dbo].[Деталь] ([Номер])
GO
ALTER TABLE [dbo].[Аналог] CHECK CONSTRAINT [FK__Аналог__НомерАна__3C69FB99]
GO
ALTER TABLE [dbo].[Аналог]  WITH CHECK ADD  CONSTRAINT [FK__Аналог__НомерДет__3B75D760] FOREIGN KEY([НомерДетали])
REFERENCES [dbo].[Деталь] ([Номер])
GO
ALTER TABLE [dbo].[Аналог] CHECK CONSTRAINT [FK__Аналог__НомерДет__3B75D760]
GO
ALTER TABLE [dbo].[ЗаказНаряд]  WITH CHECK ADD FOREIGN KEY([WINномер])
REFERENCES [dbo].[ТранспортноеСредство] ([WINномер])
GO
ALTER TABLE [dbo].[ЗаказНаряд]  WITH CHECK ADD  CONSTRAINT [FK__ЗаказНаря__ФИОсо__32E0915F] FOREIGN KEY([Механик])
REFERENCES [dbo].[Работник] ([ФИО])
GO
ALTER TABLE [dbo].[ЗаказНаряд] CHECK CONSTRAINT [FK__ЗаказНаря__ФИОсо__32E0915F]
GO
ALTER TABLE [dbo].[Запись]  WITH CHECK ADD FOREIGN KEY([ФИОклиент])
REFERENCES [dbo].[Клиент] ([ФИО])
GO
ALTER TABLE [dbo].[Расход]  WITH CHECK ADD  CONSTRAINT [FK__Расход__НомерДет__44FF419A] FOREIGN KEY([НомерДетали])
REFERENCES [dbo].[Деталь] ([Номер])
GO
ALTER TABLE [dbo].[Расход] CHECK CONSTRAINT [FK__Расход__НомерДет__44FF419A]
GO
ALTER TABLE [dbo].[Расход]  WITH CHECK ADD  CONSTRAINT [FK__Расход__НомерНар__45F365D3] FOREIGN KEY([НомерНаряда])
REFERENCES [dbo].[ЗаказНаряд] ([Номер])
GO
ALTER TABLE [dbo].[Расход] CHECK CONSTRAINT [FK__Расход__НомерНар__45F365D3]
GO
ALTER TABLE [dbo].[Смена]  WITH CHECK ADD  CONSTRAINT [FK__Смена__ДатаСмены__4F7CD00D] FOREIGN KEY([ДатаСмены])
REFERENCES [dbo].[День] ([Дата])
GO
ALTER TABLE [dbo].[Смена] CHECK CONSTRAINT [FK__Смена__ДатаСмены__4F7CD00D]
GO
ALTER TABLE [dbo].[Смена]  WITH CHECK ADD  CONSTRAINT [FK__Смена__ФИОраб__4E88ABD4] FOREIGN KEY([ФИОраб])
REFERENCES [dbo].[Работник] ([ФИО])
GO
ALTER TABLE [dbo].[Смена] CHECK CONSTRAINT [FK__Смена__ФИОраб__4E88ABD4]
GO
ALTER TABLE [dbo].[ТранспортноеСредство]  WITH CHECK ADD  CONSTRAINT [FK__Транспорт__ФИОди__2D27B809] FOREIGN KEY([ФИОдиагност])
REFERENCES [dbo].[Работник] ([ФИО])
GO
ALTER TABLE [dbo].[ТранспортноеСредство] CHECK CONSTRAINT [FK__Транспорт__ФИОди__2D27B809]
GO
ALTER TABLE [dbo].[ТранспортноеСредство]  WITH CHECK ADD FOREIGN KEY([ФИОклиента])
REFERENCES [dbo].[Клиент] ([ФИО])
GO
ALTER TABLE [dbo].[УслугиЗН]  WITH CHECK ADD FOREIGN KEY([НомерНаряда])
REFERENCES [dbo].[ЗаказНаряд] ([Номер])
GO
ALTER TABLE [dbo].[Деталь]  WITH CHECK ADD  CONSTRAINT [CK__Деталь__ЕдИзм__36B12243] CHECK  (([ЕдИзм]='Штука' OR [ЕдИзм]='Литр' AND [Количество]>=(0)))
GO
ALTER TABLE [dbo].[Деталь] CHECK CONSTRAINT [CK__Деталь__ЕдИзм__36B12243]
GO
ALTER TABLE [dbo].[ЗаказНаряд]  WITH CHECK ADD CHECK  (([Стоимость]>(0)))
GO
ALTER TABLE [dbo].[Клиент]  WITH CHECK ADD CHECK  (([Пол]='ж' OR [Пол]='м'))
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK__Работник__Должно__24927208] CHECK  (([Должность]='Директор' OR [Должность]='Менеджер' OR [Должность]='Механик'))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK__Работник__Должно__24927208]
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK__Работник__Стаж__25869641] CHECK  (([Стаж]>(0)))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK__Работник__Стаж__25869641]
GO
ALTER TABLE [dbo].[Расход]  WITH CHECK ADD  CONSTRAINT [CK__Расход__ЕдИзм__440B1D61] CHECK  (([ЕдИзм]='Штука' OR [ЕдИзм]='Литр'))
GO
ALTER TABLE [dbo].[Расход] CHECK CONSTRAINT [CK__Расход__ЕдИзм__440B1D61]
GO
ALTER TABLE [dbo].[Расход]  WITH CHECK ADD  CONSTRAINT [CK__Расход__Количест__4316F928] CHECK  (([Количество]>(0)))
GO
ALTER TABLE [dbo].[Расход] CHECK CONSTRAINT [CK__Расход__Количест__4316F928]
GO
/****** Object:  StoredProcedure [dbo].[account_data]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[account_data]
@name varchar(50)
AS
BEGIN
	select ДатаРождения,Должность,Зарплата,Стаж,Телефон,Логин,Пароль from Работник
	where ФИО = @name
END
GO
/****** Object:  StoredProcedure [dbo].[account_edit_data]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[account_edit_data]
	@fio varchar(50), @date date, @teleph bigint, @login varchar(10), @pass varchar(10) 
AS
BEGIN
	update Работник set ДатаРождения = @date, Телефон = @teleph, Логин = @login, Пароль = @pass where ФИО = @fio
END
GO
/****** Object:  StoredProcedure [dbo].[Add_detali_to_zakaz]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Add_detali_to_zakaz]
	@num_zakaz int, @count int, @format varchar(5),@discription varchar(50), @fab varchar(50), @series varchar(50)
AS
BEGIN
	declare @num_det int
	select @num_det = Номер from Деталь where Описание = @discription and Производитель = @fab and [Серийный номер] = @series
	insert into Расход values (@num_det, @num_zakaz, @count, @format)
	update Деталь set Количество = Количество - @count where Номер = @num_det 
END
GO
/****** Object:  StoredProcedure [dbo].[Add_new_client]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Add_new_client]
@fio varchar(50), @date date, @gender char(1), @tel bigint
AS
BEGIN
	insert into Клиент Values(@fio, @date, @gender, @tel)
END
GO
/****** Object:  StoredProcedure [dbo].[add_new_zakaz]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[add_new_zakaz]
	@num int, @name varchar(50), @win varchar(50),  @sost varchar(50), @cost money,@date date
AS
BEGIN
	insert into ЗаказНаряд (Номер, Механик, WINномер, СостояниеЗаказа,Стоимость,ДатаОформления) values (@num, @name, @win,  @sost, @cost, @date)
	insert into УслугиЗН values (@num,'Диагностика')
END
GO
/****** Object:  StoredProcedure [dbo].[add_service_to_zakaz]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[add_service_to_zakaz]
@num_zakaz int, @name_service varchar(50)
AS
BEGIN
	insert into УслугиЗН values(@num_zakaz,@name_service)
END
GO
/****** Object:  StoredProcedure [dbo].[admin_add_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[admin_add_detali]
@num int, @fab varchar(50), @series varchar(50),@description varchar(50), @count int, @EdIzm varchar(5), @cost money
AS
BEGIN
	insert into Деталь values (@num, @fab, @series, @description, @count, @EdIzm, @cost)
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_add_new_sort]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_add_new_sort]
@fio varchar(50), @date date, @state varchar(50), @salary money, @stage int, @teleph bigint, @login varchar(10), @pass varchar(10)
AS
BEGIN
	insert into Работник values(@fio, @date, @state, @salary, @stage, @teleph, @login, @pass)
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_add_service]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_add_service]
@name varchar(50), @description varchar(50), @cost money
AS
BEGIN
	insert into Услуга values(@name,@description,@cost)
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_edit_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_edit_detali]
@num int, @cost money
AS
BEGIN
	update Деталь set Стоимость = @cost where Номер = @num
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_edit_service]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Admin_edit_service]
@name varchar(50), @des varchar(50), @cost money 
AS
BEGIN
	update Услуга set Стоимость = @cost where Название = @name and Описание = @des
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_edit_sotr]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_edit_sotr]
@fio varchar(50), @pos varchar(50), @salary money 
AS
BEGIN
	update Работник set Должность = @pos, Зарплата = @salary where ФИО = @fio
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_list_of_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_list_of_detali]
AS
BEGIN
	select * from Деталь order by Описание, Производитель, [Серийный номер]
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_list_of_service]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_list_of_service]
AS
BEGIN
	select * from Услуга order by Название
END
GO
/****** Object:  StoredProcedure [dbo].[Admin_list_of_workers]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Admin_list_of_workers]
AS
BEGIN
	select * from Работник order by Должность, ФИО
END
GO
/****** Object:  StoredProcedure [dbo].[as_fio]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   PROCEDURE [dbo].[as_fio]
	 @isWoman bit = 0,
	 @withF bit = 1,
	 @withI bit = 1,
	 @withO bit = 1,
	 @res nvarchar(50) output
AS
BEGIN
	set @res = ''

	declare @fm nvarchar(max) = 'Иванов,Петров,Сидоров,Комаров,Смирнов,Сергеев,Никитин,Абрамов,Ильин,Лавров,Зеленин,Вихров,Козачок,Манюк,Зарипов,Мошенин,Мирзалиев'
	declare @im nvarchar(256) = 'Кирилл,Евгений,Семен,Владимир,Антон,Павел,Александр,Николай,Петр,Илья,Альберт,Захар,Роман,Никита,Даниил,Сергей,Платон,Рамен '
	declare @om nvarchar(256) = 'Петрович,Анатольевич,Дмитриевич,Иванович,Сергеевич,Павлович,Ильич,Михайлович,Кириллович,Андреевич,Платонович,Евгеньевич'

	declare @fw nvarchar(max) = 'Иванова,Петрова,Сидорова,Комарова,Смирнова,Сергеева,Никитина,Абрамова,Ильина,Лаврова,Зеленина,Вихрова,Козачок,Манюк,Зарипова,Мошенина,Мирзалиева'
	declare @iw nvarchar(256) = 'Ольга,Ирина,Яна,Жанна,Наталья,Марина,Мария,Елизавета,Евгения,Ксения,Оксана,Елена,Полина,Светлана,Ева'
	declare @ow nvarchar(256) = 'Петровна,Анатольевна,Дмитриевна,Ивановна,Сергеевна,Павловна,Михайловна,Кирилловна,Андреевна,Платоновна,Евгеньевна'


	declare @f nvarchar(max) = iif(@isWoman=1,  @fw,  @fm)
	declare @i nvarchar(max) = iif(@isWoman=1,  @iw,  @im)
	declare @o nvarchar(max) = iif(@isWoman=1,  @ow,  @om)

	if(@withF=1) begin
		set @res = @res + iif(@res='', '', ' ') 
	end
	if(@withI=1) begin
		set @res = @res + iif(@res='', '', ' ') 
	end
	if(@withO=1) begin
		set @res = @res + iif(@res='', '', ' ') 
	end

	select @res
END
GO
/****** Object:  StoredProcedure [dbo].[as_fioGenerator]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[as_fioGenerator]
	 @isWoman bit = 0,
	 @withF bit = 1,
	 @withI bit = 1,
	 @withO bit = 1
AS
BEGIN
	declare @res nvarchar(max) = ''

	declare @fm nvarchar(max) = 'Иванов,Петров,Сидоров,Комаров,Смирнов,Сергеев,Никитин,Абрамов,Ильин,Лавров,Зеленин,Вихров,Козачок,Манюк,Зарипов,Мошенин,Мирзалиев, Дудаев, Пикаев, Минаев, Забаев, Гадукин'
	declare @im nvarchar(256) = 'Анатолий,Ангеляр,Андокид,Андрей,Атанасий,Атом,Аттик,Афанасий,Бартоломео,Берт,Бехруз,Билял,Богдан,Болеслав,Бямбасурэн,Вадим,Валентин,Валентино,Валерий,Валерьян,Вальдемар,Вангьял,Варлам,Венцеслав,Вигго,Викентий,Виктор,Викторин,Вильгельм,Винцас,Владлен,Влас,Воислав,Володарь,Вольфганг,Вописк,Всеволод,Всеслав,Вук,Вукол,Вышеслав,Вячеслав,Габриеле,Гавриил,Гай,Галактион,Галымжан,Гамлет,Гаспар,Гафур,Гвидо,Гейдар,Геласий,Гелий,Гельмут,Геннадий,Генри,Генрих,Георге,Георгий,Гераклид,Герасим,Герберт,Герман,Германн,Геронтий,Герхард,Гийом,Гильем,Гинкмар,Глеб,Гней,Гоар,Горацио,Гордей,Градислав,Григорий,Гримоальд,Гуго,Гурий,Густав,Гьялцен,Давид,Дамдинсурэн,Дамир,Даниил,Дарий,Демид,Демьян,Денеш,Денис,Децим,Джаббар,Джамиль,Джан,Джанер,Джанфранко,Джафар,Джейкоб,Джихангир,Джованни,Джон,Джохар,Джулиано,Джулиус,Дино,Диодор,Дитер,Дитмар,Дитрих,Дмитрий,Доминик,Дональд,Донат,Дорофей,Досифей,Евгений,Евграф,Евдоким,Еврит,Евсей,Евстафий,Евтихан,Евтихий,Егор,Елеазар,Елисей,Емельян,Епифаний,Ербол,Ерванд,Еремей,Ермак,Ермолай,Ерофей,Ефим,Ефрем,Жан,Ждан,Жером,Жоан,Захар,Захария,Збигнев,Зденек,Зейналабдин,Зенон,Зеэв,Зигмунд,Зинон,Зия,Золтан,Зосима,Иакинф,Иан,Ибрагим,Ибрахим,Иван,Игнатий,Игорь,Иероним,Иерофей,Израиль,Икрима,Иларий,Илия,Илларион,Илмари,Ильфат,Илья,Имран,Иннокентий,Иоаким,Иоанн,Иоанникий,Иоахим,Иов,Иоганн,Иоганнес,Ионафан,Иосафат,Ираклий,Иржи,Иринарх,Ириней,Иродион,Иса,Исаак,Исаакий,Исаия,Исидор,Ислам,Исмаил,Истислав,Истома,Истукарий,Иштван,Йюрген,Кадваллон,Кадир,Казимир,Каликст,Калин,Каллистрат,Кальман,Канат,Карен,Карлос,Карп,Картерий,Кассиан,Кассий,Касторий,Касьян,Катберт,Квинт,Кехлер,Киллиан,Ким,Кир,Кириак,Кирилл,Клаас,Клавдиан,Клеоник,Климент,Кондрат,Конон,Конрад,Константин,Корнелиус,Корнилий,Коррадо,Косьма,Кратет,Кратипп,Крис,Криспин,Кристиан,Кронид,Кузьма,Куприян,Курбан,Курт,Кутлуг-Буга,Кэлин,Лаврентий,Лавс,Ладислав,Лазарь,Лайл,Лампрехт,Ландульф,Лев,Леви,Ленни,Леонид,Леонтий,Леонхард,Лиам,Линкей,Логгин,Лоренц,Лоренцо,Луи,Луитпольд,Лука,Лукас,Лукий,Лукьян,Луций,Людовик,Люцифер,Макар,Максим,Максимиан,Максимилиан,Малик,Малх,Мамбет,Маний,Мануил,Мануэль,Мариан,Мариус,Марк,Маркел,Мартын,Марчелло,Матвей,Матео,Матиас,Матфей,Матфий,Махмуд,Меир,Мелентий,Мелитон,Менахем-Мендель,Месроп,Мефодий,Мечислав,Мика,Микеланджело,Микулаш,Милорад,Мина,Мирко,Мирон,Мирослав,Митрофан,Михаил,Михей,Младан,Модест,Моисей,Мордехай,Мстислав,Мурад,Мухаммед,Мэдисон,Мэлор,Мэлс,Назар,Наиль,Насиф,Натан,Натаниэль,Наум,Нафанаил,Нацагдорж,Нестор,Никандр,Никанор,Никита,Никифор,Никодим,Николай,Нил,Нильс,Ноа,Ной,Норд,Нуржан,Нурлан,Овадья,Оге,Одинец,Октав,Октавиан,Октавий,Октавио,Олаф,Оле,Олег,Оливер,Ольгерд,Онисим,Орест,Осип,Оскар,Осман,Отто,Оттон,Очирбат,Пабло,Павел,Павлин,Павсикакий,Паисий,Палладий,Панкратий,Пантелеймон,Папа,Паруйр,Парфений,Патрик,Пафнутий,Пахомий,Педро,Пётр,Пимен,Пинхас,Пипин,Питирим,Пол,Полидор,Полиевкт,Поликарп,Поликрат,Порфирий,Потап,Предраг,Премысл,Приск,Прокл,Прокопий,Прокул,Протасий,Прохор,Публий,Рагнар,Рагуил,Радмир,Радослав,Разумник,Раймонд,Рамадан,Рамазан,Рахман,Рашад,Рейнхард,Ренат,Реститут,Ричард,Роберт,Родерик,Родион,Рожер,Розарио,Роман,Ромен,Рон,Ронан,Ростислав,Рудольф,Руслан,Руф,Руфин,Рушан,Сабит,Савва,Савватий,Савелий,Савин,Саддам,Садик,Саид,Салават,Салих,Саллюстий,Салман,Самуил,Сармат,Святослав,Севастьян,Северин,Секст,Секунд,Семён,Септимий,Серапион,Сергей,Серж,Сигеберт,Сильвестр,Симеон,Симон,Созон,Соломон,Сонам,Софрон,Спиридон,Срджан,Станислав,Степан,Стефано,Стивен,Таврион,Тавус,Тадеуш,Тарас,Тарасий,Тейс,Тендзин,Теофил,Терентий,Терри,Тиберий,Тигран,Тимофей,Тимур,Тихомир,Тихон,Томас,Томоми,Торос,Тофик,Трифон,Трофим,Тудхалия,Тутмос,Тьерри,Тьяго,Уве,Уильям,Улдис,Ульрих,Ульф,Умар,Урызмаг,Усама,Усман,Фавст,Фаддей,Файзулла,Фарид,Фахраддин,Федериго,Федосей,Федот,Фейсал,Феликс,Феоктист,Феофан,Феофил,Феофилакт,Фердинанд,Ференц,Фёдор,Фидель,Филарет,Филат,Филип,Филипп,Философ,Филострат,Фирс,Фока,Фома,Фотий,Франц,Франческо,Фредерик,Фридрих,Фродо,Фрол,Фульк,Хайме,Ханс,Харальд,Харитон,Харри,Харрисон,Хасан,Хетаг,Хильдерик,Хирам,Хлодвиг,Хокон,Хорив,Хоселито,Хосрой,Хрисанф,Христофор,Хуан,Цэрэндорж,Чеслав,Шалом,Шамиль,Шамсуддин,Шапур,Шарль,Шейх-Хайдар,Шон,Эберхард,Эдмунд,Эдна,Эдуард,Элбэгдорж,Элджернон,Элиас,Эллиот,Эмиль,Энрик,Энрико,Энтони,Эразм,Эраст,Эрик,Эрнст,Эсекьель,Эстебан,Этьен,Ювеналий,Юлиан,Юлий,Юлиус,Юрий,Юстас,Юстин,Яков,Якуб,Якун,Ян,Яни,Януарий,Яромир,Ярополк,Ярослав,
'	declare @om nvarchar(256) = 'Анатольевич, Кириллович, Прохорович, Семенович, Андреевич, Платонович, Герасимович, Павлович, Денисович, Евгеньевич, Натанович, Агниеевич, Сергеевич, Зигмундович, Периклович'

	declare @fw nvarchar(max) = 'Иванова,Петрова,Сидорова,Комарова,Смирнова,Сергеева,Никитина,Абрамова,Ильина,Лаврова,Зеленина,Вихрова,Козачок,Манюк,Зарипова,Мошенина,Мирзалиева'
	declare @iw nvarchar(256) = 'Бабетта,Багдагуль,Барбара,Беата,Беатриса,Белла,Бенедикта,Береслава,Бернадетта,Берта,Бибиана,Биргит,Бирута,Бландина,Бланка,Богдана,Божена,Болеслава,Борислава,Ботогоз,Бояна,Бригитта,Бронислава,Бруна,Валенсия,Валентина,Валерия,Валида,Валия,Ванда,Варвара,Варя,Васёна,Васила,Василида,Василина,Василиса,Василия,Василла,Васса,Вацлава,Вевея,Веджиха,Велимира,Велислава,Венедикта,Венера,Венуста,Венцеслава,Вера,Вербния,Вереника,Вероника,Веселина,Веста,Вестита,Вета,Вива,Вивея,Вивиана,Вида,Видина,Викентия,Виктбрия,Викторина,Виктория,Вила,Вилена,Виленина,Вилора,Вильгельмина,Виолетта,Виргиния,Виринея,Вита,Виталика,Виталина,Виталия,Витольда,Влада,Владилена,Владимира,Владислава,Владлена,Воислава,Воля,Всеслава,Габриэлла,Гаджимет,Газама,Гала,Галата,Галатея,Гали,Галима,Галина,Галла,Галя,Гая,Гаянэ,Геласия,Гелена,Гелла,Гемелла,Гемина,Гения,Геннадия,Геновефа,Генриетта,Георгина,Гера,Германа,Гертруда,Гея,Гизелла,Глафира,Гликерия,Глорибза,Глория,Голиндуха,Гольпира,Гонеста,Гонората,Горгония,Горислава,Гортензия,Градислава,Гражина,Грета,Гулара,Гульмира,Гульназ,Гульнара,Гюзель,Дайна,Далила,Далия,Дамира,Дана,Даная,Даниэла,Данута,Дариа,Дарина,Дария,Дарья,Дастагуль,Дебора,Деена,Декабрена,Денесия,Денница,Дея,Джамиля,Джана,Джафара,Джемма,Джулия,Джульетта,Диана,Дигна,Диля,Диляра,Дина,Динара,Диодора,Дионина,Дионисия,Дия,Доброгнева,Добромила,Добромира,Доброслава,Доля,Доминика,Домитилла,Домна,Домника,Домникия,Домнина,Донара,Доната,Дора,Доротея,Дорофея,Доса,Досифея,Дросида,Дуклида,Ева,Евангелина,Еванфия,Евгения,Евдокия,Евдоксия,Евлалия,Евлампия,Евмения,Евминия,Евника,Евникия,Евномия,Евпраксия,Евсевия,Евстафия,Евстолия,Евтихия,Евтропия,Евфалия,Евфимия,Евфросиния,Екатерина,Елена,Елизавета,Еликонида,Епистима,Епистимия,Ермиония,Есения,Ефимия,Ефимья,Ефросиния,Ефросинья,Жанна,Жеральдина,Жозефина,Забава,Заира,Замира,Зара,Зарема,Зари,Зарина,Зарифа,Звезда,Земфира,Зенона,Зина,Зинаида,Зинат,Зиновия,Зита,Злата,Зоя,Зульфия,Зураб,Зухра,Ива,Иванна,Иветта,Ивона,Ида,Идея,Изабелла,Изида,Изольда,Илария,Илзе,Илия,Илона,Ильина,Ильмира,Инара,Инга,Инесса,Инна,Иоанна,Иовилла,Иола,Иоланта,Ипполита,Ирада,Ираида,Ирена,Ирина,Ирма,Исидора,Ифигения,Июлия,Ия,Каздоя,Казимира,Калерия,Калида,Калиса,Каллиникия,Каллиста,Каллисфения,Кама,Камила,Камилла,Кандида,Капитолина,Карима,Карина,Каролина,Касиния,Катарина,Келестина,Керкира,Кетевань,Кикилия,Кима,Кира,Кириакия,Кириана,Кирилла,Кирьяна,Клавдия,Клара,Клариса,Клементина,Клена,Клеопатра,Климентина,Клотильда,Конкордия,Констанция,Консуэлла,Кора,Корнелия,Кристина,Ксаверта,Ксанфиппа,Ксения,Купава,Лавиния,Лавра,Лада,Лайма,Лариса,Латафат,Лаура,Лебния,Леда,Лейла,Лемира,Ленина,Леокадия,Леонида,Леонила,Леонина,Леонтина,Леся,Летиция,Лея,Лиана,Ливия,Лидия,Лилиана,Лилия,Лина,Линда,Лира,Лия,Лола,Лолита,Лонгина,Лора,Лота,Луиза,Лукерья,Лукиана,Лукия,Лукреция,Любава,Любовь,Любомила,Любомира,Людмила,Люсьена,Люцина,Люция,Мавра,Магда,Магдалена,Магдалина,Магна,Мадина,Мадлена,Маина,Майда,Майя,Макрина,Максима,Малания,Малика,Малина,Малинья,Мальвина,Мамелфа,Манана,Манефа,Мануэла,Маргарита,Мариам,Мариамна,Мариана,Марианна,Мариетта,Марина,Маринэ,Марионелла,Марионилла,Марица,Мариэтта,Мария,Марка,Маркеллина,Маркиана,Марксина,Марлена,Марселина,Марта,Мартина,Мартиниана,Марфа,Марьина,Марья,Марьям,Марьяна,Мастридия,Матильда,Матрёна,Матрона,Мая,Медея,Мелания,Меланья,Мелитика,Меркурия,Мерона,Милана,Милена,Милица,Милия,Милослава,Милютина,Мина,Минна,Минодора,Мира,Мирдза,Миропия,Мирослава,Мирра,Митродора,Михайлина,Михалина,Млада,Модеста,Моика,Моника,Мстислава,Муза,Мэрилант,Нада,Надежда,Назира,Наиля,Наина,Нана,Наркисса,Настасия,Настасья,Наталия,Наталья,Нателла,Нелли,Ненила,Неонила,Нида,Ника,Нила,Нимфа,Нимфодора,Нина,Нинель,Новелла,Нонна,Нора,Норгул,Ноэми,Ноябрина,Нунехия,Одетта,Оксана,Октавия,Октябрина,Олдама,Олеся,Оливия,Олимпиада,Олимпиодора,Олимпия,Ольвия,Ольга,Ольда,Офелия,Павла,Павлина,Паисия,Паллада,Паллидия,Пальмира,Памела,Параскева,Патрикия,Патриция,Паула,Паулина,Пелагея,Перегрина,Перпетуя,Петра,Петрина,Петронилла,Петрония,Пиама,Пинна,Плакида,Плакилла,Платонида,Победа,Полактия,Поликсена,Поликсения,Полина,Поплия,Правдина,Прасковья,Препедигна,Прискилла,Просдока,Пульхерия,Пульхерья,Рада,Радана,Радислава,Радмила,Радомира,Радосвета,Радослава,Радость,Раиса,Рафаила,Рахиль,Рашам,Ревекка,Ревмира,Регина,Резета,Рема,Рената,Римма,Рипсимия,Роберта,Рогнеда,Роза,Розалина,Розалинда,Розалия,Розамунда,Розина,Розмари,Роксана,Романа,Ростислава,Ружена,Рузана,Румия,Русана,Русина,Руслана,Руфина,Руфиниана,Руфь,Сабина,Савватия,Савелла,Савина,Саида,Саломея,Салтанат,Самона,Сания,Санта,Сарра,Сатира,Светислава,Светлана,Светозара,Святослава,Севастьяна,Северина,Секлетея,Секлетинья,Селена,Селестина,Селина,Серафима,Сибилла,Сильва,Сильвана,Сильвестра,Сильвия,Сима,Симона,Синклитикия,Сиотвия,Сира,Слава,Снандулия,Снежана,Созия,Сола,Соломонида,Сосипатра,София,Софрония,Софья,Сталина,Станислава,Стелла,Степанида,Стефанида,Стефания,Сусанна,Суфия,Сюзанна,Тавифа,Таира,Таисия,Таисья,Тала,Тамара,Тарасия,Татьяна,Тахмина,Текуса,Теодора,Тереза,Тигрия,Тина,Тихомира,Тихослава,Тома,Томила,Транквиллина,Трифена,Трофима,Улдуза,Улита,Ульяна,Урбана,Урсула,Устина,Устиния,Устинья,Фабиана,Фавста,Фавстина,Фаиза,Фаина,Фанни,Фантика,Фаня,Фарида,Фатима,Фая,Фебния,Феврония,Февронья,Федоза,Федора,Федосия,Федосья,Федотия,Федотья,Федула,Фекла,Фекуса,Феликса,Фелица,Фелицата,Фелициана,Фелицитата,Фелиция,Феогния,Феодора,Феодосия,Феодота,Феодотия,Феодула,Феодулия,Феозва,Феоктиста,Феона,Феонилла,Феопистия,Феосовия,Феофания,Феофила,Фервуфа,Феруза,Фессалоника,Фессалоникия,Фетиния,Фетинья,Фея,Фёкла,Фива,Фивея,Филарета,Филиппа,Филиппин,Филиппина,Филомена,Филонилла,Филофея,Фиста,Флавия,Флёна,Флора,Флорентина,Флоренция,Флориана,Флорида,Фомаида,Фортуната,Фотина,Фотиния,Фотинья,Франсуаза,Франциска,Франческа,Фредерика,Фрида,Фридерика,Хаврония,Халима,Хариесса,Хариса,Харита,Харитина,Хильда,Хильдегарда,Хиония,Хриса,Хрисия,Христиана,Христина,Христя,Цвета,Цветана,Целестина,Цецилия,Чеслава,Чулпан,Шангуль,Шарлотта,Ширин,Шушаника,Эвелина,Эгина,Эдда,Эдит,Эдита,Элахе,Элеонора,Элиана,Элиза,Элизабет,Элина,Элисса,Элла,Эллада,Эллина,Элоиза,Эльвира,Эльга,Эльза,Эльмира,Эмилиана,Эмилия,Эмма,Эннафа,Эра,Эрика,Эрнеста,Эрнестина,Эсмеральда,Эстер,Эсфирь,Юдита,Юдифь,Юзефа,Юлдуз,Юлиана,Юлиания,Юлия,Юна,Юния,Юнона,Юрия,Юстина,Юханна,Ядвига,Яна,Янина,Янита,Янка,Янсылу,Ярослава'
	declare @ow nvarchar(256) = 'Петровна,Анатольевна,Дмитриевна,Ивановна,Сергеевна,Павловна,Михайловна,Кирилловна,Андреевна,Платоновна,Евгеньевна, Прохоровна, Семеновна, Андреевна, Платоновна, Герасимовна, Павловна, Денисовна, Евгеньевна, Натановна, Агниеевна, Сергеевна, Зигмундовна, Перикловна'


	declare @f nvarchar(max) = iif(@isWoman=1,  @fw,  @fm)
	declare @i nvarchar(max) = iif(@isWoman=1,  @iw,  @im)
	declare @o nvarchar(max) = iif(@isWoman=1,  @ow,  @om)


	if(@withF=1) begin
		set @res = @res + iif(@res='', '', ' ') + (select top 1 Value from dbo.split(@f,',') order by newid())
	end
	if(@withI=1) begin
		set @res = @res + iif(@res='', '', ' ') + (select top 1 Value from dbo.split(@i,',') order by newid())
	end
	if(@withO=1) begin
		set @res = @res + iif(@res='', '', ' ') + (select top 1 Value from dbo.split(@o,',') order by newid())
	end

	select @res
END
GO
/****** Object:  StoredProcedure [dbo].[diagnostic_cost]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[diagnostic_cost]
@cost int output
AS
BEGIN
	select @cost = Стоимость  from Услуга where Название = 'Диагностика' 
END
GO
/****** Object:  StoredProcedure [dbo].[Edit_zakaz]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Edit_zakaz]
		@name varchar(50), @sost varchar(50), @cost money,@date date, @num int
AS
BEGIN
	update ЗаказНаряд set Механик=@name,СостояниеЗаказа=@sost,Стоимость=@cost,ДатаОкончания=@date
	where Номер = @num
END

GO
/****** Object:  StoredProcedure [dbo].[filter_wincode]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[filter_wincode]
	@win varchar(10)
AS
BEGIN
	select WINномер from ТранспортноеСредство where WINномер like @win + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[last_num]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[last_num]
	-- Add the parameters for the stored procedure here
	@num int output
AS
BEGIN
	select @num = (max(Номер)+1) from ЗаказНаряд 
END
GO
/****** Object:  StoredProcedure [dbo].[last_num_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[last_num_detali]
	@num int output
AS
BEGIN
	select @num = (max(Номер)+1) from Деталь 
END
GO
/****** Object:  StoredProcedure [dbo].[last_num_zapisi]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[last_num_zapisi]
@num int output
AS
BEGIN
	select @num = (max(idЗаписи)+1) from Запись
END
GO
/****** Object:  StoredProcedure [dbo].[list_of_days]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[list_of_days]
@name varchar(50)
AS
BEGIN
	select Смена.ФИОраб, Смена.ДатаСмены, День.ЧасыРаботы  from Смена
	join День on День.Дата = Смена.ДатаСмены
	where Смена.ФИОраб = @name
END
GO
/****** Object:  StoredProcedure [dbo].[list_of_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[list_of_detali]
	@number int
AS
BEGIN
	select  Деталь.Описание as [Затраченная деталь], Деталь.Производитель,Деталь.[Серийный номер] ,Расход.Количество, Деталь.Стоимость from Расход 
	join ЗаказНаряд on ЗаказНаряд.Номер = Расход.НомерНаряда
	join Деталь on Расход.НомерДетали = Деталь.Номер
	where ЗаказНаряд.Номер = @number
END
GO
/****** Object:  StoredProcedure [dbo].[list_of_service]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[list_of_service]
@number int
AS
BEGIN
	select УслугиЗН.НазваниеУслуги as [Название услуги], Услуга.Стоимость from УслугиЗН 
	join ЗаказНаряд on УслугиЗН.НомерНаряда = ЗаказНаряд.Номер
	join Услуга on Услуга.Название = УслугиЗН.НазваниеУслуги
	where ЗаказНаряд.Номер = @number
	
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_add_new_zapisi]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_add_new_zapisi]
@num int, @fio varchar(50), @date date
AS
BEGIN
	insert into Запись values(@num,@fio,@date)
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_delete_zapisi]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_delete_zapisi]
@num int
AS
BEGIN
	delete from Запись where idЗаписи = @num
END
GO
/****** Object:  StoredProcedure [dbo].[manager_edit_client]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[manager_edit_client]
@fio varchar(50),@date date,@gender char(1),@teleph bigint
AS
BEGIN
	update Клиент set ДатаРождения = @date, Пол = @gender, Телефон = @teleph 
	where ФИО = @fio
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_list_of_clients]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_list_of_clients]
AS
BEGIN
	select * from Клиент order by ФИО
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_list_of_zakaz]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_list_of_zakaz]
AS
BEGIN
	select 
	ЗаказНаряд.Номер, ЗаказНаряд.Механик, ЗаказНаряд.WINномер,
	ЗаказНаряд.СостояниеЗаказа,ЗаказНаряд.ДатаОформления,
	ЗаказНаряд.ДатаОкончания,ЗаказНаряд.Стоимость, ТранспортноеСредство.ФИОклиента, ТранспортноеСредство.Марка, ТранспортноеСредство.Модель
	from ЗаказНаряд 
	join ТранспортноеСредство on ЗаказНаряд.WINномер = ТранспортноеСредство.WINномер
	order by ЗаказНаряд.СостояниеЗаказа
end
GO
/****** Object:  StoredProcedure [dbo].[Manager_list_of_zapisi]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_list_of_zapisi]
AS
BEGIN
	select * from Запись where DATEADD(day, 1, Дата) >= getdate()
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_list_of_zapisi_actual]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Manager_list_of_zapisi_actual]
AS
BEGIN
	select * from Запись where Дата < getdate()
END
GO
/****** Object:  StoredProcedure [dbo].[Manager_update_zapasi]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Manager_update_zapasi]
@num int, @date date
AS
BEGIN
	update Запись set Дата = @date where idЗаписи = @num
END
GO
/****** Object:  StoredProcedure [dbo].[Mechanic_list_of_cars]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Mechanic_list_of_cars]
AS
BEGIN
	select * from ТранспортноеСредство
END
GO
/****** Object:  StoredProcedure [dbo].[Mechanic_list_of_orders]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Mechanic_list_of_orders]
	-- Add the parameters for the stored procedure here
	@name varchar(50)
AS
BEGIN
	select Номер, Механик, WINномер, СостояниеЗаказа, Стоимость, ДатаОформления,ДатаОкончания from ЗаказНаряд
	where Механик = @name and СостояниеЗаказа <> 'Завершён'
END
GO
/****** Object:  StoredProcedure [dbo].[Mechanic_new_car]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Mechanic_new_car]
@win varchar(50), @fioMech varchar(50), @fioClient varchar(50), @fab varchar(50), @model varchar(50)
AS
BEGIN
	insert into ТранспортноеСредство values(@win, @fioMech , @fioClient , @fab, @model)
END
GO
/****** Object:  StoredProcedure [dbo].[Mechanic_update_count_detali]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Mechanic_update_count_detali]
@num int, @count int
AS
BEGIN
	update Деталь set Количество = Количество + @count where Номер = @num
END
GO
/****** Object:  StoredProcedure [dbo].[Архив]    Script Date: 31/01/2023 20:40:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Архив]
	-- Add the parameters for the stored procedure here
	@name varchar(50)
AS
BEGIN
	select Номер, WINномер, СостояниеЗаказа, Стоимость, ДатаОформления,ДатаОкончания from ЗаказНаряд
	where Механик = @name and СостояниеЗаказа = 'Завершён'
END
GO
USE [master]
GO
ALTER DATABASE [Autoservice] SET  READ_WRITE 
GO
