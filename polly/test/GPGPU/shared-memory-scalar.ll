; RUN: opt %loadPolly -polly-codegen-ppcg -polly-acc-dump-code \
; RUN: -polly-acc-use-shared \
; RUN: -disable-output < %s | \
; RUN: FileCheck -check-prefix=CODE %s

; RUN: opt %loadPolly -polly-codegen-ppcg \
; RUN: -polly-acc-use-shared \
; RUN: -disable-output -polly-acc-dump-kernel-ir < %s | \
; RUN: FileCheck -check-prefix=KERNEL %s

; REQUIRES: pollyacc

;    void add(float *A, float alpha) {
;      for (long i = 0; i < 32; i++)
;        for (long j = 0; j < 10; j++)
;          A[i] += alpha;
;    }

; CODE:  read(t0);
; CODE-NEXT:  if (t0 == 0)
; CODE-NEXT:    read();
; CODE-NEXT:  sync0();
; CODE-NEXT:  for (int c3 = 0; c3 <= 9; c3 += 1)
; CODE-NEXT:    Stmt_bb5(t0, c3);
; CODE-NEXT:  sync1();
; CODE-NEXT:  write(t0);


; KERNEL: @shared_MemRef_alpha = internal addrspace(3) global float 0.000000e+00, align 4

; KERNEL:  %polly.access.cast.MemRef_alpha = bitcast i8* %MemRef_alpha to float*
; KERNEL-NEXT:  %shared.read1 = load float, float* %polly.access.cast.MemRef_alpha
; KERNEL-NEXT:  store float %shared.read1, float addrspace(3)* @shared_MemRef_alpha


target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @add(float* %A, float %alpha) {
bb:
  br label %bb2

bb2:                                              ; preds = %bb11, %bb
  %i.0 = phi i64 [ 0, %bb ], [ %tmp12, %bb11 ]
  %exitcond1 = icmp ne i64 %i.0, 32
  br i1 %exitcond1, label %bb3, label %bb13

bb3:                                              ; preds = %bb2
  br label %bb4

bb4:                                              ; preds = %bb8, %bb3
  %j.0 = phi i64 [ 0, %bb3 ], [ %tmp9, %bb8 ]
  %exitcond = icmp ne i64 %j.0, 10
  br i1 %exitcond, label %bb5, label %bb10

bb5:                                              ; preds = %bb4
  %tmp = getelementptr inbounds float, float* %A, i64 %i.0
  %tmp6 = load float, float* %tmp, align 4
  %tmp7 = fadd float %tmp6, %alpha
  store float %tmp7, float* %tmp, align 4
  br label %bb8

bb8:                                              ; preds = %bb5
  %tmp9 = add nuw nsw i64 %j.0, 1
  br label %bb4

bb10:                                             ; preds = %bb4
  br label %bb11

bb11:                                             ; preds = %bb10
  %tmp12 = add nuw nsw i64 %i.0, 1
  br label %bb2

bb13:                                             ; preds = %bb2
  ret void
}
