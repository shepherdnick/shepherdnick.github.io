<%@language = "VBscript"%>
<%
'Tom Germain's Standard Cgiware Global Variables and set-up
'DO NOT REMOVE THIS SECTION OR NOTHING WILL WORK
Dim strError
Response.Buffer = True 
If ScriptEngineMajorVersion < 2 Then
ReportError "Host system needs scripting engine upgrade to use this script"
End If
Set objFM = CreateObject("Scripting.Dictionary")
If IsObject(objFM) = False Then
ReportError "Host system lacks component(s) required by this script"
End If
Set objMailx = CreateObject("CDONTS.Newmail")
If IsObject(objMailx) = False Then
ReportError "Host system lacks component(s) required by this script"
End If
Set objMailx = Nothing
%>
<%
'aspmailer.asp by Tom Germain, Copyright 1998-1999
'Version 1.0
'tg@cgiware.com
'Visit http://www.cgiware.com for latest version, documentation, and other resources
'This is freeware - Use at your own risk. No warranties provided.
'Redistribution of this program, in whole or in part, is strictly
'prohibited without the expressed written consent of the author.
'Custom programming available on hourly fee basis.
%>

<%'variables you can set start here%>
<%
strRcpt = "liam@islandwebservices.co.uk" 'Put the address you want the form sent to here

strFromVar = "" 'If you want a reply-to email address to be taken from the form
' put the name of the input item here. 

strDefFrom = "cgiware@fsdrfw.com" 'Put a default, even fake, From address here

strDefSubject = "Form submitted" 'Put the subject of the letter here. If an input item called
'subject exists in the form, its value will be used instead.

strRedirect = "" 'Url to redirect to after a successful form submission. If an input item called
'redirect exists in the form, its value will be used instead.

%>
<%'variables you can set end here%>

<%
ParseForm
CheckForm
If Len(strError) > 0 Then
ReportError strError
End If
strOutX = SeqForm
If Len(strOutX) < 1 Then 
 strOutX = FormToString
End If
If Len(strOutX) < 1 Then 
ReportError "Submitted form is empty"
End If
strSubject = strDefSubject
If objFM.Exists("TGsubject") Then
strSubject = objFM.Item("TGsubject")
End If
strFrom = strDefFrom
If Len(strFromVar) > 0 Then 
If objFM.Exists(strFromVar) Then strFrom = objFM.Item(strFromVar) End If 
End If
SendMail strFrom,strRcpt,strSubject,strOutX
If Len(strRedirect) > 0 Then
 Response.redirect(strRedirect)
 Response.End
End If
If objFM.Exists("TGredirect") = True Then
If Len(objFM.Item("TGredirect")) > 0 Then 
Response.redirect(objFM.Item("TGredirect"))
Response.End
End If
End If
%>

<!--*******SUCCESSFUL SUBMISSION RESPONSE - START*******-->
<!--ADD YOUR OWN HTML TOP SECTION STARTING HERE-->
<h1>Form Sent!</h1>
Your request has been received and will be processed shortly.
<!--ADD YOUR OWN HTML TOP SECTION UP TO HERE-->
<!--*******SUCCESSFUL SUBMISSION RESPONSE - END********-->

<%
Credit
Response.End
%>
<%
Function IsValidEmail(Email)
Dim Temp,Temp2
strNotValid =  "<br>Email address not valid"
strTooLong =  "<br>Email address too long"
If Len(Email) > 100 Then
ReportError strTooLong
End If
Email = LCase(Email)
Temp = Split(Email,"@",2,1)
If UBound(Temp) < 1 Then
ReportError strNotValid
End If
Temp2 = Split(Temp(1),".",-1,1)
If UBound(Temp2) < 1 Then
ReportError strNotValid
End If
End Function
%>
<%
Function SendMail(From,Rcpt,Subject,Body)
Trim(From)
Trim(Rcpt)
If Len(From) < 1 Then  
ReportError strError & "<br>No Reply-to address (From) for this letter"
End If
If Len(Rcpt) < 1 Then
ReportError strError & "<br>No recipient for this letter"
End If
IsValidEmail Rcpt
IsValidEmail From
Set objMailer = CreateObject("CDONTS.Newmail")
objMailer.From = From
objMailer.To = Rcpt
objMailer.Subject = Subject
objMailer.Body = Body
objMailer.Send
Set objMailer = Nothing
End Function
%>
<%
Function CheckForm()
Dim Temp,strTmp,strForce
strInputReq =  "<br>Input required for "
If objFM.Exists("TGrequire") = False Then
 Exit Function
  ElseIf isEmpty(objFM.Item("TGrequire")) Then
   Exit Function
End If
strForce = objFM.Item("TGrequire")
Temp = Split(strForce,",",-1,1)
For Each strTmp in Temp
 If objFM.Exists(strTmp) = False Then
  strError = strError & strInputReq & strTmp
   ElseIf Len(objFM.Item(strTmp)) < 1 Then
    strError = strError & strInputReq & strTmp
 End If 
Next
End Function
%>
<%
Function ParseForm()
For Each Item in Request.Form
 If objFM.Exists(Item) Then
  objFM.Item(Item) = objFM.Item(Item) & "," & Request.QueryString(Item)
   Else 
    objFM.Add Item,Request.Form(Item)
 End If
Next
For Each Item in Request.QueryString
 If objFM.Exists(Item) Then
  objFM.Item(Item) = objFM.Item(Item) & "," & Request.QueryString(Item)
   Else 
    objFM.Add Item,Request.QueryString(Item)
 End If
Next
End Function
%>
<%
Function SeqForm()
Dim Temp,strTmp,strOrder,strOut
If objFM.Exists("TGorder") = False Then
 Exit Function
  ElseIf isEmpty(objFM.Item("TGorder")) Then
   Exit Function
End If
strOrder = objFM.Item("TGorder")
Temp = Split(strOrder,",",-1,1)
For Each strTmp in Temp
 If objFM.Exists(strTmp) Then
  strOut = strOut & strTmp & "=" & objFM.Item(strTmp) & Chr(10)
 End If 
Next
SeqForm = strOut
End Function
%>
<%
Function FormToString()
Dim strOut
strKeys = objFM.Keys
strValues = objFM.Items
For intCnt = 0 To objFM.Count -1
  strOut = strOut & strKeys(intCnt) & "=" & strValues(intCnt) & Chr(10)
Next
FormToString = strOut
End Function
%>
<%
Function ReportError(strMess)
If Len(strMess) < 1 Then
strMess = strError
End If
strErr = "The following error(s) happened: <br>" & strMess
Response.Clear
%>

<!--*******ERRONEOUS SUBMISSION RESPONSE - START*******-->
<!--ADD YOUR OWN HTML TOP SECTION STARTING HERE-->
<h1>Error!</h1>
<!--ADD YOUR OWN HTML TOP SECTION UP TO HERE-->

<%'Error messages will be output here, between your html%>
<%
Response.Write(strErr)
%>

<!--ADD YOUR OWN HTML BOTTOM SECTION STARTING HERE-->
<p>
<b>Click on you browser's <i>Back</i> button to correct any mistakes in your input</b>
</p>
<!--ADD YOUR OWN HTML BOTTOM SECTION UP TO HERE-->
<!--******ERRONEOUS SUBMISSION RESPONSE - END*******-->

<%
Credit
Response.End
End Function
%>

<%Function Credit%>
<!--START OF CREDIT - DO NOT CHANGE OR REMOVE ANYTHING BELOW THIS LINE-->
<p align=center>
<font face="Arial,Helvetica" size=1>
Mailer software is freeware by 
<a href="http://www.cgiware.com/" target="_top">CGIware</a> &nbsp;
<a href="http://www.cgiware.com/" target="_top"><img src="http://www.cgiware.com/powered.gif"  align="absmiddle" border="0"></a>
</font>
</p>
<!--END OF CREDIT-->
<%End Function%>

