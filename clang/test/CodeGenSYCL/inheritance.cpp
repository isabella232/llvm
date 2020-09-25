// RUN:  %clang_cc1 -fsycl -fsycl-is-device -triple spir64-unknown-unknown-sycldevice -disable-llvm-passes -emit-llvm %s -o - | FileCheck %s

#include "Inputs/sycl.hpp"

class second_base {
public:
  int *e;
};

class InnerFieldBase {
public:
  int d;
};
class InnerField : public InnerFieldBase {
  int c;
};

struct base {
public:
  int b;
  InnerField obj;
};

struct derived : base, second_base {
  int a;

  void operator()() const {
  }
};

int main() {
  cl::sycl::queue q;

  q.submit([&](cl::sycl::handler &cgh) {
    derived f{};
    cgh.single_task(f);
  });

  return 0;
}

// Check kernel paramters
// CHECK: define spir_kernel void @{{.*}}derived(%struct.{{.*}}.base* byval(%struct.{{.*}}.base) align 4 %_arg__base, %struct.{{.*}}.__wrapper_class* byval(%struct.{{.*}}.__wrapper_class) align 8 %_arg_e, i32 %_arg_a)

// Check alloca for kernel paramters
// CHECK: %[[ARG_A:[a-zA-Z0-9_.]+]] = alloca i32, align 4
// Check alloca for local functor object
// CHECK: %[[LOCAL_OBJECT:[a-zA-Z0-9_.]+]] = alloca %struct.{{.*}}.derived, align 8
// CHECK: store i32 %_arg_a, i32* %[[ARG_A]], align 4

// Initialize 'base' subobject
// CHECK: %[[DERIVED_TO_BASE:.*]] = bitcast %struct.{{.*}}.derived* %[[LOCAL_OBJECT]] to %struct.{{.*}}.base*
// CHECK: %[[BASE_TO_PTR:.*]] = bitcast %struct.{{.*}}.base* %[[DERIVED_TO_BASE]] to i8*
// CHECK: %[[PARAM_TO_PTR:.*]] = bitcast %struct.{{.*}}.base* %_arg__base to i8*
// CHECK: call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %[[BASE_TO_PTR]], i8* align 4 %[[PARAM_TO_PTR]], i64 12, i1 false)

// Initialize 'second_base' subobject
// First, derived-to-base cast with offset:
// CHECK: %[[DERIVED_PTR:.*]] = bitcast %struct.{{.*}}.derived* %[[LOCAL_OBJECT]] to i8*
// CHECK: %[[OFFSET_CALC:.*]] = getelementptr inbounds i8, i8* %[[DERIVED_PTR]], i64 16
// CHECK: %[[TO_SECOND_BASE:.*]] = bitcast i8* %[[OFFSET_CALC]] to %class.{{.*}}.second_base*
// Initialize 'second_base::e'
// CHECK: %[[SECOND_BASE_PTR:.*]] = getelementptr inbounds %class.{{.*}}.second_base, %class.{{.*}}.second_base* %[[TO_SECOND_BASE]], i32 0, i32 0
// CHECK: %[[PTR_TO_WRAPPER:.*]] = getelementptr inbounds %struct.{{.*}}.__wrapper_class, %struct.{{.*}}.__wrapper_class* %_arg_e, i32 0, i32 0
// CHECK: %[[LOAD_PTR:.*]] = load i32 addrspace(1)*, i32 addrspace(1)** %[[PTR_TO_WRAPPER]]
// CHECK: %[[AS_CAST:.*]] = addrspacecast i32 addrspace(1)* %[[LOAD_PTR]] to i32 addrspace(4)*
// CHECK: store i32 addrspace(4)* %[[AS_CAST]], i32 addrspace(4)** %[[SECOND_BASE_PTR]]

// Initialize field 'a'
// CHECK: %[[GEP_A:[a-zA-Z0-9]+]] = getelementptr inbounds %struct.{{.*}}.derived, %struct.{{.*}}.derived* %[[LOCAL_OBJECT]], i32 0, i32 3
// CHECK: %[[LOAD_A:[0-9]+]] = load i32, i32* %[[ARG_A]], align 4
// CHECK: store i32 %[[LOAD_A]], i32* %[[GEP_A]]
