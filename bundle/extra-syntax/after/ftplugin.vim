au BufNewFile,BufRead *.tt2 setf tt2html
au BufNewFile,BufRead SConstruct,SConscript,wscript,wscript_build setf python
au BufNewFile,BufRead *.p6 setf perl6
au BufNewFile,BufRead /etc/lighttpd/*.conf,lighttpd.conf set filetype=lighttpd
au FileType c 2match Search /\%>78v./
au FileType perl 2match Search /\%>78v./
au BufRead,BufNewFile *.psgi set filetype=perl

let b:tt2_syn_tags = '\[% %] <!-- -->'
