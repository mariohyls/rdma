#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <numeric>
#include <iostream>

// Here you can set the device ID that was assigned to you
#define MYDEVICE 0

float random_float(void)
{

  return static_cast<float>(rand()) / RAND_MAX;
}


// Part 1 of 6: implement the kernel
__global__ void block_sum(const float *input,
                          float *per_block_results,
                          const size_t n)
{
  extern __shared__ float sdata[];



}

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int main(void)
{
  // create array of 256ki elements
  const int num_elements = 1<<18;
  srand(time(NULL));
  // generate random input on the host
  std::vector<float> h_input(num_elements);
  for(int i = 0; i < h_input.size(); ++i)
  {
    h_input[i] = random_float();
  }

  const float host_result = std::accumulate(h_input.begin(), h_input.end(), 0.0f);
  std::cerr << "Host sum: " << host_result << std::endl;

  //Part 1 of 6: move input to device memory
  float *d_input = 0;

  // Part 1 of 6: allocate the partial sums: How much space does it need?
  float *d_partial_sums_and_total = 0;

  // Part 1 of 6: launch one kernel to compute, per-block, a partial sum. How much shared memory does it need?
  block_sum<<<num_blocks,block_size,  * sizeof(float)>>>(d_input, d_partial_sums_and_total, num_elements);

  // Part 1 of 6: compute the sum of the partial sums
  block_sum<<<>>>();

  // Part 1 of 6: copy the result back to the host
  float device_result = 0;

  std::cout << "Device sum: " << device_result << std::endl;

  // Part 1 of 6: deallocate device memory


  return 0;
}
