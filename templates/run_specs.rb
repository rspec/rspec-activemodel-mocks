run('rspec spec -cfdoc') || abort
run('rake --backtrace spec') || abort
run('rake --backtrace spec:models') || abort
run("rake --backtrace stats") || abort
