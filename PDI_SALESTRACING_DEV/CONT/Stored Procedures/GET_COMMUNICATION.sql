-- =============================================
-- Author:		Krunal Trivedi
-- Create date: 01/21/2019
-- Description:	communication feedback page
-- =============================================
CREATE PROCEDURE CONT.GET_COMMUNICATION
 @user1_fullname  nvarchar(255)=null,
 @user1_date  varchar(11)=null,
 @user1_comm [varchar](4000)=null,
 @user1_comm_id int=null,
 @res1_name nvarchar(255)=null,
 @res1_date varchar(11)=null,
 @res1_comm [varchar](4000)=null,
 @res1_comm_res_id int=null,
 @res2_name nvarchar(255)=null,
 @res2_date varchar(11)=null,
 @res2_comm [varchar](4000)=null,
 @res2_comm_res_id int=null,
@cont varchar (20)=NULL
AS
BEGIN
	
	SET NOCOUNT ON;

    DROP TABLE IF EXISTS #us1
select  c.[USR_FULL_NM] as full_name,a.COMM_DTTS,a.COMM ,a.COMM_ID
into #us1
from cont.COMMUNICATION a
  
inner join [PCM].[PCM_USER] c on a.COMM_BY_USR_ID_FK=c.[USR_ID] and a.COMM_USR_ID=c.[USR_LOGIN_NM] 
--inner join [CONT].[COMM_RESP] b on a.comm_id=b.COMM_ID_FK 
where a.CNTXT=@cont

set @user1_fullname=(select full_name  from #us1)
set @user1_comm_id=(select COMM_ID from #us1) 
set @user1_date=(select CONVERT(VARCHAR(11), COMM_DTTS, 106) from #us1)
set @user1_comm=(select COMM from #us1)


  DROP TABLE IF EXISTS #res1
select  top 1 b.COMM_RESP_ID,c.USR_FULL_NM,b.RESP_DTTS,b.RESP  
into #res1
from cont.COMMUNICATION a
  inner join [CONT].[COMM_RESP] b on a.comm_id=b.COMM_ID_FK 
inner join [PCM].[PCM_USER] c on b.RESP_USER_ID_FK=c.USR_ID 

where a.CNTXT=@cont and b.COMM_ID_FK=@user1_comm_id
order by b.[RESP_DTTS]


set @res1_name = (select USR_FULL_NM from #res1)
set @res1_date = (select  CONVERT(VARCHAR(11),RESP_DTTS,106) from #res1)
set @res1_comm =(select RESP  from #res1)
set @res1_comm_res_id =(select COMM_RESP_ID  from #res1)

  DROP TABLE IF EXISTS #res2
  set statistics io on
;with cte as
(
select top 2 * ,
ROW_NUMBER() over (order by b.RESP_DTTS) as rn
from cont.COMMUNICATION a
  inner join [CONT].[COMM_RESP] b on a.comm_id=b.COMM_ID_FK 
inner join [PCM].[PCM_USER] c on b.RESP_USER_ID_FK=c.USR_ID 

where a.CNTXT=@cont and b.COMM_ID_FK=@user1_comm_id
order by b.[RESP_DTTS]
) 
select  COMM_RESP_ID,USR_FULL_NM,RESP_DTTS,RESP  into #res2 from cte where rn=2

set @res2_name = (select USR_FULL_NM from #res2)
set @res2_date = (select  CONVERT(VARCHAR(11),RESP_DTTS,106) from #res2)
set @res2_comm =(select RESP  from #res2)
set @res2_comm_res_id =(select COMM_RESP_ID  from #res2)



select @user1_fullname as us1_full_name,@user1_comm_id as us1_comm_id,@user1_date as us1_date,@user1_comm as us1_comm,@res1_name as res1_name,@res1_date as res1_date, @res1_comm as res1_comm,@res1_comm_res_id as res1_comm_id,@res2_name as res2_name,@res2_date as res2_date, @res2_comm as res2_comm,@res2_comm_res_id as res2_comm_id


DROP TABLE IF EXISTS #us1
DROP TABLE IF EXISTS #res1
DROP TABLE IF EXISTS #res2

END
