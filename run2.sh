#! /bin/bash

path=$PWD

rm output_cuda
dna_sequence=dna/chr2.fa
approx_factor=3
pattern=AAAA

#SEQUENTIEL
printf "SEQUENTIEL\n" >> output_cuda

echo "Start Sequentiel"
output1=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output2=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output3=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output4=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )

printf "%d   %s   %s   %s   %s\n" $i $output1 $output2 $output3 $output4 >> output_cuda
echo "End Sequentiel"
printf "\n" >> output_cuda


#CUDA

printf "CUDA\n" >> output_cuda

echo "start cuda"
output1=$(./apm_cuda $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output2=$(./apm_cuda $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output3=$(./apm_cuda $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
output4=$(./apm_cuda $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
printf "%d   %s   %s   %s   %s\n" $i $output1 $output2 $output3 $output4 >> output_cuda

echo "stop cuda"
printf "\n" >> output_cuda


cat output_cuda | sed -e "s/   /,/g" >> output_cuda.csv



