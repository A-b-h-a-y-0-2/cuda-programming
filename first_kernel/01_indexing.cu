#include <iostream>

__global__ void whoami(void) {
    int blockid = 
        blockIdx.x +
        blockIdx.y * gridDim.x +
        blockIdx.z * gridDim.y * gridDim.x;
                
    int block_offset =
        blockid *
        blockDim.x * blockDim.y * blockDim.z;

    int thread_offset =
        threadIdx.x +
        threadIdx.y * blockDim.x +
        threadIdx.z * blockDim.y * blockDim.x;

    int id = block_offset + thread_offset;

    printf("%04d | Block(%d %d %d) = %3d | Thread(%d %d %d) = %3d\n",
    id,
    blockIdx.x, blockIdx.y, blockIdx.z, blockid,
    threadIdx.x, threadIdx.y, threadIdx.z, thread_offset);
}

int main(int argc, char** kwargs){
    const int b_x = 2, b_y = 3, b_z = 4;
    const int t_x = 4, t_y = 4, t_z = 4;
    
    int blocks_per_grid = b_x* b_y* b_z;
    int threads_per_block = t_x* t_y* t_z;

    printf("%d blocks/grid\n", blocks_per_grid);
    printf("%d threads/block\n", threads_per_block);
    printf("%d total threads\n", blocks_per_grid * threads_per_block);

    dim3 blocksPerGrid(b_x,b_y,b_z);
    dim3 threadsPerBlock(t_x,t_y,t_z);

    whoami<<<blocksPerGrid, threadsPerBlock>>>();
    cudaDeviceSynchronize();
}