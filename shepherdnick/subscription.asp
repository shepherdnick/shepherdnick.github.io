<!--#include file="headerinc.asp"--> <%
' #### This script Copyright (c) 2001 ASPjar.com, All Rights Reserved.  NO WARRANTEE.
' #### You need CDONTS installed to be able to send mail
' #### Your sites information starts here ####
' Your Email Address - must be a valid domain or the mail will not send
sYouEmail="news@shepherdnick.co.uk"
' Email Subject
EmailSubject="Someone wants to Subscribe"
' Heading font color
FontColor="#000000"
' Heading Background Color
HeadColor="#FFFFFF"
' Form Font Color
FormFontColor="#000000"
' Form Background Color
FormBackColor="#FFFFFF"
'Error Message Color
ErrorColor="#000000"
' That's it! - you may now wish to customize the header and footer files to suit your site.
' ####################################################################################

Function ValidateField(sFieldvalue, sFieldtype)
	ValidField = true
	Select Case LCase(sFieldtype)
		Case "name"
		If Len(sFieldvalue) = 0 Then ValidField = False
		Case "email"
			If Len(sFieldvalue) < 5 Then
				ValidField = False
			Else
				If InStr(1, sFieldvalue, "@", 1) < 2 Then
					ValidField = False
				Else
					If InStr(1, sFieldvalue, ".", 1) < 4 Then
						ValidField = False					
					End If
				End If
			End If
		Case "message"
			If Len(sFieldvalue) = 0 Then ValidField = False
		Case "else"
			ValidField = False		
	End Select
ValidateField = ValidField
End Function
Sub ShowForm
%> 
<form action="<%= Request.ServerVariables("Script_Name") %>" method="post">
  <div align="center">
    <table border="0" cellspacing="0" width="140" cellpadding=0>
      <tr bgcolor="<%=HeadColor%>"> 
        <td ALIGN="left"><B><font color="<%=FontColor%>" face="verdana,arial,helvetica" size="1">Subscribe to the Shepherdnick.co.uk News Letter!:</font></B><font size="1">&nbsp;</font></td>
      </tr>
      <tr>
        <td>
          <input name="email" type="text" value="<%= Request.Form("email") %>" SIZE="15" style="FONT-SIZE: 11px; COLOR: <%=FormFontcolor%>; FONT-FAMILY: verdana, helvetica, arial; BACKGROUND-COLOR: <%=FormBackColor%>">
        </td>
      </tr>
      <tr>
        <td><%
		If dictFields(LCase("email")) Then
		Response.Write "<font color=""" & ErrorColor & """  face=""verdana,arial,helvetica"" size=-2>You need to enter a valid email address</font>"
	Else		
		Response.Write "&nbsp;"
		End If
		%> </td>
      </tr>
      <tr>
        <td><font color="#FFFFFF" face="verdana,arial,helvetica" size="-1">
          <input type="radio" name="agree" value="true" <% 
		if Len(Request.Form("agree")) > 0 then 
		Response.Write "checked"
		End If
		%>>
          <font color="#000000"> <font size="1">Subscribe</font></font></font></td></tr>
	<tr><td><font color="#FFFFFF" face="verdana,arial,helvetica" size="-1">
          <input type="radio" name="disagree" value="true" <% 
		if Len(Request.Form("disagree")) > 0 then 
		Response.Write "checked"
		End If
		%>>
          <font color="#000000"> <font size="1">Unsubscribe</font></font></font></td></tr>
          </table>
  </div>
  <p align="center">
    <input type="submit" value="Subscribe!" style="color: #ffffff;  font-style: normal; font-family: verdana; font-weight: normal; font-size:9px; background-color: #000000; width:85;height:19;">
    <br>
</form>
<P align="center"> <%
End Sub
Sub Send
sPunter = Request.Form("Name")
sPunterEmail = Request.Form("Email")
Message = Request.Form("message")
If Request.Form("agree") = "true" then
Mailout = "They wish to subscribe to the newsletter"
End If
If Request.Form("disagree") = "true" then
Mailout = "They wish to unsubscribe to the newsletter"
End If
sMessage = "A Subscription" & sPunter & vbcrlf _
        & vbcrlf _
		& vbcrlf _
		& Message & vbcrlf _
		& vbcrlf _
		& "Their email is: " & sPunterEmail & vbcrlf _
		& vbcrlf _
		& Mailout & vbcrlf _
		& vbcrlf		
Set objNewMail = CreateObject("CDONTS.NewMail")
objNewMail.Send sPunterEmail, sYouEmail, EmailSubject, sMessage
Set objNewMail = Nothing
End Sub

Set dictFields = Server.CreateObject("Scripting.Dictionary")
For Each Field in Request.Form
If ValidateField(Request.Form(Field), Field) = False Then
dictFields.Add LCase(Field), true
End If
Next
If Request.Form.Count <> 0 And dictFields.Count  = 0 Then
%><font face="arial" size="2" color="#000000"> <B><font face="Verdana" size="1">Thank you for your submission<BR>
  </font></B></font> 
<P align="center"><font face="Verdana" size="1" color="#000000"><B><I>Your subscription / unsubscription has been verified.</I></B></font><BR>
  <%
Call Send
Else
ShowForm
End If
%> 
<P><!--#include file="footerinc.asp"-->