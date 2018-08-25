var data;
var url = 'http://172.31.255.248/esp';
function stuffdata(key) {
    data.append(key, document.getElementById(key).value ?
		document.getElementById(key).value : -1) ;
}

function send() {

    data = new FormData();
    
    stuffdata("hitemp");
    stuffdata("lowtemp");
    stuffdata("besttemp");
    stuffdata("hihumid");
    stuffdata("lowhumid");

    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.onload = function () {
	// do something to response
	console.log(data);
    };
    xhr.send(data);
}
