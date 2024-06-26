set grid
set xdata time
set format x "%Y-%m-%d"
set timefmt "%Y-%m-%d"

set datafile separator ","
set term png size 1600,1200
set key outside right top Right title 'Legend' box 3

##
set output "/var/www/html/csv-reports/images/mirrors-all-points.png"
set title "Fedora+Epel Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:2  title 'epel4' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:3  title 'epel5' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:4  title 'epel6' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:5  title 'epel7' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:72  title 'epel8' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:73  title 'epel9' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:6  title 'fed03' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:7  title 'fed04' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:8  title 'fed05' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:9  title 'fed06' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:10 title 'fed07' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:11 title 'fed08' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:12 title 'fed09' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:13 title 'fed10' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:14 title 'fed11' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:15 title 'fed12' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:16 title 'fed13' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:17 title 'fed14' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:18 title 'fed15' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:19 title 'fed16' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:20 title 'fed17' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:21 title 'fed18' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:22 title 'fed19' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:23 title 'fed20' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:24 title 'fed21' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:25 title 'fed22' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:26 title 'fed23' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:27 title 'fed24' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:28 title 'fed25' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:29 title 'fed26' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:30 title 'fed27' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:31 title 'fed28' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:32 title 'fed29' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:33 title 'rawhide' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:34 title 'unk_rel' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:35 title 'EPEL' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:36 title 'Fedora' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:37 title 'alpha' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:38 title 'ARM' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:39 title 'ARM64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:40 title 'ia64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:41 title 'mips' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:42 title 'ppc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:43 title 's390' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:44 title 'sparc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:45 title 'tilegx' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:46 title 'x86_32' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:47 title 'x86_64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:48 title 'x86_32_e' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:49 title 'x86_32_f' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:50 title 'x86_64_e' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:51 title 'x86_64_f' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:52 title 'ppc_e' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:53 title 'ppc_f' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:54 title 'unknown' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:55 title 'centos' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:56 title 'rhel' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:57 title 'ppc64' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:58 title 'ppc64le' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:59 title 'modular' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:60 title 'modular_rawhide' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:61 title 'modular_f27' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:62 title 'modular_f28' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:63 title 'modular_f29' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:64 title 'modular_f30' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:65 title 'fed30' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:66 title 'fed31' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:67 title 'fed32' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:68 title 'fed33' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:69 title 'modular_f31' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:70 title 'modular_f32' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:71 title 'modular_f33' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:72 title 'epel8' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:73 title 'epel9' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:74 title 'f34' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:75 title 'f35' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:76 title 'f36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:77 title 'f37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:78 title 'f38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:79 title 'f39' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:80 title 'modular_f34' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:81 title 'modular_f35' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:82 title 'modular_f36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:83 title 'modular_f37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:84 title 'modular_f38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:85 title 'modular_f39' with lines lw 3
unset output

# set output "/var/www/html/csv-reports/images/fedora-daily.png"
# set title "Fedora Daily Totals Unique IPs"
# plot ["2007-05-17":"2024-12-31"] \
#      '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:36 title 'Fedora' with lines lw 3
# unset output

set output "/var/www/html/csv-reports/images/fedora-os-all.png"
set title "Fedora OS Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:6  title 'fed03' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:7  title 'fed04' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:8  title 'fed05' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:9  title 'fed06' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:10 title 'fed07' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:11 title 'fed08' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:12 title 'fed09' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:13 title 'fed10' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:14 title 'fed11' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:15 title 'fed12' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:16 title 'fed13' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:17 title 'fed14' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:18 title 'fed15' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:19 title 'fed16' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:20 title 'fed17' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:21 title 'fed18' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:22 title 'fed19' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:23 title 'fed20' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:24 title 'fed21' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:25 title 'fed22' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:26 title 'fed23' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:27 title 'fed24' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:28 title 'fed25' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:29 title 'fed26' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:30 title 'fed27' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:31 title 'fed28' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:32 title 'fed29' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:65 title 'fed30' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:66 title 'fed31' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:67 title 'fed32' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:68 title 'fed33' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:74 title 'fed34' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:75 title 'fed35' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:76 title 'fed36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:77 title 'fed37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:78 title 'fed38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:79 title 'fed38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:33 title 'rawhide' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:59 title 'modular' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:60 title 'modular_rawhide' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:61 title 'modular_f27' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:62 title 'modular_f28' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:63 title 'modular_f29' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:64 title 'modular_f30' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:69 title 'modular_f31' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:70 title 'modular_f32' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:71 title 'modular_f33' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:80 title 'modular_f34' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:81 title 'modular_f35' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:82 title 'modular_f36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:83 title 'modular_f37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:84 title 'modular_f38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:85 title 'modular_f39' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:34 title 'unk_rel' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/fedora-os-modular.png"
set title "Fedora Modular Users Unique IPs"
plot ["2018-01-01":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:59 title 'modular' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:60 title 'modular_rawhide' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:61 title 'modular_f27' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:62 title 'modular_f28' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:63 title 'modular_f29' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:64 title 'modular_f30' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:69 title 'modular_f31' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:70 title 'modular_f32' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:71 title 'modular_f33' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:80 title 'modular_f34' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:81 title 'modular_f35' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:82 title 'modular_f36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:83 title 'modular_f37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:84 title 'modular_f38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:85 title 'modular_f39' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/fedora-os-latest.png"
set title "Fedora Selected Versions Unique IPs"
plot ["2022-01-01":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:36 title 'Fedora' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:76 title 'fed36' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:77 title 'fed37' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:78 title 'fed38' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:79 title 'fed39' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:33 title 'rawhide' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:34 title 'unk_rel' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/fedora-os-latest-stacked.png"
set title "Fedora Selected Versions Unique IPs"
plot ["2022-01-01":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:36 title 'Fedora' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($76+$77+$78+$79+$33) title 'fed36' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($77+$78+$79+$33) title 'fed37' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($78+$79+$33) title 'fed38' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($79+$33) title 'fed39' with filledcurves x1,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33) title 'rawhide' with filledcurves x1
unset output

set output "/var/www/html/csv-reports/images/fedora-hardware-full.png"
set title "Fedora Hardware via Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:39 title 'ARM64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:58 title 'ppc64le' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:43 title 's390' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:51 title 'x86_64_f' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:54 title 'unknown' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/fedora-hardware-2nd.png"
set title "Fedora Secondary via Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:37 title 'alpha' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:38 title 'ARM' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:40 title 'ia64' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:41 title 'mips' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:42 title 'ppc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:57 title 'ppc64' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:58 title 'ppc64le' with lines lw 3, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:43 title 's390' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:44 title 'sparc' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:45 title 'tilegx' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:54 title 'unknown' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/fedora-epel-stacked.png"
set title "Fedora Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78+$79+$33) title 'rawhide' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78+$79) title 'f39' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78) title 'f38' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77) title 'f37' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76) title 'f36' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75) title 'f35' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74) title 'f34' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68) title 'fed33' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67) title 'fed32' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66) title 'fed31' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65) title 'fed30' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32) title 'fed29' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31) title 'fed28' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30) title 'fed27' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29) title 'fed26' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'fed25' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)      title 'fed24' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)      title 'fed23' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)      title 'fed22' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)          title 'fed21' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)              title 'fed20' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)                  title 'fed19' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)                      title 'fed18' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)                          title 'fed17' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)                              title 'fed16' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)                                  title 'fed15' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)                                      title 'fed14' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)                                          title 'fed13' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15)                                              title 'fed12' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13+$14)                                                  title 'fed11' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12+$13)                                                      title 'fed10' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11+$12)                                                          title 'fed09' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10+$11)                                                              title 'fed08' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9+$10)                                                                  title 'fed07' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8+$9)                                                                      title 'fed06' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7+$8)                                                                         title 'fed05' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6+$7)                                                                            title 'fed04' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73+$6)                                                                               title 'fed03' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73)                                                                               title 'epel9' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72)                                                                               title 'epel8' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5)                                                                                  title 'epel7' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4)                                                                                     title 'epel6' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3)                                                                                        title 'epel5' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2)                                                                                           title 'epel4' w filledcurves x1
unset output


set output "/var/www/html/csv-reports/images/fedora-stacked.png"
set title "Fedora Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78+$79+$33) title 'rawhide' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78+$79) title 'f39' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78) title 'f38' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77) title 'f37' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76) title 'f36' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75) title 'f34' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74) title 'f34' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68) title 'fed33' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67) title 'fed32' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66) title 'fed31' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65) title 'fed30' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32) title 'fed29' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31) title 'fed28' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30) title 'fed27' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29) title 'fed26' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'fed25' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27)      title 'fed24' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26)      title 'fed23' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25)      title 'fed22' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24)          title 'fed21' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)              title 'fed20' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22)                  title 'fed19' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21)                      title 'fed18' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20)                          title 'fed17' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19)                              title 'fed16' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)                                  title 'fed15' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17)                                      title 'fed14' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16)                                          title 'fed13' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15)                                              title 'fed12' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14)                                                  title 'fed11' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13)                                                      title 'fed10' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12)                                                          title 'fed09' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11)                                                              title 'fed08' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10)                                                                  title 'fed07' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9)                                                                      title 'fed06' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8)                                                                         title 'fed05' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7)                                                                            title 'fed04' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6)                                                                               title 'fed03' w filledcurves x1
unset output

set output "/var/www/html/csv-reports/images/fedora-rev-all-stacked.png"
set title "Fedora Yum Reverse Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11+$10+$9+$8+$7+$6) title 'fed03' w filledcurves x1 lc rgb "#F0F0F0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11+$10+$9+$8+$7) title 'fed04' w filledcurves x1 lc rgb "#F0F0F0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11+$10+$9+$8) title 'fed05' w filledcurves x1 lc rgb "#F0F0F0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11+$10+$9) title 'fed06' w filledcurves x1 lc rgb "#D0D0D0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11+$10) title 'fed07' w filledcurves x1 lc rgb "#D0D0D0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12+$11) title 'fed08' w filledcurves x1 lc rgb "#D0D0D0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13+$12) title 'fed09' w filledcurves x1 lc rgb "#B0B0B0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14+$13) title 'fed10' w filledcurves x1 lc rgb "#B0B0B0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15+$14) title 'fed11' w filledcurves x1 lc rgb "#B0B0B0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16+$15) title 'fed12' w filledcurves x1 lc rgb "#909090", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17+$16) title 'fed13' w filledcurves x1 lc rgb "#909090", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18+$17) title 'fed14' w filledcurves x1 lc rgb "#909090", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19+$18) title 'fed15' w filledcurves x1 lc rgb "#707070", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20+$19) title 'fed16' w filledcurves x1 lc rgb "#707070", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21+$20) title 'fed17' w filledcurves x1 lc rgb "#707070", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22+$21) title 'fed18' w filledcurves x1 lc rgb "#505050", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23+$22) title 'fed19' w filledcurves x1 lc rgb "#505050", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24+$23) title 'fed20' w filledcurves x1 lc rgb "#505050", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25+$24) title 'fed21' w filledcurves x1 lc rgb "#303030", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26+$25) title 'fed22' w filledcurves x1 lc rgb "#303030", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27+$26) title 'fed23' w filledcurves x1 lc rgb "#303030", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28+$27) title 'fed24' w filledcurves x1 lc rgb "#0000FF", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29+$28) title 'fed25' w filledcurves x1 lc rgb "#00FFFF", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30+$29) title 'fed26' w filledcurves x1 lc rgb "#0000C0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31+$30) title 'fed27' w filledcurves x1 lc rgb "#00C0C0", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32+$31) title 'fed28' w filledcurves x1 lc rgb "#000080", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65+$32) title 'fed29' w filledcurves x1 lc rgb "#008080", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66+$65) title 'fed30' w filledcurves x1 lc rgb "#808080", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67+$66) title 'fed31' w filledcurves x1 lc rgb "#000040", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68+$67) title 'fed32' w filledcurves x1 lc rgb "#004040", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33+$68) title 'fed33' w filledcurves x1 lc rgb "#404040", \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($33) title 'rawhide' w filledcurves x1 lc rgb "#FF0000"
unset output

set output "/var/www/html/csv-reports/images/fedora-select-stacked.png"
set title "Fedora Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68+$74+$75+$76+$77+$78+$79+$33)  title 'fedora-future' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65+$66+$67+$68)  title 'fedora 30-33' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28+$29+$30+$31+$32+$65)  title 'fedora 26-30' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23+$24+$25+$26+$27+$28)  title 'fedora 21-25' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22+$23)  title 'fedora 16-20' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18)  title 'fedora 11-15' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8+$9+$10+$11+$12+$13)  title 'fedora 06-10' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($6+$7+$8)  title 'fedora 03-05' w filledcurves x1
unset output


##
## EPEL
##

set output "/var/www/html/csv-reports/images/epel-all.png"
set title "Epel Yum Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:2  title 'epel4' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:3  title 'epel5' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:4  title 'epel6' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:5  title 'epel7' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:72 title 'epel8' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:73 title 'epel9' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:35 title 'EPEL' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/epel-all-short.png"
set title "Epel Yum Unique IPs"
plot ["2019-12-31":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:2  title 'epel4' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:3  title 'epel5' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:4  title 'epel6' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:5  title 'epel7' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:72 title 'epel8' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:73 title 'epel9' with lines lw 3,\
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:35 title 'EPEL' with lines lw 3
unset output

set output "/var/www/html/csv-reports/images/epel-stacked.png"
set title "Epel Releases Unique IPs"
plot ["2007-05-17":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73)  title 'epel9' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72)  title 'epel8' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5)  title 'epel7' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4)     title 'epel6' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3)        title 'epel5' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2)           title 'epel4' w filledcurves x1
unset output

set output "/var/www/html/csv-reports/images/epel-stacked-short.png"
set title "Epel Releases Unique IPs"
plot ["2019-12-31":"2024-12-31"] \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72+$73)  title 'epel9' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5+$72)  title 'epel8' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4+$5)  title 'epel7' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3+$4)     title 'epel6' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2+$3)        title 'epel5' w filledcurves x1, \
     '/var/www/html/csv-reports/mirrors/mirrorsdata-all.csv' using 1:($2)           title 'epel4' w filledcurves x1
unset output

