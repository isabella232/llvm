; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck --check-prefix=NO-LIMIT %s
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -dse-memoryssa-scanlimit=0 -S | FileCheck --check-prefix=LIMIT-0 %s
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -dse-memoryssa-scanlimit=3 -S | FileCheck --check-prefix=LIMIT-3 %s
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -dse-memoryssa-scanlimit=4 -S | FileCheck --check-prefix=LIMIT-4 %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"


define void @test2(i32* noalias %P, i32* noalias %Q, i32* noalias %R) {
;
; NO-LIMIT-LABEL: @test2(
; NO-LIMIT-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; NO-LIMIT:       bb1:
; NO-LIMIT-NEXT:    br label [[BB3:%.*]]
; NO-LIMIT:       bb2:
; NO-LIMIT-NEXT:    br label [[BB3]]
; NO-LIMIT:       bb3:
; NO-LIMIT-NEXT:    store i32 0, i32* [[Q:%.*]]
; NO-LIMIT-NEXT:    store i32 0, i32* [[R:%.*]]
; NO-LIMIT-NEXT:    store i32 0, i32* [[P:%.*]]
; NO-LIMIT-NEXT:    ret void
;
; LIMIT-0-LABEL: @test2(
; LIMIT-0-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; LIMIT-0:       bb1:
; LIMIT-0-NEXT:    br label [[BB3:%.*]]
; LIMIT-0:       bb2:
; LIMIT-0-NEXT:    br label [[BB3]]
; LIMIT-0:       bb3:
; LIMIT-0-NEXT:    store i32 0, i32* [[Q:%.*]]
; LIMIT-0-NEXT:    store i32 0, i32* [[R:%.*]]
; LIMIT-0-NEXT:    store i32 0, i32* [[P:%.*]]
; LIMIT-0-NEXT:    ret void
;
; LIMIT-3-LABEL: @test2(
; LIMIT-3-NEXT:    store i32 1, i32* [[P:%.*]]
; LIMIT-3-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; LIMIT-3:       bb1:
; LIMIT-3-NEXT:    br label [[BB3:%.*]]
; LIMIT-3:       bb2:
; LIMIT-3-NEXT:    br label [[BB3]]
; LIMIT-3:       bb3:
; LIMIT-3-NEXT:    store i32 0, i32* [[Q:%.*]]
; LIMIT-3-NEXT:    store i32 0, i32* [[R:%.*]]
; LIMIT-3-NEXT:    store i32 0, i32* [[P]]
; LIMIT-3-NEXT:    ret void
;
; LIMIT-4-LABEL: @test2(
; LIMIT-4-NEXT:    br i1 true, label [[BB1:%.*]], label [[BB2:%.*]]
; LIMIT-4:       bb1:
; LIMIT-4-NEXT:    br label [[BB3:%.*]]
; LIMIT-4:       bb2:
; LIMIT-4-NEXT:    br label [[BB3]]
; LIMIT-4:       bb3:
; LIMIT-4-NEXT:    store i32 0, i32* [[Q:%.*]]
; LIMIT-4-NEXT:    store i32 0, i32* [[R:%.*]]
; LIMIT-4-NEXT:    store i32 0, i32* [[P:%.*]]
; LIMIT-4-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 true, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  store i32 0, i32* %Q
  store i32 0, i32* %R
  store i32 0, i32* %P
  ret void
}
