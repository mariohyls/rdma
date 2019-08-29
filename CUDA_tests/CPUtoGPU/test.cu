
#include <cstring>
#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include "mpi.h"





// number of elements of the host buffer. All of them are sent to the device. 
#define N 1
// number of elements that will be received on the dev buffer. M must be <= N.

// When N = M ~ 1e5             -> Everything works.
// When N = M < 4.2e4 (0.84 MB) -> Segmentation fault (non UCX related)
// When N = M > 5.7e7 (114 MB)  -> UCX ERROR: Segmentation fault.
// When N < 4.2e4 and M << N    -> works fine. 

// 2147483647


//int main()
int main(int argc, const char * argv[])
{

    printf("hello\n");

    int rank;
    int size = argc > 1 ? atoi(argv[1]) : N;
    //int size = N;
    
    int provided;
    MPI_Init_thread(nullptr, nullptr, MPI_THREAD_MULTIPLE, &provided);
    
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    float *buf_host ;
    float *buf_dev  ;

    // the size of both buffers (not necessarily the size of the package)
    int bufferSize = size*sizeof(float);

    buf_host = (float*)malloc(bufferSize);

    cudaMalloc(&buf_dev, bufferSize);               // works with small pkgs    
	cudaMalloc(&buf_dev, bufferSize);               // works with small pkgs    
    cudaMalloc(&buf_dev, bufferSize);               // works with small pkgs    

    if (rank == 0) {
        printf("-------->     r0_0\n");
        //MPI_Send(buf_host, size, MPI_FLOAT, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(buf_host, size, MPI_FLOAT, 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        //MPI_Send(buf_dev, size, MPI_FLOAT, 1, 0, MPI_COMM_WORLD);
        //MPI_Recv(buf_dev, size, MPI_FLOAT, 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("-------->     r0_1\n");
    } else { 
        // receive into the device buffer
        printf("-------->     r1_0\n");
        //MPI_Recv(buf_dev, size, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Send(buf_dev, size, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
        //MPI_Recv(buf_host, size, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        //MPI_Send(buf_host, size, MPI_FLOAT, 0, 0, MPI_COMM_WORLD);
        printf("-------->     r1_1\n");
    }

    MPI_Barrier(MPI_COMM_WORLD);
    free(buf_host);
	cudaFree(buf_dev);
    
    printf("done\n");
    MPI_Finalize();
}

