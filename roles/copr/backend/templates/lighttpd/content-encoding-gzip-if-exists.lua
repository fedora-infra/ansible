if (lighty.stat(lighty.env["physical.path"])) then
    lighty.header["Content-Encoding"] = "gzip"
end
