window.onload = startGui;
function startGui(){
	var converter = new Showdown.converter();
	
	var pageToLoad = getParameter("page");
	
	var html = converter.makeHtml(getData(pageToLoad+".markdown"))
	html = spanIt(html);
	
	document.getElementById('list').innerHTML = html;
}

function spanIt(rawHtml)
{	
	var splitArray = rawHtml.split("</h1>");
	var splitHtml = "";
	
	$.each(splitArray, function(index, value){	
		if(index > 0)
		{
			value = value.replace('<h1 ', '</div> </div> <div> <a><h1 id="'+index+'" class="header"');
			splitHtml += value + '</h1></a> <div id="'+index+'_content" class="content">';
		}
		else if(index < splitArray.length)
		{
			if(index === 0)
			{
				value = value.replace('<h1 ', '<div> <a><h1 id="'+index+'" class="header"');
			}
			splitHtml += value + '</h1></a> <div id="'+index+'_content" class="content">';
		}
		else if(index === (splitArray.length-1))
		{
			splitHtml += value + '</h1></a> </div>';
		}
	});
	
	splitHtml += "</div>";
	
	return splitHtml;
}

function getParameter(param) {
	var val = document.URL;
	var url = val.substr(val.indexOf(param))
	var n= url.replace(param+"=","");
	return n; 
}

function getData(nameOfFile)
{
	var markdownData = null;
	
	$.ajax({
     async: false,
     type: 'GET',
     url: 'http://shepherdnick.kissr.com/showdown/' + nameOfFile,
     success: function(data) {
          markdownData = data;
		}
	});

	return markdownData;
}