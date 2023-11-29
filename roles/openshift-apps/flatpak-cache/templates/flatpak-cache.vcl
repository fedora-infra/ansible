vcl 4.1;

import std;

acl whitelist {
    "localhost";
    "10.3.174.52";
    "10.3.174.61";
    "10.3.174.62";
    "10.3.174.63";
    "10.3.174.64";
    "10.3.174.57";
    "10.3.174.42";
    "10.3.174.43";
    "10.3.174.21";
    "10.3.174.22";
    "10.3.174.23";
    "10.3.174.24";
    "10.3.174.25";
    "10.3.174.26";
}

backend default {
    .host = "dl.flathub.org";
    .port = "80";
}

sub vcl_recv {
    set req.http.X-Actual-IP = regsub(req.http.X-Forwarded-For, "[, ].*$", "");
    if (std.ip(req.http.X-Actual-IP, "0.0.0.0") !~ whitelist && client.ip !~ whitelist) {
        return (pass);
        # return(synth(403, "Access denied."));
    }
    set req.http.Host = "dl.flathub.org";
}
