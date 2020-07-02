//==--------- level_zero.cpp - SYCL Level-Zero backend ---------------------==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <CL/sycl.hpp>
#include <detail/platform_impl.hpp>
#include <detail/plugin.hpp>
#include <detail/program_impl.hpp>
#include <detail/queue_impl.hpp>

__SYCL_INLINE_NAMESPACE(cl) {
namespace sycl {
namespace level0 {
using namespace detail;

//----------------------------------------------------------------------------
// Implementation of level0::make<platform>
__SYCL_EXPORT platform make_platform(pi_native_handle NativeHandle) {
  const auto &Plugin = pi::getPlugin<backend::level0>();
  // Create PI platform first.
  pi::PiPlatform PiPlatform;
  Plugin.call<PiApiKind::piextPlatformCreateWithNativeHandle>(NativeHandle,
                                                              &PiPlatform);

  // Construct the SYCL platform from PI platfrom.
  return detail::createSyclObjFromImpl<platform>(
      std::make_shared<platform_impl>(PiPlatform, Plugin));
}

//----------------------------------------------------------------------------
// Implementation of level0::make<device>
__SYCL_EXPORT device make_device(const platform &Platform,
                                 pi_native_handle NativeHandle) {
  const auto &Plugin = pi::getPlugin<backend::level0>();
  const auto &PlatformImpl = getSyclObjImpl(Platform);
  // Create PI device first.
  pi::PiDevice PiDevice;
  Plugin.call<PiApiKind::piextDeviceCreateWithNativeHandle>(
      NativeHandle, PlatformImpl->getHandleRef(), &PiDevice);
  // Construct the SYCL device from PI device.
  return detail::createSyclObjFromImpl<device>(
      std::make_shared<device_impl>(PiDevice, PlatformImpl));
}

//----------------------------------------------------------------------------
// Implementation of level0::make<program>
__SYCL_EXPORT program make_program(const context &Context,
                                   pi_native_handle NativeHandle) {
  // Construct the SYCL program from native program.
  // TODO: move here the code that creates PI program, and remove the
  // native interop constructor.
  return detail::createSyclObjFromImpl<program>(
      std::make_shared<program_impl>(getSyclObjImpl(Context), NativeHandle));
}

//----------------------------------------------------------------------------
// Implementation of level0::make<queue>
__SYCL_EXPORT queue make_queue(const context &Context,
                               pi_native_handle NativeHandle) {
  const auto &Plugin = pi::getPlugin<backend::level0>();
  const auto &ContextImpl = getSyclObjImpl(Context);
  // Create PI queue first.
  pi::PiQueue PiQueue;
  Plugin.call<PiApiKind::piextQueueCreateWithNativeHandle>(
      NativeHandle, ContextImpl->getHandleRef(), &PiQueue);
  // Construct the SYCL queue from PI queue.
  return detail::createSyclObjFromImpl<queue>(std::make_shared<queue_impl>(
      PiQueue, ContextImpl, ContextImpl->get_async_handler()));
}

} // namespace level0
} // namespace sycl
} // __SYCL_INLINE_NAMESPACE(cl)
