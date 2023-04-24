function noscript() {
    document.getElementById("cleanSlideShow").removeAttribute('id');
    document.getElementById("changeDisplay").removeAttribute('id');
    document.getElementById("cleanCanvas").removeAttribute('id');
    document.getElementById("hideNavg").removeAttribute('id');
}
function nojsregulation(){
    readelement = document.getElementsByClassName("read-more");
    for (var j = 0 ; j < readelement.length; j = j + 1) {
	readelement[j].className="read-more";
    }
    learnelement = document.getElementsByClassName("learn-more");
    popupelement = document.getElementsByClassName("simple_overlay");
    for (var i = 0 ; i < learnelement.length; i = i + 1) {
	learnelement[i].className="learn-more";
    }
    for (var k = 0 ; k < popupelement.length; k = k + 1) {
	popupelement[k].className="simple_overlay";
    }
}

premalinks = document.getElementsByTagName("a")
for (var l = 0; l < premalinks.length; l = l +1){
    premalinks[l].removeAttribute("name");
}
