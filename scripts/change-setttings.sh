#!/bin/bash

mv comps.out comps.out.old
for ip in `cat comps.txt`
do
    echo "BIOS setting changing on ${ip}" >> comps.out
    hprest --nocache load -f Bios-Settings-With-Legacy-Bootmode.json  --url ${ip} -u $ilo_user -p $ilo_pass
done
