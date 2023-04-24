var available_langs = [ "ar", "bg", "bn_IN", "cs", "da", "de", "el", "en", "es", "fi", "fr", "gu", "he", "hi", "hr", "hu", "id", "is", "it", "ja", "kn", "ko", "ks", "ml", "nl", "pa", "pl", "pt", "pt_BR", "ro", "ru", "si", "sr", "sv", "th", "tr", "uk", "vi", "zh_CN", "zh_TW" ];


var today = new Date();
var release = new Date("December 09, 2014 15:00:00 UTC");
var millisBetweenDates = release - today;
var days = Math.ceil(millisBetweenDates/1000/60/60/24);
var url = "https://fedoraproject.org/wiki/Releases/21/Schedule";

var script = document.getElementById('fedora-banner');
var lang = "en"


// getParam split the GET parameters and return the value
// of the input `sname' parameter if found or en empty string.
function getParam (sname) {
  var params = script.src.substr(script.src.indexOf("?")+1);

  params = params.split("&");
  for (var i=0; i<params.length; i++) {
      temp = params[i].split("=");
      if ([temp[0]] == sname)
        return temp[1];
  }
  return "";
}


var lang_match = getParam("lang");
if (lang_match) {
    for (var i = 0; i < available_langs.length; ++i) {
        if (available_langs[i] == lang_match) {
            lang = lang_match;
            break;
        }
    }
}

var width = getParam("width");
var valid=new RegExp("^[0-9]{2,3}px$","g"); // We should probably forbid more than 300px…

if (!valid.test(width))
  width="200px";

var banner = document.createElement('div');
var bannerlink = document.createElement('a');
var bannerimg = document.createElement("img");
bannerimg.style.border = "none";
bannerimg.style.width = width;


if (days <= 0) {
    bannerimg.setAttribute("src", "https://apps.fedoraproject.org/global/legacy-static/images/banners/f21release.png");
    bannerimg.setAttribute("alt", "Fedora 21 is here!");
    url = "http://get.fedoraproject.org/";
} else {
    bannerimg.setAttribute("src", "https://apps.fedoraproject.org/global/legacy-static/images/counter/" + lang + "/fedora21-countdown-banner-" + lang + "-" + days + ".png");
    bannerimg.setAttribute("alt", "Fedora 21 released in " + days + " days.");
}

bannerlink.setAttribute("href", url);
bannerlink.appendChild(bannerimg);
banner.appendChild(bannerlink);

script.parentNode.insertBefore(banner, script);
