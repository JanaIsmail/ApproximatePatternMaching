#! /bin/bash

path=$PWD

rm output
dna_sequence=dna/chr5_KI270897v1_alt.fa
approx_factor=3
pattern=AAAA

#SEQUENTIEL
printf "SEQUENTIEL\n" >> output

pattern=""
for i in $(seq 1 5); do
  pattern+=" AAAA"
  output1=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output2=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output3=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output4=$(./apm $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )

  printf "%d   %s   %s   %s   %s\n" $i $output1 $output2 $output3 $output4 >> output
done
printf "\n" >> output


#OMP

printf "OMP\n" >> output

pattern=AAAA
for i in $(seq 2 2 10); do
  output1=$(./apm_omp $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output2=$(./apm_omp $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output3=$(./apm_omp $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  output4=$(./apm_omp $i $approx_factor $dna_sequence $pattern | sed -n "2p" | cut -d " " -f 4 )
  printf "%d   %s   %s   %s   %s\n" $i $output1 $output2 $output3 $output4 >> output
done

printf "\n" >> output


#MPI

printf "MPI\n" >> output
pattern=AAAA
cd ~
for i in $(seq 2 5); do
  pattern+=" AAAA"
  output1=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
  output2=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
  output3=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
  output4=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
  printf "%d   %s   %s   %s   %s\n" $i $output1 $output2 $output3 $output4 >> $path/output
done
cd $path
printf "\n" >> output

#MPI & OMP

printf "MPI & OMP\n" >> output
pattern=AAAA
cd ~
for i in $(seq 2 5); do
  pattern+=" AAAA"
  for j in $(seq 2 2 10); do
    output1=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi_omp $j $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
    output2=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi_omp $j $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
    output3=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi_omp $j $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
    output4=$(mpirun -machinefile $path/machines -n $i $path/apm_mpi_omp $j $approx_factor $path/$dna_sequence $pattern | grep "APM done"  | cut -d " " -f 4 )
    printf "%d   %d   %s   %s   %s   %s\n" $i $j $output1 $output2 $output3 $output4 >> $path/output
    done
done
cd $path
printf "\n" >> output

cat output | sed -e "s/   /,/g" >> output.csv



