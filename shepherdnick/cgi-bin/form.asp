<% 
For Each x In Request.Form 
message = message & x & ": " & Request.Form(x) & CHR(10) 
Next 
set smtp=Server.CreateObject("Bamboo.SMTP") 
smtp.Server="smtp.easypublish.co.uk" 
smtp.Rcpt="liam@islandwebservices.co.uk" 
smtp.From="liam@islandwebservices.co.uk" 
smtp.FromName="Joe Smith" 
smtp.Subject="Response to my form" 
smtp.Message = message 
on error resume next 
smtp.Send 
 if err then 
response.Write err.Description 
else 
Response.redirect ("http:// redirect.com") 
end if 
set smtp = Nothing 
%> 