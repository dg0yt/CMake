
#include <string>
#include <cuda.h>
#include <iostream>

#ifdef _WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

int dynamic_base_func(int);

EXPORT int __host__ cuda_dynamic_host_func(int x)
{
  return dynamic_base_func(x);
}

static
__global__
void DetermineIfValidCudaDevice()
{
}

EXPORT void cuda_dynamic_lib_func()
{
  DetermineIfValidCudaDevice <<<1,1>>> ();
  cudaError_t err = cudaGetLastError();
  if(err != cudaSuccess)
    {
    std::cerr << "DetermineIfValidCudaDevice [SYNC] failed: "
              << cudaGetErrorString(err) << std::endl;
    }
  err = cudaDeviceSynchronize();
  if(err != cudaSuccess)
    {
    std::cerr << "DetermineIfValidCudaDevice [ASYNC] failed: "
              << cudaGetErrorString(cudaGetLastError()) << std::endl;
    }
}
