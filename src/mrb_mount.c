/*
** mrb_mount.c - Mount class
**
** Copyright (c) Uchio Kondo 2016
**
** See Copyright Notice in LICENSE
*/

#define _GNU_SOURCE

// clang-format off
#include <stdio.h>
#include <sys/mount.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

#include <mruby.h>
#include <mruby/data.h>
#include <mruby/error.h>
#include "mrb_mount.h"
// clang-format on

#define DONE mrb_gc_arena_restore(mrb, 0);

static mrb_value mrb_mount_init(mrb_state *mrb, mrb_value self)
{
  DATA_PTR(self) = NULL;

  return self;
}

#define SYS_FAIL_MESSAGE_LENGTH 2048

static void mrb_mount_sys_fail(mrb_state *mrb, int error_no, const char *fmt, ...)
{
  char buf[1024];
  char arg_msg[SYS_FAIL_MESSAGE_LENGTH];
  char err_msg[SYS_FAIL_MESSAGE_LENGTH];
  char *ret;
  va_list args;

  va_start(args, fmt);
  vsnprintf(arg_msg, SYS_FAIL_MESSAGE_LENGTH, fmt, args);
  va_end(args);

  if ((ret = strerror_r(error_no, buf, 1024)) == NULL) {
    snprintf(err_msg, SYS_FAIL_MESSAGE_LENGTH, "[BUG] strerror_r failed at %s:%s. Please report haconiwa-dev", __FILE__,
             __func__);
    mrb_sys_fail(mrb, err_msg);
  }

  snprintf(err_msg, SYS_FAIL_MESSAGE_LENGTH, "sys failed %s:%s errno: %d message: %s mrbgem message: %s", __FILE__,
           __func__, error_no, ret, arg_msg);
  mrb_sys_fail(mrb, err_msg);
}

static mrb_value mrb_mount_mount(mrb_state *mrb, mrb_value self)
{
  // mrb_mount_data *d = DATA_PTR(self);
  char *source, *target, *fstype, *data;
  mrb_int mountflag;
  int ret;

  mrb_get_args(mrb, "zzz!iz!", &source, &target, &fstype, &mountflag, &data);

  ret = mount(source, target, fstype, mountflag, data);
  if (ret == -1) {
    mrb_mount_sys_fail(mrb, errno, "args: %s, %s", source, target);
  }

  return mrb_fixnum_value(ret);
}

static mrb_value mrb_mount_umount(mrb_state *mrb, mrb_value self)
{
  char *target;
  mrb_value f = mrb_nil_value();
  int umountflag, ret;

  mrb_get_args(mrb, "z|i", &target, &f);
  umountflag = mrb_nil_p(f) ? 0 : mrb_fixnum(f);

  ret = umount2(target, umountflag);
  if (ret == -1) {
    mrb_mount_sys_fail(mrb, errno, "umount failed: %s", ret);
  }

  return mrb_fixnum_value(ret);
}

void mrb_mruby_mount_gem_init(mrb_state *mrb)
{
  struct RClass *mount;
  mount = mrb_define_class(mrb, "Mount", mrb->object_class);
  mrb_define_method(mrb, mount, "initialize", mrb_mount_init, MRB_ARGS_NONE());
  mrb_define_method(mrb, mount, "__mount__", mrb_mount_mount, MRB_ARGS_REQ(5));
  mrb_define_method(mrb, mount, "umount", mrb_mount_umount, MRB_ARGS_ARG(1, 1));

  // please see <linux/fs.h>
  mrb_define_const(mrb, mount, "MS_MGC_VAL", mrb_fixnum_value(MS_MGC_VAL));

  mrb_define_const(mrb, mount, "MS_DIRSYNC", mrb_fixnum_value(MS_DIRSYNC));
  mrb_define_const(mrb, mount, "MS_MANDLOCK", mrb_fixnum_value(MS_MANDLOCK));
  mrb_define_const(mrb, mount, "MS_MOVE", mrb_fixnum_value(MS_MOVE));
  mrb_define_const(mrb, mount, "MS_NOATIME", mrb_fixnum_value(MS_NOATIME));
  mrb_define_const(mrb, mount, "MS_NODEV", mrb_fixnum_value(MS_NODEV));
  mrb_define_const(mrb, mount, "MS_NODIRATIME", mrb_fixnum_value(MS_NODIRATIME));
  mrb_define_const(mrb, mount, "MS_NOEXEC", mrb_fixnum_value(MS_NOEXEC));
  mrb_define_const(mrb, mount, "MS_NOSUID", mrb_fixnum_value(MS_NOSUID));
  mrb_define_const(mrb, mount, "MS_RDONLY", mrb_fixnum_value(MS_RDONLY));
  mrb_define_const(mrb, mount, "MS_REMOUNT", mrb_fixnum_value(MS_REMOUNT));
  mrb_define_const(mrb, mount, "MS_SYNCHRONOUS", mrb_fixnum_value(MS_SYNCHRONOUS));
  mrb_define_const(mrb, mount, "MS_BIND", mrb_fixnum_value(MS_BIND));
  mrb_define_const(mrb, mount, "MS_PRIVATE", mrb_fixnum_value(MS_PRIVATE));
  mrb_define_const(mrb, mount, "MS_REC", mrb_fixnum_value(MS_REC));
  mrb_define_const(mrb, mount, "MS_SLAVE", mrb_fixnum_value(MS_SLAVE));

  mrb_define_const(mrb, mount, "MNT_FORCE", mrb_fixnum_value(MNT_FORCE));
  mrb_define_const(mrb, mount, "MNT_DETACH", mrb_fixnum_value(MNT_DETACH));
  mrb_define_const(mrb, mount, "MNT_EXPIRE", mrb_fixnum_value(MNT_EXPIRE));

  DONE;
}

void mrb_mruby_mount_gem_final(mrb_state *mrb)
{
}
