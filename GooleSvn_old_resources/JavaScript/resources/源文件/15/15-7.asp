<%@LANGUAGE="JAVASCRIPT" CODEPAGE="936"%>
<% 
  var conn=Server.CreateObject("ADODB.Connection")    //建立一个connection对象变量
  var connstr="DRIVER={Microsoft Access Driver (*.mdb)};DBQ="+Server.MapPath("data.mdb") //数据源的连接字符串
  conn.Open(connstr);                                    //打开连接
var rs=Server.CreateObject("ADODB.recordset");          //创建Recordset对象
rs=conn.Execute("student");                                //查询数据表
var i=0;                                               //定义一个循环变量
                                             //定义一个循环变量
%>
<html>
<head>
<title>输出数据表格</title>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<% 
rs.MoveFirst;                                            //指针移动到记录集的第一个记录
while(!rs.EOF)
 {
for(i=0;i<=rs.Fields.Count-1;i++)
{
Response.Write(rs(i)+"&nbsp;&nbsp;&nbsp;");
}
Response.Write("<br>");
rs.MoveNext;
}
rs.Close();                                             //关闭记录集
rs=null;
conn.Close();                                          //关闭数据库
conn=null;
%>
</body>
</html>

