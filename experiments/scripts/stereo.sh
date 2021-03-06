#!/bin/bash

application="stereo"
ogm="/Users/afix/Work/Vision/opengm/build/src/interfaces/commandline/double/opengm_min_sum"
data_dir="/Users/afix/Work/Vision/opengm-benchmarks/$application"
data_files="$data_dir/cones.h5 $data_dir/teddy.h5 $data_dir/venus.h5"
timestamp=$(date +%y-%m-%d-%H-%M-%S)
output_dir="/Users/afix/Work/Vision/CVPR15-results/all-results/$application/$timestamp"
output_link="/Users/afix/Work/Vision/CVPR15-results/$application-results"

maxIt=300
timeout=600
sospd_pairwise="    -a SOSPD --ubType pairwise     --maxIt $maxIt"
sospd_chen="        -a SOSPD --ubType chen         --maxIt $maxIt"
sospd_cardinality=" -a SOSPD --ubType cardinality  --maxIt $maxIt"
sospd_gurobiL1="    -a SOSPD --ubType gurobiL1     --maxIt $maxIt"
sospd_gurobiL2="    -a SOSPD --ubType gurobiL2     --maxIt $maxIt"
sospd_gurobiLInfty="-a SOSPD --ubType gurobiLInfty --maxIt $maxIt"
sospd_cvpr14="      -a SOSPD --ubType cvpr14       --maxIt $maxIt"
sospd_triple="      -a SOSPD --ubType triple       --maxIt $maxIt"
sospd_tripleInfty=" -a SOSPD --ubType tripleInfty  --maxIt $maxIt"
trws="-a TRWS"
icm="-a ICM"
bp="-a BELIEFPROPAGATION"
trbp="-a TRBP"
lazy_flipper="-a LAZYFLIPPER"
inf_and_flip="-a INFANDFLIP"
reduction_fusion="      -a Fusion -f QPBO --numIt $maxIt"
sos_pair_fusion="       -a Fusion -f SOS  --numIt $maxIt --ubType pairwise"
sos_cvpr_fusion="       -a Fusion -f SOS  --numIt $maxIt --ubType cvpr14"
sos_chen_fusion="       -a Fusion -f SOS  --numIt $maxIt --ubType chen"
sos_cardinality_fusion="-a Fusion -f SOS  --numIt $maxIt --ubType cardinality"
sos_triple_fusion="     -a Fusion -f SOS  --numIt $maxIt --ubType triple"
sos_tripleInfty_fusion="-a Fusion -f SOS  --numIt $maxIt --ubType tripleInfty"

methods="\
         sospd_pairwise \
         sospd_cvpr14 \
         sospd_cardinality \
         sospd_chen \
         sospd_triple \
         sospd_tripleInfty \
         reduction_fusion \
         sos_pair_fusion \
         sos_cvpr_fusion \
         sos_chen_fusion \
         sos_cardinality_fusion \
         sos_triple_fusion \
         sos_tripleInfty_fusion"


common_args="-p 1 --timeout $timeout"

mkdir -p $output_dir
rm -f $output_link
ln -s $output_dir $output_link

cp $0 $output_dir/

for file in $data_files
do
    echo $(basename $file .h5) >> $output_dir/files.txt
done

for method in $methods
do
    echo $method >> $output_dir/methods.txt
done

for file in $data_files
do
    for method in $methods
    do
        echo "*** Optimizing $file $method ***"
        output=$(basename $file .h5)_$method.txt
        eval args=\$$method
        $ogm -m $file $common_args $args -o $output_dir/$output >> $output_dir/output.txt
    done
done

