
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
Arr = []
function make_bar(width) {
    return "<div id='mybar' style='width:" + width + "% />" +
	width + '%' + "</div>";
}

function normalise(obj) {
    humid = obj.humidity;
    temp = obj.temp;
    var nom_h = humid;
    var nom_t = temp ;
    var floor = Math.floor;
    return [nom_h,nom_t];
}

function move(startwidth, bar) {
    var elem = document.getElementById(bar);
    elem.ldBar.set(startwidth);
} 

var url = "http://172.31.255.254/rawdata";

function loop() {
    var fun = function(string) {
	json = string;
	var Obj = JSON.parse(string);
	Arr = normalise(Obj);
	move(Arr[0], "tempbar");
	move(Arr[1], "humidbar");
    }
    //httpGet("http://www.wildbartty.com/cgi-bin/agrihack.cgi", fun);
    httpGet(url, fun);
}
