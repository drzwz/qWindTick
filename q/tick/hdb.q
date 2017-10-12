if[not system"p";system"p 5012"];
if[11h<>type key hsym `$ myhdbdir1: ssr[myhdbdir: getenv[`qhome],"\\..\\hdb";  "\\";  "/"]; system "md ",myhdbdir];
system "l ",myhdbdir1;
