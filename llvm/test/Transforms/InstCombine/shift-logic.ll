; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i8 @shl_and(i8 %x, i8 %y) {
; CHECK-LABEL: @shl_and(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i8 [[X:%.*]], 5
; CHECK-NEXT:    [[TMP2:%.*]] = shl i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[SH1:%.*]] = and i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[SH1]]
;
  %sh0 = shl i8 %x, 3
  %r = and i8 %sh0, %y
  %sh1 = shl i8 %r, 2
  ret i8 %sh1
}

define i16 @shl_or(i16 %x, i16 %py) {
; CHECK-LABEL: @shl_or(
; CHECK-NEXT:    [[Y:%.*]] = srem i16 [[PY:%.*]], 42
; CHECK-NEXT:    [[TMP1:%.*]] = shl i16 [[X:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = shl nsw i16 [[Y]], 7
; CHECK-NEXT:    [[SH1:%.*]] = or i16 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i16 [[SH1]]
;
  %y = srem i16 %py, 42 ; thwart complexity-based canonicalization
  %sh0 = shl i16 %x, 5
  %r = or i16 %y, %sh0
  %sh1 = shl i16 %r, 7
  ret i16 %sh1
}

define i32 @shl_xor(i32 %x, i32 %y) {
; CHECK-LABEL: @shl_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[X:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = shl i32 [[Y:%.*]], 7
; CHECK-NEXT:    [[SH1:%.*]] = xor i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[SH1]]
;
  %sh0 = shl i32 %x, 5
  %r = xor i32 %sh0, %y
  %sh1 = shl i32 %r, 7
  ret i32 %sh1
}

define i64 @lshr_and(i64 %x, i64 %py) {
; CHECK-LABEL: @lshr_and(
; CHECK-NEXT:    [[Y:%.*]] = srem i64 [[PY:%.*]], 42
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i64 [[Y]], 7
; CHECK-NEXT:    [[SH1:%.*]] = and i64 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i64 [[SH1]]
;
  %y = srem i64 %py, 42 ; thwart complexity-based canonicalization
  %sh0 = lshr i64 %x, 5
  %r = and i64 %y, %sh0
  %sh1 = lshr i64 %r, 7
  ret i64 %sh1
}

define <4 x i32> @lshr_or(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: @lshr_or(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> [[X:%.*]], <i32 12, i32 12, i32 12, i32 12>
; CHECK-NEXT:    [[TMP2:%.*]] = lshr <4 x i32> [[Y:%.*]], <i32 7, i32 7, i32 7, i32 7>
; CHECK-NEXT:    [[SH1:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <4 x i32> [[SH1]]
;
  %sh0 = lshr <4 x i32> %x, <i32 5, i32 5, i32 5, i32 5>
  %r = or <4 x i32> %sh0, %y
  %sh1 = lshr <4 x i32> %r, <i32 7, i32 7, i32 7, i32 7>
  ret <4 x i32> %sh1
}

define <8 x i16> @lshr_xor(<8 x i16> %x, <8 x i16> %py) {
; CHECK-LABEL: @lshr_xor(
; CHECK-NEXT:    [[Y:%.*]] = srem <8 x i16> [[PY:%.*]], <i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42>
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <8 x i16> [[X:%.*]], <i16 12, i16 12, i16 12, i16 12, i16 12, i16 12, i16 12, i16 12>
; CHECK-NEXT:    [[TMP2:%.*]] = lshr <8 x i16> [[Y]], <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
; CHECK-NEXT:    [[SH1:%.*]] = xor <8 x i16> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <8 x i16> [[SH1]]
;
  %y = srem <8 x i16> %py, <i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 42, i16 -42> ; thwart complexity-based canonicalization
  %sh0 = lshr <8 x i16> %x, <i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5>
  %r = xor <8 x i16> %y, %sh0
  %sh1 = lshr <8 x i16> %r, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  ret <8 x i16> %sh1
}


define <16 x i8> @ashr_and(<16 x i8> %x, <16 x i8> %py, <16 x i8> %pz) {
; CHECK-LABEL: @ashr_and(
; CHECK-NEXT:    [[Y:%.*]] = srem <16 x i8> [[PY:%.*]], [[PZ:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <16 x i8> [[X:%.*]], <i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5>
; CHECK-NEXT:    [[TMP2:%.*]] = ashr <16 x i8> [[Y]], <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
; CHECK-NEXT:    [[SH1:%.*]] = and <16 x i8> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <16 x i8> [[SH1]]
;
  %y = srem <16 x i8> %py, %pz ; thwart complexity-based canonicalization
  %sh0 = ashr <16 x i8> %x, <i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3, i8 3>
  %r = and <16 x i8> %y, %sh0
  %sh1 = ashr <16 x i8> %r, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <16 x i8> %sh1
}

define <2 x i64> @ashr_or(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: @ashr_or(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <2 x i64> [[X:%.*]], <i64 12, i64 12>
; CHECK-NEXT:    [[TMP2:%.*]] = ashr <2 x i64> [[Y:%.*]], <i64 7, i64 7>
; CHECK-NEXT:    [[SH1:%.*]] = or <2 x i64> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i64> [[SH1]]
;
  %sh0 = ashr <2 x i64> %x, <i64 5, i64 5>
  %r = or <2 x i64> %sh0, %y
  %sh1 = ashr <2 x i64> %r, <i64 7, i64 7>
  ret <2 x i64> %sh1
}

define i32 @ashr_xor(i32 %x, i32 %py) {
; CHECK-LABEL: @ashr_xor(
; CHECK-NEXT:    [[Y:%.*]] = srem i32 [[PY:%.*]], 42
; CHECK-NEXT:    [[TMP1:%.*]] = ashr i32 [[X:%.*]], 12
; CHECK-NEXT:    [[TMP2:%.*]] = ashr i32 [[Y]], 7
; CHECK-NEXT:    [[SH1:%.*]] = xor i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[SH1]]
;
  %y = srem i32 %py, 42 ; thwart complexity-based canonicalization
  %sh0 = ashr i32 %x, 5
  %r = xor i32 %y, %sh0
  %sh1 = ashr i32 %r, 7
  ret i32 %sh1
}

define i32 @shr_mismatch_xor(i32 %x, i32 %y) {
; CHECK-LABEL: @shr_mismatch_xor(
; CHECK-NEXT:    [[SH0:%.*]] = ashr i32 [[X:%.*]], 5
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[SH0]], [[Y:%.*]]
; CHECK-NEXT:    [[SH1:%.*]] = lshr i32 [[R]], 7
; CHECK-NEXT:    ret i32 [[SH1]]
;
  %sh0 = ashr i32 %x, 5
  %r = xor i32 %y, %sh0
  %sh1 = lshr i32 %r, 7
  ret i32 %sh1
}

define i32 @ashr_overshift_xor(i32 %x, i32 %y) {
; CHECK-LABEL: @ashr_overshift_xor(
; CHECK-NEXT:    [[SH0:%.*]] = ashr i32 [[X:%.*]], 15
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[SH0]], [[Y:%.*]]
; CHECK-NEXT:    [[SH1:%.*]] = ashr i32 [[R]], 17
; CHECK-NEXT:    ret i32 [[SH1]]
;
  %sh0 = ashr i32 %x, 15
  %r = xor i32 %y, %sh0
  %sh1 = ashr i32 %r, 17
  ret i32 %sh1
}

define i32 @lshr_or_extra_use(i32 %x, i32 %y, i32* %p) {
; CHECK-LABEL: @lshr_or_extra_use(
; CHECK-NEXT:    [[SH0:%.*]] = lshr i32 [[X:%.*]], 5
; CHECK-NEXT:    [[R:%.*]] = or i32 [[SH0]], [[Y:%.*]]
; CHECK-NEXT:    store i32 [[R]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[SH1:%.*]] = lshr i32 [[R]], 7
; CHECK-NEXT:    ret i32 [[SH1]]
;
  %sh0 = lshr i32 %x, 5
  %r = or i32 %sh0, %y
  store i32 %r, i32* %p
  %sh1 = lshr i32 %r, 7
  ret i32 %sh1
}
