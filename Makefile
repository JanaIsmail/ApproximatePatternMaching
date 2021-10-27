SRC_DIR=src
HEADER_DIR=include
OBJ_DIR=obj

CC=gcc
CUDA_HOME=/usr/local/cuda
CUDASDK=/usr/local/cuda/samples
CUDANVIDIA=/usr/lib64/nvidia
NVCC=$(CUDA_HOME)/bin/nvcc

CFLAGS_SEQ=-O3 -I$(HEADER_DIR)
CFLAGS_CUDA= -L $(CUDA_HOME)/lib64 -L $(CUDANVIDIA)

NVCFLAGS= -I $(CUDA_HOME)/include -I$(CUDASDK)/common/inc


LDFLAGS=

SRC= apm.c

OBJ= $(OBJ_DIR)/apm.o

all: $(OBJ_DIR) apm apm_mpi apm_mpi_omp apm_omp 

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c  
	$(CC) $(CFLAGS_SEQ) -c -o $@ $^


$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cu  
	$(NVCC) $(NVCFLAGS) -c -o $@ $<

apm:$(OBJ_DIR)/apm.o
	$(CC) $(CFLAGS_SEQ) $(LDFLAGS) -o $@ $^

apm_omp:src/apm_omp.o
	gcc -fopenmp -o apm_omp $(SRC_DIR)/apm_omp.c

apm_cuda:$(OBJ_DIR)/apm_cuda.o
	$(NVCC) $(CFLAGS_CUDA)  -o $@ $^ 

apm_mpi:$(SRC_DIR)/apm_mpi.c
	mpicc -o apm_mpi $(SRC_DIR)/apm_mpi.c

apm_mpi_omp:$(SRC_DIR)/apm_mpi_omp.c
	mpicc -fopenmp -o apm_mpi_omp $(SRC_DIR)/apm_mpi_omp.c

clean:
	rm -f apm apm_cuda $(OBJ) apm_mpi
