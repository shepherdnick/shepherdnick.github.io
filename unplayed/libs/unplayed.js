window.onload = startGui;
function startGui(){
	// make a new javascript markdown converter
	converter = new Showdown.converter();
	
	// html holding vars
	var unplayedGames = null;
	var unbeatenGames = null;
	var completedGames = null;
	var multiplayerGames = null;
	
	// create the html markdown, and then swap the () for spans
	unplayedGames = spanIt(converter.makeHtml(getData("unplayed.markdown")));
	unbeatenGames = spanIt(converter.makeHtml(getData("unbeaten.markdown")));
	completedGames = spanIt(converter.makeHtml(getData("completed.markdown")));
	multiplayerGames = spanIt(converter.makeHtml(getData("multiplayer.markdown")));	
	
	// add the new html blocks to the DOM
	$("#unplayed").html(unplayedGames);
	$("#unbeaten").html(unbeatenGames);
	$("#completed").html(completedGames);
	$("#multiplayer").html(multiplayerGames);
	
	// add star ratings to the abandoned and the beaten lists
	starIt("multiplayer");
	starIt("completed");
	
	// if we don't call the star-rating api after the html has changed, all we get is radio buttons - yeuch
	$('input[type=radio].star').rating();
}

function spanIt(rawHtml)
{
	// backup the raw html
	var changedHtml = rawHtml;
	// replace the brackets
	changedHtml = changedHtml.replace(/\(/g, "<span>");
	changedHtml = changedHtml.replace(/\)/g, "</span>");
	// send the shiny new html back
	return changedHtml;
}

function starIt(holdingId)
{
	// find the right DOM element
	var html = "";
	var selector = "#" + holdingId;	
	var $column = $(selector);
	
	// for each list item in the DOM element (every game in a column)
	$column.find('li').each(function (index){
		var htmlBlock = $(this).html();
		// try to find the star rating e.g. [3/5]
		var allStarRatings = htmlBlock.match(/\[\d\/\d\]/g);
		
		// get the number of stars we want to give the game
        var starRating = /\[(\d)\/(\d)\]/g;
		if(allStarRatings != null && typeof(allStarRatings) != 'undefined')
		{
			if(allStarRatings.length > 0){
				var match = starRating.exec(allStarRatings[0]); //regex match
				
				html += "<div class='starRatingHolder'>";
				
				// create the inputs based on the number of stars we want to give
				for(var i = 1; i <= parseInt(match[2]); i++)
				{
					if(i == parseInt(match[1]))
					{
						// this one is checked to show it's where the stars should stop
						html += "<input name='star-rating-" + holdingId + "-" + index + "' type='radio' class='star' disabled='disabled' checked='checked'\/>";
					}
					else{
						html += "<input name='star-rating-" + holdingId + "-" + index + "' type='radio' class='star' disabled='disabled'\/>";
					}
				}
				
				html += "</div>";
			}
		}
		
		// actually remove the [3/5] from the page
		htmlBlock = htmlBlock.replace(/\[\d\/\d\]/g, "");
		htmlBlock += html;
		
		// add the new html to the DOM
		$(this).html(htmlBlock);
		
		// blank down the vars we used
		html = "";
		htmlBlock = "";
	});
}

function createCORSRequest(method, url){
  var xhr = new XMLHttpRequest();
  if ("withCredentials" in xhr){
    // XHR has 'withCredentials' property only if it supports CORS
    xhr.open(method, url, true);
  } else if (typeof XDomainRequest != "undefined"){ // if IE use XDR
    xhr = new XDomainRequest();
    xhr.open(method, url);
  } else {
    xhr = null;
  }
  return xhr;
}

function getData(nameOfFile)
{
	var markdownData = null;
	
	var request = createCORSRequest( "get", "https://www.dropbox.com/s/rb6q39iwuoscnwa/unplayed.markdown?dl=1" );
	if ( request ){
  		// Define a callback function
  		request.onload = function(){
  			console.log(request.responseText);
  		};
  		// Send request
  		request.send();
	}
	
	
	// use jQuery ajax to get the markdown file
	$.ajax({
     async: false,
     type: 'GET',
     url: 'https://dl.dropboxusercontent.com/u/2013399/unplayed/' + nameOfFile,
     success: function(data) {
          markdownData = data;
		}
	});

	return markdownData;
}