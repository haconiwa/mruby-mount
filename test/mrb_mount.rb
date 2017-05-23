##
## Mount Test
##

assert("Mount class") do
  assert_equal(Module, Mount.class)
end

assert("Mount#bind_mount") do
  current_dir = File.expand_path(File.dirname(__FILE__))
  Mount.bind_mount("#{current_dir}/test_src_dir", "#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/src"
  Mount.umount("#{current_dir}/test_dst_dir")
end

assert("Mount#umount") do
  current_dir = File.expand_path(File.dirname(__FILE__))

  Mount.bind_mount("#{current_dir}/test_src_dir", "#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/src"

  Mount.umount("#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/dst"
end

assert("Mount#mount") do
  current_dir = File.expand_path(File.dirname(__FILE__))

  Mount.mount("proc", "#{current_dir}/test_dst_dir", type: "proc")
  assert_true File.exists? "#{current_dir}/test_dst_dir/self/mounts"

  Mount.umount("#{current_dir}/test_dst_dir")
end
