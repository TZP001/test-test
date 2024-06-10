function CollExp(id, img) {
	var e = document.getElementById(id);
	var i = document.getElementById(img);
	if (null != e) {
		switch (e.style.display) {
		case "none":
			e.style.display = "";
			i.src = "Ressources/d.bmp";
			break;
		default:
			e.style.display = "none";
			i.src = "Ressources/r.bmp";
		}
	}
}

var ie = (document.getElementById && document.all)?1:0; 
var ns = (document.getElementById && !document.all)?1:0;
var obj = null;
var x = 0;
var y = 0;

function showHint(msg) {
	if (null != obj) {
		obj.style.left = x;
		obj.style.top = y;
		obj.innerHTML = msg;
		obj.style.visibility = "visible";
	}
}

function hideHint() {
	if (null != obj)
		obj.style.visibility = "hidden";
}

function getMouseMove(e) {
	if(ie && obj) {
		x = document.body.scrollLeft + event.clientX;
		y = document.body.scrollTop + event.clientY + 20;
	}
	else if(ns && obj) {
		x = window.pageXOffset + e.clientX + "px";
		y = window.pageYOffset + e.clientY + 20 + "px";
	}
}

function hintInit() {
	obj = document.getElementById("Hint");
}

document.onmousemove = getMouseMove;
onload = hintInit;
