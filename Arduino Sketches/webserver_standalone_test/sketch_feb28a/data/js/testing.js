
// Start agrihack

function id(X) {
    return X;
}

function httpGet(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() { 
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous 
    xmlHttp.send(null);
}

templist = [];

humidlist = [];

function make_bar(width) {
    return "<div id='mybar' style='width:" + width + "% />" +
	width + '%' + "</div>";
}

function normalise(obj) {
    const max_num = 65536;
    var humid = obj.humidity;
    var temp = obj.temp;
    var nom_h = humid / max_num;
    var nom_t = temp / max_num;
    return [( (nom_h * 100)).toFixed(2) ,(50 - (nom_t * 100)).toFixed(2) ];
}

function move(startwidth, bar) {
    var elem = document.getElementById(bar);
    var width = startwidth;

	elem.style.width = width + '%';
} 

function start() {
    var fun = function(string) {
	var Obj = JSON.parse(string);
	var Arr = normalise(Obj);
	move(Arr[0], "tempbar");
	//move(Arr[1], "humidbar");
    }
    httpGet("http://172.18.31.29", fun);
}
