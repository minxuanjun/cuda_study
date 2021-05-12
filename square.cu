#include <stdio.h>

__global__ void square(float* d_in, float* d_out)
{
    int id = threadIdx.x;
    d_out[id] = d_in[id]*d_in[id];
}


int main(int argc, char** argv){
    const int ARRAY_SIZE = 64;
    const int ARRAY_BYTES = ARRAY_SIZE*sizeof(float);

    float h_in[ARRAY_SIZE];
    float h_out[ARRAY_SIZE];
    for(int i = 0; i < ARRAY_SIZE; i++){
        h_in[i] =i;
    }

    float* d_in;
    float* d_out;

    cudaMalloc((void **)&d_in,ARRAY_BYTES);
    cudaMalloc((void **)&d_out,ARRAY_BYTES);

    cudaMemcpy(d_in,h_in,ARRAY_BYTES, cudaMemcpyHostToDevice);

    square<<<1, ARRAY_BYTES>>>(d_in,d_out);
    cudaMemcpy(h_out, d_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    for(int i=0; i < ARRAY_SIZE; i++)
    {
        printf("%f", h_out[i]);
        printf(((i%4)!=3) ? "\t" : "\n");
    }

    
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}