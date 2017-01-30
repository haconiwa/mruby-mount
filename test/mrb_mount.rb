##
## Mount Test
##

assert("Mount class") do
  t = Mount.new
  assert_equal(Mount, t.class)
end

assert("Mount#bind_mount") do
  m = Mount.new
  current_dir = File.expand_path(File.dirname(__FILE__))
  m.bind_mount("#{current_dir}/test_src_dir", "#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/src"
  m.umount("#{current_dir}/test_dst_dir")
end

assert("Mount#umount") do
  m = Mount.new
  current_dir = File.expand_path(File.dirname(__FILE__))

  m.bind_mount("#{current_dir}/test_src_dir", "#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/src"

  m.umount("#{current_dir}/test_dst_dir")
  assert_true File.exists? "#{current_dir}/test_dst_dir/dst"
end
