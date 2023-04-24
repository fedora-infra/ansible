// this executes all the "window.onload" type events

$(document).ready(function(){

	// for export regulations
	$(".export-regulations").expander({
		slicePoint: 350,
		widow: 1,
		userCollapse: true,
		expandText: 'Read full export regulations',
		userCollapseText: 'Hide full export regulations'
	});

	// setup ul.tabs to work as tabs for each div directly under div.panes
	// added .history() to remember history of last tab
	$("ul.tabs").tabs("div.panes > div").history();

	// hide all "learn more" links
	$("span.learn-more").hide();

	// toggles links on/off on hover
	$("tr.spin-row").hover(
		function () {
			$(this).find("span.learn-more").show();
		},
		function () {
			$(this).find("span.learn-more").hide();
		}
	);

	// force overlay
	$("img[rel]").overlay();

    // slideshow
    $('.simpleSlideShow').slideShow({
        interval: 9
    });

    $('p.warning').fadeIn(3000);



    // redirect download links to splash page
    $("a.download-splash").click(function(event){
        event.preventDefault();
        linkLocation = this.href;

        // this passes the URL path to the splash page
        window.location = 'download-splash?file='+linkLocation;
	});


    // splash download page stuff
    if (/.*download-splash.*/i.test(window.location.href)) {
        $("p.download-path").ready(function(){
            // get file path from URL, then display it
            var valid = false;
            var allowed_prefixes = [
                'http://download.fedoraproject.org/',
                'http://torrent.fedoraproject.org/',
                'http://mirrors.fedoraproject.org/'
            ]

            var file_url = $.query.get('file');

            // Only accept URLs beginning with our known prefix.
            for (i in allowed_prefixes) {
                prefix = allowed_prefixes[i];
                if (file_url.substring(0, prefix.length) == prefix) {
                    valid = true;
                }
            }

            if (valid) {
                $("p.download-path").prepend($("<a>", {
                    href: encodeURI(file_url),
                    text: file_url
                }))
                setTimeout(function() { window.location = file_url }, "2000");
            }
        });
    }

    // redirect download links to ARM splash page
    $("a.download-arm-splash").click(function(event){
        event.preventDefault();
        linkLocation = this.href;

        // this passes the URL path to the ARM splash page
        window.location = 'download-arm-splash?file='+linkLocation;
    });

    // splash download page stuff
    if (/.*download-arm-splash.*/i.test(window.location.href)) {
        $("p.download-path").ready(function(){
            // get file path from URL, then display it
            var valid = false;
            var allowed_prefixes = [
                'http://download.fedoraproject.org/',
                'http://torrent.fedoraproject.org/',
                'http://mirrors.fedoraproject.org/'
            ]

            var file_url = $.query.get('file');

            // Only accept URLs beginning with our known prefix.
            for (i in allowed_prefixes) {
                prefix = allowed_prefixes[i];
                if (file_url.substring(0, prefix.length) == prefix) {
                    valid = true;
                }
            }

            if (valid) {
                $("p.download-path").prepend($("<a>", {
                    href: encodeURI(file_url),
                    text: file_url
                }))
                setTimeout(function() { window.location = file_url }, "2000");
            }
        });
    }

    // redirect download links to CLOUD splash page
    $("a.download-cloud-splash").click(function(event){
        event.preventDefault();
        linkLocation = this.href;

        // this passes the URL path to the CLOUD splash page
        window.location = 'download-cloud-splash?file='+linkLocation;
    });

    // splash download page stuff
    if (/.*download-cloud-splash.*/i.test(window.location.href)) {
        $("p.download-path").ready(function(){
            // get file path from URL, then display it
            var valid = false;
            var allowed_prefixes = [
                'http://download.fedoraproject.org/',
                'http://torrent.fedoraproject.org/',
                'http://mirrors.fedoraproject.org/'
            ]

            var file_url = $.query.get('file');

            // Only accept URLs beginning with our known prefix.
            for (i in allowed_prefixes) {
                prefix = allowed_prefixes[i];
                if (file_url.substring(0, prefix.length) == prefix) {
                    valid = true;
                }
            }

            if (valid) {
                $("p.download-path").prepend($("<a>", {
                    href: encodeURI(file_url),
                    text: file_url
                }))
                setTimeout(function() { window.location = file_url }, "2000");
            }
        });
    }

     // redirect download links to Workstation splash page
    $("a.download-prerelease-splash").click(function(event){
        event.preventDefault();
        linkLocation = this.href;

        // this passes the URL path to the splash page
        window.location = 'download-prerelease-splash?file='+linkLocation;
	});


    // splash download page stuff
    if (/.*download-prerelease-splash.*/i.test(window.location.href)) {
        $("p.download-path").ready(function(){
            // get file path from URL, then display it
            var valid = false;
            var allowed_prefixes = [
                'http://download.fedoraproject.org/',
                'http://torrent.fedoraproject.org/',
                'http://mirrors.fedoraproject.org/'
            ]

            var file_url = $.query.get('file');

            // Only accept URLs beginning with our known prefix.
            for (i in allowed_prefixes) {
                prefix = allowed_prefixes[i];
                if (file_url.substring(0, prefix.length) == prefix) {
                    valid = true;
                }
            }

            if (valid) {
                $("p.download-path").prepend($("<a>", {
                    href: encodeURI(file_url),
                    text: file_url
                }))
                setTimeout(function() { window.location = file_url }, "2000");
            }
        });
    }

    // Random banners
    function random_banner(){
    var images = [], ry, lnk;
    images[0] = "/static/images/banners/random/formats.png";
    images[1] = "/static/images/banners/random/spins.png";
    images[2] = "/static/images/banners/random/clouds.png";
    images[3] = "/static/images/banners/random/2nd_arches.png";

    var links = [];
    links[0] = "/get-fedora-options#formats";
    links[1] = "http://spins.fedoraproject.org/";
    links[2] = "/get-fedora-options#clouds";
    links[3] = "/get-fedora-options#2nd_arches";

    var alt = [];
    alt[0] = "Desktop";
    alt[1] = "Spins";
    alt[2] = "Cloud";
    alt[3] = "Secondary Arches";

    ry = Math.floor(Math.random() * images.length);
    lnk = document.getElementById('archreleases');
    lnk.href = links[ry];
    lnk.alt = alt[ry];
    lnk.getElementsByTagName('img')[0].src = images[ry];
    lnk.getElementsByTagName('img')[0].alt = alt[ry];
    }
    if (/.*get-fedora-options.*/i.test(window.location.href)) {
		random_banner();
	}

    $(".tweet").tweet({
        username: "fedora",
        count: 1,
        intro_text: null,
        outro_text: null,
        loading_text: "Loading Fedora tweets..."
    });

	// hosting sponsor banners
	// see: /sponsors/*.js
    $("#hosting-sponsor img").attr("src", sponsor_banner[0]);
    $("#hosting-sponsor img").attr("alt", sponsor_banner[1]);
    $("#hosting-sponsor a").attr("href", sponsor_banner[2]);


/* Not actually used anywhere.
	// main site banners
	// see: banner.js
	var choices = [];
	var k = 0;
	for (var i = 0; i < banners.length; ++i) {
		for (var j = 0; j < banners[i][3]; ++j) { choices[k++] = i; }
	}

	var choice = Math.floor(Math.random()*(choices.length));

    $("#fedora-banners img").attr("src", banners[choices[choice]][0]);
    $("#fedora-banners img").attr("alt", banners[choices[choice]][1]);
    $("#fedora-banners a").attr("href", banners[choices[choice]][2]);
*/
});


